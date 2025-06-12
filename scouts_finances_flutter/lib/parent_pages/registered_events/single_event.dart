import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

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
    'First Name (Reverse)',
    'Last Name',
    'Last Name (Reverse)',
    'Paid First',
    'Paid Last',
  ];
  int sortIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    final colourScheme = Theme.of(context).colorScheme;
    final colStyle = TextStyle(
        color: colourScheme.onPrimaryContainer, fontWeight: FontWeight.bold);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    final filteredRegistrations = registrations
        .where((e) =>
            e.child != null &&
                (e.child!.firstName
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
            (e.child!.lastName.toLowerCase().contains(query.toLowerCase())))
        .toList();

    final children = filteredRegistrations
        .map((e) => (
              childId: e.child!.id,
              name: "${e.child!.firstName} ${e.child!.lastName}",
              paidDate: e.paidDate
            ))
        .toList();

    children.sort((a, b) {
      switch (sorts[sortIndex]) {
        case 'First Name':
          return a.name.split(' ')[0].compareTo(b.name.split(' ')[0]);
        case 'First Name (Reverse)':
          return b.name.split(' ')[0].compareTo(a.name.split(' ')[0]);
        case 'Last Name':
          return a.name.split(' ').last.compareTo(b.name.split(' ').last);
        case 'Last Name (Reverse)':
          return b.name.split(' ').last.compareTo(a.name.split(' ').last);
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
            columnWidth: const FlexColumnWidth()),
        DataColumn(
            label: Text(
              'Paid',
              style: colStyle,
            ),
            columnWidth: const IntrinsicColumnWidth()),
      ],
      rows: children
          .map((e) => DataRow(
                  cells: [
                    DataCell(Row(children: [
                      Text(e.name),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press, e.g., navigate to child's profile
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.arrow_forward, size: 16),
                      )
                    ])),
                    DataCell(Text(e.paidDate == null
                        ? 'Not paid'
                        : 'Paid on ${e.paidDate!.toLocal().day}/${e.paidDate!.toLocal().month}/${e.paidDate!.toLocal().year}')),
                  ],
                  color: e.paidDate == null
                      ? WidgetStateProperty.all(colourScheme.errorContainer)
                      : WidgetStateProperty.all(Colors.green.shade100)))
          .toList(),
      // decoration: BoxDecoration(
      //   border: Border.all(color: colourScheme.secondary, width: 2),
      //   borderRadius: BorderRadius.circular(10),
      //   color: colourScheme.secondaryContainer,
      // ),
      border: TableBorder.symmetric(
          inside: BorderSide(
            color: colourScheme.onSecondaryContainer,
            width: 0.5,
          ),
          outside: BorderSide.none),
      // border: TableBorder.all(
      //   color: colourScheme.onSecondaryContainer,
      //   width: 0.5,
      // ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(columnWidths: {
            0: IntrinsicColumnWidth(),
          }, children: [
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text("${event.date.day}/${event.date.month}/${event.date.year}"),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Location:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('TBD'),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Price:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('£${(event.cost / 100).toStringAsFixed(2)}'),
            ]),
          ]),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(children: [
                const Text('Registrations:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Sets rounded corners
                  ),
                  color: colourScheme.secondaryContainer,
                  clipBehavior: Clip.antiAlias,
                  child: childrenTable,
                )
              ])),
        ],
      ),
    );
  }
}
