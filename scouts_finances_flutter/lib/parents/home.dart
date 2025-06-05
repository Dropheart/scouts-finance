import 'package:flutter/material.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parents Home'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Parents Home Page',
        ),
      ),
    );
  }
}
