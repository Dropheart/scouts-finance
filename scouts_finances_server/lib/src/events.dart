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
        include: EventRegistration.include(
            child: Child.include(),
            payments: Payment.includeList()
          ));

    return (eventDetails, eventRegistration);
  }
}
