import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/parent_details.dart';

class AddParent extends FloatingActionButton {
  final BuildContext context;
  final VoidCallback? onParentAdded;

  const AddParent({super.key, required this.context, this.onParentAdded})
      : super(onPressed: null);

  @override
  VoidCallback? get onPressed => () {
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
                                final parent = await client.parent.addParent(
                                  Parent(
                                    firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    phone: phone,
                                    balance: 0,
                                  ),
                                );
                                if (context.mounted) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop(true);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ParentDetails(parentId: parent.id!),
                                    ),
                                  );
                                }
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
        ).then((result) {
          if (result == true) {
            // Trigger rebuild of parent widget
            if (context.mounted) {
              onParentAdded?.call();
            }
          }
        });
      };

  @override
  Widget? get child => const Icon(Icons.add);
}
