import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ScoutGroupsEndpoint extends Endpoint {
  Future<List<ScoutGroup>> getScoutGroups(Session session) async {
    return ScoutGroup.db.find(session);
  }
}