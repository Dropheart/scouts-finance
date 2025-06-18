import 'package:scouts_finances_server/src/extensions.dart';
import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:scouts_finances_server/src/twlilio.dart';
import 'package:serverpod/serverpod.dart';

class ReminderFutureCall extends FutureCall<Event> {
  @override
  Future<void> invoke(Session session, Event? event) async {
    if (event == null) {
      print('No event provided for reminders, skipping.');
      return; // No event to process
    }

    // Fetch event registrations for the given event
    final registrations = await EventRegistration.db.find(
      session,
      where: (t) =>
          (t.event.id.equals(event.id)) & (t.event.date > DateTime.now()),
      include: EventRegistration.include(
          child: Child.include(parent: Parent.include())),
    );

    // Pivot to group registrations by parent
    final parentRegistrations = <int, List<EventRegistration>>{};
    for (var registration in registrations) {
      parentRegistrations
          .putIfAbsent(registration.child!.parentId, () => [])
          .add(registration);
    }

    // Send reminders to each parent
    for (var parentId in parentRegistrations.keys) {
      final parent = await Parent.db.findById(session, parentId);
      if (parent == null) {
        print('Parent with id $parentId not found, skipping reminder.');
        continue; // Skip if parent not found
      }

      final buffer = StringBuffer();
      buffer.writeln('Dear ${parent.firstName},');
      buffer.writeln(
          'This message is a reminder for the upcoming event "${event.name}" on ${event.date}.');

      final registrations = parentRegistrations[parentId]!;
      for (var registration in registrations.where((r) => r.paidDate == null)) {
        buffer.writeln(
            '- ${registration.child!.firstName} is registered but not paid for this event.');
      }
      if (registrations.any((r) => r.paidDate == null)) {
        buffer.writeln(
            'Please ensure that the payment is made before the event date.');
      } else {
        buffer.writeln('All registrations for this event are paid.');
      }

      buffer.writeln(
          'As a general reminder, here are the upcoming events your child(ren) registered for:');
      final eventDetails = await eventRemindersForParent(session, parent);
      buffer.writeln(eventDetails);

      buffer.writeln('Thank you for your attention!');

      final reminder = buffer.toString();
      TwilioClient().sendMessage(body: reminder);
    }
  }
}

Future<String> eventRemindersForParent(Session session, Parent parent) async {
  final buffer = StringBuffer();

  final eventRegistrations = await EventRegistration.db.find(session,
      where: (t) => t.child.parentId.equals(parent
          .id) /*& (t.event.date > DateTime.now())*/, // reintro this line if our data permits lol
      include: EventRegistration.include(
        event: Event.include(),
        child: Child.include(parent: Parent.include()),
      ));

  final unpaidRegistrations =
      eventRegistrations.where((r) => r.paidDate == null).toList();
  final paidRegistrations =
      eventRegistrations.where((r) => r.paidDate != null).toList();

  buffer.writeln('Current balance: ${parent.balance.formatMoney}');
  buffer.writeln('\nUnpaid registrations:');
  if (unpaidRegistrations.isEmpty) {
    buffer.writeln('None');
  } else {
    for (var registration in unpaidRegistrations) {
      buffer.writeln(
          '- ${registration.event!.name} on ${registration.event!.date.formattedDate} (Cost: ${registration.event!.cost.formatMoney})');
    }
  }
  buffer.writeln('\nPaid registrations:');
  if (paidRegistrations.isEmpty) {
    buffer.writeln('None');
  } else {
    for (var registration in paidRegistrations) {
      buffer.writeln(
          '- ${registration.event!.name} on ${registration.event!.date.formattedDate} (Paid on: ${registration.paidDate!.formattedDate})');
    }
  }
  final outstandingBalance =
      unpaidRegistrations.fold(0, (sum, r) => sum + (r.event?.cost ?? 0)) -
          parent.balance;

  buffer.writeln('Outstanding balance: ${outstandingBalance.formatMoney}');
  if (outstandingBalance > 0) {
    buffer.writeln(
        'To pay your outstanding balance, please transfer to the BACS details below:');
    addPaymentInstructions(buffer, parent);
  } else {
    buffer.writeln('Thank you for keeping your account up to date!\n');
  }

  return buffer.toString();
}

void addPaymentInstructions(StringBuffer buffer, Parent parent) {
  buffer.writeln('Account Name: Scouts Finances');
  buffer.writeln('Account Number: 12345678');
  buffer.writeln('Sort Code: 12-34-56');
  buffer.writeln('Reference: SCOUT${parent.id}');
}
