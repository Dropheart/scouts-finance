import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/shared/parent_transactions.dart';

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
              Text('Children:', style: const TextStyle(fontSize: 16)),
              ...children.map((child) => TextButton(onPressed: () => {}, child: Text('${child.firstName} ${child.lastName}'))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Not Implemented'),
                      content: const Text(
                          'Editing parent details is not implemented yet.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Edit Parent Details'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => {}, child: Text('Delete')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Transaction History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ParentTransactionTable(
            parent: parent,
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(loading
              ? 'Loading parent...'
              : "${parent.firstName} ${parent.lastName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }
}
