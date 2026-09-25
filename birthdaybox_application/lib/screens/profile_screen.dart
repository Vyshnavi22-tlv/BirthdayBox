import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';

/// User Profile and Application Settings Screen.
/// Demonstrates:
/// - State Management with Provider for instant global theme switching (Lab Experiment 5b)
/// - Interactive Forms, Dialogs & State Toggles (Lab Experiments 4a, 7a & 7b)
/// - Responsive Multi-Column scaling across Mobile, Tablet, and Desktop (Lab Experiments 3a & 3b)
/// - Custom Cards and Reusable UI Components (Lab Experiment 6a)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Personal Information (local state)
  String _userName = 'Vyshnavi Rao';
  String _userEmail = 'vyshnavi.rao@birthdaybox.app';
  String _userPhone = '+91 98765 43210';
  String _userBirthday = '15 August 2003';
  String _userLocation = 'Hyderabad, India (IST)';
  String _userAvatarEmoji = '👑';

  // Notification Preferences
  bool _birthdayReminders = true;
  bool _advanceReminders = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _celebrationSounds = true;

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Dialog to edit user personal information
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);
    final birthdayController = TextEditingController(text: _userBirthday);
    final locationController = TextEditingController(text: _userLocation);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit_note, size: 28),
              SizedBox(width: 8),
              Text('Edit Profile'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: birthdayController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location & Timezone',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  setState(() {
                    _userName = nameController.text.trim();
                    _userEmail = emailController.text.trim();
                    _userPhone = phoneController.text.trim();
                    _userBirthday = birthdayController.text.trim();
                    _userLocation = locationController.text.trim();
                  });
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile information updated successfully!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// Dialog to pick an avatar emoji
  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomCtx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Profile Avatar',
                style: Theme.of(bottomCtx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AppConstants.avatarEmojis.map((emoji) {
                  final isSelected = emoji == _userAvatarEmoji;
                  return InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() => _userAvatarEmoji = emoji);
                      Navigator.pop(bottomCtx);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Theme.of(bottomCtx)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.18)
                            : Theme.of(bottomCtx)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.4),
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(bottomCtx).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Confirmation dialog before logging out
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(dialogCtx);
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Log Out'),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out of BirthdayBox? You will need to sign in again to access your birthdays.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(!isDark),
          ),
          IconButton(
            tooltip: 'Edit Profile',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _showEditProfileDialog,
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

              final heroProfileCard = _buildHeroProfileCard(context);
              final personalInfoCard = _buildPersonalInfoCard(context);
              final themeCard = _buildThemeSettingsCard(context, themeProvider, isDark);
              final notificationCard = _buildNotificationSettingsCard(context);
              final aboutCard = _buildAboutCard(context);
              final logoutButton = _buildLogoutAction(context);

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20.0,
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Hero profile + Personal info + Logout
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                heroProfileCard,
                                const SizedBox(height: 18),
                                personalInfoCard,
                                const SizedBox(height: 18),
                                logoutButton,
                              ],
                            ),
                          ),
                          const SizedBox(width: 22),
                          // Right Column: Theme Settings + Notifications + About
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                themeCard,
                                const SizedBox(height: 18),
                                notificationCard,
                                const SizedBox(height: 18),
                                aboutCard,
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          heroProfileCard,
                          const SizedBox(height: 16),
                          personalInfoCard,
                          const SizedBox(height: 16),
                          themeCard,
                          const SizedBox(height: 16),
                          notificationCard,
                          const SizedBox(height: 16),
                          aboutCard,
                          const SizedBox(height: 20),
                          logoutButton,
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HERO PROFILE CARD (Avatar, Name, Email)
  // ==========================================
  Widget _buildHeroProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          children: [
            // User Avatar with Edit Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        AppTheme.secondaryColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.cardTheme.color ?? colorScheme.surface,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _userAvatarEmoji,
                        style: const TextStyle(fontSize: 44),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Material(
                    color: colorScheme.primary,
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: InkWell(
                      onTap: _showAvatarPicker,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(7.0),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // User Name
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _userName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),

            // User Email
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _userEmail,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // Member Badge
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.celebrationGold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.celebrationGold.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.stars,
                      size: 16,
                      color: AppTheme.celebrationGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BirthdayBox Pro Member',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  // ==========================================
  // 2. PERSONAL INFORMATION CARD
  // ==========================================
  Widget _buildPersonalInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Personal Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Edit Information',
                  onPressed: _showEditProfileDialog,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),

            _buildInfoRow(
              context,
              icon: Icons.person_outline,
              label: 'Full Name',
              value: _userName,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.email_outlined,
              label: 'Email Address',
              value: _userEmail,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              value: _userPhone,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.cake_outlined,
              label: 'Date of Birth',
              value: _userBirthday,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.location_on_outlined,
              label: 'Location & Timezone',
              value: _userLocation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. THEME SETTINGS CARD (Uses ThemeProvider)
  // ==========================================
  Widget _buildThemeSettingsCard(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.palette_outlined,
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
                        'Theme Settings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Managed by ThemeProvider • Updates instantly',
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
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Dark Mode SwitchListTile
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                color: isDark ? colorScheme.primary : AppTheme.celebrationGold,
              ),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isDark
                    ? 'Dark theme enabled for low-light comfort'
                    : 'Light theme enabled for daytime visibility',
              ),
              value: isDark,
              onChanged: (val) {
                // Toggles globally via ThemeProvider
                themeProvider.toggleTheme(val);
              },
            ),
            const SizedBox(height: 10),

            // Segmented Quick Selection (Light vs Dark)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !isDark
                          ? colorScheme.primary.withValues(alpha: 0.12)
                          : null,
                      side: BorderSide(
                        color: !isDark ? colorScheme.primary : colorScheme.outline,
                        width: !isDark ? 2 : 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    ),
                    onPressed: () => themeProvider.setDarkMode(false),
                    icon: const Icon(Icons.wb_sunny_outlined, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Light Mode'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark
                          ? colorScheme.primary.withValues(alpha: 0.12)
                          : null,
                      side: BorderSide(
                        color: isDark ? colorScheme.primary : colorScheme.outline,
                        width: isDark ? 2 : 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    ),
                    onPressed: () => themeProvider.setDarkMode(true),
                    icon: const Icon(Icons.nightlight_round, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Dark Mode'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 4. NOTIFICATION SETTINGS UI CARD
  // ==========================================
  Widget _buildNotificationSettingsCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
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
                        'Notification Settings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Customize alert preferences & schedules',
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
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Birthday Reminders
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.cake_outlined, color: colorScheme.primary),
              title: const Text(
                'Birthday Reminders',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Receive notifications on the day of celebrations'),
              value: _birthdayReminders,
              onChanged: (val) => setState(() => _birthdayReminders = val),
            ),

            // Advance Notice
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                Icons.notification_important_outlined,
                color: colorScheme.primary,
              ),
              title: const Text(
                'Advance Notification',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Remind me 3 days ahead to prepare greetings or gifts'),
              value: _advanceReminders,
              onChanged: (val) => setState(() => _advanceReminders = val),
            ),

            // Daily Alert Time Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.schedule_outlined, color: colorScheme.primary),
              title: const Text(
                'Reminder Time',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Daily notification time: ${_formatTimeOfDay(_reminderTime)}',
              ),
              trailing: ActionChip(
                avatar: const Icon(Icons.access_time, size: 16),
                label: Text(_formatTimeOfDay(_reminderTime)),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime,
                  );
                  if (picked != null) {
                    setState(() => _reminderTime = picked);
                  }
                },
              ),
            ),

            // Celebration Sound
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.music_note_outlined, color: colorScheme.primary),
              title: const Text(
                'Celebration Sounds',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Play celebratory chime with notifications'),
              value: _celebrationSounds,
              onChanged: (val) => setState(() => _celebrationSounds = val),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 5. ABOUT BIRTHDAYBOX CARD
  // ==========================================
  Widget _buildAboutCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'About BirthdayBox',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // App branding row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🎂', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'v${AppConstants.appVersion}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        AppConstants.appTagline,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Never miss a special day again. BirthdayBox is an intuitive, celebratory birthday tracker with milestone countdowns, interactive calendars, and relationship-driven categorization.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Features Overview
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTagChip(context, '🎂 Countdowns & Milestones'),
                _buildTagChip(context, '📅 Interactive Calendar'),
                _buildTagChip(context, '👥 Contact Categories'),
                _buildTagChip(context, '🌓 Responsive Dark Mode'),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Info Links
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Privacy & Terms'),
                          content: const Text(
                            'BirthdayBox operates 100% locally on your device for this lab release. Your birthday entries and personal details are never uploaded or shared with any third party.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.privacy_tip_outlined, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Privacy'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showLicensePage(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: AppConstants.appVersion,
                      );
                    },
                    icon: const Icon(Icons.description_outlined, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Licenses'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==========================================
  // 6. LOGOUT BUTTON
  // ==========================================
  Widget _buildLogoutAction(BuildContext context) {
    return CustomButton(
      onPressed: _confirmLogout,
      text: 'Log Out of BirthdayBox',
      icon: Icons.logout,
      isOutlined: true,
    );
  }
}
