import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/extensions/payment_method.dart';
import 'package:scouts_finances_flutter/payments/single_payment.dart';

Card toCard(BuildContext context, Payment payment, Function callback) {
  return Card(
    child: ListTile(
      title: Row(
        children: [
          Text('£${(payment.amount / 100).toStringAsFixed(2)}'),
          const Spacer(),
          const SizedBox(width: 4.0),
          Text(payment.method.toDisplayString()),
        ],
      ),
      subtitle: Row(children: [
        Row(
          children: [
            const Icon(Icons.person, size: 14.0),
            const SizedBox(width: 4.0),
            Text(payment.parent?.fullName ?? 'Unattributed'),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14.0),
            const SizedBox(width: 4.0),
            Text(payment.date.toLocal().toString().split(' ')[0]),
          ],
        ),
      ]),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SinglePaymentView(paymentId: payment.id!, callback: callback),
          ),
        );
      },
      trailing: const Icon(Icons.edit_square),
    ),
  );
}
