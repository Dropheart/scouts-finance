import 'package:flutter/material.dart';

class OptionsMenu extends StatelessWidget {
  final int selectedIndex;
  const OptionsMenu({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return EventOptionsMenu();
      case 1:
        return PaymentsOptionsMenu();
      case 2:
        return ScoutsOptionsMenu();
      case 3:
        return ParentOptionsMenu();
      default:
        return const SizedBox.shrink();
    }
  }
}

abstract class AbstractOptionsMenu extends StatelessWidget {
  const AbstractOptionsMenu({super.key});

  abstract final List<ScoutMenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
        icon: Icon(Icons.more_horiz,
            color: Theme.of(context).colorScheme.onPrimary),
        onSelected: (String result) {
          // Handle the selection
        },
        popUpAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        ),
        position: PopupMenuPosition.under,
        color: colours.surfaceContainer,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: colours.onSurface),
                    SizedBox(width: 8.0),
                    Text('Settings'),
                  ],
                ),
              ),
              ...menuItems.map((item) => PopupMenuItem<String>(
                    value: item.value,
                    child: Row(
                      children: [
                        Icon(item.icon, color: colours.onSurface),
                        SizedBox(width: 8.0),
                        Text(item.title),
                      ],
                    ),
                  )),
            ]);
  }
}

class ScoutMenuItem {
  final String title;
  final IconData icon;
  final String value;

  ScoutMenuItem({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class EventOptionsMenu extends AbstractOptionsMenu {
  EventOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(title: 'Export Events', value: 'export_events', icon: Icons.download)
  ];
}

class PaymentsOptionsMenu extends AbstractOptionsMenu {
  PaymentsOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(title: 'Export Payments', value: 'export_payments', icon: Icons.download),
    ScoutMenuItem(title: 'View Payments', value: 'view_payments', icon: Icons.list),
  ];
}

class ScoutsOptionsMenu extends AbstractOptionsMenu {
  ScoutsOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(title: 'Add Scout', value: 'add_scout', icon: Icons.add),
    ScoutMenuItem(title: 'View Scouts', value: 'view_scouts', icon: Icons.list),
  ];
}

class ParentOptionsMenu extends AbstractOptionsMenu {
  ParentOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(title: 'Add Parent', value: 'add_parent', icon: Icons.add),
    ScoutMenuItem(title: 'View Parents', value: 'view_parents', icon: Icons.list),
  ];
}
