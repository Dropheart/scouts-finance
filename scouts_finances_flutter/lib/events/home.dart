import 'package:flutter/material.dart';

class EventHome extends StatelessWidget {
  const EventHome({super.key});

  @override
  Widget build(BuildContext context) {
    // This will become a map over data
    List<Card> events = [
      Card(
        child: ListTile(
          title: const Text('Event Name'),
          subtitle: Row(
            children: [
              const Text('15/27 Paid'),
              const Spacer(),
              const Text('DD/MM'),
            ],
          ),
          onTap: () {
            // Navigate to event details
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),

      Card(
        child: ListTile(
          title: const Text('Another Event'),
          subtitle: Row(
            children: [
              const Text('12/12 Paid'),
              const Spacer(),
              const Text('DD/MM'),
            ],
          ),
          onTap: () {
            // Navigate to event details
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    ];

    Center body = Center(child: ListView(children: events));

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