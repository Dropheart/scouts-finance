import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/parents/add_parent.dart';
import 'package:scouts_finances_flutter/parents/all_parents.dart';
import 'package:scouts_finances_flutter/parents/outstanding_parents.dart';

class ParentHome extends StatelessWidget {
  ParentHome({super.key});

  final GlobalKey<AllParentsViewState> _allParentsKey =
      GlobalKey<AllParentsViewState>();

  final tabBar = TabBar(
    isScrollable: false,
    tabs: [
      Tab(text: 'All Parents'),
      Tab(text: 'Payments Due'),
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
          floatingActionButton: AddParent(
            context: context,
            onParentAdded: () {
              _allParentsKey.currentState?.refresh();
            },
          )),
    );
  }
}
