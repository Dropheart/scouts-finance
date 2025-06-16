import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/payment_table.dart';
import 'package:scouts_finances_flutter/shared/parent_dropdown.dart';

class SinglePaymentView extends StatefulWidget {
  final int paymentId;
  const SinglePaymentView({super.key, required this.paymentId});

  @override
  State<StatefulWidget> createState() => _SinglePaymentViewState();
}

class _SinglePaymentViewState extends State<SinglePaymentView> {
  late Payment? payment;
  late List<Parent> parents;
  Parent get currParent => parents[parentIndex];
  int parentIndex = -1;
  int loading = 3; // Number of async operations to wait for

  @override
  void initState() {
    super.initState();
    _getPayment();
    _getUnpaidEvents();
  }

  void _getPayment() async {
    try {
      payment = await client.payment.getPaymentById(widget.paymentId);
      setState(() {
        loading = loading - 1;
      });

      parents = await client.parent.getParents();
      parents.sort((a, b) => a.lastName.compareTo(b.lastName));
      setState(() {
        loading = loading - 1;

        if (payment!.parentId != null) {
          // Then there is already a parent assigned so the index should reflect that
          parentIndex = parents.indexWhere((p) => p.id == payment!.parentId!);
        } else if (parentIndex == -1) {
          // Try to find the parent by payee name
          parentIndex = parents.indexWhere((p) =>
              payment!.payee.contains(p.firstName) &&
              payment!.payee.contains(p.lastName));
        }
        if (parentIndex == -1) {
          // If we still can't find it, default to the first parent
          parentIndex = 0;
        }
      });
    } catch (e) {
      setState(() {
        payment = null; // Set to null if not found
        parents = [];
      });
    }
  }

  late List<EventRegistration> unpaidEvents;
  void _getUnpaidEvents() async {
    try {
      unpaidEvents = await client.event.unpaidEvents();
      setState(() {
        loading = loading - 1;
      });
    } catch (e) {
      setState(() {
        unpaidEvents = [];
      });
    }
  }

  String formatMoney(int amount) {
    return '£${(amount / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading != 0) {
      body = const Center(child: CircularProgressIndicator());
    } else if (payment == null) {
      body = const Center(
        child: Text(
          'Payment not found. This suggests there is an internal error. Please contact the developers.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    } else if (parents.isEmpty) {
      body = const Center(
          child: Text(
              "No parents found. This suggests there is an internal error. Please contact the developers."));
    } else {
      Row parentSelection = Row(children: [
        Text("Assign this payment to parent: "),
        ParentDropdown(
          parents: parents,
          defaultParentId: parents[parentIndex].id,
          onChanged: (p) {
            setState(() {
              parentIndex = parents.indexWhere((parent) => parent.id == p);
            });
          },
        )
      ]);

      List<EventRegistration> unpaidEventsForParent = unpaidEvents
          .where((eventReg) => eventReg.child!.parentId == currParent.id)
          .toList()
        ..sort(
          (a, b) => a.event!.date.compareTo(b.event!.date),
        );

      int bal = payment!.amount + currParent.balance;
      List<EventRegistration> toBePaidEvents = [];
      while (bal > 0 && unpaidEventsForParent.isNotEmpty) {
        final event = unpaidEventsForParent.removeAt(0);
        if (event.event!.cost <= bal) {
          toBePaidEvents.add(event);
          bal -= event.event!.cost;
        } else {
          // If the event cost is more than the balance, we can't pay it off
          break;
        }
      }

      List<Widget> clearedEventsInfo = [];
      if (toBePaidEvents.isNotEmpty) {
        clearedEventsInfo.add(const Text(
          "This payment will mark the following events as paid:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ));
        clearedEventsInfo.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
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
                        DataColumn(label: Text('Child')),
                        DataColumn(label: Text('Event')),
                        DataColumn(label: Text('Cost (£)')),
                      ],
                      rows: toBePaidEvents
                          .map(
                            (event) => DataRow(
                              cells: [
                                DataCell(Text(
                                  event.event!.date
                                      .toIso8601String()
                                      .split('T')[0],
                                )),
                                DataCell(Text(
                                    '${event.child!.firstName} ${event.child!.lastName}')),
                                DataCell(Text(event.event!.name)),
                                DataCell(Text(formatMoney(event.event!.cost))),
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
              'Leaving a balance of ${formatMoney(bal)}.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ));
      } else {
        clearedEventsInfo.add(const Text(
          "This payment will not clear any unpaid events for this parent.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ));
      }

      body = Column(
        children: [
          PaymentTable(payment: payment!),
          const SizedBox(height: 16),
          Column(children: [parentSelection]),
          const SizedBox(height: 32),
          Text(
              "This will change ${currParent.firstName}'s balance from ${formatMoney(currParent.balance)} to ${formatMoney(currParent.balance + payment!.amount)}.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ...clearedEventsInfo,
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: submit,
            child: Row(
              children: [
                Text('Match payment to ${currParent.fullName}'),
                Spacer(),
                Icon(Icons.check_rounded),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: body,
      ),
    );
  }

  void submit() async {
    if (payment == null || parents.isEmpty) return;

    try {
      await client.payment.updatePayment(payment!.id!, currParent);
    } catch (e) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to classify payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
    return;
  }
}
