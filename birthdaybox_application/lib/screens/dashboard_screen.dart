import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthday_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/birthday_card.dart';
import '../widgets/countdown_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/stat_card.dart';

/// Final Responsive BirthdayBox Dashboard.
/// Demonstrates:
/// - Row, Column, Container, Card, Stack composition (Lab Experiment 2b)
/// - Responsive UI: Mobile (single column), Tablet (2-column cards), Desktop (Sidebar + multi-column) (Lab 3a & 3b)
/// - State Management with Provider & auto-updating UI (Lab Experiment 5b)
/// - Custom Reusable Widgets (Lab Experiment 6a)
/// - Themes & Custom Styles without hardcoded colors (Lab Experiment 6b)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _DashboardMobileView(),
      tablet: _DashboardTabletView(),
      desktop: _DashboardDesktopView(),
    );
  }
}

// ==========================================
// 1. MOBILE LAYOUT (<600px) - Single Column
// ==========================================
class _DashboardMobileView extends StatelessWidget {
  const _DashboardMobileView();

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final upcomingList = birthdayProvider.upcomingBirthdays;

    return Scaffold(
      appBar: AppBar(
        title: const _DashboardHeaderTitle(),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(!isDark),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
        icon: const Icon(Icons.add),
        label: const Text('Add Birthday'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Welcome message banner
          const _WelcomeBanner(layoutName: 'Mobile (Single Column)'),
          const SizedBox(height: 16),

          // Statistics (3 cards in Row)
          _DashboardStatisticsRow(birthdayProvider: birthdayProvider),
          const SizedBox(height: 16),

          // Nearest countdown spotlight card
          if (upcomingList.isNotEmpty) ...[
            CountdownCard(
              birthday: upcomingList.first,
              onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
            ),
            const SizedBox(height: 16),
          ],

          // Upcoming celebrations header
          _UpcomingSectionHeader(
            count: upcomingList.length,
            onViewAll: () => Navigator.pushNamed(context, AppRoutes.birthdays),
          ),
          const SizedBox(height: 10),

          // Single-column birthday cards
          if (upcomingList.isEmpty)
            const _EmptyBirthdaysPlaceholder()
          else
            ...upcomingList.map(
              (birthday) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: BirthdayCard(
                  birthday: birthday,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                  onDelete: () => _confirmDelete(context, birthdayProvider, birthday),
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Quick Navigation Hub
          const _DashboardNavigationChips(),

          const SizedBox(height: 60), // Spacing for FAB
        ],
      ),
    );
  }
}

// ==========================================
// 2. TABLET LAYOUT (600px - 1024px) - 2-Column Cards
// ==========================================
class _DashboardTabletView extends StatelessWidget {
  const _DashboardTabletView();

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final upcomingList = birthdayProvider.upcomingBirthdays;

    return Scaffold(
      appBar: AppBar(
        title: const _DashboardHeaderTitle(),
        actions: [
          IconButton(
            tooltip: 'Calendar',
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.calendar),
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(!isDark),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
        icon: const Icon(Icons.add),
        label: const Text('Add Birthday'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // Welcome header banner
              const _WelcomeBanner(layoutName: 'Tablet (2-Column Adaptive)'),
              const SizedBox(height: 18),

              // 3 Statistics Cards
              _DashboardStatisticsRow(birthdayProvider: birthdayProvider),
              const SizedBox(height: 18),

              // Countdown spotlight card
              if (upcomingList.isNotEmpty) ...[
                CountdownCard(
                  birthday: upcomingList.first,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                ),
                const SizedBox(height: 18),
              ],

              // Upcoming celebrations header
              _UpcomingSectionHeader(
                count: upcomingList.length,
                onViewAll: () => Navigator.pushNamed(context, AppRoutes.birthdays),
              ),
              const SizedBox(height: 12),

              // Two-column birthday cards grid
              if (upcomingList.isEmpty)
                const _EmptyBirthdaysPlaceholder()
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 110,
                  ),
                  itemCount: upcomingList.length,
                  itemBuilder: (context, index) {
                    final b = upcomingList[index];
                    return BirthdayCard(
                      birthday: b,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                      onDelete: () => _confirmDelete(context, birthdayProvider, b),
                    );
                  },
                ),

              const SizedBox(height: 24),
              const _DashboardNavigationChips(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. DESKTOP LAYOUT (≥1024px) - Sidebar + Multi-Column
// ==========================================
class _DashboardDesktopView extends StatelessWidget {
  const _DashboardDesktopView();

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final upcomingList = birthdayProvider.upcomingBirthdays;

    return Scaffold(
      body: Row(
        children: [
          // Persistent Sidebar
          _DesktopSidebar(
            isDark: isDark,
            onToggleTheme: () => themeProvider.toggleTheme(!isDark),
          ),

          // Main Multi-Column Content
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Dashboard Overview'),
                actions: [
                  IconButton(
                    tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () => themeProvider.toggleTheme(!isDark),
                  ),
                  IconButton(
                    tooltip: 'Profile',
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                icon: const Icon(Icons.add),
                label: const Text('Add Birthday'),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                children: [
                  // Welcome banner
                  const _WelcomeBanner(layoutName: 'Dashboard (Sidebar + Multi-Column)'),
                  const SizedBox(height: 20),

                  // 3-card Statistics row
                  _DashboardStatisticsRow(birthdayProvider: birthdayProvider),
                  const SizedBox(height: 24),

                  // Multi-column section: Left Spotlight + Right Grid
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Spotlight Countdown + Quick Actions
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (upcomingList.isNotEmpty)
                              CountdownCard(
                                birthday: upcomingList.first,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.birthdayDetails,
                                ),
                              )
                            else
                              const _EmptyBirthdaysPlaceholder(),
                            const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.bolt, color: colorScheme.primary),
                                        const SizedBox(width: 8),
                                        Text('Quick Actions', style: theme.textTheme.titleMedium),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    CustomButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.addBirthday,
                                      ),
                                      text: 'Add New Birthday',
                                      icon: Icons.add,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.birthdays,
                                      ),
                                      text: 'View All Celebrations',
                                      icon: Icons.cake_outlined,
                                      isOutlined: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Right Column: Upcoming Celebrations Grid
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _UpcomingSectionHeader(
                              count: upcomingList.length,
                              onViewAll: () => Navigator.pushNamed(context, AppRoutes.birthdays),
                            ),
                            const SizedBox(height: 12),
                            if (upcomingList.isEmpty)
                              const _EmptyBirthdaysPlaceholder()
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 110,
                                ),
                                itemCount: upcomingList.length,
                                itemBuilder: (context, index) {
                                  final b = upcomingList[index];
                                  return BirthdayCard(
                                    birthday: b,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.birthdayDetails,
                                    ),
                                    onDelete: () => _confirmDelete(
                                      context,
                                      birthdayProvider,
                                      b,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  const _DashboardNavigationChips(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// REUSABLE DASHBOARD SUB-COMPONENTS
// ==========================================

/// Header Title Widget
class _DashboardHeaderTitle extends StatelessWidget {
  const _DashboardHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎂 '),
          Text(
            AppConstants.appName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Welcome Banner with layout badge
class _WelcomeBanner extends StatelessWidget {
  final String layoutName;

  const _WelcomeBanner({required this.layoutName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back, Alex! 🎉',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Keep track of every smile, celebration, and special day.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.devices, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    layoutName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Statistics Row (Total Birthdays, This Month, Today)
class _DashboardStatisticsRow extends StatelessWidget {
  final BirthdayProvider birthdayProvider;

  const _DashboardStatisticsRow({required this.birthdayProvider});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Total Birthdays
        Expanded(
          child: StatCard(
            icon: Icons.cake_outlined,
            number: '${birthdayProvider.totalBirthdayCount}',
            label: 'Total Birthdays',
            accentColor: colorScheme.primary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.birthdays),
          ),
        ),
        const SizedBox(width: 10),
        // This Month
        Expanded(
          child: StatCard(
            icon: Icons.calendar_month_outlined,
            number: '${birthdayProvider.thisMonthsBirthdayCount}',
            label: 'This Month',
            accentColor: colorScheme.secondary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.birthdays),
          ),
        ),
        const SizedBox(width: 10),
        // Today
        Expanded(
          child: StatCard(
            icon: Icons.celebration_outlined,
            number: '${birthdayProvider.todayBirthdays.length}',
            label: "Today's",
            accentColor: AppTheme.celebrationGold,
            onTap: () => Navigator.pushNamed(context, AppRoutes.birthdays),
          ),
        ),
      ],
    );
  }
}

/// Upcoming Celebrations Section Header
class _UpcomingSectionHeader extends StatelessWidget {
  final int count;
  final VoidCallback onViewAll;

  const _UpcomingSectionHeader({
    required this.count,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(Icons.stars_rounded, color: colorScheme.primary, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Upcoming Celebrations ($count)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: const Text('View All'),
        ),
      ],
    );
  }
}

/// Placeholder when no birthdays are saved
class _EmptyBirthdaysPlaceholder extends StatelessWidget {
  const _EmptyBirthdaysPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            const Text('🎂', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              'No upcoming birthdays yet!',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Tap the button below to add your first birthday.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Desktop Navigation Sidebar
class _DesktopSidebar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _DesktopSidebar({
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🎂', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppConstants.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 12),

          // Navigation Links
          _SidebarTile(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            isSelected: true,
            onTap: () {},
          ),
          _SidebarTile(
            icon: Icons.cake_outlined,
            title: 'All Birthdays',
            onTap: () => Navigator.pushNamed(context, AppRoutes.birthdays),
          ),
          _SidebarTile(
            icon: Icons.add_circle_outline,
            title: 'Add Birthday',
            onTap: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
          ),
          _SidebarTile(
            icon: Icons.calendar_month_outlined,
            title: 'Calendar',
            onTap: () => Navigator.pushNamed(context, AppRoutes.calendar),
          ),
          _SidebarTile(
            icon: Icons.person_outline,
            title: 'Profile & Settings',
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),

          const Spacer(),
          const Divider(height: 1),

          // Theme Switcher Tile
          ListTile(
            leading: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: colorScheme.primary,
            ),
            title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
            onTap: onToggleTheme,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        selected: isSelected,
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
        selectedColor: colorScheme.primary,
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

/// Navigation Chips for verifying named routes
class _DashboardNavigationChips extends StatelessWidget {
  const _DashboardNavigationChips();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.alt_route, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Quick Route Shortcuts', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.cake, size: 16),
                  label: const Text('/birthdays'),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdays),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('/add-birthday'),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                ),
                ActionChip(
                  avatar: const Icon(Icons.calendar_month, size: 16),
                  label: const Text('/calendar'),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.calendar),
                ),
                ActionChip(
                  avatar: const Icon(Icons.person, size: 16),
                  label: const Text('/profile'),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to confirm deleting a birthday
void _confirmDelete(
  BuildContext context,
  BirthdayProvider provider,
  Birthday birthday,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Birthday'),
      content: Text('Are you sure you want to remove ${birthday.name}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          onPressed: () {
            provider.deleteBirthday(birthday.id);
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${birthday.name} removed'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
