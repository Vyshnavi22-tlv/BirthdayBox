import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

/// AppRoutes defines named route constants and page route generation.
/// Demonstrates Named Routes & Navigation (Lab Experiments 4a & 4b).
class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String birthdays = '/birthdays';
  static const String addBirthday = '/add-birthday';
  static const String birthdayDetails = '/birthday-details';
  static const String calendar = '/calendar';
  static const String profile = '/profile';

  /// Centralized route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
    }
  }
}
