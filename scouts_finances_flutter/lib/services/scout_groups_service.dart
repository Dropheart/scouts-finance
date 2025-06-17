import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/services/theme_service.dart';

class ScoutGroupsService extends ChangeNotifier {
  List<ScoutGroup> scoutGroups = [];
  late ScoutGroup currentScoutGroup;

  void setScoutGroups(BuildContext context, List<ScoutGroup> groups) {
    scoutGroups = groups;
    if (groups.isNotEmpty) {
      setCurrentScoutGroup(context, groups.first);
    }
    notifyListeners();
  }

  void setCurrentScoutGroup(BuildContext context, ScoutGroup group) {
    currentScoutGroup = group;
    final colour = switch (group.colour) {
      GroupColour.black => Colors.black,
      GroupColour.darkblue => Colors.blue[900]!,
      GroupColour.lightblue => Colors.lightBlue[300]!,
      GroupColour.green => Colors.green,
      GroupColour.teal => Colors.teal,
      GroupColour.red => Colors.red
    };

    Provider.of<ThemeService>(context, listen: false).setPrimaryColor(colour);
    notifyListeners();
  }

  void showCreateScoutGroupPopup(BuildContext context) {
    final groupnameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Group'),
          content: TextField(
            autofocus: true,
            controller: groupnameController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                createScoutGroup(context, value, GroupColour.black);
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  if (groupnameController.text.isNotEmpty) {
                    createScoutGroup(
                        context, groupnameController.text, GroupColour.black);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Create'))
          ],
        );
      },
    );
  }

  Future<void> createScoutGroup(
      BuildContext context, String name, GroupColour colour) async {
    try {
      final newGroup = await client.scoutGroups.createScoutGroup(name, colour);
      scoutGroups.add(newGroup);
      if (context.mounted) setCurrentScoutGroup(context, newGroup);
      notifyListeners();
    } catch (e) {
      // print('Failed to create scout group: $e');
    }
  }

  Future<void> getScoutGroups() async {
    try {
      scoutGroups = await client.scoutGroups.getScoutGroups();

      if (scoutGroups.isEmpty) {
        await client.admin.resetDb();
        scoutGroups = await client.scoutGroups.getScoutGroups();
      }

      currentScoutGroup = scoutGroups.first;
    } catch (e) {
      // print('Failed to load scout groups: $e');
    }
  }

  Future<void> refreshScoutGroups() async {
    try {
      scoutGroups = await client.scoutGroups.getScoutGroups();
      currentScoutGroup = scoutGroups.first;
      notifyListeners();
    } catch (e) {
      // print('Failed to refresh scout groups: $e');
    }
  }
}
