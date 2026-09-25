import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthday_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/birthday_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';

/// Screen displaying monthly birthday calendar view with date selection,
/// birthday highlights, and navigation.
/// Demonstrates:
/// - Custom GridView Calendar composition (Lab Experiment 2b)
/// - Date calculations & State Management with Provider (Lab Experiment 5b)
/// - Interactive Selection & Navigation (Lab Experiments 4a & 5a)
/// - Responsive Multi-Column scaling (Lab Experiments 3a & 3b)
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
        1,
      );
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _displayedMonth = DateTime(now.year, now.month, 1);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  void _selectDay(int day) {
    setState(() {
      _selectedDate = DateTime(_displayedMonth.year, _displayedMonth.month, day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final allBirthdays = birthdayProvider.birthdays;

    // Filter birthdays occurring in the displayed month
    final monthBirthdays = allBirthdays
        .where((b) => b.dateOfBirth.month == _displayedMonth.month)
        .toList();

    // Filter birthdays occurring on the selected date
    final selectedDayBirthdays = allBirthdays
        .where((b) =>
            b.dateOfBirth.month == _selectedDate.month &&
            b.dateOfBirth.day == _selectedDate.day)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_outlined),
            tooltip: 'Go to Today',
            onPressed: _goToToday,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Birthday',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ResponsiveLayout.builder(
            builder: (context, constraints, deviceType) {
              final isWide = constraints.maxWidth >= 840;
              final horizontalPadding = switch (deviceType) {
                DeviceType.mobile => 16.0,
                DeviceType.tablet => 24.0,
                DeviceType.desktop => 32.0,
              };

              final calendarCard = _buildCalendarCard(
                context,
                allBirthdays,
                monthBirthdays,
              );

              final selectedDatePanel = _buildSelectedDatePanel(
                context,
                selectedDayBirthdays,
              );

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16.0,
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: calendarCard),
                          const SizedBox(width: 20),
                          Expanded(flex: 5, child: selectedDatePanel),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          calendarCard,
                          const SizedBox(height: 18),
                          selectedDatePanel,
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Calendar card containing Month Navigator, Weekday Headers, and Day Grid
  Widget _buildCalendarCard(
    BuildContext context,
    List<Birthday> allBirthdays,
    List<Birthday> monthBirthdays,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();

    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    // Weekday index (Sun = 0, Mon = 1, ..., Sat = 6)
    final firstWeekdayOffset = _displayedMonth.weekday % 7;
    final totalCells = firstWeekdayOffset + daysInMonth;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month Navigation Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous Month',
                  onPressed: _previousMonth,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.celebrationGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '🎉 ${monthBirthdays.length} ${monthBirthdays.length == 1 ? 'birthday' : 'birthdays'} this month',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next Month',
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weekday Headers (Sun - Sat)
            Row(
              children: _weekdays.map((day) {
                final isWeekend = day == 'Sun' || day == 'Sat';
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isWeekend
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Calendar Day Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.05,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                if (index < firstWeekdayOffset) {
                  // Blank leading cell before first day of month
                  return const SizedBox.shrink();
                }

                final day = index - firstWeekdayOffset + 1;
                final isToday = day == now.day &&
                    _displayedMonth.month == now.month &&
                    _displayedMonth.year == now.year;

                final isSelected = day == _selectedDate.day &&
                    _displayedMonth.month == _selectedDate.month &&
                    _displayedMonth.year == _selectedDate.year;

                // Check for birthdays on this day
                final dayBirthdays = allBirthdays
                    .where((b) =>
                        b.dateOfBirth.month == _displayedMonth.month &&
                        b.dateOfBirth.day == day)
                    .toList();

                final hasBirthdays = dayBirthdays.isNotEmpty;

                return _buildDayCell(
                  context,
                  day: day,
                  isToday: isToday,
                  isSelected: isSelected,
                  hasBirthdays: hasBirthdays,
                  dayBirthdays: dayBirthdays,
                  onTap: () => _selectDay(day),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Individual Day Cell widget with highlights for birthdays, today, and selection
  Widget _buildDayCell(
    BuildContext context, {
    required int day,
    required bool isToday,
    required bool isSelected,
    required bool hasBirthdays,
    required List<Birthday> dayBirthdays,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color? backgroundColor;
    Border? border;

    if (isSelected) {
      backgroundColor = colorScheme.primary.withValues(alpha: 0.18);
      border = Border.all(color: colorScheme.primary, width: 2);
    } else if (hasBirthdays) {
      backgroundColor = AppTheme.celebrationGold.withValues(alpha: 0.16);
      border = Border.all(
        color: AppTheme.celebrationGold.withValues(alpha: 0.5),
        width: 1.5,
      );
    } else if (isToday) {
      backgroundColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);
      border = Border.all(
        color: colorScheme.primary.withValues(alpha: 0.4),
        width: 1,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: border,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day Number
            Text(
              '$day',
              style: TextStyle(
                fontWeight: isSelected || hasBirthdays || isToday
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? colorScheme.primary
                    : (isToday ? colorScheme.primary : colorScheme.onSurface),
                fontSize: 13,
              ),
            ),

            // Birthday Highlight Indicator
            if (hasBirthdays) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: dayBirthdays.take(3).map((b) {
                  final dotColor = AppTheme.getRelationshipColor(b.relationship);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ] else if (isToday) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Selected Date Details Panel displaying birthdays on the chosen date
  Widget _buildSelectedDatePanel(
    BuildContext context,
    List<Birthday> selectedDayBirthdays,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedSelected =
        '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selected Date Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Birthdays on $formattedSelected',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        selectedDayBirthdays.isEmpty
                            ? 'No celebrations on this day'
                            : '${selectedDayBirthdays.length} ${selectedDayBirthdays.length == 1 ? 'celebration' : 'celebrations'} found',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Content: List of BirthdayCards or Empty State
            if (selectedDayBirthdays.isNotEmpty) ...[
              ...selectedDayBirthdays.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: BirthdayCard(
                      birthday: b,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.birthdayDetails,
                        arguments: b,
                      ),
                    ),
                  )),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      size: 44,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No birthdays on this day',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'None of your contacts were born on this date.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.addBirthday),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Birthday'),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),

            // Quick Add Action
            CustomButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.addBirthday),
              text: 'Add New Birthday',
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
