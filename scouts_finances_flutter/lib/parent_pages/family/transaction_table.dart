import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';

class HardTransactionTable extends StatelessWidget {
  final Parent parent; // The parent in question
  HardTransactionTable({super.key, required this.parent});

  // Example data, replace with your actual data source
  final List<Transaction> transactions = [
    Transaction(
        date: DateTime.now(), description: "Payment for camping", amount: 5),
    Transaction(
        date: DateTime.now(), description: "Payment for hiking", amount: 7)
  ];

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No transactions found for ${parent.firstName} ${parent.lastName}.',
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
