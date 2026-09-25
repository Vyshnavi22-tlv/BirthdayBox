import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthday_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/birthday_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';
import 'add_birthday_screen.dart';

/// Sort options for organizing birthdays.
enum BirthdaySortOption {
  upcoming('Upcoming Birthday', Icons.hourglass_top_rounded),
  name('Name (A-Z)', Icons.sort_by_alpha_rounded),
  date('Date of Birth', Icons.calendar_month_rounded);

  final String label;
  final IconData icon;
  const BirthdaySortOption(this.label, this.icon);
}

/// Screen displaying all birthdays with search, category filtering, and sorting.
/// Demonstrates:
/// - Custom Widgets & `BirthdayCard` (Lab Experiment 6a)
/// - Responsive UI across Mobile, Tablet, and Desktop (Lab Experiments 3a & 3b)
/// - Local UI State Management with `StatefulWidget` (Lab Experiment 5a)
/// - Global State Management with Provider (Lab Experiment 5b)
class BirthdaysScreen extends StatefulWidget {
  const BirthdaysScreen({super.key});

  @override
  State<BirthdaysScreen> createState() => _BirthdaysScreenState();
}

class _BirthdaysScreenState extends State<BirthdaysScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  BirthdaySortOption _sortBy = BirthdaySortOption.upcoming;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters and sorts birthdays based on current search, category, and sort option.
  List<Birthday> _getFilteredAndSortedBirthdays(List<Birthday> source) {
    var list = source;

    // 1. Filter by search query (case-insensitive name match)
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((b) => b.name.toLowerCase().contains(query)).toList();
    }

    // 2. Filter by relationship category
    if (_selectedCategory != 'All') {
      list = list
          .where((b) => b.relationship.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // 3. Sort
    list = List<Birthday>.from(list);
    switch (_sortBy) {
      case BirthdaySortOption.upcoming:
        list.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
        break;
      case BirthdaySortOption.name:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case BirthdaySortOption.date:
        list.sort((a, b) {
          final cmpMonth = a.dateOfBirth.month.compareTo(b.dateOfBirth.month);
          if (cmpMonth != 0) return cmpMonth;
          return a.dateOfBirth.day.compareTo(b.dateOfBirth.day);
        });
        break;
    }

    return list;
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _sortBy = BirthdaySortOption.upcoming;
    });
  }

  void _openEditBirthday(BuildContext context, Birthday b) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddBirthdayScreen(existingBirthday: b),
      ),
    );
  }

  void _confirmDeleteBirthday(BuildContext context, Birthday b) {
    final provider = Provider.of<BirthdayProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Birthday'),
        content: Text('Are you sure you want to delete ${b.name}’s birthday?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              provider.deleteBirthday(b.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${b.name}’s birthday deleted'),
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

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final allBirthdays = birthdayProvider.birthdays;
    final filteredBirthdays = _getFilteredAndSortedBirthdays(allBirthdays);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthdays List'),
        actions: [
          IconButton(
            tooltip: 'Add Birthday',
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Birthday',
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: allBirthdays.isEmpty
              ? _buildGlobalEmptyState(context, theme)
              : ResponsiveLayout.builder(
                  builder: (context, constraints, deviceType) {
                    final horizontalPadding = switch (deviceType) {
                      DeviceType.mobile => 16.0,
                      DeviceType.tablet => 24.0,
                      DeviceType.desktop => 32.0,
                    };

                    final gridColumns = switch (deviceType) {
                      DeviceType.mobile => 1,
                      DeviceType.tablet => 2,
                      DeviceType.desktop => constraints.maxWidth >= 1400 ? 4 : 3,
                    };

                    return ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),
                      children: [
                        // 1. Search Bar
                        TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search birthdays by name...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    tooltip: 'Clear search',
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Filter by Relationship Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('All', null, allBirthdays.length),
                              const SizedBox(width: 8),
                              ...AppConstants.relationshipCategories.map((category) {
                                final count = allBirthdays
                                    .where((b) =>
                                        b.relationship.toLowerCase() == category.toLowerCase())
                                    .length;
                                final color = AppTheme.getRelationshipColor(category);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: _buildFilterChip(category, color, count),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 3. Status Bar & Sort Selector
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Text(
                              'All Birthdays (${filteredBirthdays.length})',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<BirthdaySortOption>(
                              initialValue: _sortBy,
                              tooltip: 'Sort Options',
                              onSelected: (option) => setState(() => _sortBy = option),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: BirthdaySortOption.upcoming,
                                  child: Text('Upcoming Birthday'),
                                ),
                                const PopupMenuItem(
                                  value: BirthdaySortOption.name,
                                  child: Text('Name (A-Z)'),
                                ),
                                const PopupMenuItem(
                                  value: BirthdaySortOption.date,
                                  child: Text('Date of Birth'),
                                ),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colorScheme.outline.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_sortBy.icon, size: 15, color: colorScheme.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      _sortBy.label,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_drop_down,
                                        size: 18, color: colorScheme.primary),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // 4. Content Area: Empty Filter State, Single-Column List, or Multi-Column Grid
                        if (filteredBirthdays.isEmpty)
                          _buildFilterEmptyState(context, colorScheme, theme)
                        else if (gridColumns == 1)
                          // Mobile: Single-column list
                          ...filteredBirthdays.map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: BirthdayCard(
                                  birthday: b,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.birthdayDetails,
                                    arguments: b,
                                  ),
                                  onEdit: () => _openEditBirthday(context, b),
                                  onDelete: () => _confirmDeleteBirthday(context, b),
                                ),
                              ))
                        else
                          // Tablet & Desktop: Multi-column grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridColumns,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              mainAxisExtent: 115,
                            ),
                            itemCount: filteredBirthdays.length,
                            itemBuilder: (context, index) {
                              final b = filteredBirthdays[index];
                              return BirthdayCard(
                                birthday: b,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.birthdayDetails,
                                  arguments: b,
                                ),
                                onEdit: () => _openEditBirthday(context, b),
                                onDelete: () => _confirmDeleteBirthday(context, b),
                              );
                            },
                          ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  /// Builds a relationship filter chip with color indicator and count badge.
  Widget _buildFilterChip(String category, Color? categoryColor, int count) {
    final isSelected = _selectedCategory.toLowerCase() == category.toLowerCase();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chipColor = categoryColor ?? colorScheme.primary;

    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (categoryColor != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : categoryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(category),
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.white.withValues(alpha: 0.9) : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      onSelected: (_) {
        setState(() {
          _selectedCategory = category;
        });
      },
      selectedColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? chipColor : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  /// Global empty state when no birthdays exist in BirthdayProvider.
  Widget _buildGlobalEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎂', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No birthdays added yet!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Never miss a celebration. Add your first birthday to get started!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: CustomButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                text: 'Add Birthday',
                icon: Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state when search or filter returns zero matches.
  Widget _buildFilterEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              'No birthdays found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No matching results for "$_searchQuery"'
                  : 'No birthdays in the $_selectedCategory category',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Search & Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
