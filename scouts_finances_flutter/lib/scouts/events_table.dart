import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';

class ChildEventsTable extends StatefulWidget {
  final Child child; // The child in question
  const ChildEventsTable({super.key, required this.child});

  @override
  State<ChildEventsTable> createState() => _ChildEventsTableState();
}

class _ChildEventsTableState extends State<ChildEventsTable> {
  // Example data, replace with your actual data source
  late final List<EventRegistration> registrations;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRegistrations();
  }

  void _fetchRegistrations() async {
    try {
      final allRegs =
          await client.event.getRegistrationsByChildId(widget.child.id!);
      setState(() {
        registrations = allRegs;
        loading = false;
      });
    } catch (e) {
      setState(() {
        registrations = [];
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
    if (registrations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No events found for ${widget.child.fullName}',
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
                    DataColumn(label: Text('Event')),
                    DataColumn(label: Text('Amount (£)')),
                  ],
                  rows: registrations
                      .map(
                        (r) => DataRow(
                          cells: [
                            DataCell(Text(r.event!.date
                                .toLocal()
                                .toIso8601String()
                                .split('T')[0])),
                            DataCell(Text(r.event!.name)),
                            DataCell(
                                Text((r.event!.cost / 100).toStringAsFixed(2))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
