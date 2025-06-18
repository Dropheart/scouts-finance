import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/services/scout_groups_service.dart';

class AddScout extends FloatingActionButton {
  final BuildContext context;
  final VoidCallback? onScoutAdded;
  final Parent parent;

  const AddScout({
    super.key,
    required this.context,
    this.onScoutAdded,
    required this.parent,
  }) : super(onPressed: null);

  @override
  VoidCallback? get onPressed => () {
        final scoutGroups =
            Provider.of<ScoutGroupsService>(context, listen: false).scoutGroups;

        showDialog(
          context: context,
          builder: (context) {
            final formKey = GlobalKey<FormState>();
            String firstName = '';
            String lastName = '';
            int scoutGroupId =
                scoutGroups.isNotEmpty ? scoutGroups.first.id! : 0;
            bool submitting = false;
            String? error;

            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text('Add Young Person'),
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
                      DropdownButtonFormField<int>(
                        value: scoutGroupId,
                        decoration: const InputDecoration(
                          labelText: 'Scout Group',
                        ),
                        items: scoutGroups.map((group) {
                          return DropdownMenuItem<int>(
                            value: group.id,
                            child: Text(group.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          scoutGroupId = value ?? scoutGroupId;
                        },
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
                                final child = Child(
                                  firstName: firstName,
                                  lastName: lastName,
                                  parentId: parent.id!,
                                  parent: parent,
                                  scoutGroupId: scoutGroupId,
                                  scoutGroup: scoutGroups
                                      .firstWhere((g) => g.id == scoutGroupId),
                                );
                                await client.scouts.addChild(child);
                                if (context.mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              } catch (e) {
                                setState(() {
                                  error = 'Failed to add young person';
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
        ).then((result) {
          if (result == true) {
            // Trigger rebuild of parent widget
            if (context.mounted) {
              onScoutAdded?.call();
            }
          }
        });
      };

  @override
  Widget? get child => const Icon(Icons.add);
}
