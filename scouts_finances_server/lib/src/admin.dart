import 'dart:math';

import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class AdminEndpoint extends Endpoint {
  Future<void> resetDb(Session session) async {
    // Hardcode some dummy data into the database for testing purposes.

    // First, delete all existing data
    await EventRegistration.db.deleteWhere(session, where: (t) => t.id > -1);
    await Payment.db.deleteWhere(session, where: (t) => t.id > -1);
    await Child.db.deleteWhere(session, where: (t) => t.id > -1);
    await Event.db.deleteWhere(session, where: (t) => t.id > -1);

    // Now create some children
    final child1 = Child(firstName: "John", lastName: "Doe");
    final child2 = Child(firstName: "Jane", lastName: "Doe");
    final child3 = Child(firstName: "Alice", lastName: "Smith");
    final child4 = Child(firstName: "Silver", lastName: "Johnson");
    final child5 = Child(firstName: "Charlie", lastName: "Brown");

    await Child.db.insert(session, [child1, child2, child3, child4, child5]);

    // Create some events
    final event1 = Event(name: "Rafting", cost: 20, date: DateTime(2025, 1, 5));
    final event2 = Event(name: "Hiking", cost: 15, date: DateTime(2025, 2, 10));
    final event3 =
        Event(name: "Camping", cost: 30, date: DateTime(2025, 3, 15));
    final event4 =
        Event(name: "Swimming", cost: 10, date: DateTime(2025, 4, 20));
    final event5 =
        Event(name: "Climbing", cost: 25, date: DateTime(2025, 5, 25));

    await Event.db.insert(session, [event1, event2, event3, event4, event5]);

    // Get the IDs of the inserted children and events
    final insertedChildren = await Child.db.find(session);
    final insertedEvents = await Event.db.find(session);

    // Register some children for events
    final registrations = [
      EventRegistration(
          eventId: insertedEvents[0].id!, childId: insertedChildren[0].id!),
      EventRegistration(
          eventId: insertedEvents[0].id!, childId: insertedChildren[1].id!),
      EventRegistration(
          eventId: insertedEvents[0].id!, childId: insertedChildren[2].id!),
      EventRegistration(
          eventId: insertedEvents[1].id!, childId: insertedChildren[1].id!),
      EventRegistration(
          eventId: insertedEvents[1].id!, childId: insertedChildren[2].id!),
      EventRegistration(
          eventId: insertedEvents[2].id!, childId: insertedChildren[3].id!),
      EventRegistration(
          eventId: insertedEvents[3].id!, childId: insertedChildren[4].id!),
      EventRegistration(
          eventId: insertedEvents[4].id!, childId: insertedChildren[0].id!),
    ];
    await EventRegistration.db.insert(session, registrations);

    // So we have the IDs
    final insertedRegistrations = await EventRegistration.db.find(session);

    for (var registration in insertedRegistrations) {
      // Get the event for the event cost
      final event = await Event.db.findById(session, registration.eventId);
      if (event == null) {
        throw ArgumentError('Event with id ${registration.eventId} not found');
      }

      // Randomly decide whether to pay in full or partially
      final payInFull = Random().nextBool();
      // Randomly decide the amount to pay if not paying in full
      final amount =
          payInFull ? event.cost : (event.cost * Random().nextDouble());
      // Randomly decide to pay in two installments or not
      final payInTwoInstallments = Random().nextBool();
      // Create the payments
      final payments = payInTwoInstallments
          ? [
              Payment(
                reference: "Hope my child enjoys :)",
                method: PaymentMethod.cash,
                amount: amount / 2,
                date: DateTime.now().subtract(Duration(days: 30)),
              ),
              Payment(
                reference: "Hope my child enjoys :)",
                method: PaymentMethod.cash,
                amount: amount / 2,
                date: DateTime.now(),
              ),
            ]
          : [
              Payment(
                reference: "Hope my child enjoys :)",
                method: PaymentMethod.cash,
                amount: amount,
                date: DateTime.now(),
              ),
            ];

      // Insert into the payment table
      final insertedPayments = await Payment.db.insert(session, payments);
      // Link to event
      for (var payment in insertedPayments) {
        await EventRegistration.db.attachRow
            .payments(session, registration, payment);
      }
    }
  }
}
