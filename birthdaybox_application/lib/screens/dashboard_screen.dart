import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthday_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/birthday_card.dart';
import '../widgets/countdown_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/stat_card.dart';

/// Responsive BirthdayBox Dashboard.
/// Demonstrates:
/// - Reusable Responsive Layout and Scaffolding without screen duplication (Lab Experiments 3a & 3b)
/// - Breakpoints: Mobile (< 600px), Tablet (600px - 1023px), Desktop (>= 1024px)
/// - Mobile: Bottom navigation + single-column cards
/// - Tablet: Two-column cards layout + more horizontal spacing
/// - Desktop: Sidebar navigation + multi-column content + larger content area
/// - State Management with BirthdayProvider & auto-updating UI (Lab Experiment 5b)
/// - Custom Reusable Widgets (Lab Experiment 6a) & Theming without hardcoded colors (Lab Experiment 6b)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);

    return ResponsiveScaffold(
      currentNavIndex: 0,
      title: const _DashboardHeaderTitle(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
        icon: const Icon(Icons.add),
        label: const Text('Add Birthday'),
      ),
      body: ResponsiveLayout.builder(
        builder: (context, constraints, deviceType) {
          final upcomingList = birthdayProvider.upcomingBirthdays;

          // Responsive horizontal padding across breakpoints
          final horizontalPadding = ResponsiveLayout.value<double>(
            context,
            mobile: 16.0,
            tablet: 28.0,
            desktop: 36.0,
          );

          // Responsive layout mode badge for academic demonstration
          final layoutBadge = switch (deviceType) {
            DeviceType.mobile => 'Mobile (Single Column)',
            DeviceType.tablet => 'Tablet (2-Column Adaptive)',
            DeviceType.desktop => 'Dashboard (Sidebar + Multi-Column)',
          };

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: deviceType == DeviceType.desktop ? 24.0 : 16.0,
            ),
            children: [
              // 1. Welcome Greeting Banner (Shared across layouts)
              _WelcomeBanner(layoutName: layoutBadge),
              const SizedBox(height: 16),

              // 2. Statistics Row (Total Birthdays, This Month, Today's) - Shared component
              _DashboardStatisticsRow(birthdayProvider: birthdayProvider),
              const SizedBox(height: 20),

              // 3. Celebrations Section (Adapts responsively without screen duplication)
              if (deviceType == DeviceType.desktop)
                // Desktop: Multi-column content (Left flex 5: spotlight & actions; Right flex 7: grid)
                _DashboardDesktopContent(
                  upcomingList: upcomingList,
                  birthdayProvider: birthdayProvider,
                )
              else if (deviceType == DeviceType.tablet)
                // Tablet: Spotlight Countdown + 2-Column Cards Grid with adaptive spacing
                _DashboardTabletContent(
                  upcomingList: upcomingList,
                  birthdayProvider: birthdayProvider,
                )
              else
                // Mobile: Spotlight Countdown + Single-Column Cards List
                _DashboardMobileContent(
                  upcomingList: upcomingList,
                  birthdayProvider: birthdayProvider,
                ),

              const SizedBox(height: 24),

              // 4. Quick Navigation Hub (Shared component)
              const _DashboardNavigationChips(),

              const SizedBox(height: 60), // Spacing for FAB
            ],
          );
        },
      ),
    );
  }
}

// ==========================================
// 1. MOBILE CONTENT (< 600px) - Single Column
// ==========================================
class _DashboardMobileContent extends StatelessWidget {
  final List<Birthday> upcomingList;
  final BirthdayProvider birthdayProvider;

  const _DashboardMobileContent({
    required this.upcomingList,
    required this.birthdayProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (upcomingList.isNotEmpty) ...[
          CountdownCard(
            birthday: upcomingList.first,
            onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
          ),
          const SizedBox(height: 16),
        ],
        _UpcomingSectionHeader(
          count: upcomingList.length,
          onViewAll: () => Navigator.pushNamed(context, AppRoutes.birthdays),
        ),
        const SizedBox(height: 10),
        if (upcomingList.isEmpty)
          const _EmptyBirthdaysPlaceholder()
        else
          ...upcomingList.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: BirthdayCard(
                birthday: b,
                onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                onDelete: () => _confirmDelete(context, birthdayProvider, b),
              ),
            ),
          ),
      ],
    );
  }
}

// ==========================================
// 2. TABLET CONTENT (600px - 1023px) - 2-Column Grid
// ==========================================
class _DashboardTabletContent extends StatelessWidget {
  final List<Birthday> upcomingList;
  final BirthdayProvider birthdayProvider;

  const _DashboardTabletContent({
    required this.upcomingList,
    required this.birthdayProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (upcomingList.isNotEmpty) ...[
          CountdownCard(
            birthday: upcomingList.first,
            onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
          ),
          const SizedBox(height: 18),
        ],
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
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 115,
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
      ],
    );
  }
}

// ==========================================
// 3. DESKTOP CONTENT (>= 1024px) - Multi-Column Area
// ==========================================
class _DashboardDesktopContent extends StatelessWidget {
  final List<Birthday> upcomingList;
  final BirthdayProvider birthdayProvider;

  const _DashboardDesktopContent({
    required this.upcomingList,
    required this.birthdayProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (flex 5): Spotlight Countdown & Quick Actions Card
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (upcomingList.isNotEmpty)
                CountdownCard(
                  birthday: upcomingList.first,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
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
                          Expanded(
                            child: Text(
                              'Quick Actions',
                              style: theme.textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      CustomButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                        text: 'Add New Birthday',
                        icon: Icons.add,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdays),
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

        // Right Column (flex 7): Section Header & Celebrations Grid
        Expanded(
          flex: 7,
          child: LayoutBuilder(
            builder: (context, colConstraints) {
              final useTwoCols = colConstraints.maxWidth >= 480;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _UpcomingSectionHeader(
                    count: upcomingList.length,
                    onViewAll: () => Navigator.pushNamed(context, AppRoutes.birthdays),
                  ),
                  const SizedBox(height: 12),
                  if (upcomingList.isEmpty)
                    const _EmptyBirthdaysPlaceholder()
                  else if (!useTwoCols)
                    ...upcomingList.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: BirthdayCard(
                          birthday: b,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                          onDelete: () => _confirmDelete(context, birthdayProvider, b),
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 115,
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
                ],
              );
            },
          ),
        ),
      ],
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
              'No upcoming birthdays',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap "+ Add Birthday" to record your loved ones’ special days.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick Navigation Hub
class _DashboardNavigationChips extends StatelessWidget {
  const _DashboardNavigationChips();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Navigation',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.cake_outlined, size: 18),
              label: const Text('Birthdays List'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdays),
            ),
            ActionChip(
              avatar: const Icon(Icons.calendar_month_outlined, size: 18),
              label: const Text('Calendar View'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.calendar),
            ),
            ActionChip(
              avatar: const Icon(Icons.person_outline, size: 18),
              label: const Text('User Profile'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            ),
            ActionChip(
              avatar: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('New Birthday'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
            ),
          ],
        ),
      ],
    );
  }
}

/// Delete Confirmation Dialog
void _confirmDelete(
  BuildContext context,
  BirthdayProvider provider,
  Birthday birthday,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Birthday?'),
      content: Text(
        'Are you sure you want to remove ${birthday.name}’s birthday celebration from your list?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            provider.deleteBirthday(birthday.id);
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${birthday.name}’s birthday'),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
