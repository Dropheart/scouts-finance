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
              .fold(0.0, (previous, payment) => previous + payment.amount)
        ));

    final childrenTable = DataTable(
        columns: [
          DataColumn(label: Text('Child ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Paid')),
        ],
        rows: children
            .map((e) => DataRow(
                    cells: [
                      DataCell(Text('${e.childId}')),
                      DataCell(Text(e.name)),
                      DataCell(Text(e.paid.toStringAsFixed(2))),
                    ],
                    color: e.paid < event.cost
                        ? WidgetStateProperty.all(Colors.red[100])
                        : WidgetStateProperty.all(Colors.green[100])))
            .toList());

    return Scaffold(
      appBar: AppBar(
        title: Text('Event ${widget.eventId} Details'),
      ),
      body: Center(
          child: Column(
        children: [
          Row(children: [
            Text('Event: ${event.name}'),
            Spacer(),
            Text('Date: ${event.date}'),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Text('Location: TBD'),
            Spacer(),
            Text('Price: ${event.cost.toStringAsFixed(2)}'),
          ]),
          const SizedBox(height: 20),
          const Text('Registrations:'),
          const SizedBox(height: 10),
          childrenTable
        ],
      )),
    );
  }
}
