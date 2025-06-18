import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ScoutsEndpoint extends Endpoint {
  Future<List<Child>> getChildren(Session session) async {
    // Fetch all children from the database
    return await Child.db.find(session);
  }

  Future<List<Child>> getChildrenOfParent(Session session, int parentId) async {
    // Fetch all children associated with the given parent ID
    return await Child.db
        .find(session, where: (c) => c.parentId.equals(parentId));
  }

  Future<Child?> getChildById(Session session, int id) async {
    // Fetch a specific child by ID
    return await Child.db.findById(session, id,
        include: Child.include(
            parent: Parent.include(), scoutGroup: ScoutGroup.include()));
  }

  Future<Child?> addChild(Session session, Child child) {
    return Child.db.insertRow(session, child);
  }
}
