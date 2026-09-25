import 'package:flutter/material.dart';

/// ThemeProvider manages global theme state across BirthdayBox.
/// Demonstrates State Management with Provider (Lab Experiment 5b).
///
/// Responsibilities:
/// - Stores whether dark mode is currently enabled.
/// - Toggles between Light and Dark themes.
/// - Notifies all listening widgets when the theme changes.
class ThemeProvider extends ChangeNotifier {
  // Stores whether dark mode is currently enabled
  bool _isDarkMode = false;

  /// Getter to check if dark mode is active
  bool get isDarkMode => _isDarkMode;

  /// Returns the appropriate ThemeMode for MaterialApp
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Toggles between Light and Dark themes and notifies all listeners
  void toggleTheme([bool? enableDark]) {
    _isDarkMode = enableDark ?? !_isDarkMode;
    notifyListeners();
  }

  /// Explicitly sets dark mode on or off
  void setDarkMode(bool enable) {
    if (_isDarkMode != enable) {
      _isDarkMode = enable;
      notifyListeners();
    }
  }
}
