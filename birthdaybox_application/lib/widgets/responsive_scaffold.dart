import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';
import 'responsive_layout.dart';

/// Reusable ResponsiveScaffold that provides unified adaptive navigation:
/// - Mobile (< 600px): Bottom navigation bar with 4 core destinations.
/// - Tablet (600px–1023px): Vertical NavigationRail on the left.
/// - Desktop (>= 1024px): Permanent sidebar / navigation rail.
///
/// Destinations:
/// 0: Home
/// 1: Birthdays
/// 2: Calendar
/// 3: Profile
///
/// Demonstrates:
/// - MediaQuery & LayoutBuilder responsive behavior (Lab Experiments 3a & 3b)
/// - Named routes as underlying navigation architecture (Lab Experiments 4a & 4b)
/// - Visual consistency in both Light and Dark themes (Lab Experiment 6b)
class ResponsiveScaffold extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final int currentNavIndex;
  final ValueChanged<int>? onNavIndexChanged;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.currentNavIndex = 0,
    this.onNavIndexChanged,
  });

  /// Handles route transition between primary destinations using named routes
  void _handleNavigation(BuildContext context, int index) {
    if (onNavIndexChanged != null) {
      onNavIndexChanged!(index);
      return;
    }

    if (index == currentNavIndex) return;

    final targetRoute = switch (index) {
      0 => AppRoutes.dashboard,
      1 => AppRoutes.birthdays,
      2 => AppRoutes.calendar,
      3 => AppRoutes.profile,
      _ => AppRoutes.dashboard,
    };

    try {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, targetRoute);
      } else if (currentNavIndex == 0) {
        Navigator.pushNamed(context, targetRoute);
      } else {
        Navigator.pushReplacementNamed(context, targetRoute);
      }
    } catch (_) {
      // Fallback for isolated widget test environments
    }
  }

  /// Smooth animated theme switcher button with rotation and fade transition
  static Widget buildThemeSwitchButton(ThemeProvider themeProvider, bool isDark) {
    return IconButton(
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
        ),
      ),
      onPressed: () => themeProvider.toggleTheme(!isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = themeProvider.isDarkMode;

    return ResponsiveLayout.builder(
      builder: (context, constraints, deviceType) {
        // ==========================================
        // 1. DESKTOP VIEW (>= 1024px) - Permanent Sidebar
        // ==========================================
        if (deviceType == DeviceType.desktop) {
          return Scaffold(
            body: Row(
              children: [
                // Permanent Sidebar Navigation
                _DesktopSidebar(
                  currentNavIndex: currentNavIndex,
                  onSelectIndex: (idx) => _handleNavigation(context, idx),
                  isDark: isDark,
                  onToggleTheme: () => themeProvider.toggleTheme(!isDark),
                ),

                // Main Content with AppBar
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      title: title,
                      actions: [
                        ...?actions,
                        buildThemeSwitchButton(themeProvider, isDark),
                        IconButton(
                          tooltip: 'Profile',
                          icon: const Icon(Icons.person_outline),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    floatingActionButton: floatingActionButton,
                    body: body,
                  ),
                ),
              ],
            ),
          );
        }

        // ==========================================
        // 2. TABLET VIEW (600px - 1023px) - NavigationRail
        // ==========================================
        if (deviceType == DeviceType.tablet) {
          return Scaffold(
            body: Row(
              children: [
                // Adaptive NavigationRail on Tablet
                NavigationRail(
                  backgroundColor: theme.cardTheme.color ?? colorScheme.surface,
                  selectedIndex: currentNavIndex >= 0 && currentNavIndex < 4
                      ? currentNavIndex
                      : 0,
                  onDestinationSelected: (idx) => _handleNavigation(context, idx),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: IconThemeData(color: colorScheme.primary),
                  unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
                  selectedLabelTextStyle: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('🎂', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: buildThemeSwitchButton(themeProvider, isDark),
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.cake_outlined),
                      selectedIcon: Icon(Icons.cake),
                      label: Text('Birthdays'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month),
                      label: Text('Calendar'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: colorScheme.outline.withValues(alpha: 0.25),
                ),

                // Main Content with AppBar
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      title: title,
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
                        buildThemeSwitchButton(themeProvider, isDark),
                        ...?actions,
                        const SizedBox(width: 8),
                      ],
                    ),
                    floatingActionButton: floatingActionButton,
                    body: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 960),
                        child: body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // ==========================================
        // 3. MOBILE VIEW (< 600px) - Bottom Navigation
        // ==========================================
        return Scaffold(
          appBar: AppBar(
            title: title,
            actions: [
              IconButton(
                tooltip: 'Profile',
                icon: const Icon(Icons.person_outline),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
              ),
              buildThemeSwitchButton(themeProvider, isDark),
              ...?actions,
              const SizedBox(width: 8),
            ],
          ),
          floatingActionButton: floatingActionButton,
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentNavIndex >= 0 && currentNavIndex < 4
                ? currentNavIndex
                : 0,
            onTap: (index) => _handleNavigation(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.cardTheme.color ?? colorScheme.surface,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cake_outlined),
                activeIcon: Icon(Icons.cake),
                label: 'Birthdays',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Desktop Navigation Sidebar Component
class _DesktopSidebar extends StatelessWidget {
  final int currentNavIndex;
  final ValueChanged<int> onSelectIndex;
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _DesktopSidebar({
    required this.currentNavIndex,
    required this.onSelectIndex,
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
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: theme.cardTheme.color ?? colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo & Branding
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Reminder App',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 12),

          // 4 Core Navigation Destinations
          _SidebarTile(
            icon: Icons.dashboard_outlined,
            title: 'Home',
            isSelected: currentNavIndex == 0,
            onTap: () => onSelectIndex(0),
          ),
          _SidebarTile(
            icon: Icons.cake_outlined,
            title: 'Birthdays',
            subtitle: 'All Birthdays',
            isSelected: currentNavIndex == 1,
            onTap: () => onSelectIndex(1),
          ),
          _SidebarTile(
            icon: Icons.calendar_month_outlined,
            title: 'Calendar',
            isSelected: currentNavIndex == 2,
            onTap: () => onSelectIndex(2),
          ),
          _SidebarTile(
            icon: Icons.person_outline,
            title: 'Profile',
            isSelected: currentNavIndex == 3,
            onTap: () => onSelectIndex(3),
          ),

          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          const SizedBox(height: 8),

          // Quick Action: Add Birthday
          _SidebarTile(
            icon: Icons.add_circle_outline,
            title: 'Add Birthday',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
          ),

          const Spacer(),
          const Divider(height: 1),

          // Theme Switcher Tile (consistent in Light & Dark mode)
          ListTile(
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(isDark),
                color: colorScheme.primary,
              ),
            ),
            title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
            onTap: onToggleTheme,
          ),
          const SizedBox(height: 12),
        ],
      ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            selected: isSelected,
            leading: Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
