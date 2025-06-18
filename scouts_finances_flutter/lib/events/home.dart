import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/events/single_event.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/events/add.dart';
import 'package:scouts_finances_flutter/services/account_type_service.dart';
import 'package:scouts_finances_flutter/services/scout_groups_service.dart';

typedef EventPaidCounts = Map<int, (int paidCount, int totalCount)>;

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  late List<Event> futureEvents;
  late List<Event> pastEvents;
  late EventPaidCounts paidCounts; // eventId -> (paidCount, totalCount)
  String? errorMessage;
  int loading = 2;
  final sorts = [
    'Upcoming First',
    'Upcoming Last',
    'Most Paid',
    'Fewest Paid',
  ];
  int sortIndex = 0;
  String query = '';
  late StreamSubscription stream;

  void _getEvents() async {
    try {
      final result = await client.event.getEvents();
      setState(() {
        futureEvents =
            result.where((e) => e.date.isAfter(DateTime.now())).toList();
        pastEvents =
            result.where((e) => e.date.isBefore(DateTime.now())).toList();
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
            'Failed to load event details (pay counts). Are you connected to the internet?';
      });
    }
    loading--;
  }

  void refresh() {
    setState(() {
      loading = 2;
      errorMessage = null;
    });
    _getEvents();
    _getPaidCounts();
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
    _getPaidCounts();

    stream = client.event.eventStream().listen((_) {
      refresh();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await stream.cancel();
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
    List<Event> filteredFutureEvents =
        futureEvents.where((e) => _eventQueryFilter(e)).toList();
    List<Event> filteredPastEvents =
        pastEvents.where((e) => _eventQueryFilter(e)).toList();

    filteredFutureEvents.sort((a, b) => _sortEvents(a, b));
    filteredPastEvents.sort((a, b) => _sortEvents(a, b));

    Widget futureEventsExpansionTile =
        Consumer2<ScoutGroupsService, AccountTypeService>(
            builder: (context, scoutGroupService, accountTypeService, child) =>
                _eventsBuilder(context, scoutGroupService, accountTypeService,
                    child, filteredFutureEvents,
                    title: 'Upcoming Events'));

    Widget pastEventsExpansionTile =
        Consumer2<ScoutGroupsService, AccountTypeService>(
            builder: (ctx, scoutGroupService, accountTypeService, child) =>
                _eventsBuilder(context, scoutGroupService, accountTypeService,
                    child, filteredPastEvents,
                    title: 'Past Events'));

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
      futureEventsExpansionTile,
      pastEventsExpansionTile,
      const SizedBox(height: 128.0),
    ]);

    final addEventButton =
        Consumer<AccountTypeService>(builder: (ctx, accountTypeService, child) {
      if (accountTypeService.accountType == AccountType.treasurer) {
        return const SizedBox.shrink();
      } else {
        return FloatingActionButton(
          heroTag: 'addEvent',
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddEventDialog();
              },
            ).then((event) {
              // Navigate to the new event page
              if (event == null) return;
              if (!context.mounted) return;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SingleEvent(eventId: event.id!)));
            });
          },
        );
      }
    });

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

  bool _eventQueryFilter(Event event) {
    final scoutGroupName = event.scoutGroup?.name ?? '';
    return (event.name.toLowerCase().contains(query.toLowerCase()) ||
        scoutGroupName.toLowerCase().contains(query.toLowerCase()));
  }

  int _sortEvents(Event a, Event b) {
    switch (sortIndex) {
      case 0: // Upcoming First
        return a.date.compareTo(b.date);
      case 1: // Upcoming Last
        return b.date.compareTo(a.date);
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
  }

  Widget _eventsBuilder(
      BuildContext context,
      ScoutGroupsService scoutGroupService,
      AccountTypeService accountTypeService,
      Widget? child,
      List<Event> filteredPastEvents,
      {required String title}) {
    final accountType = accountTypeService.accountType;
    final relevantEvents = filteredPastEvents
        .where((e) =>
            (scoutGroupService.scoutGroups.isNotEmpty &&
                e.scoutGroupId == scoutGroupService.currentScoutGroup.id) ||
            accountType == AccountType.treasurer)
        .toList();

    List<Card> eventCards = relevantEvents.map((event) {
      final (paid, total) = paidCounts[event.id!] ?? (0, 0);
      String trailing = accountType == AccountType.treasurer
          ? '- ${event.scoutGroup?.name ?? 'Unknown Group'}'
          : '';

      return Card(
        child: ListTile(
          title: Text('${event.name} $trailing'),
          subtitle: Row(
            children: [
              Text('$paid/$total Paid'),
              const Spacer(),
              Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 4.0),
              Text(event.date.toLocal().toString().split(' ')[0]),
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

    return ExpansionTile(
        title: Text(title),
        initiallyExpanded: true,
        controlAffinity: ListTileControlAffinity.leading,
        children: eventCards);
  }
}
