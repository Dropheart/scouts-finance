import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/payments/add.dart';
import 'package:scouts_finances_flutter/payments/matched_view.dart';
import 'package:scouts_finances_flutter/payments/unmatched_view.dart';

class PaymentsHome extends StatefulWidget {
  const PaymentsHome({super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  final GlobalKey<UnmatchedViewState> unmatchedViewKey =
      GlobalKey<UnmatchedViewState>();

  String query = '';
  final TextEditingController _searchController = TextEditingController();

  final tabBar = TabBar(
    isScrollable: false,
    tabs: [
      Tab(text: 'Unattributed Payments'),
      Tab(text: 'Attributed Payments'),
    ],
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBar = SearchBar(
      controller: _searchController,
      onChanged: (String value) {
        setState(() {
          query = value;
        });
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: const Icon(Icons.search),
      ),
      hintText: 'Search by payee, amount, date...',
    );

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
                    UnmatchedView(
                        searchBar: searchBar,
                        query: query,
                        key: unmatchedViewKey),
                    MatchedView(searchBar: searchBar, query: query),
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
                return AddPaymentDialog(onSubmit: () {
                  unmatchedViewKey.currentState?.refresh();
                });
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
