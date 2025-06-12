import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class PaymentEndpoint extends Endpoint {
  Future<List<Payment>> getPayments(Session session) async {
    return Payment.db
        .find(session, include: Payment.include(parent: Parent.include()));
    // This will also fetch the parent information for each payment (if it exists)
  }

  Future<List<Payment>> insertPayment(
      Session session, int amount, String payee, DateTime? date) async {
    final payment = Payment(
      amount: amount,
      method: PaymentMethod.cash, // Default to cash, can be changed later
      payee: payee,
      date: date ?? DateTime.now(),
      reference: "Manual Payment",
    );
    // Insert the payment into the database
    await Payment.db.insert(session, [payment]);

    // Return the updated list of payments
    return Payment.db.find(session);
  }

  Future<Payment?> getPaymentById(Session session, int paymentId) async {
    // Find the payment by ID
    return Payment.db.findById(session, paymentId);
  }

  Future<List<Payment>> getPaymentsByParentId(
      Session session, int parentId) async {
    // Find all payments associated with the given parent ID
    return Payment.db.find(session, where: (p) => p.parentId.equals(parentId));
  }

  Future<void> updatePayment(
      Session session, int paymentId, Parent parent) async {
    // Find the payment by ID
    final payment = await Payment.db.findById(session, paymentId);
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
        ));

    // Get new parent balance & see what we can pay off
    int balance = parent.balance + payment.amount;
    final clearableRegistrations = <EventRegistration>[];
    while (balance > 0 && registrations.isNotEmpty) {
      final reg = registrations.removeAt(0);
      if (reg.event!.cost <= balance) {
        clearableRegistrations.add(reg);
        balance -= reg.event!.cost;
      } else {
        break;
      }
    }

    await session.db.transaction((transaction) async {
      payment.parentId = parent.id;
      await Payment.db.updateRow(session, payment, transaction: transaction);

      for (final reg in clearableRegistrations) {
        reg.paidDate = DateTime.now();
        await EventRegistration.db
            .updateRow(session, reg, transaction: transaction);
      }

      parent.balance = balance;
      await Parent.db.updateRow(session, parent, transaction: transaction);
    });
  }
}
