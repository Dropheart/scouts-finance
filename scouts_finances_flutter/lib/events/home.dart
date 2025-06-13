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
  late List<EventWithRegistrations> events;
  String? errorMessage;
  bool loading = true;
  final sorts = ['Upcoming First', 'Upcoming Last', 'Most Paid', 'Least Paid'];
  int sortIndex = 0;
  String query = '';

  void _getEvents() async {
    try {
      final result = await client.event.getEvents();
      final eventWithRegs = await Future.wait(result.map((e) async {
        final reg = await client.event.getRegistrationsByEventId(e.id!);
        return EventWithRegistrations(
            e, reg.length, reg.where((r) => r.paidDate != null).length);
      }));
      setState(() {
        events = eventWithRegs;
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
    final List<EventWithRegistrations> filteredEvents = events.where((event) {
      return event.event.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    filteredEvents.sort((a, b) {
      switch (sortIndex) {
        case 0: // Upcoming First
          return b.event.date.compareTo(a.event.date);
        case 1: // Upcoming Last
          return a.event.date.compareTo(b.event.date);
        // Paid count tbd
        case 2: // Most Paid
          return b.paid.compareTo(a.paid);
        case 3: // Least Paid
          return a.paid.compareTo(b.paid);
        default:
          return 0; // No sorting
      }
    });

    List<Card> eventCards = filteredEvents.map((event) {
      return Card(
        child: ListTile(
          title: Text(event.event.name),
          subtitle: Row(
            children: [
              Text('${event.paid}/${event.totalRegs} Paid'),
              const Spacer(),
              Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 4.0),
              Text(event.event.date.toLocal().toIso8601String().split('T')[0]),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SingleEvent(eventId: event.event.id!)));
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

class EventWithRegistrations {
  final Event event;
  final int totalRegs;
  final int paid;

  const EventWithRegistrations(this.event, this.totalRegs, this.paid);
}
