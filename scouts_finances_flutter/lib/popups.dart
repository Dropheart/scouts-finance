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

  abstract final List<PopupMenuEntry<String>> menuItems;

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
              ...menuItems,
            ]);
  }
}

class EventOptionsMenu extends AbstractOptionsMenu {
  EventOptionsMenu({super.key});

  @override
  final List<PopupMenuEntry<String>> menuItems = [
    PopupMenuItem<String>(
      value: 'add_event',
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.green),
          SizedBox(width: 8.0),
          Text('Add Event'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'view_events',
      child: Row(
        children: [
          Icon(Icons.list, color: Colors.blue),
          SizedBox(width: 8.0),
          Text('View Events'),
        ],
      ),
    ),
  ];
}

class PaymentsOptionsMenu extends AbstractOptionsMenu {
  PaymentsOptionsMenu({super.key});

  @override
  final List<PopupMenuEntry<String>> menuItems = [
    PopupMenuItem<String>(
      value: 'add_payment',
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.green),
          SizedBox(width: 8.0),
          Text('Add Payment'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'view_payments',
      child: Row(
        children: [
          Icon(Icons.list, color: Colors.blue),
          SizedBox(width: 8.0),
          Text('View Payments'),
        ],
      ),
    ),
  ];
}

class ScoutsOptionsMenu extends AbstractOptionsMenu {
  ScoutsOptionsMenu({super.key});

  @override
  final List<PopupMenuEntry<String>> menuItems = [
    PopupMenuItem<String>(
      value: 'add_scout',
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.green),
          SizedBox(width: 8.0),
          Text('Add Scout'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'view_scouts',
      child: Row(
        children: [
          Icon(Icons.list, color: Colors.blue),
          SizedBox(width: 8.0),
          Text('View Scouts'),
        ],
      ),
    ),
  ];
}

class ParentOptionsMenu extends AbstractOptionsMenu {
  ParentOptionsMenu({super.key});

  @override
  final List<PopupMenuEntry<String>> menuItems = [
    PopupMenuItem<String>(
      value: 'add_parent',
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.green),
          SizedBox(width: 8.0),
          Text('Add Parent'),
        ],
      ),
    ),
    PopupMenuItem<String>(
      value: 'view_parents',
      child: Row(
        children: [
          Icon(Icons.list, color: Colors.blue),
          SizedBox(width: 8.0),
          Text('View Parents'),
        ],
      ),
    ),
  ];
}
