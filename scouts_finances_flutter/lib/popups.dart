import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/extensions/datetime.dart';
import 'package:scouts_finances_flutter/settings/home.dart';
import 'package:share_plus/share_plus.dart';

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
      // case 2:
      //   return ScoutsOptionsMenu();
      case 2:
        return PeopleOptionsMenu();
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
    return PopupMenuButton<Function(BuildContext)>(
        icon: Icon(Icons.more_vert,
            color: Theme.of(context).colorScheme.onPrimary),
        onSelected: (func) => func(context),
        popUpAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        ),
        position: PopupMenuPosition.under,
        color: colours.surfaceContainer,
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<Function(BuildContext)>>[
              PopupMenuItem(
                value: (ctx) => Navigator.of(ctx).push(
                  MaterialPageRoute(builder: (ctx) => SettingsHome()),
                ),
                child: Row(
                  children: [
                    Icon(Icons.settings, color: colours.onSurface),
                    SizedBox(width: 8.0),
                    Text('Settings'),
                  ],
                ),
              ),
              ...menuItems.map((item) => PopupMenuItem(
                    value:
                        item.onPressed ?? ((ctx) => item.defaultOnPressed(ctx)),
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
  final Function(BuildContext context)? onPressed;

  void defaultOnPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $value')),
    );
  }

  static void exportFile(
      {required BuildContext context, required String fileName}) {
    final csv = XFile.fromData(
      utf8.encode('real data'),
      mimeType: 'text/csv',
    );
    final shareParams = ShareParams(
      files: [csv],
      fileNameOverrides: ['$fileName-${DateTime.now().formattedDate}.csv'],
    );

    SharePlus.instance.share(shareParams);
  }

  ScoutMenuItem({
    required this.title,
    required this.value,
    required this.icon,
    this.onPressed,
  });
}

class EventOptionsMenu extends AbstractOptionsMenu {
  EventOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(
        title: 'Export Events',
        value: 'export_events',
        icon: Icons.download,
        onPressed: (ctx) =>
            ScoutMenuItem.exportFile(context: ctx, fileName: 'events')),
  ];
}

class PaymentsOptionsMenu extends AbstractOptionsMenu {
  PaymentsOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(
        title: 'Export Payments',
        value: 'export_payments',
        icon: Icons.download,
        onPressed: (ctx) =>
            ScoutMenuItem.exportFile(context: ctx, fileName: 'payments')),
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

class PeopleOptionsMenu extends AbstractOptionsMenu {
  PeopleOptionsMenu({super.key});

  @override
  final List<ScoutMenuItem> menuItems = [
    ScoutMenuItem(
        title: 'Export People',
        value: 'export_people',
        icon: Icons.download,
        onPressed: (ctx) =>
            ScoutMenuItem.exportFile(context: ctx, fileName: 'people')),
  ];
}
