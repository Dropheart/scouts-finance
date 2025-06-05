import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ParentEndpoint extends Endpoint {
  Future<List<Parent>> getParents(Session session) async {
    return Parent.db.find(session);
  }

  Future<Parent?> getParentById(Session session, int id) async {
    return Parent.db.findById(session, id);
  }
}
