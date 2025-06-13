import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

class EventAddParticipant extends StatefulWidget {
  final int eventId;
  final VoidCallback closeFn;

  const EventAddParticipant(
      {super.key, required this.eventId, required this.closeFn});

  @override
  State<EventAddParticipant> createState() => _EventAddParticipantState();
}

class _EventAddParticipantState extends State<EventAddParticipant> {
  late List<Child> allChildren;
  int loading = 2;
  String? err;
  late List<Child> eventChildren;
  List<Child> selectedChildren = [];
  List<int> selectedChildrenIndices = [];

  void _getChildren() async {
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
    loading--;
  }

  void _getEventChildren() async {
    final (event, registrations) =
        await client.event.getEventById(widget.eventId);
    setState(() {
      eventChildren = registrations.map((e) => e.child!).toList();
    });
    loading--;
  }

  @override
  void initState() {
    super.initState();
    _getChildren();
    _getEventChildren();
  }

  @override
  Widget build(BuildContext context) {
    if (loading > 0) {
      return const Center(child: CircularProgressIndicator());
    }
    if (err != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(err!,
              style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    }

    final choices = SearchChoices.multiple(
      selectedItems: selectedChildrenIndices,
      items: allChildren
          .where((child) => !eventChildren.any((e) => e.id == child.id))
          .map((child) => DropdownMenuItem<Child>(
                value: child,
                child: Text('${child.firstName} ${child.lastName}'),
              ))
          .toList(),
      hint: "Select Scouts",
      onChanged: (List selections) {
        setState(() {
          selectedChildrenIndices = selections.cast<int>();
          selectedChildren = allChildren.where((child) {
            return selections.contains(allChildren.indexOf(child));
          }).toList();
        });
      },
      closeButton: (selectedChildren) {
        return (selectedChildren.isEmpty
            ? "None selected"
            : "${selectedChildren.length} selected");
      },
      isExpanded: true,
      selectedAggregateWidgetFn: (List selected) => Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            selected.isEmpty
                ? "None selected"
                : "${selected.length} scout${selected.length > 1 ? 's' : ''} selected",
          )),
    );

    // Confirm button, greyed out if no children selected
    IconButton confirmButton = IconButton(
      onPressed: selectedChildren.isEmpty
          ? null
          : () async {
              try {
                // await client.event.addParticipantsToEvent(
                //     widget.eventId, selectedChildren.map((e) => e.id).toList());
                setState(() {
                  selectedChildrenIndices = [];
                  selectedChildren = [];
                  widget.closeFn();
                });
              } catch (e) {
                setState(() {
                  err = 'Failed to add participants: $e';
                });
              }
            },
      icon: const Icon(Icons.check),
      tooltip: 'Confirm',
    );

    // Cancel button
    IconButton cancelButton = IconButton(
      onPressed: selectedChildren.isEmpty
          ? null
          : () {
              setState(() {
                selectedChildrenIndices = [];
                selectedChildren = [];
                widget.closeFn();
              });
            },
      icon: const Icon(Icons.cancel),
      tooltip: 'Cancel',
    );

    return SizedBox(
        width: double.infinity,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Expanded(child: choices), confirmButton, cancelButton]));
  }
}
