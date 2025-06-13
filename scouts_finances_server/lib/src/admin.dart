import 'dart:math';

import 'package:scouts_finances_server/src/events.dart';
import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class AdminEndpoint extends Endpoint {
  Future<void> resetDb(Session session) async {
    // Hardcode some dummy data into the database for testing purposes.

    // First, delete all existing data
    await Payment.db.deleteWhere(session, where: (t) => t.id > -1);
    await EventRegistration.db.deleteWhere(session, where: (t) => t.id > -1);
    await Child.db.deleteWhere(session, where: (t) => t.id > -1);
    await Event.db.deleteWhere(session, where: (t) => t.id > -1);
    await Parent.db.deleteWhere(session, where: (t) => t.id > -1);
    await BankAccount.db.deleteWhere(session, where: (t) => t.id > -1);

    final parent1 = Parent(
        firstName: "Phoebe",
        lastName: "Galindo",
        email: "pgalindo@gmail.com",
        phone: "1234567890",
        balance: 0);
    final parent2 = Parent(
        firstName: "Salvatore",
        lastName: "Esparza",
        email: "sesparza@gmail.com",
        phone: "2345678901",
        balance: 0);
    final parent3 = Parent(
        firstName: "Ramona",
        lastName: "Stanton",
        email: "rstanton@gmail.com",
        phone: "3456789012",
        balance: 0);
    final parent4 = Parent(
        firstName: "Zyair",
        lastName: "Gould",
        email: "zgould@gmail.com",
        phone: "4567890123",
        balance: 0);
    final parent5 = Parent(
        firstName: "Violeta",
        lastName: "Norman",
        email: "vnorman@gmail.com",
        phone: "5678901234",
        balance: 0);

    await Parent.db
        .insert(session, [parent1, parent2, parent3, parent4, parent5]);

    List<Parent> insertedParents =
        await Parent.db.find(session, where: (t) => t.id > -1);

    // Now create some children
    final child1 = Child(
        firstName: "John",
        lastName: "Doe",
        parentId:
            insertedParents[Random().nextInt(insertedParents.length)].id!);
    final child2 = Child(
        firstName: "Jane",
        lastName: "Doe",
        parentId:
            insertedParents[Random().nextInt(insertedParents.length)].id!);
    final child3 = Child(
        firstName: "Alice",
        lastName: "Smith",
        parentId:
            insertedParents[Random().nextInt(insertedParents.length)].id!);
    final child4 = Child(
        firstName: "Silver",
        lastName: "Johnson",
        parentId:
            insertedParents[Random().nextInt(insertedParents.length)].id!);
    final child5 = Child(
        firstName: "Charlie",
        lastName: "Brown",
        parentId:
            insertedParents[Random().nextInt(insertedParents.length)].id!);
    await Child.db.insert(session, [child1, child2, child3, child4, child5]);

    // Create some events
    final event1 =
        Event(name: "Rafting", cost: 500, date: DateTime(2025, 1, 5));
    final event2 =
        Event(name: "Hiking", cost: 1000, date: DateTime(2025, 2, 10));
    final event3 =
        Event(name: "Camping", cost: 750, date: DateTime(2025, 3, 15));
    final event4 =
        Event(name: "Swimming", cost: 1500, date: DateTime(2025, 4, 20));
    final event5 =
        Event(name: "Climbing", cost: 2000, date: DateTime(2025, 5, 25));

    await Event.db.insert(session, [event1, event2, event3, event4, event5]);

    // Get the IDs of the inserted children and events
    final insertedChildren = await Child.db.find(session);
    final insertedEvents = await Event.db.find(session);

    // Register some children for events
    // Register children for events using the registerChildForEvent endpoint
    final registrationsData = [
      [insertedEvents[0].id!, insertedChildren[0].id!],
      [insertedEvents[0].id!, insertedChildren[1].id!],
      [insertedEvents[0].id!, insertedChildren[2].id!],
      [insertedEvents[1].id!, insertedChildren[1].id!],
      [insertedEvents[1].id!, insertedChildren[2].id!],
      [insertedEvents[2].id!, insertedChildren[3].id!],
      [insertedEvents[3].id!, insertedChildren[4].id!],
      [insertedEvents[4].id!, insertedChildren[0].id!],
    ];

    final endpoint = EventEndpoint();

    // Use the endpoint to register children for events so we get balances
    for (var reg in registrationsData) {
      await endpoint.registerChildForEvent(session, reg[0], reg[1]);
    }

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
      final int amount =
          payInFull ? event.cost : (event.cost * Random().nextDouble()).toInt();
      // Randomly decide to pay in two installments or not
      final payInTwoInstallments = Random().nextBool();
      // Create the payments
      final payee = [
        "${parent1.firstName} ${parent1.lastName}",
        "${parent2.firstName} ${parent2.lastName}",
        "${parent3.firstName} ${parent3.lastName}",
        "${parent4.firstName} ${parent4.lastName}",
        "${parent5.firstName} ${parent5.lastName}",
      ][Random().nextInt(5)];

      final payments = payInTwoInstallments
          ? [
              Payment(
                reference: "Hope my child enjoys :)",
                payee: payee,
                method: PaymentMethod.cash,
                amount: amount ~/ 2,
                date: DateTime.now().subtract(Duration(days: 30)),
              ),
              Payment(
                reference: "Hope my child enjoys :)",
                payee: payee,
                method: PaymentMethod.cash,
                amount: amount ~/ 2,
                date: DateTime.now(),
              ),
            ]
          : [
              Payment(
                reference: "Hope my child enjoys :)",
                payee: payee,
                method: PaymentMethod.cash,
                amount: amount,
                date: DateTime.now(),
              ),
            ];

      // Insert into the payment table
      /*final insertedPayments = */
      await Payment.db.insert(session, payments);
      // // Link to event
      // for (var payment in insertedPayments) {
      //   await EventRegistration.db.attachRow
      //       .payments(session, registration, payment);
      // }
    }
  }
}
