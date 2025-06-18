import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/shared.dart';

class UnmatchedView extends StatefulWidget {
  const UnmatchedView(
      {super.key, required this.searchBar, required this.query});
  final SearchBar searchBar;
  final String query;

  @override
  State<UnmatchedView> createState() => UnmatchedViewState();
}

class UnmatchedViewState extends State<UnmatchedView> {
  late List<Payment> unmatchedPayments;
  String? err;
  bool loading = true;

  final ScrollController _scrollController = ScrollController();

  late StreamSubscription stream;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    stream.cancel();
  }

  void _getPayments() async {
    try {
      final result = await client.payment.getPayments();

      final unmatchedPayments = result.where((p) => p.parent == null).toList();
      unmatchedPayments.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
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
    stream = client.payment.paymentStream().listen((_) {
      refresh();
    });
  }

  void refresh() {
    setState(() {
      loading = true;
      err = null;
    });
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
            payment.payee.toLowerCase().contains(widget.query.toLowerCase()) ||
            (payment.amount / 100).toString().contains(widget.query) ||
            payment.date.toLocal().toString().contains(widget.query))
        .toList();

    List<Card> unmatchedPaymentCards = filteredUnmatchedPayments.map((payment) {
      return toCard(context, payment, refresh);
    }).toList();

    return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.searchBar,
            const SizedBox(height: 16.0),
            ...unmatchedPaymentCards,
            if (unmatchedPaymentCards.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No unattributed payments found.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            const SizedBox(height: 128.0),
          ],
        ));
  }
}
