import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/payment_method.dart';

class PaymentTable extends StatelessWidget {
  final Payment payment;

  const PaymentTable({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text("£${(payment.amount / 100).toStringAsFixed(2)}"),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(payment.date.toLocal().toString().split(' ')[0]),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Payee Name",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(payment.payee),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Payment Method",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(payment.method.toDisplayString()),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Sort code",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(payment.bankAccount?.sortCode ?? "N/A"),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Account No.",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(payment.bankAccount?.accountNumber ?? "N/A"),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Reference",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(payment.reference),
        ]),
      ],
    );
  }
}
