import 'package:flutter/material.dart';

class PaymentsHome extends StatelessWidget {
  const PaymentsHome({super.key});

  @override
  Widget build(BuildContext context) {

    Column body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      const Text('Action Required - 1',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const Placeholder(),
      const Text('Known Payees - 2',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const Placeholder(),
      const SizedBox(height: 128.0),
      ],
    );

    return Scaffold(
      body: Padding(padding: EdgeInsetsGeometry.all(8.0), child: SingleChildScrollView(child: body)),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'fab_left',
              child: const Icon(Icons.save),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Export'),
                      content: const Text('Feature not implemented yet!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            FloatingActionButton(
              heroTag: 'fab_right',
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add Payment'),
                      content: const Text('Feature not implemented yet!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK :('),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
