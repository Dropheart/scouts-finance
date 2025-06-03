import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/events/single_event.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/events/add.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  late List<Event> events;
  String? errorMessage;
  bool loading = true;

  void _getEvents() async {
    try {
      final result = await client.event.getEvents();
      setState(() {
        events = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to load events. Are you connected to the internet?';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
            return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    }

    List<Card> eventCards = events.map((event) {
      return Card(
        child: ListTile(
          title: Text(event.name),
          subtitle: Row(
            children: [
              Text('${event.id}/YY Paid'),
              const Spacer(),
              Text('${event.date.day}/${event.date.month}'),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SingleEvent(eventId: event.id!)));
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
      );
    }).toList();

    Center body = Center(
      child: ListView(children: [
        ExpansionTile(title: const Text('Future Events'), initiallyExpanded: true, children: eventCards),
        //   child: ListView(children: [
        // ...eventCards,
        ExpansionTile(title: const Text('Past Events'), initiallyExpanded: true, children: [
          Card(
            child: ListTile(
              title: const Text('Winter Camp'),
              subtitle: Row(
                children: [
                  const Text('15/20 paid'),
                  const Spacer(),
                  const Text('01/01/2025'),
                ],
              ),
              onTap: () {
                // Navigate to event details
              },
              trailing: const Icon(Icons.arrow_forward),
            ),
          ),
        ]),
    ]));

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddEventDialog();
            },
          ).then((_) {
            // Refresh the event list after adding a new event
            _getEvents();
          });
        },
      ),
    );
  }
}
