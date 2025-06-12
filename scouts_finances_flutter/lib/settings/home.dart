import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_flutter/services/theme_service.dart';
import 'package:scouts_finances_flutter/widgets/snake_game.dart';
import 'dart:async';

class SettingsHome extends StatefulWidget {
  const SettingsHome({super.key});

  @override
  State<SettingsHome> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  bool _notifications = true;
  bool _remindDayBefore = true;
  bool _remindXDaysBefore = false;
  int _xDaysBeforeValue = 7;
  int _versionTapCount = 0;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _onVersionTap() {
    setState(() {
      _versionTapCount++;
    });

    // Reset counter after 3 seconds of no taps
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _versionTapCount = 0;
      });
    });

    // Show snake game after 3 taps
    if (_versionTapCount >= 3) {
      _resetTimer?.cancel();
      setState(() {
        _versionTapCount = 0;
      });
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SnakeGame(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Theme Settings Section
            Text(
              'Theme Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  const ColorSelectorTile(
                    title: 'Primary Color',
                    subtitle: 'Main app color',
                    colorType: ColorType.primary,
                  ),
                  const ColorSelectorTile(
                    title: 'Secondary Color',
                    subtitle: 'Accent color',
                    colorType: ColorType.secondary,
                  ),
                  const ColorSelectorTile(
                    title: 'Background Color',
                    subtitle: 'App background color',
                    colorType: ColorType.background,
                  ),
                  ListTile(
                    title: const Text('Reset Colors'),
                    subtitle: const Text('Reset to default colors'),
                    trailing: const Icon(Icons.refresh),
                    onTap: () {
                      _showResetColorsDialog();
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // App Settings Section
            Text(
              'App Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Enable push notifications'),
                    value: _notifications,
                    onChanged: (value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Payment Reminders Section
            Text(
              'Payment Reminders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Remind day before'),
                    subtitle: const Text('Send reminder 1 day before payment due'),
                    value: _remindDayBefore,
                    onChanged: (value) {
                      setState(() {
                        _remindDayBefore = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Remind $_xDaysBeforeValue days before'),
                    subtitle: Text('Send reminder $_xDaysBeforeValue days before payment due'),
                    value: _remindXDaysBefore,
                    onChanged: (value) {
                      setState(() {
                        _remindXDaysBefore = value;
                      });
                    },
                  ),
                  if (_remindXDaysBefore)
                    ListTile(
                      title: const Text('Days before reminder'),
                      subtitle: Text('Send reminder $_xDaysBeforeValue days before due date'),
                      trailing: SizedBox(
                        width: 80,
                        child: TextFormField(
                          initialValue: _xDaysBeforeValue.toString(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (value) {
                            final intValue = int.tryParse(value);
                            if (intValue != null && intValue >= 2) {
                              setState(() {
                                _xDaysBeforeValue = intValue;
                              });
                            }
                          },
                          validator: (value) {
                            final intValue = int.tryParse(value ?? '');
                            if (intValue == null || intValue < 2) {
                              return 'Must be ≥ 2';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  if (_remindXDaysBefore)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Note: Reminder features are not yet implemented',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // About Section
            Text(
              'About',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Version'),
                    subtitle: Text(_versionTapCount > 0 
                        ? '1.0.0 (${3 - _versionTapCount} more taps...)'
                        : '1.0.0'),
                    onTap: _onVersionTap,
                  ),
                  ListTile(
                    title: const Text('About'),
                    subtitle: const Text('Scout Group Finance Management App'),
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetColorsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Colors'),
        content: const Text('Are you sure you want to reset all colors to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ThemeService>(context, listen: false).resetToDefaults();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Colors reset to defaults'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showNotImplementedDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature is not implemented yet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Scout Finance Manager',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Scout Group Finance Management',
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'A comprehensive finance management application for Scout groups, '
            'helping track payments, events, and member finances.',
          ),
        ),
      ],
    );
  }
}

enum ColorType { primary, secondary, background }

class ColorSelectorTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final ColorType colorType;

  const ColorSelectorTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.colorType,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        Color currentColor;
        switch (colorType) {
          case ColorType.primary:
            currentColor = themeService.primaryColor;
            break;
          case ColorType.secondary:
            currentColor = themeService.secondaryColor;
            break;
          case ColorType.background:
            currentColor = themeService.backgroundColor;
            break;
        }

        return ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: currentColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onTap: () {
            _showColorPicker(context, themeService, currentColor);
          },
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ThemeService themeService, Color currentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select $title'),
        content: SizedBox(
          width: 350,
          height: 500,
          child: Column(
            children: [
              // Hex input section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Hex Color',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: '#FF5722 or FF5722',
                              prefixText: '#',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onSubmitted: (value) {
                              final color = ThemeService.colorFromHex(value);
                              if (color != null) {
                                _setColor(themeService, color);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid hex color format'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: currentColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current: ${ThemeService.colorToHex(currentColor)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Predefined colors section
              Text(
                'Or choose from presets:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Color grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: ThemeService.predefinedColors.length,
                  itemBuilder: (context, index) {
                    final color = ThemeService.predefinedColors[index];
                    final isSelected = color.value == currentColor.value;

                    return GestureDetector(
                      onTap: () {
                        _setColor(themeService, color);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                            width: isSelected ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _setColor(ThemeService themeService, Color color) {
    switch (colorType) {
      case ColorType.primary:
        themeService.setPrimaryColor(color);
        break;
      case ColorType.secondary:
        themeService.setSecondaryColor(color);
        break;
      case ColorType.background:
        themeService.setBackgroundColor(color);
        break;
    }
  }
}
