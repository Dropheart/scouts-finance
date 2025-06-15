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
