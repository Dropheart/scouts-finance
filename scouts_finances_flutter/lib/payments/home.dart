import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/parent.dart';
import 'package:scouts_finances_flutter/extensions/payment_method.dart';
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
  String query = '';
  final searchBy = [
    'payee',
    'amount',
    'date',
  ];
  int searchByIndex = 0;

  void _getPayments() async {
    try {
      final result = await client.payment.getPayments();

      final classifiedPayments = result.where((p) => p.parent != null).toList();
      classifiedPayments.sort((a, b) => a.date.compareTo(b.date));

      final unclassifiedPayments =
          result.where((p) => p.parent == null).toList();
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
                  style: const TextStyle(color: Colors.red, fontSize: 16))));
    }

    List<Card> unclassifiedPaymentCards = unclassifiedPayments.map((payment) {
      return toCard(context, payment);
    }).toList();

    List<Card> classifiedPaymentCards = classifiedPayments.map((payment) {
      return toCard(context, payment);
    }).toList();

    SearchBar searchBar = SearchBar(
      onChanged: (String value) {
        setState(() {
          query = value;
        });
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: const Icon(Icons.search),
      ),
      hintText: 'Search payments',
    );

    Widget sortSelection = Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Text("Search by:"),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton<int>(
              value: searchByIndex,
              items: searchBy.map((value) {
                return DropdownMenuItem<int>(
                  value: searchBy.indexOf(value),
                  child: Text(value),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  searchByIndex = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );

    final List<Widget> body = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: searchBar,
      ),
      sortSelection,
    ];
    if (unclassifiedPaymentCards.isNotEmpty) {
      body.add(ExpansionTile(
          title: Text(
              'Unclassified Payments - ${unclassifiedPaymentCards.length}'),
          initiallyExpanded: true,
          shape: const Border(),
          children: unclassifiedPaymentCards));
    }

    if (classifiedPaymentCards.isNotEmpty) {
      body.add(ExpansionTile(
          title: Text('Classified Payments - ${classifiedPaymentCards.length}'),
          initiallyExpanded: false,
          shape: const Border(),
          children: classifiedPaymentCards));
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddPaymentDialog();
                  },
                ).then((_) {
                  _getPayments(); // Refresh the UI after adding
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
          Row(
            children: [
              const Icon(Icons.person, size: 14.0),
              const SizedBox(width: 4.0),
              Text(payment.parent?.fullName ?? 'Unclassified'),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                  payment.method == PaymentMethod.cash
                      ? Icons.money
                      : Icons.credit_card,
                  size: 14.0),
              const SizedBox(width: 4.0),
              Text(payment.method.toDisplayString()),
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
