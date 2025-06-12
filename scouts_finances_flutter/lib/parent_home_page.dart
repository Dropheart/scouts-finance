import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/admin_pages/parents/home.dart';
import 'package:scouts_finances_flutter/parent_pages/registered_events/home.dart';

class ParentHomepage extends StatefulWidget {
  final SetPageFunc setPageFunc;
  const ParentHomepage({super.key, required this.setPageFunc});

  @override
  State<StatefulWidget> createState() => _ParentHomepageState();
}

class _ParentHomepageState extends State<ParentHomepage> {
  int currentPageIndex = 0;
  static final List<Widget> pages = [
    RegisteredEventsHome(),
    ParentHome(), // Example parent ID
  ];
  static final List<String> pageTitles = [
    'Events',
    'Details',
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = [
      NavigationDestination(
        icon: Icon(Icons.calendar_month),
        label: 'Events',
      ),
      GestureDetector(
        onDoubleTap: () {
          widget.setPageFunc(0); // Switch to admin home
        },
        child: const NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Details',
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[currentPageIndex]),
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: destinations),
    );
  }
}
