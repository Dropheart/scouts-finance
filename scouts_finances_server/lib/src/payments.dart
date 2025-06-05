import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class PaymentEndpoint extends Endpoint {
  Future<List<Payment>> getPayments(Session session) async {
    return Payment.db.find(session);
  }

  Future<List<Payment>> insertPayment(
      Session session, int amount, String payee, DateTime? date) async {
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

  Future<void> updatePayment(
      Session session, int paymentId, Parent parent) async {
    // Find the payment by ID
    final payment = await Payment.db.findById(session, paymentId);
    if (payment == null) {
      throw ArgumentError('Payment with id $paymentId not found');
    }
    // Update the payment with the new parent information
    //payment.parent = parent;
    payment.parentId = parent.id!;
    print('Updating payment with ID: $paymentId for parent: ${parent.id}');
    await Payment.db.updateRow(session, payment);
  }
}
