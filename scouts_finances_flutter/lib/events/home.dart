import 'package:flutter/material.dart';

class EventHome extends StatelessWidget {
  const EventHome({super.key});

  @override
  Widget build(BuildContext context) {
    // This will become a map over data
    List<Widget> events = [
      Card(
        child: ListTile(
          title: const Text('Event Name'),
          subtitle: Row(
            children: [
              const Text('15/27 paid'),
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
          title: const Text('August Camp'),
          subtitle: Row(
            children: [
              const Text('4/15 paid'),
              const Spacer(),
              const Text('20/06/2025'),
            ],
          ),
          onTap: () {
            // Navigate to event details
          },
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),

      ExpansionTile(title: const Text('Past Events'), children: [
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