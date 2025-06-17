import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/payments/add.dart';
import 'package:scouts_finances_flutter/payments/matched_view.dart';
import 'package:scouts_finances_flutter/payments/unmatched_view.dart';

class PaymentsHome extends StatelessWidget {
  PaymentsHome({super.key});

  final tabBar = TabBar(
    isScrollable: false,
    tabs: [
      Tab(text: 'Unattributed Payments'),
      Tab(text: 'Attributed Payments'),
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
                    UnmatchedView(),
                    MatchedView(),
                  ])),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddPaymentDialog();
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
