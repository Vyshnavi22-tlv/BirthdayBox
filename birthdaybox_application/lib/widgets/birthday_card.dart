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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar Emoji / Profile Icon
              Container(
                width: 52,
                height: 52,
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
                  style: const TextStyle(fontSize: 26),
                ),
              ),

              const SizedBox(width: 14),

              // Person Details (Name, Relationship, Birthday Date)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      birthday.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Relationship Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: relationshipColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: relationshipColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            birthday.relationship,
                            style: TextStyle(
                              color: relationshipColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Birthday date & age
                        Flexible(
                          child: Text(
                            '${birthday.formattedDate} • Age ${birthday.age}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Countdown / Status Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      countdownText,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onDelete != null || onEdit != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onEdit != null)
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Edit',
                            onPressed: onEdit,
                          ),
                        if (onDelete != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Delete',
                            onPressed: onDelete,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
