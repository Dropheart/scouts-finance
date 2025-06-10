import 'package:flutter/material.dart';

class OptionsMenu extends StatelessWidget {
  final int selectedIndex;
  const OptionsMenu({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;

    final String moreOptions;
    switch (selectedIndex) {
      case 0:
        moreOptions = 'Export Events';
        break;
      case 1:
        moreOptions = 'Export Payments';
        break;
      case 2:
        moreOptions = 'Export Scouts';
        break;
      case 3:
        moreOptions = 'Export Parents';
        break;
      default:
        throw Exception('Invalid selectedIndex: $selectedIndex');
    }

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
              PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: colours.onSurface),
                    SizedBox(width: 8.0),
                    Text(moreOptions),
                  ],
                ),
              ),
            ]);
  }
}
