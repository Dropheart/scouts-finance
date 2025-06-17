import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/parent_details.dart';
import 'package:scouts_finances_flutter/scouts/scout_details.dart';

class AllParentsView extends StatefulWidget {
  const AllParentsView({super.key});

  @override
  State<AllParentsView> createState() => _AllParentsViewState();
}

class _AllParentsViewState extends State<AllParentsView> {
  late List<Parent> allParents;
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
      final result = await client.parent.getParents();
      final outstandingRegs = await client.event.unpaidEvents();
      setState(() {
        allParents = result;
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
        allParents = [];
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
      SearchBar searchBar = SearchBar(
        hintText: 'Search parent, scout, email, phone',
        onChanged: (value) => setState(() {
          query = value;
        }),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Icon(Icons.search),
        ),
      );

      List<Widget> parentCards = allParents
          .where((e) =>
              e.firstName.toLowerCase().contains(query.toLowerCase()) ||
              e.lastName.toLowerCase().contains(query.toLowerCase()) ||
              e.email.toLowerCase().contains(query.toLowerCase()) ||
              e.phone.contains(query) ||
              (e.children != null &&
                  e.children!.any((c) =>
                      c.firstName.toLowerCase().contains(query.toLowerCase()) ||
                      c.lastName.toLowerCase().contains(query.toLowerCase()))))
          .map(
        (p) {
          final Widget children;
          if ((query.isEmpty && !showScouts) ||
              p.children == null ||
              p.children!.isEmpty) {
            children = const SizedBox.shrink();
          } else {
            final childrenWidgets = p.children!.map((c) {
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScoutDetailsView(scoutId: c.id!),
                    ),
                  ),
                },
                icon: Icon(Icons.person, size: 14.0),
                label: Text(c.fullName),
              );
            }).toList();

            children = Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    children: childrenWidgets,
                  ),
                ));
          }
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("${p.firstName} ${p.lastName}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email_rounded, size: 14.0),
                          SizedBox(width: 4.0),
                          Expanded(
                              child: Text(
                            p.email,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          )),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 14.0),
                          SizedBox(width: 4.0),
                          Expanded(
                              child: Text(
                            p.phone,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          )),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.info_outline),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ParentDetails(parentId: p.id!),
                      ),
                    ),
                  },
                ),
                children,
              ],
            ),
          );
        },
      ).toList();

      final switchWidget = SwitchListTile(
        title: const Text('Show Scouts'),
        value: showScouts,
        onChanged: (value) {
          setState(() {
            showScouts = value;
          });
        },
      );

      body = ListView(
        controller: _scrollController,
        children: [
          searchBar,
          switchWidget,
          SizedBox(height: 16.0),
          ...parentCards,
        ],
      );
    }
    return body;
  }
}
