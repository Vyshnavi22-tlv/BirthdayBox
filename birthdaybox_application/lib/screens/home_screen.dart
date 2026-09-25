import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/birthday_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/responsive_layout.dart';

/// Starter Foundation, Theme Showcase & Navigation Hub for BirthdayBox.
/// Demonstrates:
/// - Stateless & Stateful widgets (Lab 5a)
/// - Row, Column & Card layouts (Lab 2b)
/// - Responsive Breakpoints (Lab 3b)
/// - Themes & Custom Styles without hardcoded screen colors (Lab 6b)
/// - Global Theme Mode switching with Provider (Lab 5b)
/// - Navigator & Named Routes (Lab 4a & 4b)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine current layout mode based on responsive breakpoints
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
            tooltip: 'Profile & Settings',
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Welcome header card with theme-aware styling
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to ${AppConstants.appName}! 🎉',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppConstants.appTagline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.devices,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Active Layout: $layoutMode',
                            style: theme.textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Text(
                            isDark ? '🌙 Dark Theme' : '☀️ Light Theme',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Statistics summary cards (Row + Expanded)
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
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Total Birthdays',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
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
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                            Text(
                              'Upcoming (30d)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Named Routes Navigation Hub (Lab 4a & 4b)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.alt_route, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Named Routes Navigation (Lab 4a & 4b)',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap any route below to test seamless named route transitions:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.cake, size: 18),
                            label: const Text('/birthdays'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdays),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.add, size: 18),
                            label: const Text('/add-birthday'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.info_outline, size: 18),
                            label: const Text('/birthday-details'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.calendar_month, size: 18),
                            label: const Text('/calendar'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.calendar),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.person, size: 18),
                            label: const Text('/profile'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.login, size: 18),
                            label: const Text('/login'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.person_add, size: 18),
                            label: const Text('/signup'),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Theme System Showcase Card (demonstrates requirements)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette_outlined, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Theme System & Styling Components',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'All components automatically adapt between Light & Dark themes without hardcoded screen colors:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Relationship category chips preview
                      Text('Relationship Tags:', style: theme.textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AppConstants.relationshipCategories.map((category) {
                          final categoryColor = AppTheme.getRelationshipColor(category);
                          return Chip(
                            backgroundColor: categoryColor.withValues(alpha: 0.15),
                            side: BorderSide(
                              color: categoryColor.withValues(alpha: 0.4),
                              width: 1,
                            ),
                            label: Text(
                              category,
                              style: TextStyle(
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Reusable input decoration preview
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Sample Birthday Reminder Input',
                          hintText: 'Enter name or notes...',
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Reusable Button styles preview
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                themeProvider.toggleTheme(!isDark);
                              },
                              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                              label: Text(isDark ? 'Switch to Light' : 'Switch to Dark'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdays),
                              child: const Text('View Birthdays'),
                            ),
                          ),
                        ],
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
