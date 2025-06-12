import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ParentEndpoint extends Endpoint {
  Future<List<Parent>> getParents(Session session) async {
    return Parent.db.find(session);
  }

  Future<Parent?> getParentById(Session session, int id) async {
    return Parent.db.findById(session, id);
  }

  Future<void> addBalance(Session session, int parentId, int amount) async {
    final parent = await Parent.db.findById(session, parentId);
    if (parent == null) {
      throw ArgumentError('Parent with id $parentId not found');
    }
    parent.balance += amount;
    await Parent.db.update(session, [parent]);
  }

  Future<void> addParent(Session session, Parent parent) async {
    await Parent.db.insert(session, [parent]);
  }

  Future<List<EventRegistration>> getUnpaidEventRegistrations(Session session, int parentId) async {
    return EventRegistration.db.find(session,
        where: (t) =>
            t.child.parentId.equals(parentId) & t.paidDate.equals(null),
        include: EventRegistration.include(
          event: Event.include(),
          child: Child.include(),
        ));
  }
}
