import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/admin_pages/events/home.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/admin_pages/parents/home.dart';

class ParentHomepage extends StatefulWidget {
  final SetPageFunc setPageFunc;
  const ParentHomepage({super.key, required this.setPageFunc});

  @override
  State<StatefulWidget> createState() => _ParentHomepageState();
}

class _ParentHomepageState extends State<ParentHomepage> {
  int currentPageIndex = 0;
  static final List<Widget> pages = [
    EventHome(),
    ParentHome(), // Example parent ID
  ];
  static final List<String> pageTitles = [
    'Transactions',
    'Details',
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = [
      NavigationDestination(
        icon: Icon(Icons.account_balance_wallet),
        label: 'Transactions',
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
