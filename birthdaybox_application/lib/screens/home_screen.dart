import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/birthday_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/responsive_layout.dart';

/// Starter Foundation Screen for BirthdayBox.
/// Demonstrates:
/// - Stateless & Stateful widgets (Lab 5a)
/// - Row, Column & Card layouts (Lab 2b)
/// - Responsive Breakpoints (Lab 3b)
/// - Theme & State Management using Provider (Lab 5b & 6b)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final isDark = themeProvider.isDarkMode(context);

    // Determine current layout device type for demonstration
    String layoutMode = 'Mobile (<600px)';
    if (ResponsiveLayout.isDesktop(context)) {
      layoutMode = 'Desktop (≥1024px)';
    } else if (ResponsiveLayout.isTablet(context)) {
      layoutMode = 'Tablet (600–1024px)';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🎂 '),
            Text(AppConstants.appName),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme(!isDark);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Welcome header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to ${AppConstants.appName}! 🎉',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.appTagline,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.devices, size: 20, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            'Active Layout: $layoutMode',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Foundation status and statistics summary
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text('🎂', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${birthdayProvider.totalCount}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Text('Total Birthdays', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text('⏳', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              '${birthdayProvider.upcomingThisMonthCount}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Text('Upcoming (30d)', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Foundation check card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Project Foundation Ready',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'The clean folder architecture and foundational state providers (ThemeProvider & BirthdayProvider) are set up and running successfully.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
