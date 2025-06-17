import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:scouts_finances_server/src/events.dart';
import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:scouts_finances_server/src/payments.dart';
import 'package:serverpod/serverpod.dart';

class UserInfo {
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;

  UserInfo({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    final phone = json['phone'] as String?;
    String? ukPhone;
    if (phone != null) {
      // Strip out brackets, dashes, and plus signs and add country code
      String strippedPhone = phone.replaceAll(RegExp(r'\(|\)|\-|\+| '), '');
      if (strippedPhone.startsWith('0')) {
        strippedPhone = strippedPhone.substring(1);
      }
      ukPhone = '+44$strippedPhone';
    }

    return UserInfo(
      firstName: json['name']['first'] as String,
      lastName: json['name']['last'] as String,
      email: json['email'] as String?,
      phone: ukPhone,
    );
  }
}

class AdminEndpoint extends Endpoint {
  Future<void> resetDb(Session session) async {
    // Hardcode some dummy data into the database for testing purposes.
    final scoutGroups = [
      ('Beavers', GroupColour.lightblue),
      ('Cubs', GroupColour.green),
      ('Scouts', GroupColour.teal)
    ];
    final childrenPerGroup = 20;
    final numParents = (childrenPerGroup * 1.5)
        .floor(); // Some parents have children in multiple groups, some don't

    // Get random API data upfront, as to not delete data if we can't recreate
    // Initialize getting random user data
    String randomPeopleEndpoint(int numPeople, List<String> inc) =>
        'https://randomuser.me/api/?results=$numPeople&inc=${inc.join(',')}&noinfo&nat=gb';
    final httpClient = http.Client();

    // Fetch people to be parents
    final parentReq = await httpClient.read(Uri.parse(
        randomPeopleEndpoint(numParents, ['name', 'email', 'phone'])));
    final parentJson = json.decode(parentReq) as Map<String, dynamic>;
    final List<UserInfo> parentInfos = (parentJson['results'] as List)
        .map((p) => UserInfo.fromJson(p as Map<String, dynamic>))
        .toList();

    // Fetch people to be children
    final childReq = await httpClient.read(Uri.parse(
        randomPeopleEndpoint(childrenPerGroup * scoutGroups.length, ['name'])));
    final childJson = json.decode(childReq) as Map<String, dynamic>;
    final List<UserInfo> childInfos = (childJson['results'] as List)
        .map((c) => UserInfo.fromJson(c as Map<String, dynamic>))
        .toList();
    httpClient.close();

    // Do it all in a transaction for performance + rollback
    await session.db.transaction((t) async {
      // First, delete all existing data
      await Payment.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await EventRegistration.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await Child.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await Event.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await Parent.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await BankAccount.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await ScoutGroup.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);

      // Create scout groups
      final groups = scoutGroups
          .map((group) => ScoutGroup(name: group.$1, colour: group.$2))
          .toList();
      final insertedGroups =
          await ScoutGroup.db.insert(session, groups, transaction: t);

      // Create parents
      final parents = <Parent>[];
      for (var i = 0; i < numParents; i++) {
        final info = parentInfos[i];
        parents.add(Parent(
          firstName: info.firstName,
          lastName: info.lastName,
          email: info.email!,
          phone: info.phone!,
          balance: 0,
        ));
      }
      final insertedParents =
          await Parent.db.insert(session, parents, transaction: t);

      // For each scout group, create & add children
      final children = <Child>[];
      for (final group in insertedGroups) {
        for (var i = 0; i < childrenPerGroup; i++) {
          final info =
              childInfos[i + childrenPerGroup * insertedGroups.indexOf(group)];
          // Randomly assign a parent to the child
          final parent =
              insertedParents[Random().nextInt(insertedParents.length)];

          children.add(Child(
            firstName: info.firstName,
            lastName: info.lastName,
            scoutGroupId: group.id!,
            parentId: parent.id!,
          ));
        }
      }
      final insertedChildren =
          await Child.db.insert(session, children, transaction: t);

      // Create some events
      final scoutEvents = [
        'Rafting',
        'Hiking',
        'Camping',
        'Swimming',
        'Climbing',
        'Archery',
        'Cycling',
        'Kayaking',
        'Sailing',
        'Rock Climbing',
        'Caving',
        'Fishing',
        'Skiing',
        'Snowboarding',
        'Surfing',
        'Horse Riding'
      ];

      // Each scout group gets between 3 and 7 events
      final events = <Event>[];
      for (final group in insertedGroups) {
        final numEvents = 3 + Random().nextInt(5); // Between 3 and 7 events
        final shuffledEvents = scoutEvents.toList()
          ..shuffle()
          ..take(numEvents);
        for (var i = 0; i < numEvents; i++) {
          final eventName = shuffledEvents[i];
          final cost =
              500 + Random().nextInt(2000); // Cost between 5 and 25 pounds
          // Some time in the next year
          final date =
              DateTime.now().add(Duration(days: Random().nextInt(365)));
          events.add(Event(
            name: eventName,
            cost: cost,
            date: date,
            scoutGroupId: group.id!,
          ));
        }
      }
      final insertedEvents =
          await Event.db.insert(session, events, transaction: t);

      // Register some children for events
      // Each child has a 50% chance of being registered for a given event
      final eventRegs = <(int childId, int eventId)>[];
      for (final group in insertedGroups) {
        final groupEvents =
            insertedEvents.where((e) => e.scoutGroupId == group.id!).toList();
        final groupChildren =
            insertedChildren.where((c) => c.scoutGroupId == group.id!).toList();

        for (final event in groupEvents) {
          // Randomly decide whether to register the child for each event
          for (final child in groupChildren) {
            if (Random().nextBool()) {
              eventRegs.add((child.id!, event.id!));
            }
          }
        }
      }

      // Use the endpoint in case logic changes in the future
      final endpoint = EventEndpoint();
      for (final (childId, eventId) in eventRegs) {
        await endpoint.registerChildForEvent(session, eventId, childId,
            transaction: t);
      }

      // Get IDs of the inserted registrations
      final insertedRegistrations = await EventRegistration.db.find(session,
          include: EventRegistration.include(
              event: Event.include(),
              child: Child.include(parent: Parent.include())),
          transaction: t);

      // Create some payments for the registrations
      final payments = <Payment>[];
      for (final registration in insertedRegistrations) {
        // Get the event for the event cost
        final event = registration.event!;

        // Randomly decide whether to pay
        // All events are in the next year so decide
        // based on how far in the future the event is
        if (Random().nextDouble() >
            (event.date.difference(DateTime.now()).inDays / 365)) {
          continue; // Skip this registration, no payment
        }

        // Randomly decide whether to pay in full or partially
        // 95/5 split
        final payInFull = Random().nextDouble() < 0.95;

        // Randomly decide the amount to pay if not paying in full
        final int amount = payInFull
            ? event.cost
            : (event.cost * Random().nextDouble()).toInt();
        // Randomly decide to pay in two installments or not - this bit is
        // mainly to test our payment logic but also to simulate real-world
        final payInTwoInstallments = Random().nextBool();

        // Create the payments
        final parent = registration.child!.parent!;
        final payee = '${parent.firstName} ${parent.lastName}';

        // Nonsense ref because parents are a pain to deal with
        // Eventually, change this to be X% chance of expected ref.
        // For now, 18 characters of random alphanumeric string
        String ref() => String.fromCharCodes(
              List.generate(18, (index) => Random().nextInt(26) + 97),
            );

        final newPayments = payInTwoInstallments
            ? [
                Payment(
                  reference: ref(),
                  payee: payee,
                  method: PaymentMethod.bank_transfer,
                  amount: amount ~/ 2,
                  date: DateTime.now().subtract(Duration(days: 15)),
                ),
                Payment(
                  reference: ref(),
                  payee: payee,
                  method: PaymentMethod.bank_transfer,
                  amount: amount ~/ 2,
                  date: DateTime.now(),
                ),
              ]
            : [
                Payment(
                  reference: ref(),
                  payee: payee,
                  method: PaymentMethod.bank_transfer,
                  amount: amount,
                  date: DateTime.now(),
                ),
              ];

        payments.addAll(newPayments);
      }

      // Insert the payments
      final insertedPayments =
          await Payment.db.insert(session, payments, transaction: t);

      // Assign ~80% of payments to parents
      final assignedPayments = <(Payment payment, Parent parent)>[];
      for (final payment in insertedPayments) {
        if (Random().nextDouble() < 0.8) {
          // Randomly assign a parent to the payment
          final parent = insertedParents.firstWhere(
            (p) => payment.payee == '${p.firstName} ${p.lastName}',
          );

          assignedPayments.add((payment, parent));
        }
      }
      // Use the API endpoint for the logic.
      final paymentEndpoint = PaymentEndpoint();
      for (final (payment, parent) in assignedPayments) {
        await paymentEndpoint.updatePayment(session, payment.id!, parent,
            transaction: t);
      }
    });
  }
}
