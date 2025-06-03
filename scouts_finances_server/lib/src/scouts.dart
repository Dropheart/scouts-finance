import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ScoutsEndpoint extends Endpoint  {
  Future<List<Child>> getChildren(Session session) async {
    // Fetch all children from the database
    return await Child.db.find(session);
  }
}