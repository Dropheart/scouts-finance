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
  late List<Child> registeredChildren;

  void _getChildren() async {
    try {
      allChildren = await client.scouts.getChildren();
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
      registeredChildren = registrations.map((e) => e.child!).toList();
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

    final registeredChildrenIndicies = registeredChildren
        .map((child) =>
            allChildren.indexWhere((child2) => child2.id == child.id))
        .where((index) => index >= 0)
        .toList();

    final choices = SearchChoices.multiple(
        selectedItems: registeredChildrenIndicies,
        items: allChildren
            .map((child) => DropdownMenuItem<Child>(
                  value: child,
                  child: Text('${child.firstName} ${child.lastName}'),
                ))
            .toList(),
        hint: "Manage Participants",
        doneButton: SizedBox.shrink(),
        displayClearIcon: false,
        onChanged: (List selections) async {
          // Runs when you exit the popup.
          final changedChildren = allChildren
              .where((child) {
                bool previouslySelected = registeredChildrenIndicies
                    .contains(allChildren.indexOf(child));
                bool currentlySelected =
                    selections.contains(allChildren.indexOf(child));

                return previouslySelected != currentlySelected;
              })
              .map((child) => (child, allChildren.indexOf(child)))
              .toList();

          if (changedChildren.isNotEmpty) {
            final changedChildrenIds =
                changedChildren.map((c) => c.$1.id!).toList();
            await client.event
                .updateEventRegistrations(widget.eventId, changedChildrenIds);
            widget.closeFn();
          }
          setState(() {
            registeredChildren = allChildren
                .where(
                    (child) => selections.contains(allChildren.indexOf(child)))
                .toList();
          });
        },
        closeButton: (List selectedChildren) {
          final removedChildren = registeredChildrenIndicies
              .where((index) => !selectedChildren.contains(index))
              .toList();
          final addedChildren = selectedChildren
              .where((index) => !registeredChildrenIndicies.contains(index))
              .toList();

          return (addedChildren.isEmpty && removedChildren.isEmpty)
              ? "Confirm (no changes)"
              : "Confirm  (${addedChildren.length} added, ${removedChildren.length} removed)";
        },
        isExpanded: true,
        selectedAggregateWidgetFn: (List selected) => Text('Manage Scouts'));

    return SizedBox(
        width: double.infinity,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Expanded(child: choices)]));
  }
}
