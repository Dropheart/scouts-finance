import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
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
  late List<Payment> matchedPayments;
  late List<Payment> unmatchedPayments;
  String? err;
  bool loading = true;
  String query = '';

  void _getPayments() async {
    try {
      final result = await client.payment.getPayments();

      final matchedPayments = result.where((p) => p.parent != null).toList();
      matchedPayments.sort((a, b) => a.date.compareTo(b.date));

      final unmatchedPayments = result.where((p) => p.parent == null).toList();
      unmatchedPayments.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        this.matchedPayments = matchedPayments;
        this.unmatchedPayments = unmatchedPayments;
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

    // Filter payments based on the search query
    List<Payment> filteredUnmatchedPayments = unmatchedPayments
        .where((payment) =>
            payment.payee.toLowerCase().contains(query.toLowerCase()) ||
            (payment.amount / 100).toString().contains(query) ||
            payment.date.toLocal().toString().contains(query))
        .toList();

    List<Card> uncmatchedPaymentCards =
        filteredUnmatchedPayments.map((payment) {
      return toCard(context, payment);
    }).toList();

    // Filter payments based on the search query
    List<Payment> filteredMatchedPayments = matchedPayments
        .where((payment) =>
            payment.payee.toLowerCase().contains(query.toLowerCase()) ||
            payment.amount.toString().contains(query) ||
            payment.date.toLocal().toString().contains(query))
        .toList();

    List<Card> matchedPaymentCards = filteredMatchedPayments.map((payment) {
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
      hintText: 'Search by payee, amount, date...',
    );

    final List<Widget> body = [
      searchBar,
    ];

    if (uncmatchedPaymentCards.isNotEmpty) {
      body.add(ExpansionTile(
          title: Text('Unmatched Payments - ${uncmatchedPaymentCards.length}'),
          initiallyExpanded: true,
          controlAffinity: ListTileControlAffinity.leading,
          shape: const Border(),
          children: uncmatchedPaymentCards));
    }

    if (matchedPaymentCards.isNotEmpty) {
      body.add(ExpansionTile(
          title: Text('Matched Payments - ${matchedPaymentCards.length}'),
          initiallyExpanded: false,
          shape: const Border(),
          controlAffinity: ListTileControlAffinity.leading,
          children: matchedPaymentCards));
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPaymentDialog();
            },
          ).then((_) {
            _getPayments();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Card toCard(BuildContext context, Payment payment) {
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
              Text(payment.parent?.fullName ?? 'Unmatched'),
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
