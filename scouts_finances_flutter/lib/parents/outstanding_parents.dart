import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/parent_details.dart';

class OutstandingParentsView extends StatefulWidget {
  const OutstandingParentsView({super.key});

  @override
  State<OutstandingParentsView> createState() => _OutstandingParentsViewState();
}

class _OutstandingParentsViewState extends State<OutstandingParentsView> {
  late List<(Parent, int)> outstandingParents;
  String? errorMessage;
  bool loading = true;

  String query = '';
  bool showScouts = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getParents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getParents() async {
    try {
      final outstandingRegs = await client.event.unpaidEvents();
      setState(() {
        outstandingParents = outstandingRegs.fold([], (acc, reg) {
          final parent = reg.child!.parent!;
          // Check if parent already exists in acc
          final index = acc.indexWhere((element) => element.$1.id == parent.id);
          if (index != -1) {
            // If exists, increment the amount due
            final (p, s) = acc[index];
            acc[index] = (p, s + reg.event!.cost);
          } else {
            // If not, add new entry
            acc.add((parent, reg.event!.cost - parent.balance));
          }
          return acc;
        });
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            "Failed to fetch parents. Are you connected to the internet?";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      body = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    } else {
      List<Card> outstandingCards = (outstandingParents
            ..sort((a, b) => b.$2.compareTo(a.$2)))
          .map(
            (e) => Card(
              child: ListTile(
                title: Text("${e.$1.firstName} ${e.$1.lastName}"),
                subtitle:
                    Text("Amount due: £${(e.$2 / 100).toStringAsFixed(2)}"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ParentDetails(parentId: e.$1.id!),
                    ),
                  ),
                },
              ),
            ),
          )
          .toList();

      body = ListView(
        controller: _scrollController,
        children: outstandingCards.isEmpty
            ? [Text('You\'re all up to date!')]
            : outstandingCards,
      );
    }
    return body;
  }
}
