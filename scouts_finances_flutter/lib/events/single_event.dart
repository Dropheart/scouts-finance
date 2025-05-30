import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

typedef EventDetails = (Event, List<EventRegistration>);

class SingleEvent extends StatefulWidget {
  final int eventId;

  const SingleEvent({super.key, required this.eventId});

  @override
  State<SingleEvent> createState() => _SingleEventState();
}

class _SingleEventState extends State<SingleEvent> {
  late EventDetails eventDetails;
  String? errorMessage;
  bool loading = true;

  void _getEventDetails() async {
    try {
      final details = await client.event.getEventById(widget.eventId);

      setState(() {
        eventDetails = details;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load event details.';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Event ${widget.eventId} Details'),
      ),
      body: Center(
        child: Text(eventDetails.$1.name),
      ),
    );
  }
}