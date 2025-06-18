import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_flutter/services/scout_groups_service.dart';
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
  bool changed = false;
  List<int> submitted = [];

  List<int> selectedIndicies = [];
  List<int> unchangingSelectedIndicies = [];

  late StreamSubscription stream;

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
      selectedIndicies = registeredChildren
          .map((child) => allChildren.indexWhere((c) => c.id == child.id))
          .where((index) => index >= 0)
          .toList();
      unchangingSelectedIndicies = List.from(selectedIndicies);
    });
    loading--;
  }

  void refresh() {
    setState(() {
      loading = 2;
      err = null;
    });
    _getChildren();
    _getEventChildren();
  }

  @override
  void initState() {
    super.initState();
    _getChildren();
    _getEventChildren();
    stream = client.event.eventStream().listen((_) {
      refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
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
        selectedItems: selectedIndicies,
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
          if (!changed || submitted.isEmpty) {
            return;
          }

          final changedChildren = allChildren
              .where((child) {
                final index = allChildren.indexOf(child);
                return submitted.contains(index);
              })
              .map((child) => (child))
              .toList();

          if (changedChildren.isNotEmpty) {
            final changedChildrenIds =
                changedChildren.map((c) => c.id!).toList();
            await client.event
                .updateEventRegistrations(widget.eventId, changedChildrenIds);
            widget.closeFn();
          }
          submitted.clear();
          refresh();
        },
        closeButton:
            (List<int> selectedChildren, closeContext, Function updateParent) {
          final addScoutGroups = Consumer<ScoutGroupsService>(
              builder: (ctx, scoutGroupsService, child) {
            final groups = scoutGroupsService.scoutGroups;

            final buttons = groups.map((group) {
              return ElevatedButton(
                onPressed: () {
                  final groupChildrenIndicies = group.children!
                      .map((gChild) => allChildren
                          .indexWhere((aChild) => aChild.id == gChild.id))
                      .where((index) => index >= 0)
                      .toList();
                  final currentlySelected = selectedIndicies.where((sIndex) =>
                      groupChildrenIndicies.any((gIndex) => sIndex == gIndex));

                  final toRemove = <int>[];
                  final toAdd = <int>[];

                  if (currentlySelected.length == group.children!.length) {
                    toRemove.addAll(currentlySelected);
                  } else {
                    final indiciesToAdd = groupChildrenIndicies
                        .where((index) => !currentlySelected.contains(index));

                    toAdd.addAll(indiciesToAdd);
                  }

                  setState(() {
                    selectedChildren
                        .removeWhere((index) => toRemove.contains(index));
                    selectedChildren.addAll(toAdd);
                    selectedIndicies = selectedChildren;
                  });
                  updateParent(selectedChildren);
                },
                child: Text(group.name),
              );
            });

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons.toList(),
            );
          });

          final removedChildren = unchangingSelectedIndicies
              .where((index) => !selectedChildren.contains(index))
              .toList();
          final addedChildren = selectedChildren
              .where((index) => !unchangingSelectedIndicies.contains(index))
              .toList();
          changed = addedChildren.isNotEmpty || removedChildren.isNotEmpty;

          final confirmText = changed
              ? "Confirm  (${addedChildren.length} added, ${removedChildren.length} removed)"
              : 'Confirm (no changes)';
          final confirmButton = ElevatedButton(
            onPressed: changed
                ? () {
                    submitted.addAll(removedChildren);
                    submitted.addAll(addedChildren);
                    Navigator.pop(closeContext);
                    refresh();
                  }
                : null,
            child: Text(confirmText),
          );
          final cancelButton = ElevatedButton(
            onPressed: () {
              changed = false;
              Navigator.pop(closeContext);
              setState(() {
                selectedIndicies = registeredChildren
                    .map((child) =>
                        allChildren.indexWhere((c) => c.id == child.id))
                    .where((index) => index >= 0)
                    .toList();
              });
            },
            child: const Text('Cancel'),
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Toggle All'),
              addScoutGroups,
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  confirmButton,
                  cancelButton,
                ],
              ),
            ],
          );
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
