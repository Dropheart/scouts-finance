import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/add.dart';

class PaymentsHome extends StatefulWidget {
  const PaymentsHome({super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  late List<Payment> payments;
  String? err;
  bool loading = true;

  void _getEvents() async {
    try {
      final result = await client.payment.getPayments();
      setState(() {
        payments = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        err =
            'Failed to load payments. Are you connected to the internet? If this error persists, please contact the developers.';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
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
        ),
      );
    }

    List<Card> paymentCards = payments.map((payment) {
      return Card(
        child: ListTile(
          title: Text('£${(payment.amount / 100).toStringAsFixed(2)}'),
          subtitle: Row(children: [
            Text(payment.payee),
            const Spacer(),
            Text(payment.date.toLocal().toString().split(' ')[0]),
          ]),
          onTap: () {
            // Navigate to payment details
          },
          trailing: const Icon(Icons.edit_square),
        ),
      );
    }).toList();

    Column body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Action Required - 1',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...paymentCards,
        const Text('Known Payees - 2',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Card(
          child: ListTile(
            title: const Text('£2.49'),
            subtitle: const Row(
              children: [
                Text('Nishant Aanjaney Jalan'),
                Spacer(),
                Text('01/01/2025'),
              ],
            ),
            onTap: () {
              // Navigate to event details
            },
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('£3.14'),
            subtitle: const Row(
              children: [
                Text('Nishant Aanjaney Jalan'),
                Spacer(),
                Text('07/05/2025'),
              ],
            ),
            onTap: () {
              // Navigate to event details
            },
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
        const SizedBox(height: 128.0),
      ],
    );

    return Scaffold(
      body: Padding(
          padding: EdgeInsetsGeometry.all(8.0),
          child: SingleChildScrollView(child: body)),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddPaymentDialog();
                  },
                ).then((_) {
                  _getEvents();
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
