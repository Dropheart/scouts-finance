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
  final sorts = [
    'Upcoming First',
    'Upcoming Last',
    /*'Most Paid', 'Least Paid' */
  ];
  int sortIndex = 0;
  String query = '';

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

    // Filter events based on the search query
    List<Event> filteredEvents = events.where((event) {
      return event.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    filteredEvents.sort((a, b) {
      switch (sortIndex) {
        case 0: // Upcoming First
          return b.date.compareTo(a.date);
        case 1: // Upcoming Last
          return a.date.compareTo(b.date);
        // Paid count tbd
        case 2: // Most Paid
        // return b.paidCount.compareTo(a.paidCount);
        case 3: // Least Paid
        // return a.paidCount.compareTo(b.paidCount);
        default:
          return 0; // No sorting
      }
    });

    List<Card> eventCards = filteredEvents.map((event) {
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

    SearchBar searchBar = SearchBar(
      hintText: 'Search Events',
      onChanged: (value) => setState(() {
        query = value;
      }),
      leading: const Icon(Icons.search),
    );

    Center body = Center(
        child: ListView(children: [
      Padding(
          padding: EdgeInsets.all(16.0), child: searchBar),
      ExpansionTile(
          title: const Text('Future Events'),
          initiallyExpanded: true,
          shape: const Border(),
          children: eventCards),
      //   child: ListView(children: [
      // ...eventCards,
      ExpansionTile(
          title: const Text('Past Events'),
          initiallyExpanded: true,
          shape: const Border(),
          children: [
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

    FloatingActionButton addEventButton = FloatingActionButton(
      heroTag: 'addEvent',
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
    );

    FloatingActionButton sortButton = FloatingActionButton(
      heroTag: 'sort',
      child: const Icon(Icons.sort),
      onPressed: () {
        setState(() {
          sortIndex = (sortIndex + 1) % sorts.length;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sorted by: ${sorts[sortIndex]}')),
        );
        return;
      },
    );

    Row actionButtons = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [sortButton, addEventButton]);

    return Scaffold(
      body: body,
      // Padding is required so the buttons don't clip the bottom/sides of the screen
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: actionButtons),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
