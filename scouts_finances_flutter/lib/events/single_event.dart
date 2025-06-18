import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/events/event_add_participant.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/payments/add.dart';
import 'package:scouts_finances_flutter/scouts/scout_details.dart';
import 'package:scouts_finances_flutter/services/account_type_service.dart';

typedef EventDetails = (Event, List<EventRegistration>);

class SingleEvent extends StatefulWidget {
  final int eventId;

  const SingleEvent({super.key, required this.eventId});

  @override
  State<SingleEvent> createState() => _SingleEventState();
}

class _SingleEventState extends State<SingleEvent> {
  late Event event;
  late List<EventRegistration> registrations;
  String? errorMessage;
  bool loading = true;
  String query = '';
  final sorts = [
    'First Name',
    'Last Name',
    'Paid',
    'Unpaid',
  ];
  int sortIndex = 0;
  late StreamSubscription stream;

  void _getEventDetails() async {
    try {
      final (eventRes, registrationRes) =
          await client.event.getEventById(widget.eventId);

      setState(() {
        event = eventRes;
        registrations = registrationRes;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load event details.';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEventDetails();
    stream = client.event.eventStream().listen((_) {
      refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
  }

  void refresh() {
    setState(() {
      loading = true;
      errorMessage = null;
    });
    _getEventDetails();
  }

  Widget eventView(BuildContext context) {
    final colourScheme = Theme.of(context).colorScheme;
    final colStyle = TextStyle(
        color: colourScheme.onPrimaryContainer, fontWeight: FontWeight.bold);

    final filteredRegistrations = registrations.where((e) {
      String fullName =
          "${e.child!.firstName} ${e.child!.lastName}".toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();

    final children = filteredRegistrations
        .map((e) => (
              child: e.child!,
              name: "${e.child!.firstName} ${e.child!.lastName}",
              paidDate: e.paidDate,
              reg: e,
            ))
        .toList();

    children.sort((a, b) {
      switch (sorts[sortIndex]) {
        case 'First Name':
          return a.name.split(' ')[0].compareTo(b.name.split(' ')[0]);
        case 'Last Name':
          return a.name.split(' ').last.compareTo(b.name.split(' ').last);
        case 'Paid First':
          return a.paidDate == null && b.paidDate == null
              ? 0
              : (a.paidDate == null
                  ? 1
                  : (b.paidDate == null
                      ? -1
                      : a.paidDate!.compareTo(b.paidDate!)));
        case 'Paid Last':
          return a.paidDate == null && b.paidDate == null
              ? 0
              : (a.paidDate == null
                  ? -1
                  : (b.paidDate == null
                      ? 1
                      : a.paidDate!.compareTo(b.paidDate!)));
        default:
          return 0;
      }
    });

    final childrenTable = DataTable(
      columns: [
        DataColumn(
          label: Text('Name', style: colStyle),
          columnWidth: const FlexColumnWidth(),
        ),
        DataColumn(
            label: Text(
              'Paid',
              style: colStyle,
            ),
            columnWidth: const IntrinsicColumnWidth()),
      ],
      headingRowColor: WidgetStateProperty.all(colourScheme.secondaryContainer),
      rows: children
          .map((e) => DataRow(
                  cells: [
                    DataCell(Row(children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(e.name),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScoutDetailsView(scoutId: e.child.id!),
                              ),
                            );
                          }),
                    ])),
                    DataCell((e.paidDate == null
                        ? TextButton(
                            onPressed: () {
                              _addCashPayment(context, e.reg);
                            },
                            child: Text('Add Cash Payment'))
                        : Text(
                            'Paid on ${e.paidDate!.toLocal().day}/${e.paidDate!.toLocal().month}/${e.paidDate!.toLocal().year}'))),
                  ],
                  color: e.paidDate == null
                      ? WidgetStateProperty.all(colourScheme.errorContainer)
                      : WidgetStateProperty.all(
                          const Color.fromARGB(199, 1, 230, 104))))
          .toList(),
      border: TableBorder.symmetric(
          inside: BorderSide(
            color: colourScheme.onSecondaryContainer,
            width: 0.5,
          ),
          outside: BorderSide.none),
    );

    SearchBar searchBar = SearchBar(
      onChanged: (value) {
        setState(() {
          query = value;
        });
      },
      hintText: 'Search by child name...',
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: const Icon(Icons.search),
      ),
    );

    Widget sortSelection = Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          const Text("Sort by:"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: sorts[sortIndex],
              onChanged: (String? newValue) {
                setState(() {
                  sortIndex = sorts.indexOf(newValue!);
                });
              },
              items: sorts.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

    final detailsHeading = GestureDetector(
      onDoubleTap: () async {
        final List<
            ({
              Child child,
              String name,
              DateTime? paidDate,
              EventRegistration reg
            })?> nullableRegs = List.from(children);
        final scoutReg = nullableRegs.firstWhere(
          (e) => e!.paidDate == null,
          orElse: () => null,
        );
        if (scoutReg == null) return;

        final parent = scoutReg.child.parent!;
        final bankAcc = parent.bankAccount?.firstOrNull ??
            BankAccount(
              name: parent.fullName,
              sortCode: '12-34-56',
              accountNumber: '98765432',
            );

        final payment = Payment(
          amount: event.cost,
          date: DateTime.now(),
          reference: "Scouting",
          method: PaymentMethod.bank_transfer,
          bankAccount: bankAcc,
          payee: scoutReg.child.parent!.fullName,
        );

        await client.payment.insertPayment(payment);
      },
      child: Text(
        'Details',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    final reminderButton = ElevatedButton(
        onPressed: () async {
          await client.event.sendReminders(event.id!);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification sent to parents.'),
            ),
          );
        },
        child: const Row(
          children: [
            Text('Notify Parents'),
            Spacer(),
            Icon(Icons.send),
          ],
        ));

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(columnWidths: {
              0: IntrinsicColumnWidth(),
            }, children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: detailsHeading,
                ),
                const SizedBox.shrink(),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                    "${event.date.day}/${event.date.month}/${event.date.year}"),
              ]),
              // TableRow(children: [
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //     child: Text('Location:',
              //         style: TextStyle(fontWeight: FontWeight.bold)),
              //   ),
              //   Text('TBD'),
              // ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Price:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('£${(event.cost / 100).toStringAsFixed(2)}'),
              ]),
            ]),
            SizedBox(height: 32),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(children: [
                  const SizedBox(height: 16),
                  searchBar,
                  sortSelection,
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Sets rounded corners
                    ),
                    color: colourScheme.secondaryContainer,
                    clipBehavior: Clip.antiAlias,
                    child: childrenTable,
                  ),
                  EventAddParticipant(
                    eventId: widget.eventId,
                    closeFn: () => _getEventDetails(),
                  ),
                ])),
            if (children.isNotEmpty) reminderButton,
            const SizedBox(height: 128),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Provider.of<AccountTypeService>(context, listen: false).isLeader
                  ? Text(loading ? 'Loading...' : event.name)
                  : Text(loading
                      ? 'Loading...'
                      : "${event.name} - ${event.scoutGroup!.name}"),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : eventView(context));
  }

  void _addCashPayment(BuildContext context, EventRegistration reg) {
    showDialog(
        context: context,
        builder: (context) => AddPaymentDialog(
              onSubmit: () {
                // Refresh the event details after adding a payment
                _getEventDetails();
              },
              initialPayment: Payment(
                  amount: event.cost,
                  date: DateTime.now(),
                  reference: "Manual cash payment for ${event.name}",
                  method: PaymentMethod.cash,
                  payee: reg.child!.parent!.fullName),
              parent: reg.child!.parent!,
              eventRegistration: reg,
            ));
  }
}
