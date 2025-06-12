import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/parent.dart';
import 'package:scouts_finances_flutter/parent_pages/family/transaction_table.dart';

class FamilyPage extends StatelessWidget {
  FamilyPage({super.key});

  final Parent parent = Parent(
      id: 0,
      firstName: 'Ebtisam',
      lastName: 'Alkhunaizi',
      email: 'ebtesam@gmail.com',
      phone: '+447564736184',
      balance: 12);
  final List<Child> children = [
    Child(
      id: 1,
      firstName: 'Ali',
      lastName: 'Alkhunaizi',
      parentId: 0,
    ),
    Child(
      id: 2,
      firstName: 'Sara',
      lastName: 'Alkhunaizi',
      parentId: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget body;

    final linkColour = Theme.of(context).colorScheme.primary;
    body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Email:',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(parent.phone)
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Children:', style: const TextStyle(fontSize: 16)),
            ...children.map((child) => TextButton(
                onPressed: () => {},
                child: Text('${child.firstName} ${child.lastName}'))),
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
              child: const Text('Edit Family Details'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Transaction History:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        HardTransactionTable(
          parent: parent,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(parent.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }
}
