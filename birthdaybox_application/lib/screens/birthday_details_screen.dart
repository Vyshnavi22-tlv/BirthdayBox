import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthday_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';
import 'add_birthday_screen.dart';

/// Screen displaying in-depth details, celebration countdown, and actions for a birthday.
/// Demonstrates:
/// - Stack & Positioned composition (Lab Experiment 2b)
/// - Custom Dialogs & Modal Confirmation (Lab Experiment 7b)
/// - State Management via Provider for updates and deletion (Lab Experiment 5b)
/// - Responsive card layouts across Mobile, Tablet, and Desktop (Lab Experiments 3a & 3b)
class BirthdayDetailsScreen extends StatelessWidget {
  final Birthday? birthday;

  const BirthdayDetailsScreen({
    super.key,
    this.birthday,
  });

  static const List<String> _months = [
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

  static String _formatDate(DateTime dt) {
    final monthName = _months[dt.month - 1];
    return '${dt.day} $monthName ${dt.year}';
  }

  void _openEdit(BuildContext context, Birthday b) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddBirthdayScreen(existingBirthday: b),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Birthday b) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context, listen: false);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Birthday'),
        content: Text(
          'Are you sure you want to delete ${b.name}’s birthday? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () {
              birthdayProvider.deleteBirthday(b.id);
              Navigator.pop(ctx); // Close dialog
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // Pop details screen
              }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final birthdayProvider = Provider.of<BirthdayProvider>(context);

    // Extract birthday from direct parameter or ModalRoute arguments
    final routeBirthday = ModalRoute.of(context)?.settings.arguments as Birthday?;
    final target = birthday ?? routeBirthday;

    // Check if birthday exists in provider for live updates
    final currentBirthday = target != null ? birthdayProvider.findById(target.id) ?? target : null;

    if (currentBirthday == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Birthday Details')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('Birthday Not Found', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'The requested birthday could not be located or has been deleted.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoutes.birthdays);
                    }
                  },
                  child: const Text('Back to Birthdays'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final relationshipColor = AppTheme.getRelationshipColor(currentBirthday.relationship);
    final isToday = currentBirthday.isToday;
    final days = currentBirthday.daysRemaining;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentBirthday.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Birthday',
            onPressed: () => _openEdit(context, currentBirthday),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Birthday',
            onPressed: () => _confirmDelete(context, currentBirthday),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Visually Impressive Birthday Status Section using Stack
                _buildHeroStatusSection(
                  context,
                  currentBirthday,
                  relationshipColor,
                  isToday,
                  days,
                ),
                const SizedBox(height: 20),

                // 2. Birthday Milestone & Timing Cards (Responsive layout)
                ResponsiveLayout.builder(
                  builder: (context, constraints, deviceType) {
                    final isMobile = deviceType == DeviceType.mobile;
                    final dobCard = _buildInfoTile(
                      context,
                      icon: Icons.cake_outlined,
                      iconColor: relationshipColor,
                      label: 'Date of Birth',
                      value: currentBirthday.formattedFullDate,
                      subValue: 'Born in ${currentBirthday.dateOfBirth.year}',
                    );
                    final nextBdayCard = _buildInfoTile(
                      context,
                      icon: Icons.event_available_outlined,
                      iconColor: AppTheme.celebrationGold,
                      label: 'Next Birthday',
                      value: _formatDate(currentBirthday.nextBirthday),
                      subValue: isToday
                          ? '🎉 Today!'
                          : (days == 1 ? 'Tomorrow!' : 'In $days days'),
                    );

                    if (isMobile) {
                      return Column(
                        children: [
                          dobCard,
                          const SizedBox(height: 12),
                          nextBdayCard,
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(child: dobCard),
                          const SizedBox(width: 14),
                          Expanded(child: nextBdayCard),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 14),

                // 3. Phone Number Card
                _buildSectionCard(
                  context,
                  icon: Icons.phone_outlined,
                  iconColor: colorScheme.primary,
                  title: 'Phone Number',
                  content: currentBirthday.phone.isNotEmpty
                      ? Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentBirthday.phone,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton.filledTonal(
                              icon: const Icon(Icons.phone, size: 20),
                              tooltip: 'Call',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Calling ${currentBirthday.name}...'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Text(
                          'No phone number added',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                ),
                const SizedBox(height: 14),

                // 4. Notes & Gift Ideas Card
                _buildSectionCard(
                  context,
                  icon: Icons.card_giftcard_outlined,
                  iconColor: Colors.deepOrangeAccent,
                  title: 'Notes & Gift Ideas',
                  content: currentBirthday.notes.isNotEmpty
                      ? Text(
                          currentBirthday.notes,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.4,
                          ),
                        )
                      : Text(
                          'No notes or gift ideas added yet. Tap edit to jot down gift ideas or memories.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                ),
                const SizedBox(height: 28),

                // 5. Action Buttons: [ Edit Birthday ] & [ Delete Birthday ]
                ResponsiveLayout.builder(
                  builder: (context, constraints, deviceType) {
                    final editButton = CustomButton(
                      onPressed: () => _openEdit(context, currentBirthday),
                      text: 'Edit Birthday',
                      icon: Icons.edit_outlined,
                    );

                    final deleteButton = OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _confirmDelete(context, currentBirthday),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text(
                        'Delete Birthday',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );

                    if (deviceType == DeviceType.mobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          editButton,
                          const SizedBox(height: 12),
                          deleteButton,
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(child: editButton),
                          const SizedBox(width: 14),
                          Expanded(child: deleteButton),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Visually impressive hero birthday status section using Stack composition.
  Widget _buildHeroStatusSection(
    BuildContext context,
    Birthday birthday,
    Color relationshipColor,
    bool isToday,
    int days,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            relationshipColor.withValues(alpha: 0.88),
            colorScheme.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: relationshipColor.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background decorative layer 1: Large decorative watermark cake
          Positioned(
            right: -25,
            top: -20,
            child: Opacity(
              opacity: 0.12,
              child: const Icon(
                Icons.cake,
                size: 150,
                color: Colors.white,
              ),
            ),
          ),

          // Background decorative layer 2: Celebratory floating sparkles & balloons
          Positioned(
            left: 20,
            bottom: 15,
            child: Opacity(
              opacity: 0.25,
              child: const Text('✨', style: TextStyle(fontSize: 28)),
            ),
          ),
          Positioned(
            right: 65,
            bottom: 20,
            child: Opacity(
              opacity: 0.35,
              child: const Text('🎈', style: TextStyle(fontSize: 24)),
            ),
          ),

          // Corner Milestone Badge: Top-right positioned tag
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Age ${birthday.age}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Foreground Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar / Icon Area
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    birthday.avatarEmoji,
                    style: const TextStyle(fontSize: 46),
                  ),
                ),
                const SizedBox(height: 14),

                // Name
                Text(
                  birthday.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                // Relationship Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    birthday.relationship,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Countdown Status Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppTheme.celebrationGold
                        : Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isToday
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isToday
                            ? Icons.celebration
                            : (days == 1 ? Icons.alarm : Icons.hourglass_top),
                        color: isToday ? Colors.black87 : Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isToday
                              ? '🎉 Today is the Birthday!'
                              : (days == 1
                                  ? '🎂 Tomorrow is the big day!'
                                  : '⏳ In $days days (Age ${birthday.age + 1})'),
                          style: TextStyle(
                            color: isToday ? Colors.black87 : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Informational card tile for Date of Birth and Next Birthday.
  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String subValue,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subValue,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
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

  /// Generic section card for Phone, Notes, and additional information.
  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}
