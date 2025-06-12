import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/events/home.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/home.dart';
import 'package:scouts_finances_flutter/payments/home.dart';
import 'package:scouts_finances_flutter/scouts/home.dart';

class AdminHomepage extends StatefulWidget {
  final SetPageFunc setPageFunc;
  const AdminHomepage({super.key, required this.setPageFunc});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int currentPageIndex = 0;
  static final List<Widget> pages = [
    EventHome(),
    PaymentsHome(),
    ScoutsHome(),
    ParentHome()
  ];
  static final List<String> pageTitles = [
    'Events',
    'Payments',
    'Scouts',
    'Parents',
  ];

  Future<void> switchScoutGroup() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Switch Scout Group'),
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
  Widget build(BuildContext context) {
    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.event),
        label: 'Events',
      ),
      const NavigationDestination(
        icon: Icon(Icons.attach_money),
        label: 'Payments',
      ),
      const NavigationDestination(
        icon: Icon(Icons.hiking),
        label: 'Scouts',
      ),
      GestureDetector(
        onDoubleTap: () {
          widget.setPageFunc(1); // Switch to parent home
        },
        child: const NavigationDestination(
          icon: Icon(Icons.supervisor_account),
          label: 'Parents',
        ),
      ),
    ];

    final colours = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[currentPageIndex],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colours.onPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: colours.primary,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: pages[currentPageIndex],
    );
  }
}
