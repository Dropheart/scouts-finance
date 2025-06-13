import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/events/single_event.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/events/add.dart';

typedef EventPaidCounts = Map<int, (int paidCount, int totalCount)>;

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  late List<Event> events;
  late EventPaidCounts paidCounts; // eventId -> (paidCount, totalCount)
  String? errorMessage;
  int loading = 2;
  final sorts = [
    'Upcoming First',
    'Upcoming Last',
    'Paid count',
    'Unpaid count',
  ];
  int sortIndex = 0;
  String query = '';

  void _getEvents() async {
    try {
      final result = await client.event.getEvents();
      setState(() {
        events = result;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to load events. Are you connected to the internet?';
      });
    }
    loading--;
  }

  void _getPaidCounts() async {
    try {
      final result = await client.event.getPaidCounts();
      setState(() {
        paidCounts = result;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to load paid counts. Are you connected to the internet?';
      });
    }
    loading--;
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
    _getPaidCounts();
  }

  @override
  Widget build(BuildContext context) {
    if (loading > 0) {
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
          final (paidA, totalA) = paidCounts[a.id!] ?? (0, 0);
          final (paidB, totalB) = paidCounts[b.id!] ?? (0, 0);
          return paidB.compareTo(paidA); // Sort by most paid
        case 3: // Least Paid
          final (paidA, totalA) = paidCounts[a.id!] ?? (0, 0);
          final (paidB, totalB) = paidCounts[b.id!] ?? (0, 0);
          return paidA.compareTo(paidB); // Sort by least paid
        default:
          return 0; // No sorting
      }
    });

    List<Card> eventCards = filteredEvents.map((event) {
      final (paid, total) = paidCounts[event.id!] ?? (0, 0);

      return Card(
        child: ListTile(
          title: Text(event.name),
          subtitle: Row(
            children: [
              Text('$paid/$total Paid'),
              const Spacer(),
              Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 4.0),
              Text(event.date.toLocal().toIso8601String().split('T')[0]),
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
      hintText: 'Search by name...',
      onChanged: (value) => setState(() {
        query = value;
      }),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: const Icon(Icons.search),
      ),
    );

    Widget sortSelection = Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          const Text("Sort by:"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: sorts[sortIndex],
              onChanged: (String? newValue) {
                setState(() {
                  sortIndex = sorts.indexOf(newValue!);
                });
              },
              items: sorts.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

    ListView body = ListView(children: [
      searchBar,
      sortSelection,
      ExpansionTile(
          title: const Text('Future Events'),
          initiallyExpanded: true,
          shape: const Border(),
          children: eventCards),
      //   child: ListView(children: [
      // ...eventCards,
      ExpansionTile(
          title: const Text('Past Events'),
          initiallyExpanded: false,
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
      const SizedBox(height: 128.0),
    ]);

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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
      // Padding is required so the buttons don't clip the bottom/sides of the screen
      floatingActionButton: addEventButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
