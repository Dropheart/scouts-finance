import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/scouts/scout_details.dart';
import 'package:scouts_finances_flutter/shared/parent_transactions.dart';
import 'package:scouts_finances_flutter/shared/unpaid_events.dart';

class ParentDetails extends StatefulWidget {
  final int parentId;

  const ParentDetails({super.key, required this.parentId});

  @override
  State<ParentDetails> createState() => _ParentDetailsState();
}

class _ParentDetailsState extends State<ParentDetails> {
  String? errorMessage;
  bool loading = true;
  late Parent parent;
  late List<Child> children;

  @override
  void initState() {
    super.initState();
    _getParentDetails();
  }

  void _getParentDetails() async {
    try {
      final result = await client.parent.getParentById(widget.parentId);
      final childrenResult =
          await client.scouts.getChildrenOfParent(widget.parentId);
      setState(() {
        if (result == null) {
          errorMessage = "Parent not found.";
        } else {
          parent = result;
          children = childrenResult;
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch parent details.";
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
      final linkColour = Theme.of(context).colorScheme.primary;
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Email:',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              GestureDetector(
                child: Text(
                  parent.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: linkColour,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Not Implemented'),
                          content: const Text(
                              'Email functionality is not implemented yet.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }),
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Phone:',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(parent.phone)
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Children:',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              ...children.map((child) => TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ScoutDetailsView(scoutId: child.id!);
                      })),
                    },
                    child: Text(child.fullName),
                  )),
            ],
          ),
          Row(
            children: [
              Text('Credit:',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text('£${(parent.balance / 100).toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Payment History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ParentTransactionTable(
            parent: parent,
          ),
          const SizedBox(height: 16),
          const Text('Unpaid Events:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          UnpaidEventsTable(parent: parent),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: Icon(Icons.send),
            label: Text('Send registered events reminder'),
            onPressed: () {
              client.parent.remindParent(parent.id!);
            },
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(loading
            ? 'Loading parent...'
            : "${parent.firstName} ${parent.lastName}"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'switchGroup',
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit parent details'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete parent'),
                  ],
                ),
              )
            ],
            onSelected: (value) {},
            position: PopupMenuPosition.under,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }
}
