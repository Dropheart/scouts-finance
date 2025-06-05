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

    final children = registrations.map((e) => (
          childId: e.child!.id,
          name: "${e.child!.firstName} ${e.child!.lastName}",
          paid: e.payments!
              .fold(0.0, (previous, payment) => previous + payment.amount),
          payments: e.payments!
              .map((p) => "${p.amount.toStringAsFixed(2)} (${p.date})")
              .join(', '),
        ));

    final childrenTable = DataTable(
      columns: [
        DataColumn(
            label: Text('Name', style: colStyle),
            columnWidth: const FixedColumnWidth(200)),
        DataColumn(
            label: Text(
              'Paid',
              style: colStyle,
            ),
            columnWidth: const FixedColumnWidth(150)),
      ],
      rows: children
          .map((e) => DataRow(
                  cells: [
                    DataCell(Text(e.name)),
                    DataCell(Text("£${(e.paid / 100).toStringAsFixed(2)}")),
                  ],
                  color: e.paid < event.cost
                      ? WidgetStateProperty.all(colourScheme.errorContainer)
                      : WidgetStateProperty.all(Colors.green.shade100)))
          .toList(),
      decoration: BoxDecoration(
        border: Border.all(color: colourScheme.secondary, width: 1),
        borderRadius: BorderRadius.circular(4),
        color: colourScheme.secondaryContainer,
      ),
      border: TableBorder.all(
        color: colourScheme.onSecondaryContainer,
        width: 1,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text('Date: ${event.date.day}/${event.date.month}/${event.date.year}'),
            const SizedBox(height: 10),
            Text('Location: TBD'),
            const SizedBox(height: 10),  
            Text('Price: £${(event.cost / 100).toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Registrations:'),
            const SizedBox(height: 10),
            childrenTable
          ],
        ),
      )),
    );
  }
}
