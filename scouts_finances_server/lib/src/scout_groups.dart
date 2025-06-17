import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ScoutGroupsEndpoint extends Endpoint {
  Future<List<ScoutGroup>> getScoutGroups(Session session) async {
    return ScoutGroup.db.find(session,
        include: ScoutGroup.include(children: Child.includeList()));
  }

  Future<ScoutGroup> createScoutGroup(
      Session session, String name, GroupColour colour) async {
    final newGroup = ScoutGroup(name: name, colour: colour);
    return await ScoutGroup.db.insertRow(session, newGroup);
  }
}
