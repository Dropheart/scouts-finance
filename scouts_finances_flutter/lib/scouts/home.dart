import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/main.dart';

class ScoutsHome extends StatelessWidget {
  ScoutsHome({super.key});

  final adminButton =
      ElevatedButton(onPressed: () async {
        await client.admin.resetDb();
      }, child: const Text('TBD'));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [Text('Scouts'), adminButton]),
    );
  }
}
