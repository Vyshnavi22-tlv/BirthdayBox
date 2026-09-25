import 'package:flutter/material.dart';
import '../models/birthday_model.dart';
import '../theme/app_theme.dart';

/// CountdownCard highlights the closest upcoming birthday.
/// Demonstrates:
/// - Custom Widgets (Lab Experiment 6a)
/// - Stack, Row & Column composition (Lab Experiment 2b)
/// - Festive Birthday Aesthetics & Theming (Lab Experiment 6b)
class CountdownCard extends StatelessWidget {
  final BirthdayModel birthday;
  final VoidCallback? onTap;

  const CountdownCard({
    super.key,
    required this.birthday,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isToday = birthday.isToday;
    final days = birthday.daysUntilNextBirthday;

    // Calculate approximate hours remaining until midnight of next birthday
    final now = DateTime.now();
    final nextBday = birthday.nextBirthday;
    final totalHours = nextBday.difference(now).inHours;
    final remainingHours = totalHours % 24;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.7),
                colorScheme.secondaryContainer.withValues(alpha: 0.4),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              // Subtle background celebratory watermark
              Positioned(
                right: -10,
                bottom: -15,
                child: Text(
                  '🎉',
                  style: TextStyle(
                    fontSize: 84,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),

              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header badge
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppTheme.celebrationGold.withValues(alpha: 0.2)
                                  : colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isToday
                                    ? AppTheme.celebrationGold
                                    : colorScheme.primary,
                                width: 1,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(isToday ? '🎂 ' : '⏳ '),
                                  Text(
                                    isToday ? 'CELEBRATING TODAY!' : 'NEXT UPCOMING BIRTHDAY',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isToday
                                          ? AppTheme.celebrationGold
                                          : colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        birthday.avatarEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Person Name & Relationship
                  Text(
                    birthday.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${birthday.relationship} • ${birthday.formattedDate}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const Divider(height: 28),

                  // Countdown digits display (Days & Hours)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Days unit
                          _CountdownUnit(
                            value: isToday ? '0' : '$days',
                            label: days == 1 ? 'DAY' : 'DAYS',
                            highlightColor: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          // Hours unit
                          _CountdownUnit(
                            value: isToday ? '0' : '$remainingHours',
                            label: 'HOURS',
                            highlightColor: colorScheme.secondary,
                          ),
                        ],
                      ),
                      // Subtitle status
                      Text(
                        isToday
                            ? 'Wish them a Happy Birthday today! 🥳'
                            : days <= 7
                                ? 'Coming up very soon! Prepare gift 🎁'
                                : 'Marked on your calendar 📅',
                        textAlign: TextAlign.end,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  final String value;
  final String label;
  final Color highlightColor;

  const _CountdownUnit({
    required this.value,
    required this.label,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: highlightColor,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
