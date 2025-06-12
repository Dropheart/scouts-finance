import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

typedef EventDetails = (Event, List<EventRegistration>);

class EventEndpoint extends Endpoint {
  Future<List<Event>> getEvents(Session session) async {
    return Event.db.find(session);
  }

  Future<EventDetails> getEventById(Session session, int id) async {
    final eventDetails = await Event.db.findById(session, id);

    if (eventDetails == null) {
      throw ArgumentError('Event with id $id not found');
    }

    final eventRegistration = await EventRegistration.db.find(session,
        where: (t) => t.eventId.equals(id),
        include: EventRegistration.include(child: Child.include()));

    return (eventDetails, eventRegistration);
  }

  Future<List<Event>> insertEvent(
    Session session,
    String name,
    int cost,
    DateTime? date,
  ) async {
    final event = Event(name: name, date: date ?? DateTime.now(), cost: cost);

    await Event.db.insert(session, [event]);

    return Event.db.find(session);
  }

  Future<EventRegistration> registerChildForEvent(
    Session session,
    int eventId,
    int childId,
  ) async {
    final event = await Event.db.findById(session, eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId not found');
    }

    final child = await Child.db.findById(session, childId,
        include: Child.include(
          parent: Parent.include(),
        ));
    if (child == null) {
      throw ArgumentError('Child with id $childId not found');
    }
    final registration = EventRegistration(
      eventId: eventId,
      childId: childId,
      event: event,
      child: child,
    );

    // Need to subtract this from the parent's balance
    if (child.parent == null) {
      throw ArgumentError(
          'Child with id $childId has no parent and cannot be registered for events.');
    }

    final parent = child.parent!;
    final balance = parent.balance;
    final newBalance = balance - event.cost;
    parent.balance = newBalance;

    // Makes the operation atomic
    await session.db.transaction(
      (transaction) async => {
        await EventRegistration.db.insert(session, [registration], transaction: transaction),
        await Parent.db.update(session, [parent], transaction: transaction,),
      },
    );

    return registration;
  }

  Future<List<EventRegistration>> unpaidEvents(Session session) async {
    final allRegistrations = await EventRegistration.db.find(session,
        include: EventRegistration.include(
            child: Child.include(parent: Parent.include()),
            event: Event.include()));

    allRegistrations.sort((a, b) => a.event!.date.compareTo(b.event!.date));
    allRegistrations.retainWhere((eventReg) => eventReg.paidDate == null);

    return allRegistrations;
  }

  Future<List<EventRegistration>> getRegistrationsByChildId(
      Session session, int childId) async {
    return EventRegistration.db.find(session,
        where: (t) => t.childId.equals(childId),
        include: EventRegistration.include(event: Event.include()));
  }
}
