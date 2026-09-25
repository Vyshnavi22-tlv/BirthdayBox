import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';
import 'responsive_layout.dart';

/// Reusable ResponsiveScaffold that provides:
/// - Mobile (< 600px): Bottom navigation bar + compact AppBar + single column layout.
/// - Tablet (600px–1023px): Two-column layout support + adaptive AppBar + generous horizontal spacing.
/// - Desktop (>= 1024px): Persistent Sidebar navigation + larger content area.
///
/// Demonstrates:
/// - MediaQuery & LayoutBuilder responsive behavior (Lab Experiments 3a & 3b)
/// - Unified responsive scaffolding without duplicating screens
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

  void _handleNavigation(BuildContext context, int index) {
    if (onNavIndexChanged != null) {
      onNavIndexChanged!(index);
      return;
    }

    if (index == currentNavIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.birthdays);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.calendar);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
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
        // 1. DESKTOP VIEW (>= 1024px) - Persistent Sidebar
        // ==========================================
        if (deviceType == DeviceType.desktop) {
          return Scaffold(
            body: Row(
              children: [
                // Persistent Sidebar
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
                    floatingActionButton: floatingActionButton,
                    body: body,
                  ),
                ),
              ],
            ),
          );
        }

        // ==========================================
        // 2. TABLET VIEW (600px - 1023px) - Adaptive Spacing
        // ==========================================
        if (deviceType == DeviceType.tablet) {
          return Scaffold(
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
                IconButton(
                  tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () => themeProvider.toggleTheme(!isDark),
                ),
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
              IconButton(
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => themeProvider.toggleTheme(!isDark),
              ),
              ...?actions,
              const SizedBox(width: 8),
            ],
          ),
          floatingActionButton: floatingActionButton,
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentNavIndex,
            onTap: (index) => _handleNavigation(context, index),
            type: BottomNavigationBarType.fixed,
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
            isSelected: currentNavIndex == 0,
            onTap: () => onSelectIndex(0),
          ),
          _SidebarTile(
            icon: Icons.cake_outlined,
            title: 'All Birthdays',
            isSelected: currentNavIndex == 1,
            onTap: () => onSelectIndex(1),
          ),
          _SidebarTile(
            icon: Icons.add_circle_outline,
            title: 'Add Birthday',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
          ),
          _SidebarTile(
            icon: Icons.calendar_month_outlined,
            title: 'Calendar',
            isSelected: currentNavIndex == 2,
            onTap: () => onSelectIndex(2),
          ),
          _SidebarTile(
            icon: Icons.person_outline,
            title: 'Profile & Settings',
            isSelected: currentNavIndex == 3,
            onTap: () => onSelectIndex(3),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        selected: isSelected,
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.12),
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
        onTap: onTap,
      ),
    );
  }
}
