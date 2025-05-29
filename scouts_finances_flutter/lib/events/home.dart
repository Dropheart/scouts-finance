import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  List<Event>? events;
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
        errorMessage = 'Failed to load events: $e';
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
      return Center(child: Text(errorMessage!));
    }

    List<Card> eventCards = events?.map((event) {
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
            // Navigate to event details
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
          );
        }).toList() ??
        [];

    Center body = Center(child: ListView(children: eventCards));

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to create event page
        },
      ),
    );
  }
}