import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:scouts_finances_server/src/events.dart';
import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:scouts_finances_server/src/payments.dart';
import 'package:serverpod/serverpod.dart';
import 'package:yaml/yaml.dart';

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
      await BankAccount.db
          .deleteWhere(session, where: (t) => t.id > -1, transaction: t);
      await Parent.db
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

      // Create various bank accounts to use parent
      final bankAccs = <BankAccount>[];
      for (final _ in insertedParents) {
        // Randomly generate a sort code and account number
        final sortCode = '${Random().nextInt(10)}${Random().nextInt(10)}-'
            '${Random().nextInt(10)}${Random().nextInt(10)}-'
            '${Random().nextInt(10)}${Random().nextInt(10)}';
        final accountNumber = '${Random().nextInt(10)}${Random().nextInt(10)}'
            '${Random().nextInt(10)}${Random().nextInt(10)}'
            '${Random().nextInt(10)}${Random().nextInt(10)}'
            '${Random().nextInt(10)}${Random().nextInt(10)}';

        bankAccs.add(BankAccount(
            name: 'Starling',
            sortCode: sortCode,
            accountNumber: accountNumber));
      }
      final insertedBankAccs =
          await BankAccount.db.insert(session, bankAccs, transaction: t);

      final parentBanks = {
        for (int i = 0; i < insertedParents.length; i++)
          insertedParents[i].id: insertedBankAccs[i]
      };

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
          // Randomly pick a date within +/- 180 days from now (past or future)
          final date = DateTime.now().add(
            Duration(days: Random().nextInt(361) - 180),
          );
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

        // Get the bank account for the parent
        final bankAccount = parentBanks[registration.child!.parentId]!;

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
                  bankAccount: bankAccount,
                  bankAccountId: bankAccount.id,
                  amount: amount ~/ 2,
                  date: DateTime.now().subtract(Duration(days: 15)),
                ),
                Payment(
                  reference: ref(),
                  payee: payee,
                  method: PaymentMethod.bank_transfer,
                  bankAccount: bankAccount,
                  bankAccountId: bankAccount.id,
                  amount: amount ~/ 2,
                  date: DateTime.now(),
                ),
              ]
            : [
                Payment(
                  reference: ref(),
                  payee: payee,
                  method: PaymentMethod.bank_transfer,
                  bankAccount: bankAccount,
                  bankAccountId: bankAccount.id,
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

  Future<String> dummyData(Session session) async {
    try {
      // --- 1. DROP ALL EXISTING TABLES (in reverse order of dependency) ---
      print('--- Dropping all tables... ---');
      await Payment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await EventRegistration.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
      await Event.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Child.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await BankAccount.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
      await Parent.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await ScoutGroup.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
      print('--- All tables dropped successfully. ---');

      // --- 2. RECREATE TABLES FROM SCHEMA ---
      // Skipped: Serverpod does not support recreating tables at runtime.
      // Tables are managed via migrations and CLI tools, not programmatically.
      print('--- Skipping table recreation (not supported at runtime). ---');

      // --- 3. READ AND PARSE YAML DATA ---
      print('--- Reading and parsing YAML file... ---');
      final file = File('lib/src/data/dummy_data.yaml');
      if (!await file.exists()) {
        final errorMessage = 'Error: dummy_data.yaml not found at ${file.path}';
        print(errorMessage);
        return errorMessage;
      }
      final content = await file.readAsString();
      final yaml = loadYaml(content);
      print('--- YAML file parsed successfully. ---');

      // Maps to store the mapping from old YAML IDs to new database IDs
      final parentIdMap = <int, int>{};
      final bankAccountIdMap = <int, int>{};
      final childIdMap = <int, int>{};
      final eventIdMap = <int, int>{};
      final scoutGroupIdMap = <int, int>{};

      // --- 4. IMPORT DATA IN ORDER OF DEPENDENCY ---

      // Import Scout Groups (no dependencies)
      print('Importing scout groups...');
      for (var item in (yaml['scout_group'] as YamlList)) {
        final oldId = item['id'] as int;
        final group = ScoutGroup(
          name: item['name'],
          description: item['description'],
          colour: GroupColour.values.byName(item['colour']),
        );
        final newGroup = await ScoutGroup.db.insertRow(session, group);
        scoutGroupIdMap[oldId] = newGroup.id!;
      }

      // Import Parents (no dependencies)
      print('Importing parents...');
      for (var item in (yaml['parent'] as YamlList)) {
        final oldId = item['id'] as int;
        final parent = Parent(
          firstName: item['firstName'],
          lastName: item['lastName'],
          email: item['email'],
          phone: item['phone'],
          balance: item['balance'],
        );
        final newParent = await Parent.db.insertRow(session, parent);
        parentIdMap[oldId] = newParent.id!;
      }

      // Import Bank Accounts (depends on Parent)
      print('Importing bank accounts...');
      for (var item in (yaml['bank_account'] as YamlList)) {
        final oldId = item['id'] as int;
        final account = BankAccount(
          accountNumber: item['accountNumber'],
          sortCode: item['sortCode'],
          name: item['name'],
          parentId: parentIdMap[item['parentId']]!,
        );
        final newAccount = await BankAccount.db.insertRow(session, account);
        bankAccountIdMap[oldId] = newAccount.id!;
      }

      // Import Children (depends on Parent and ScoutGroup)
      print('Importing children...');
      for (var item in (yaml['child'] as YamlList)) {
        final oldId = item['id'] as int;
        final child = Child(
          firstName: item['firstName'],
          lastName: item['lastName'],
          parentId: parentIdMap[item['parentId']]!,
          scoutGroupId: scoutGroupIdMap[item['scoutGroupId']]!,
        );
        final newChild = await Child.db.insertRow(session, child);
        childIdMap[oldId] = newChild.id!;
      }

      // Import Events (depends on ScoutGroup)
      print('Importing events...');
      for (var item in (yaml['event'] as YamlList)) {
        final oldId = item['id'] as int;
        final event = Event(
          name: item['name'],
          date: DateTime.parse(item['date']),
          cost: item['cost'],
          // Handle optional scout group for "All groups" events
          scoutGroupId: item['scoutGroupId'] != null
              ? scoutGroupIdMap[item['scoutGroupId']]!
              : 0,
        );
        final newEvent = await Event.db.insertRow(session, event);
        eventIdMap[oldId] = newEvent.id!;
      }

      // Import Event Registrations (depends on Event and Child)
      print('Importing event registrations...');
      for (var item in (yaml['event_registration'] as YamlList)) {
        final registration = EventRegistration(
          eventId: eventIdMap[item['eventId']]!,
          childId: childIdMap[item['childId']]!,
          paidDate: item['paidDate'] != null
              ? DateTime.parse(item['paidDate'])
              : null,
        );
        await EventRegistration.db.insertRow(session, registration);
      }

      // Import Payments (depends on BankAccount and Parent)
      print('Importing payments...');
      for (var item in (yaml['payment'] as YamlList)) {
        final payment = Payment(
          amount: item['amount'],
          date: DateTime.parse(item['date']),
          reference: item['reference'],
          method: PaymentMethod.values.byName(item['method']),
          payee: item['payee'],
          bankAccountId: item['bankAccountId'] != null
              ? bankAccountIdMap[item['bankAccountId']]
              : null,
          parentId:
              item['parentId'] != null ? parentIdMap[item['parentId']] : null,
        );
        await Payment.db.insertRow(session, payment);
      }

      print('--- Data import complete! ---');
      return 'Successfully dropped all tables and populated with dummy data.';
    } catch (e, stackTrace) {
      final errorMessage = 'An error occurred during data import: $e';
      print(errorMessage);
      print(stackTrace);
      return errorMessage;
    }
  }
}
