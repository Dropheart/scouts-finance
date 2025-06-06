import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/payment_method.dart';
import 'package:scouts_finances_flutter/main.dart';

class ParentTransactionTable extends StatefulWidget {
  final Parent parent; // The parent in question
  const ParentTransactionTable({super.key, required this.parent});

  @override
  State<ParentTransactionTable> createState() => _ParentTransactionTableState();
}

class _ParentTransactionTableState extends State<ParentTransactionTable> {
  // Example data, replace with your actual data source
  late final List<Transaction> transactions;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() async {
    try {
      // First get the children of this parent
      final List<Child> children =
          await client.scouts.getChildrenOfParent(widget.parent.id!);
      final List<List<EventRegistration>> registrationsLists =
          await Future.wait(
        children
            .map((child) => client.event.getRegistrationsByChildId(child.id!)),
      );
      final List<EventRegistration> outPayments =
          registrationsLists.expand((x) => x).toList();
      final List<Payment> inPayments =
          await client.payment.getPaymentsByParentId(widget.parent.id!);

      final List<Transaction> allTransactions = [];

      allTransactions.addAll(outPayments.map((reg) => Transaction(
            date: reg.paidDate ?? DateTime.now(), // show unpaid ones as today
            description: 'Event: ${reg.event!.name}',
            amount: -1 * reg.event!.cost.toDouble() / 100,
          )));

      allTransactions.addAll(inPayments.map((payment) => Transaction(
            date: payment.date,
            description: 'Payment: ${payment.method.toDisplayString()}',
            amount: payment.amount.toDouble() / 100,
          )));

      allTransactions
          .sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending

      setState(() {
        transactions = allTransactions;
        loading = false;
      });
    } catch (e) {
      setState(() {
        transactions = [];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No transactions found for ${widget.parent.firstName} ${widget.parent.lastName}.',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 16.0),
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24.0,
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Amount (£)')),
                  ],
                  rows: transactions
                      .map(
                        (tx) => DataRow(
                          cells: [
                            DataCell(Text(tx.date
                                .toLocal()
                                .toIso8601String()
                                .split('T')[0])),
                            DataCell(Text(tx.description)),
                            DataCell(Text(tx.amount.toStringAsFixed(2))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        Text(
          'Balance: £${transactions.fold(0.0, (sum, tx) => sum + tx.amount).toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class Transaction {
  final DateTime date;
  final String description;
  final double amount;

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
  });
}
