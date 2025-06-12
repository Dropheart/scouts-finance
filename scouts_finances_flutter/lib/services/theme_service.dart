import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  ThemeData get themeData {
    // Generate base color scheme from primary and secondary colors
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      secondary: _secondaryColor,
      brightness: _isLightBackground ? Brightness.light : Brightness.dark,
    );
    
    // Override background and surface colors with the selected background color
    final customColorScheme = baseColorScheme.copyWith(
      surface: _backgroundColor,
      background: _backgroundColor,
      // Adjust on-surface colors based on background brightness
      onSurface: _getContrastingTextColor(_backgroundColor),
      onBackground: _getContrastingTextColor(_backgroundColor),
    );

    return ThemeData(
      colorScheme: customColorScheme,
      scaffoldBackgroundColor: _backgroundColor,
      cardTheme: CardThemeData(
        elevation: 1.0,
        color: _backgroundColor,
      ),
      searchBarTheme: const SearchBarThemeData(
        elevation: WidgetStatePropertyAll(0.0),
      ),
    );
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
          return Color(int.parse('FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}', radix: 16));
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
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
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
    await prefs.setInt(_primaryColorKey, color.value);
    notifyListeners();
  }

  Future<void> setSecondaryColor(Color color) async {
    _secondaryColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_secondaryColorKey, color.value);
    notifyListeners();
  }

  Future<void> setBackgroundColor(Color color) async {
    _backgroundColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_backgroundColorKey, color.value);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _primaryColor = Colors.orange;
    _secondaryColor = Colors.blue;
    _backgroundColor = Colors.white;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_primaryColorKey);
    await prefs.remove(_secondaryColorKey);
    await prefs.remove(_backgroundColorKey);
    
    notifyListeners();
  }
}
