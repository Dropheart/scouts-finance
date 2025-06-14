import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/parent_details.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  String query = '';
  late List<Parent> allParents;
  late List<(Parent, int)> outstandingParents;
  String? errorMessage;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _getParents();
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
        hintText: 'Search parent, email, phone...',
        onChanged: (value) => setState(() {
          query = value;
        }),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Icon(Icons.search),
        ),
      );

      List<Card> parentCards = allParents
          .where((e) =>
              e.firstName.toLowerCase().contains(query.toLowerCase()) ||
              e.lastName.toLowerCase().contains(query.toLowerCase()) ||
              e.email.toLowerCase().contains(query.toLowerCase()) ||
              e.phone.contains(query))
          .map(
            (e) => Card(
              child: ListTile(
                title: Text("${e.firstName} ${e.lastName}"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email_rounded, size: 14.0),
                        SizedBox(width: 4.0),
                        Text(e.email),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14.0),
                        SizedBox(width: 4.0),
                        Text(e.phone),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(Icons.info_outline),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ParentDetails(parentId: e.id!),
                    ),
                  ),
                },
              ),
            ),
          )
          .toList();

      List<Card> outstandingCards = (outstandingParents
            ..sort((a, b) => a.$2.compareTo(b.$2)))
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
        children: [
          outstandingCards.isEmpty
              ? const SizedBox.shrink()
              : ExpansionTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Payments Outstanding',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  tilePadding: EdgeInsets.zero,
                  initiallyExpanded: true,
                  children: outstandingCards,
                ),
          SizedBox(height: 16.0),
          Text(
            'All Parents',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
