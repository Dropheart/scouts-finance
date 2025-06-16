import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ScoutGroupsEndpoint extends Endpoint {
  Future<List<ScoutGroup>> getScoutGroups(Session session) async {
    return ScoutGroup.db.find(session);
  }

  Future<ScoutGroup> createScoutGroup(Session session, String name) async {
    final newGroup = ScoutGroup(name: name);
    return await ScoutGroup.db.insertRow(session, newGroup);
  }
}
