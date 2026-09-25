import 'package:flutter/material.dart';
import '../models/birthday_model.dart';
import '../theme/app_theme.dart';

/// BirthdayCard displays individual birthday information in list and grid views.
/// Demonstrates:
/// - Custom Widgets (Lab Experiment 6a)
/// - Row, Column & Stack composition (Lab Experiment 2b)
/// - Themes & Dynamic Category Colors (Lab Experiment 6b)
class BirthdayCard extends StatelessWidget {
  final BirthdayModel birthday;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BirthdayCard({
    super.key,
    required this.birthday,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final relationshipColor = AppTheme.getRelationshipColor(birthday.relationship);

    // Determine countdown badge text and styling
    final days = birthday.daysUntilNextBirthday;
    final isToday = birthday.isToday;

    String countdownText;
    Color badgeColor;
    if (isToday) {
      countdownText = 'Today! 🎂';
      badgeColor = AppTheme.celebrationGold;
    } else if (days == 1) {
      countdownText = 'Tomorrow';
      badgeColor = colorScheme.secondary;
    } else {
      countdownText = 'In $days days';
      badgeColor = days <= 30 ? colorScheme.primary : colorScheme.onSurfaceVariant;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            children: [
              // Avatar Emoji / Profile Icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: relationshipColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: relationshipColor.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  birthday.avatarEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),

              const SizedBox(width: 10),

              // Person Details (Name, Date/Age, Relationship Tag)
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        birthday.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${birthday.formattedDate} • Age ${birthday.age}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // Relationship Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: relationshipColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: relationshipColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          birthday.relationship,
                          style: TextStyle(
                            color: relationshipColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Countdown / Status Badge & Actions
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        countdownText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (onDelete != null || onEdit != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Edit',
                              onPressed: onEdit,
                            ),
                          if (onDelete != null) ...[
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Delete',
                              onPressed: onDelete,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
