import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

class ScoutGroupsService extends ChangeNotifier {
  List<ScoutGroup> scoutGroups = [];
  late ScoutGroup currentScoutGroup;

  void setScoutGroups(List<ScoutGroup> groups) {
    scoutGroups = groups;
    if (groups.isNotEmpty) {
      currentScoutGroup = groups.first;
    }
    notifyListeners();
  }

  void setCurrentScoutGroup(ScoutGroup group) {
    currentScoutGroup = group;
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
                createScoutGroup(value);
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
                    createScoutGroup(groupnameController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Create'))
          ],
        );
      },
    );
  }

  Future<void> createScoutGroup(String name) async {
    try {
      final newGroup = await client.scoutGroups.createScoutGroup(name);
      scoutGroups.add(newGroup);
      currentScoutGroup = newGroup;
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
      notifyListeners();
    } catch (e) {
      // print('Failed to refresh scout groups: $e');
    }
  }
}
