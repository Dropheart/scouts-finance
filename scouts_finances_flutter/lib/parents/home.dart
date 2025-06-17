import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/parents/add_parent.dart';
import 'package:scouts_finances_flutter/parents/all_parents.dart';
import 'package:scouts_finances_flutter/parents/outstanding_parents.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  final GlobalKey<AllParentsViewState> _allParentsKey = GlobalKey<AllParentsViewState>();
  final tabBar = TabBar(
    isScrollable: false,
    tabs: [
      Tab(text: 'All Parents'),
      Tab(text: 'Outstanding'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          body: Column(
            children: [
              tabBar,
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TabBarView(children: [
                      AllParentsView(key: _allParentsKey),
                      OutstandingParentsView(),
                    ])),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: AddParent(context: context, onParentAdded: () {
            _allParentsKey.currentState?.refresh();
          },)),
    );
  }
}
