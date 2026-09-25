import 'package:flutter/material.dart';
import '../screens/add_birthday_screen.dart';
import '../screens/birthday_details_screen.dart';
import '../screens/birthdays_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';

/// AppRoutes defines named route constants and page route generation.
/// Demonstrates Named Routes & Navigation (Lab Experiments 4a & 4b).
class AppRoutes {
  // Named route paths
  static const String root = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String birthdays = '/birthdays';
  static const String addBirthday = '/add-birthday';
  static const String birthdayDetails = '/birthday-details';
  static const String calendar = '/calendar';
  static const String profile = '/profile';

  /// Centralized route map for MaterialApp
  static Map<String, WidgetBuilder> get routes => {
        root: (_) => const SplashScreen(),
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        signup: (_) => const SignupScreen(),
        home: (_) => const DashboardScreen(),
        dashboard: (_) => const DashboardScreen(),
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
      builder: (_) => const DashboardScreen(),
      settings: settings,
    );
  }
}
