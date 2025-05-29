import 'package:scouts_finances_server/src/generated/events/events.dart';
import 'package:serverpod/serverpod.dart';

class EventEndpoint extends Endpoint {
  Future<List<Event>> getEvents(Session session) async {
    return [
      Event(
        id: 79,
        date: DateTime.now(),
        name: 'Sample Event',
      )
    ];
  }
}
