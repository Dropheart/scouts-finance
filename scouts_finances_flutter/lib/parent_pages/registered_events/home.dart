import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/parent_pages/registered_events/single_event.dart';
import 'package:scouts_finances_flutter/main.dart';

class RegisteredEventsHome extends StatefulWidget {
  const RegisteredEventsHome({super.key});

  @override
  State<RegisteredEventsHome> createState() => _RegisteredEventsHomeState();
}

class _RegisteredEventsHomeState extends State<RegisteredEventsHome> {
  late List<Event> events;
  late Map<int, (int, int)> paidCounts; // eventId -> (paidCount, totalCount)
  String? errorMessage;
  int loading = 2;
  final sorts = [
    'Upcoming First',
    'Upcoming Last',
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
        default:
          return 0; // No sorting
      }
    });

    List<Card> eventCards = filteredEvents.map((event) {
      final (paid, total) = paidCounts[event.id!] ?? (0, 0);
      bool anyPaid = paid > 0;

      return Card(
        color: anyPaid ? Colors.green[100] : Colors.red[100],
        child: ListTile(
          title: Text(event.name),
          subtitle: Row(
            children: [
              Text(anyPaid ? 'Paid' : 'Unpaid - £${event.cost / 100} due'),
              const Spacer(),
              Text('${event.date.day}/${event.date.month}/${event.date.year}'),
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

    Center body = Center(
        child: ListView(children: [
      Padding(padding: EdgeInsets.all(16.0), child: searchBar),
      sortSelection,
      ExpansionTile(
          title: const Text('Registered Events'),
          initiallyExpanded: true,
          shape: const Border(),
          children: eventCards),
      //   child: ListView(children: [
      // ...eventCards,
      ExpansionTile(
          title: const Text('Unregistered Events'),
          initiallyExpanded: false,
          shape: const Border(),
          children: [
            Card(
              color: Colors.yellow[100],
              child: ListTile(
                title: const Text('Winter Camp'),
                subtitle: Row(
                  children: [
                    const Text('£5.00'),
                    const Spacer(),
                    const Text('01/01/2025'),
                  ],
                ),
                onTap: () {
                  // popup to register for the event
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Register for Winter Camp'),
                        content: const Text(
                            'Are you sure you want to register for Winter Camp? This action will register all your children for this event.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle registration logic here
                              Navigator.of(context).pop();
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      );
                    },
                  );
                },
                trailing: const Icon(Icons.add_circle),
              ),
            ),
          ]),
      const SizedBox(height: 128.0),
    ]));

    return Scaffold(
      body: body,
    );
  }
}
