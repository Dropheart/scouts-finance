import 'package:scouts_finances_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class PaymentEndpoint extends Endpoint {
  Future<List<Payment>> getPayments(Session session) async {
    return Payment.db.find(session);
  }

  Future<List<Payment>> insertPayment(
      Session session, double amount, String payee
    ) async {
    final payment = Payment(
      amount: amount,
      method: PaymentMethod.cash,
      payee: payee,
      date: DateTime.now(),
      reference: "Cash Payment",
    );
    // Insert the payment into the database
    await Payment.db.insert(session, [payment]);

    // Return the updated list of payments
    return Payment.db.find(session);
  }
}