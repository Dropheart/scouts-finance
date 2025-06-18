import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/shared.dart';

class MatchedView extends StatefulWidget {
  const MatchedView({super.key, required this.searchBar, required this.query});
  final SearchBar searchBar;
  final String query;

  @override
  State<MatchedView> createState() => _MatchedViewState();
}

class _MatchedViewState extends State<MatchedView> {
  late List<Payment> matchedPayments;
  String? err;
  bool loading = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getPayments() async {
    try {
      final result = await client.payment.getPayments();

      final matchedPayments = result.where((p) => p.parent != null).toList();
      matchedPayments.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        this.matchedPayments = matchedPayments;
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

  void refresh() {
    setState(() {
      loading = true;
      err = null;
    });
    _getPayments();
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
    List<Payment> filteredMatchedPayments = matchedPayments
        .where((payment) =>
            payment.payee.toLowerCase().contains(widget.query.toLowerCase()) ||
            payment.amount.toString().contains(widget.query) ||
            payment.date.toLocal().toString().contains(widget.query))
        .toList();

    List<Card> matchedPaymentCards = filteredMatchedPayments.map((payment) {
      return toCard(context, payment, refresh);
    }).toList();

    return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.searchBar,
            const SizedBox(height: 16.0),
            ...matchedPaymentCards,
            if (matchedPaymentCards.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No attributed payments found.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            const SizedBox(height: 128.0),
          ],
        ));
  }
}
