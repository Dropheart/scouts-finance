import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

class EventAddSection extends StatefulWidget {
  final int eventId;
  final VoidCallback closeFn;

  const EventAddSection({super.key, required this.eventId, required this.closeFn});

  @override
  State<EventAddSection> createState() => _EventAddSectionState();
}

class _EventAddSectionState extends State<EventAddSection> {
  late List<Child> allChildren;
  List<Child> selectedChildren = [];

  void _getSections() async {
    try {
      allChildren = await client.scouts.getChildren();
      setState(() {
        selectedChildren = [];
      });
    } catch (e) {
      setState(() {
        allChildren = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSections();
  }

  void _submit() {
    if (selectedChildren.isNotEmpty) {
      selectedChildren.map((child) {
        if (child.id != null) {
          return client.event.registerChildForEvent(widget.eventId, child.id!);
        }
        return null;
      }).toList();
      Navigator.of(context).pop(selectedChildren);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchChoices.multiple(
      items: allChildren
          .map((child) => DropdownMenuItem<Child>(
                value: child,
                child: Text('${child.firstName} ${child.lastName}'),
              ))
          .toList(),
      hint: "Register Scouts",
      onChanged: (value) {
        setState(() {
          selectedChildren = value ?? [];
        });
      },
      closeButton: (selectedChildren) {
        return (selectedChildren.isEmpty
            ? "None selected"
            : "${selectedChildren.length} selected");
      },
      isExpanded: true,

      // actions: [
      //   TextButton(
      //     onPressed: () => Navigator.of(context).pop(),
      //     child: const Text("Cancel"),
      //   ),
      //   ElevatedButton(
      //     onPressed: _submit,
      //     child: const Text("Add Participants"),
      //   ),
      // ],
    );
  }
}