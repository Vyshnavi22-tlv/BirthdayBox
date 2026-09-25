import 'package:flutter/material.dart';
import '../screens/add_birthday_screen.dart';
import '../screens/birthday_details_screen.dart';
import '../screens/birthdays_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/signup_screen.dart';

/// AppRoutes defines named route constants and page route generation.
/// Demonstrates Named Routes & Navigation (Lab Experiments 4a & 4b).
class AppRoutes {
  // Named route paths
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String birthdays = '/birthdays';
  static const String addBirthday = '/add-birthday';
  static const String birthdayDetails = '/birthday-details';
  static const String calendar = '/calendar';
  static const String profile = '/profile';

  /// Centralized route map for MaterialApp
  static Map<String, WidgetBuilder> get routes => {
        root: (_) => const HomeScreen(),
        home: (_) => const HomeScreen(),
        login: (_) => const LoginScreen(),
        signup: (_) => const SignupScreen(),
        birthdays: (_) => const BirthdaysScreen(),
        addBirthday: (_) => const AddBirthdayScreen(),
        birthdayDetails: (_) => const BirthdayDetailsScreen(),
        calendar: (_) => const CalendarScreen(),
        profile: (_) => const ProfileScreen(),
      };

  /// Dynamic route generator for handling named routes and arguments
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    // Fallback route in case an undefined route is requested
    return MaterialPageRoute(
      builder: (_) => const HomeScreen(),
      settings: settings,
    );
  }
}
