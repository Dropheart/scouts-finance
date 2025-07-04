import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _customThemeEnabled = true;

  void _toggleTheme() {
    setState(() {
      _customThemeEnabled = !_customThemeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _customThemeEnabled
          ? ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            )
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue), // Default to blue
              useMaterial3: true,
            ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Toggle the theme:',
              ),
              Switch(
                value: _customThemeEnabled,
                onChanged: (bool newValue) {
                  _toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeService extends ChangeNotifier {
  static const String _primaryColorKey = 'primary_color';
  static const String _secondaryColorKey = 'secondary_color';
  static const String _backgroundColorKey = 'background_color';

  Color _primaryColor = Colors.orange;
  Color _secondaryColor = Colors.blue;
  Color _backgroundColor = Colors.white;

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get backgroundColor => _backgroundColor;

  bool enabled = false;

  ThemeData get themeData {
    // Generate base color scheme from primary and secondary colors
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: _isLightBackground ? Brightness.light : Brightness.dark,
    );

    // Override background and surface colors with the selected background color
    // Apply secondary color to card surfaces
    final customColorScheme = baseColorScheme.copyWith(
      surface: _backgroundColor,
      surfaceContainerHighest: _secondaryColor, // Much stronger color
      // Adjust on-surface colors based on background brightness
      onSurface: _getContrastingTextColor(_backgroundColor),
    );

    if (enabled) {
      return ThemeData(
        colorScheme: customColorScheme,
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: _getContrastingTextColor(_primaryColor),
          titleTextStyle: TextStyle(
            color: _getContrastingTextColor(_primaryColor),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: _secondaryColor,
          foregroundColor: _getContrastingTextColor(_secondaryColor),
          elevation: 2.0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: _primaryColor,
          indicatorColor: _primaryColor,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: _getContrastingTextColor(_primaryColor)),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: _getContrastingTextColor(_primaryColor)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 1.0,
          color: _secondaryColor, // Much stronger from 0.15 to 0.4
          surfaceTintColor: _secondaryColor, // Secondary color tint
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStatePropertyAll(_secondaryColor),
          surfaceTintColor: WidgetStatePropertyAll(_secondaryColor),
          overlayColor: WidgetStatePropertyAll(_secondaryColor),
          elevation: const WidgetStatePropertyAll(0.0),
        ),
      );
    } else {
      final scheme = ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: _isLightBackground ? Brightness.light : Brightness.dark,
      );

      return ThemeData(
          colorScheme: scheme,
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 1.0,
          ),
          searchBarTheme: SearchBarThemeData(
            elevation: const WidgetStatePropertyAll(0.0),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: _primaryColor,
            foregroundColor: _getContrastingTextColor(_primaryColor),
            titleTextStyle: TextStyle(
              color: _getContrastingTextColor(_primaryColor),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
          ));
    }
  }

  bool get _isLightBackground {
    // Calculate if the background is light or dark for proper contrast
    final luminance = _backgroundColor.computeLuminance();
    return luminance > 0.5;
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    // Return black text for light backgrounds, white text for dark backgrounds
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  static final List<Color> predefinedColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.white,
    Colors.black,
  ];

  /// Converts a hex string to a Color object
  /// Supports formats: #RGB, #RRGGBB, #AARRGGBB, RGB, RRGGBB, AARRGGBB
  static Color? colorFromHex(String hexString) {
    String hex = hexString.replaceAll('#', '').toUpperCase();

    // Validate hex string
    if (!RegExp(r'^[0-9A-F]+$').hasMatch(hex)) {
      return null;
    }

    try {
      switch (hex.length) {
        case 3: // RGB
          return Color(int.parse(
              'FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}',
              radix: 16));
        case 6: // RRGGBB
          return Color(int.parse('FF$hex', radix: 16));
        case 8: // AARRGGBB
          return Color(int.parse(hex, radix: 16));
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Converts a Color object to a hex string
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final primaryValue = prefs.getInt(_primaryColorKey);
    final secondaryValue = prefs.getInt(_secondaryColorKey);
    final backgroundValue = prefs.getInt(_backgroundColorKey);

    if (primaryValue != null) {
      _primaryColor = Color(primaryValue);
    }
    if (secondaryValue != null) {
      _secondaryColor = Color(secondaryValue);
    }
    if (backgroundValue != null) {
      _backgroundColor = Color(backgroundValue);
    }

    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_primaryColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setSecondaryColor(Color color) async {
    _secondaryColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_secondaryColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setBackgroundColor(Color color) async {
    _backgroundColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_backgroundColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _primaryColor = Colors.orange;
    _secondaryColor = Colors.orangeAccent;
    _backgroundColor = Colors.white;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_primaryColorKey);
    await prefs.remove(_secondaryColorKey);
    await prefs.remove(_backgroundColorKey);

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    enabled = !enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_enabled', enabled);
    notifyListeners();
  }
}
