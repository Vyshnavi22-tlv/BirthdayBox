import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

/// HomeScreen delegates to the responsive DashboardScreen.
/// Preserves backward compatibility while providing the full dashboard experience.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
