import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/add.dart';
import 'package:scouts_finances_flutter/payments/single_payment.dart';

class PaymentsHome extends StatefulWidget {
  const PaymentsHome({super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  late List<Payment> classifiedPayments;
  late List<Payment> unclassifiedPayments;
  String? err;
  bool loading = true;

  void _getPayments() async {
    try {
      final result = await client.payment.getPayments();

      final classifiedPayments =
          result.where((p) => p.parentId != null).toList();
      classifiedPayments.sort((a, b) => a.date.compareTo(b.date));

      final unclassifiedPayments =
          result.where((p) => p.parentId == null).toList();
      unclassifiedPayments.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        this.classifiedPayments = classifiedPayments;
        this.unclassifiedPayments = unclassifiedPayments;
        loading = false;
      });
    } catch (e) {
      setState(() {
        err =
            'Failed to load payments. Are you connected to the internet? If this error persists, please contact the developers.';
        err =
            'Failed to load payments. Are you connected to the internet? If this error persists, please contact the developers.';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPayments();
  }

  @override
  Widget build(BuildContext context) {
    // Get which payments are action required
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (err != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(err!,
              style: const TextStyle(color: Colors.red, fontSize: 16)),
              style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    }

    List<Card> unclassifiedPaymentCards = unclassifiedPayments.map((payment) {
      return toCard(context, payment);
    }).toList();

    List<Card> classifiedPaymentCards = classifiedPayments.map((payment) {
      return toCard(context, payment);
    }).toList();

    final List<Widget> body = [];
    if (unclassifiedPaymentCards.isNotEmpty) {
      body.add(Text(
          "Unclassified Payments - ${unclassifiedPaymentCards.length}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
      body.addAll(unclassifiedPaymentCards);
    }

    if (classifiedPaymentCards.isNotEmpty) {
      body.add(Text("Classified Payments - ${classifiedPaymentCards.length}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
      body.addAll(classifiedPaymentCards);
    }

    body.add(const SizedBox(height: 128.0));

    return Scaffold(
      body: Padding(
          padding: EdgeInsetsGeometry.all(8.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: body,
          ))),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'fab_left',
              child: const Icon(Icons.save),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Export'),
                      content: const Text('Feature not implemented yet!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            FloatingActionButton(
              heroTag: 'fab_right',
              child: const Icon(Icons.add),
              onPressed: () {
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddPaymentDialog();
                    return AddPaymentDialog();
                  },
                ).then((_) {
                  _getPayments();
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Card toCard(BuildContext context, Payment payment) {
    return Card(
      child: ListTile(
        title: Text('£${(payment.amount / 100).toStringAsFixed(2)}'),
        subtitle: Row(children: [
          Text(payment.payee),
          const Spacer(),
          Text(payment.date.toLocal().toString().split(' ')[0]),
        ]),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SinglePaymentView(paymentId: payment.id!),
            ),
          );
          _getPayments(); // Refresh payments after viewing
        },
        trailing: const Icon(Icons.edit_square),
      ),
    );
  }
}
