import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/parent_details.dart';
import 'package:scouts_finances_flutter/scouts/scout_details.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
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
          trailing: [
            IconButton(
              icon: Icon(showScouts ? Icons.person : Icons.person_outline),
              onPressed: () {
                setState(() {
                  showScouts = !showScouts;
                });
              },
              tooltip: showScouts ? 'Hide Scouts' : 'Show Scouts',
            ),
          ]);

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
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 8.0),
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
        children: [
          outstandingCards.isEmpty
              ? const SizedBox.shrink()
              : ExpansionTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Payments Outstanding',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  initiallyExpanded: true,
                  children: outstandingCards,
                ),
          SizedBox(height: 16.0),
          SizedBox(height: 8.0),
          searchBar,
          SizedBox(height: 16.0),
          ...parentCards,
        ],
      );
    }

    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16.0), child: body),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final formKey = GlobalKey<FormState>();
              String firstName = '';
              String lastName = '';
              String email = '';
              String phone = '';
              bool submitting = false;
              String? error;

              return StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  title: const Text('Add Parent'),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                          onChanged: (v) => firstName = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                          onChanged: (v) => lastName = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          onChanged: (v) => email = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Phone'),
                          onChanged: (v) => phone = v,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        if (error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(error!,
                                style: const TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed:
                          submitting ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: submitting
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  submitting = true;
                                  error = null;
                                });
                                try {
                                  await client.parent.addParent(
                                    Parent(
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: email,
                                      phone: phone,
                                      balance: 0,
                                    ),
                                  );
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  }
                                  _getParents();
                                } catch (e) {
                                  setState(() {
                                    error = 'Failed to add parent';
                                    submitting = false;
                                  });
                                }
                              }
                            },
                      child: submitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          ).then((_) => {
                _getParents(),
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
