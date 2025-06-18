import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class PaymentEndpoint extends Endpoint {
  Future<List<Payment>> getPayments(Session session) async {
    return Payment.db
        .find(session, include: Payment.include(parent: Parent.include()));
    // This will also fetch the parent information for each payment (if it exists)
  }

  Future<List<Payment>> insertPayment(Session session, Payment payment) async =>
      Payment.db.insert(
        session,
        [payment],
      );

  Future<Payment?> getPaymentById(Session session, int paymentId) async {
    // Find the payment by ID
    return Payment.db.findById(session, paymentId);
  }

  Future<List<Payment>> getPaymentsByParentId(
      Session session, int parentId) async {
    // Find all payments associated with the given parent ID
    return Payment.db.find(session, where: (p) => p.parentId.equals(parentId));
  }

  Future<void> updatePayment(Session session, int paymentId, Parent parent,
      {Transaction? transaction}) async {
    // Find the payment by ID
    final payment =
        await Payment.db.findById(session, paymentId, transaction: transaction);
    if (payment == null) {
      throw ArgumentError('Payment with id $paymentId not found');
    }
    // Update the payment with the new parent information
    print('Updating payment with ID: $paymentId for parent: ${parent.id}');

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
    int balance = parent.balance + payment.amount;
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

    payment.parentId = parent.id;
    payment.parent = parent;
    parent.balance = balance;
    if (transaction == null) {
      await session.db.transaction((transaction) async {
        await Payment.db.updateRow(session, payment, transaction: transaction);
        await EventRegistration.db
            .update(session, clearableRegistrations, transaction: transaction);
        await Parent.db.updateRow(session, parent, transaction: transaction);
      });
    } else {
      await Payment.db.updateRow(session, payment, transaction: transaction);

      await EventRegistration.db
          .update(session, clearableRegistrations, transaction: transaction);

      await Parent.db.updateRow(session, parent, transaction: transaction);
    }
    // To reload the 'events' tab
    session.messages.postMessage('update_events', payment);
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
  }
}
