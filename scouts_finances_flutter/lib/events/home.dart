import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/events/single_event.dart';
import 'package:scouts_finances_flutter/main.dart';

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

  Future<void> addEvent() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: const Text('This feature is not implemented yet.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      return Center(child: Text(errorMessage!));
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

    Center body = Center(child: ListView(children: [
      ...eventCards,ExpansionTile(title: const Text('Past Events'), children: [
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
      ]),]));

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addEvent();
        },
      ),
    );
  }
}
