import 'dart:collection';

import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

typedef EventDetails = (Event, List<EventRegistration>);

class EventEndpoint extends Endpoint {
  Future<List<Event>> getEvents(Session session) async {
    return Event.db.find(session);
  }

  Future<Map<int, (int, int)>> getPaidCounts(Session session) async {
    final res = HashMap<int, (int, int)>();

    final allEvents = await Event.db.find(session);
    for (var event in allEvents) {
      int paidCount = 0;
      final registrations = await EventRegistration.db.find(session,
          where: (t) => t.eventId.equals(event.id),
          include: EventRegistration.include(child: Child.include()));
      int totalCount = registrations.length;

      for (var registration in registrations) {
        if (registration.paidDate != null) {
          paidCount++;
        }
      }

      res[event.id!] = (paidCount, totalCount);
    }

    return res;
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

    final child = await Child.db.findById(session, childId);
    if (child == null) {
      throw ArgumentError('Child with id $childId not found');
    }
    final registration = EventRegistration(
      eventId: eventId,
      childId: childId,
      event: event,
      child: child,
    );

    await EventRegistration.db.insert(session, [registration]);

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
