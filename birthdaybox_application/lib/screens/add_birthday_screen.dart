import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthday_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

/// Screen for adding a new birthday to BirthdayBox.
/// Demonstrates:
/// - Form & `GlobalKey<FormState>` (Lab Experiment 7a)
/// - Custom Validation & Error Handling (Lab Experiment 7b)
/// - showDatePicker integration & date calculations (Lab Experiment 1b)
/// - DropdownButtonFormField & input decoration (Lab Experiment 2a)
/// - State Management via Provider with local setState UI state (Lab Experiment 5a & 5b)
/// - Responsive design across Mobile, Tablet, and Desktop (Lab Experiments 3a & 3b)
class AddBirthdayScreen extends StatefulWidget {
  final Birthday? existingBirthday; // Optional for edit mode

  const AddBirthdayScreen({
    super.key,
    this.existingBirthday,
  });

  @override
  State<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends State<AddBirthdayScreen> {
  // Global form key for form validation (Lab 7a)
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;

  // Local form/UI state (managed via setState)
  String _selectedEmoji = '🎂';
  DateTime? _selectedDate;
  String? _selectedRelationship;

  @override
  void initState() {
    super.initState();
    final b = widget.existingBirthday;
    _nameController = TextEditingController(text: b?.name ?? '');
    _phoneController = TextEditingController(text: b?.phone ?? '');
    _notesController = TextEditingController(text: b?.notes ?? '');

    if (b != null) {
      _selectedDate = b.dateOfBirth;
      _selectedEmoji = b.imagePath.isNotEmpty ? b.imagePath : '🎂';
      _selectedRelationship = b.relationship;
      _dateController = TextEditingController(text: b.formattedFullDate);
    } else {
      _dateController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ==========================================
  // FORM VALIDATORS (Lab Experiment 7b)
  // ==========================================

  /// Validates person's name
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates date of birth
  String? _validateDate(String? value) {
    if (_selectedDate == null || value == null || value.trim().isEmpty) {
      return 'Date of Birth is required';
    }
    return null;
  }

  /// Validates relationship dropdown
  String? _validateRelationship(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Relationship is required';
    }
    return null;
  }

  /// Validates phone number: optional, but must be valid format if entered
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // ==========================================
  // DATE PICKER INTERACTION
  // ==========================================

  /// Displays standard Flutter DatePicker dialog
  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = _selectedDate ?? DateTime(2000, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select Date of Birth',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day} ${_monthName(picked.month)} ${picked.year}';
      });
      // Re-validate date field to clear previous errors
      _formKey.currentState?.validate();
    }
  }

  static String _monthName(int month) {
    const months = [
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
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  // ==========================================
  // SUBMISSION & PROVIDER INTEGRATION
  // ==========================================

  void _saveBirthday() {
    // 1. Trigger form validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final birthdayProvider = Provider.of<BirthdayProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final nav = Navigator.of(context);

    // 2. Create or update Birthday object
    final birthday = Birthday(
      id: widget.existingBirthday?.id ??
          'bday-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      dateOfBirth: _selectedDate!,
      relationship: _selectedRelationship!,
      phone: _phoneController.text.trim(),
      notes: _notesController.text.trim(),
      imagePath: _selectedEmoji,
    );

    // 3. Update state via BirthdayProvider
    if (widget.existingBirthday != null) {
      birthdayProvider.updateBirthday(birthday);
    } else {
      birthdayProvider.addBirthday(birthday);
    }

    // 4. Show success feedback
    messenger.showSnackBar(
      SnackBar(
        content: Text('🎉 ${birthday.name}’s birthday saved successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 3),
      ),
    );

    // 5. Navigate back to previous screen
    if (nav.canPop()) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.existingBirthday != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Birthday' : 'Add Birthday'),
      ),
      body: Center(
        child: ConstrainedBox(
          // Constrain width for Tablet & Desktop responsiveness
          constraints: const BoxConstraints(maxWidth: 620),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form Header
                      Text(
                        isEditing ? 'Update Celebration' : 'New Celebration 🎉',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Keep memories alive by saving your loved ones’ special day.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // 1. Profile Image / Icon Area
                      _AvatarPicker(
                        selectedEmoji: _selectedEmoji,
                        onEmojiSelected: (emoji) => setState(() => _selectedEmoji = emoji),
                        relationshipColor: _selectedRelationship != null
                            ? AppTheme.getRelationshipColor(_selectedRelationship!)
                            : colorScheme.primary,
                      ),
                      const SizedBox(height: 24),

                      // 2. Name Field (Required)
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Full Name *',
                        hintText: 'e.g. Priya Sharma',
                        prefixIcon: const Icon(Icons.person_outline),
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),

                      // 3. Date of Birth Field (Required, with DatePicker)
                      CustomTextField(
                        controller: _dateController,
                        labelText: 'Date of Birth *',
                        hintText: 'Select date of birth',
                        readOnly: true,
                        prefixIcon: const Icon(Icons.cake_outlined),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month_outlined),
                          tooltip: 'Choose Date',
                          onPressed: () => _pickDate(context),
                        ),
                        onTap: () => _pickDate(context),
                        validator: _validateDate,
                      ),
                      const SizedBox(height: 16),

                      // 4. Relationship Dropdown (Required)
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRelationship,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Relationship *',
                          prefixIcon: Icon(Icons.people_outline),
                        ),
                        hint: const Text(
                          'Select relationship category',
                          overflow: TextOverflow.ellipsis,
                        ),
                        validator: _validateRelationship,
                        onChanged: (val) {
                          setState(() => _selectedRelationship = val);
                        },
                        items: AppConstants.relationshipCategories.map((category) {
                          final color = AppTheme.getRelationshipColor(category);
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(category),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // 5. Phone Number Field (Optional, Validated if entered)
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Phone Number (Optional)',
                        hintText: 'e.g. 9876543210',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                        textInputAction: TextInputAction.next,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 16),

                      // 6. Notes Field (Optional, Multiline)
                      CustomTextField(
                        controller: _notesController,
                        labelText: 'Notes & Gift Ideas (Optional)',
                        hintText: 'e.g. Loves blueberry cheesecake & fantasy books',
                        prefixIcon: const Icon(Icons.notes_outlined),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 28),

                      // 7. Save Birthday Button
                      CustomButton(
                        onPressed: _saveBirthday,
                        text: isEditing ? 'Update Birthday' : 'Save Birthday',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar & Emoji Icon Picker Component
class _AvatarPicker extends StatelessWidget {
  final String selectedEmoji;
  final ValueChanged<String> onEmojiSelected;
  final Color relationshipColor;

  const _AvatarPicker({
    required this.selectedEmoji,
    required this.onEmojiSelected,
    required this.relationshipColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Large Selected Avatar Preview
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: relationshipColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: relationshipColor.withValues(alpha: 0.4),
              width: 2.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            selectedEmoji,
            style: const TextStyle(fontSize: 44),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Choose an Avatar Icon',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Quick Emoji Selector Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: AppConstants.avatarEmojis.map((emoji) {
            final isSelected = emoji == selectedEmoji;
            return InkWell(
              onTap: () => onEmojiSelected(emoji),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.2)
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: isSelected ? 22 : 18),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
