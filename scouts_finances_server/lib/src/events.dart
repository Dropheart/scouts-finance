import 'package:scouts_finances_server/src/extensions.dart';
import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:scouts_finances_server/src/reminder.dart';
import 'package:scouts_finances_server/src/twlilio.dart';
import 'package:serverpod/serverpod.dart';

typedef EventDetails = (Event, List<EventRegistration>);
typedef EventPaidCounts = Map<int, (int paidCount, int totalCount)>;

class EventEndpoint extends Endpoint {
  Future<List<Event>> getEvents(Session session) async {
    return Event.db.find(session,
        include: Event.include(scoutGroup: ScoutGroup.include()));
  }

  Future<Map<int, (int, int)>> getPaidCounts(Session session) async {
    final res = EventPaidCounts();

    final allEvents = await Event.db.find(session);
    for (var event in allEvents) {
      final registrations = await EventRegistration.db.find(session,
          where: (t) => t.eventId.equals(event.id),
          include: EventRegistration.include(child: Child.include()));
      int totalCount = registrations.length;
      int paidCount =
          totalCount - registrations.where((r) => r.paidDate == null).length;

      res[event.id!] = (paidCount, totalCount);
    }

    return res;
  }

  Future<EventDetails> getEventById(Session session, int id) async {
    final eventDetails = await Event.db.findById(session, id,
        include: Event.include(scoutGroup: ScoutGroup.include()));

    if (eventDetails == null) {
      throw ArgumentError('Event with id $id not found');
    }

    final eventRegistration = await EventRegistration.db.find(session,
        where: (t) => t.eventId.equals(id),
        include: EventRegistration.include(
            child: Child.include(parent: Parent.include())));

    return (eventDetails, eventRegistration);
  }

  Future<Event> insertEvent(Session session, String name, int cost,
      DateTime? date, int groupId) async {
    final event = Event(
        name: name,
        date: date ?? DateTime.now(),
        cost: cost,
        scoutGroupId: groupId);

    final retEvent = await Event.db.insertRow(session, event);

    // Notify all clients about the new event
    await session.messages.postMessage('update_events', event);

    return retEvent;
  }

  Future<EventRegistration> registerChildForEvent(
      Session session, int eventId, int childId,
      {Transaction? transaction}) async {
    final event =
        await Event.db.findById(session, eventId, transaction: transaction);
    if (event == null) {
      throw ArgumentError('Event with id $eventId not found');
    }

    final child =
        await Child.db.findById(session, childId, transaction: transaction);
    if (child == null) {
      throw ArgumentError('Child with id $childId not found');
    }
    final registration = EventRegistration(
      eventId: eventId,
      childId: childId,
      event: event,
      child: child,
    );

    await EventRegistration.db
        .insert(session, [registration], transaction: transaction);

    // Notify all clients about the new registration
    await session.messages.postMessage('update_events', event);

    return registration;
  }

  Future<void> registerChildrenForEvent(
      Session session, int eventId, List<int> childIds) async {
    final event = await Event.db.findById(session, eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId not found');
    }

    final children = await Child.db
        .find(session, where: (c) => c.id.inSet(childIds.toSet()));

    if (children.length != childIds.length) {
      throw ArgumentError('Some children not found');
    }

    final registrations = children.map((child) {
      return EventRegistration(
        eventId: eventId,
        childId: child.id!,
      );
    }).toList();

    print("-");
    // select all event registrations for the event
    final existingRegs = await EventRegistration.db.find(
      session,
      where: (r) => r.eventId.equals(eventId),
    );
    print(existingRegs);

    print("-");

    // notify clients about the change in registrations
    await session.messages.postMessage('update_events', event);

    await EventRegistration.db.insert(session, registrations);
  }

  Future<List<EventRegistration>> unpaidEvents(Session session) async {
    final res = await EventRegistration.db.find(session,
        include: EventRegistration.include(
            child: Child.include(parent: Parent.include()),
            event: Event.include()),
        where: (r) => r.paidDate.equals(null));
    return res;
  }

  Future<List<EventRegistration>> getRegistrationsByChildId(
      Session session, int childId) async {
    return EventRegistration.db.find(session,
        where: (t) => t.childId.equals(childId),
        include: EventRegistration.include(event: Event.include()));
  }

  Future<List<EventRegistration>> getRegistrationsByEventId(
          Session session, int eventId) =>
      EventRegistration.db
          .find(session, where: (t) => t.eventId.equals(eventId));

  Future<void> updateEventRegistrations(
      Session session, int eventId, List<int> childIds) async {
    final existingRegistrations = await EventRegistration.db.find(
      session,
      where: (r) => r.eventId.equals(eventId),
      include: EventRegistration.include(
          child: Child.include(parent: Parent.include()),
          event: Event.include()),
    );

    final existingChildIds =
        existingRegistrations.map((r) => r.childId).toSet();

    final newChildIds = childIds.toSet();

    final toRemove = existingRegistrations
        .where((r) => newChildIds.contains(r.childId))
        .toList();
    if (toRemove.isNotEmpty) {
      for (var reg in toRemove.where((r) => r.paidDate != null)) {
        // Gotta update parent balance.
        final child = reg.child!;
        child.parent!.balance += reg.event!.cost;
        await Parent.db.updateRow(session, child.parent!);
      }
      await EventRegistration.db.delete(session, toRemove);
    }

    // Add registrations for new children
    final toAdd = newChildIds
        .where((id) => !existingChildIds.contains(id))
        .map((id) => EventRegistration(eventId: eventId, childId: id))
        .toList();
    if (toAdd.isNotEmpty) {
      await EventRegistration.db.insert(session, toAdd);
    }

    // Notify all clients about the updated registrations
    final event = await Event.db.findById(session, eventId);
    if (event != null) {
      await session.messages.postMessage('update_events', event);
    }
  }

  Stream eventStream(Session session) async* {
    await for (final msg in session.messages.createStream('update_events')) {
      yield msg;
    }
  }

  Future<void> sendReminders(Session session, int eventId) async {
    final event = (await Event.db.findById(session, eventId))!;
    final eventRegs = await EventRegistration.db.find(
      session,
      where: (r) => r.eventId.equals(eventId),
      include: EventRegistration.include(
          child: Child.include(parent: Parent.include())),
    );

    final buffer = StringBuffer();

    final target = eventRegs.first.child!.parent!;

    buffer.writeln('Dear ${target.firstName},\n');
    buffer.writeln(
        'Your child(ren) ${eventRegs.first.child!.firstName} has been invited to the following event:');

    buffer.writeln('Event: ${event.name}');
    buffer.writeln('Date: ${event.date.formattedDate}');
    buffer.writeln('Cost: ${event.cost.formatMoney}\n');

    buffer.writeln(
        'Please pay for the event at your earliest convenience. Payment can be done either via bank transfer or cash at the event.\n');
    addPaymentInstructions(buffer, target);

    buffer.writeln(
        'Thank you for your attention!\n NB: This is an automated message, please do not reply.\nFor any questions, please contact your relevant scout leader.');

    final message = buffer.toString();

    TwilioClient().sendMessage(body: message);
  }
}
