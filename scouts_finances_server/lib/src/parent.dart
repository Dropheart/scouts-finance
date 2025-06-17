import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:scouts_finances_server/src/reminder.dart';
import 'package:scouts_finances_server/src/twlilio.dart';
import 'package:serverpod/serverpod.dart';

class ParentEndpoint extends Endpoint {
  Future<List<Parent>> getParents(Session session) async {
    return Parent.db
        .find(session, include: Parent.include(children: Child.includeList()));
  }

  Future<Parent?> getParentById(Session session, int id) async {
    return Parent.db.findById(session, id,
        include: Parent.include(children: Child.includeList()));
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

  Future<List<EventRegistration>> getUnpaidEventRegistrations(
      Session session, int parentId) async {
    return EventRegistration.db.find(session,
        where: (t) =>
            t.child.parentId.equals(parentId) & t.paidDate.equals(null),
        include: EventRegistration.include(
          event: Event.include(),
          child: Child.include(),
        ));
  }

  Future<void> remindParent(Session session, int parentId) async {
    final parent = await Parent.db.findById(session, parentId);
    if (parent == null) {
      throw ArgumentError('Parent with id $parentId not found');
    }

    final buffer = StringBuffer();
    buffer.writeln('Dear ${parent.firstName},');
    buffer.writeln(
        'This message is a reminder for the upcoming events your child(ren) registered for.\n');

    final reminder = await eventRemindersForParent(session, parent);

    if (reminder.isEmpty) {
      buffer.writeln('No upcoming events found for your child(ren).');
    } else {
      buffer.writeln(reminder);
    }

    buffer.writeln('Thank you for your attention!\n NB: This is an automated message, please do not reply.');

    final message = buffer.toString();

    TwilioClient().sendMessage(body: message);
  }

  Future<void> remindAllParents(Session session) async {
    final parents = await Parent.db.find(session);
    for (var parent in parents) {
      await remindParent(session, parent.id!);
    }
  }
}
