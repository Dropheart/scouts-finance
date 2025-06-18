import 'package:scouts_finances_server/src/extensions.dart';
import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:scouts_finances_server/src/reminder.dart';
import 'package:scouts_finances_server/src/twlilio.dart';
import 'package:serverpod/serverpod.dart';

class PaymentEndpoint extends Endpoint {
  Future<List<Payment>> getPayments(Session session) async {
    return Payment.db.find(session,
        include: Payment.include(
            parent: Parent.include(), bankAccount: BankAccount.include()));
    // This will also fetch the parent information for each payment (if it exists)
  }

  Future<Payment> insertPayment(Session session, Payment payment) async {
    final res = await Payment.db.insertRow(
      session,
      payment,
    );

    // Notify of update payments
    session.messages.postMessage('update_payments', res);
    return res;
  }

  Future<Payment?> getPaymentById(Session session, int paymentId) async {
    // Find the payment by ID
    return Payment.db.findById(session, paymentId,
        include: Payment.include(bankAccount: BankAccount.include()));
  }

  Future<List<Payment>> getPaymentsByParentId(
      Session session, int parentId) async {
    // Find all payments associated with the given parent ID
    return Payment.db.find(session, where: (p) => p.parentId.equals(parentId));
  }

  Future<void> updatePayment(Session session, int paymentId, Parent parent,
      {Transaction? transaction}) async {
    // Find the payment by ID
    final payment = await Payment.db.findById(session, paymentId,
        transaction: transaction,
        include: Payment.include(bankAccount: BankAccount.include()));
    if (payment == null) {
      throw ArgumentError('Payment with id $paymentId not found');
    }
    print('Updating payment with ID: $paymentId for parent: ${parent.id}');

    // If new bank account, assign to parent
    final paymentBankAcc = payment.bankAccount;
    final assignablePayments = [payment];
    if (paymentBankAcc != null && paymentBankAcc.parentId == null) {
      // This is a new bank account, so assign it to parent
      // and see if we can clear more payments
      paymentBankAcc.parent = parent;
      paymentBankAcc.parentId = parent.id;
      final res = await BankAccount.db
          .updateRow(session, paymentBankAcc, transaction: transaction);

      print(
          'Inserted new bank account: ${res.id} (${res.name}) to parent: ${parent.id} (${parent.firstName} ${parent.lastName})');

      // Get all other unassigned payments from this bank account
      final otherPayments = await Payment.db.find(
        session,
        where: (p) =>
            p.bankAccount.sortCode.equals(paymentBankAcc.sortCode) &
            p.bankAccount.accountNumber.equals(paymentBankAcc.accountNumber) &
            p.parentId.equals(null),
        transaction: transaction,
      );

      print(
          'Found ${otherPayments.length} other payments for bank account: ${paymentBankAcc.id} (${paymentBankAcc.name})');

      assignablePayments.addAll(otherPayments);
    }

    // Find all event registrations that can be paid
    // sorted by date
    final registrations = await EventRegistration.db.find(session,
        where: (t) =>
            (t.child.parentId.equals(parent.id)) & (t.paidDate.equals(null)),
        orderBy: (t) => t.event.date,
        include: EventRegistration.include(
          event: Event.include(),
        ),
        transaction: transaction);

    // Get new parent balance & see what we can pay off
    int balance =
        parent.balance + assignablePayments.fold(0, (sum, p) => sum + p.amount);
    final clearableRegistrations = <EventRegistration>[];
    while (balance > 0 && registrations.isNotEmpty) {
      final reg = registrations.removeAt(0);
      if (reg.event!.cost <= balance) {
        reg.paidDate = DateTime.now();
        clearableRegistrations.add(reg);
        balance -= reg.event!.cost;
      } else {
        break;
      }
    }

    // Update the payments with the new parent information
    for (var p in assignablePayments) {
      p.parentId = parent.id;
      p.parent = parent;
    }

    parent.balance = balance;
    if (transaction == null) {
      await session.db.transaction((transaction) async {
        await Payment.db
            .update(session, assignablePayments, transaction: transaction);
        await EventRegistration.db
            .update(session, clearableRegistrations, transaction: transaction);
        await Parent.db.updateRow(session, parent, transaction: transaction);
      });
    } else {
      await Payment.db
          .update(session, assignablePayments, transaction: transaction);

      await EventRegistration.db
          .update(session, clearableRegistrations, transaction: transaction);

      await Parent.db.updateRow(session, parent, transaction: transaction);
    }
    // To reload the 'events' tab
    session.messages.postMessage('update_events', payment);
    // Notify of update payments
    session.messages.postMessage('update_payments', payment);

    final buffer = StringBuffer();
    buffer.writeln('Dear ${parent.firstName},\n');

    buffer.writeln(
        'Your payment of ${assignablePayments.fold(0, (sum, p) => sum + p.amount).formatMoney} has been recieved and processed successfully.');
    buffer.writeln('Your new financial standing is as follows:');
    final financialStanding = await eventRemindersForParent(session, parent);
    buffer.writeln(financialStanding);

    final msg = buffer.toString();
    await TwilioClient().sendMessage(body: msg);
  }

  Future<void> insertCashPayment(
      Session session, Payment payment, EventRegistration eventReg) async {
    payment.parent = eventReg.child!.parent;
    payment.parentId = eventReg.child!.parentId;

    await Payment.db.insertRow(
      session,
      payment,
    );

    eventReg.paidDate = DateTime.now();
    await EventRegistration.db.updateRow(
      session,
      eventReg,
    );

    // To reload the 'events' tab
    session.messages.postMessage('update_events', payment);
    // Notify of update payments
    session.messages.postMessage('update_payments', payment);
  }

  Stream paymentStream(Session session) async* {
    // This stream will yield new payments as they are inserted
    await for (final message
        in session.messages.createStream('update_payments')) {
      yield message;
    }
  }
}
