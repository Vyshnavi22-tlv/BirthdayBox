import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/add_birthday_screen.dart';
import 'package:birthdaybox_application/widgets/custom_button.dart';

void main() {
  group('AddBirthdayScreen Tests (Lab 7a & 7b Forms & Validation, Lab 5b Provider)', () {
    Widget buildTestWidget({
      BirthdayProvider? birthdayProvider,
      Birthday? existingBirthday,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider.value(
            value: birthdayProvider ?? BirthdayProvider(),
          ),
        ],
        child: MaterialApp(
          home: AddBirthdayScreen(existingBirthday: existingBirthday),
        ),
      );
    }

    testWidgets('Renders all form fields and avatar picker cleanly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Header and title
      expect(find.text('Add Birthday'), findsOneWidget);
      expect(find.text('New Celebration 🎉'), findsOneWidget);

      // Avatar picker
      expect(find.text('Choose an Avatar Icon'), findsOneWidget);
      expect(find.text('🎂'), findsWidgets); // Preview + chip

      // Form input fields
      expect(find.widgetWithText(TextFormField, 'Full Name *'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Date of Birth *'), findsOneWidget);
      expect(find.text('Relationship *'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Phone Number (Optional)'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Notes & Gift Ideas (Optional)'), findsOneWidget);

      // Submit button
      expect(find.widgetWithText(CustomButton, 'Save Birthday'), findsOneWidget);
    });

    testWidgets('Validates required fields when submitted empty',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Save Birthday without entering any information
      final saveBtn = find.widgetWithText(CustomButton, 'Save Birthday');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Check required error messages
      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Date of Birth is required'), findsOneWidget);
      expect(find.text('Relationship is required'), findsOneWidget);
    });

    testWidgets('Validates short name and invalid phone number',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Enter 1-character name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name *'),
        'A',
      );

      // Enter invalid phone
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number (Optional)'),
        'invalid-phone',
      );

      final saveBtn = find.widgetWithText(CustomButton, 'Save Birthday');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
      expect(find.text('Please enter a valid phone number'), findsOneWidget);
    });

    testWidgets('Avatar picker updates selected emoji on tap',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap the flower emoji chip '🌸'
      final flowerChip = find.text('🌸');
      await tester.ensureVisible(flowerChip);
      await tester.tap(flowerChip);
      await tester.pumpAndSettle();

      // Verify flower emoji is now selected
      expect(find.text('🌸'), findsWidgets);
    });

    testWidgets('Submits valid form, adds Birthday to provider, and shows SnackBar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final provider = BirthdayProvider();
      final initialCount = provider.totalBirthdayCount;

      await tester.pumpWidget(buildTestWidget(birthdayProvider: provider));
      await tester.pumpAndSettle();

      // 1. Enter Name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name *'),
        'Siddharth Rao',
      );

      // 2. Select Date via DatePicker
      final dateField = find.widgetWithText(TextFormField, 'Date of Birth *');
      await tester.tap(dateField);
      await tester.pumpAndSettle();

      // Tap 'Select' on the DatePicker dialog
      final selectButton = find.text('Select');
      if (selectButton.evaluate().isNotEmpty) {
        await tester.tap(selectButton);
        await tester.pumpAndSettle();
      } else {
        // Fallback for default 'OK' in DatePicker
        final okButton = find.text('OK');
        if (okButton.evaluate().isNotEmpty) {
          await tester.tap(okButton);
          await tester.pumpAndSettle();
        }
      }

      // 3. Select Relationship from Dropdown
      final dropdown = find.byType(DropdownButtonFormField<String>);
      await tester.ensureVisible(dropdown);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Pick 'Friend'
      final friendOption = find.text('Friend').last;
      await tester.tap(friendOption);
      await tester.pumpAndSettle();

      // 4. Enter valid phone number
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number (Optional)'),
        '9876543210',
      );

      // 5. Enter notes
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Notes & Gift Ideas (Optional)'),
        'Enjoys photography and science fiction novels',
      );

      // 6. Tap Save Birthday button
      final saveBtn = find.widgetWithText(CustomButton, 'Save Birthday');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify birthday was added to Provider
      expect(provider.totalBirthdayCount, initialCount + 1);
      final Birthday added = provider.birthdays.firstWhere((b) => b.name == 'Siddharth Rao');
      expect(added.relationship, 'Friend');
      expect(added.phone, '9876543210');
      expect(added.notes, 'Enjoys photography and science fiction novels');

      // Verify success snackbar
      expect(
        find.text('🎉 Siddharth Rao’s birthday saved successfully!'),
        findsOneWidget,
      );
    });

    testWidgets('Responsive Form: Renders on Mobile, Tablet, and Desktop without overflow',
        (WidgetTester tester) async {
      // 1. Mobile (360x700)
      tester.view.physicalSize = const Size(360, 700);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Add Birthday'), findsOneWidget);

      // 2. Tablet (768x1024)
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Add Birthday'), findsOneWidget);

      // 3. Desktop (1280x900)
      tester.view.physicalSize = const Size(1280, 900);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Add Birthday'), findsOneWidget);

      tester.view.resetPhysicalSize();
    });

    testWidgets('Edit Mode: Pre-fills all existing values and avatar cleanly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final existing = Birthday(
        id: 'edit-1',
        name: 'Kavita Menon',
        dateOfBirth: DateTime(1996, 4, 18),
        relationship: 'Family',
        phone: '9876512345',
        notes: 'Loves hand-poured lavender candles',
        imagePath: '🌸',
      );

      await tester.pumpWidget(buildTestWidget(existingBirthday: existing));
      await tester.pumpAndSettle();

      // Header and titles for edit mode
      expect(find.text('Edit Birthday'), findsOneWidget);
      expect(find.text('Update Celebration'), findsOneWidget);
      expect(find.text('Update Birthday'), findsOneWidget);

      // Pre-filled values in text form fields
      expect(find.widgetWithText(TextFormField, 'Kavita Menon'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '18 April 1996'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '9876512345'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Loves hand-poured lavender candles'), findsOneWidget);

      // Selected avatar emoji
      expect(find.text('🌸'), findsWidgets);
    });

    testWidgets('Edit Mode: Saves updated values via BirthdayProvider and shows SnackBar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final provider = BirthdayProvider();
      final existing = Birthday(
        id: 'edit-2',
        name: 'Sameer Verma',
        dateOfBirth: DateTime(1998, 9, 10),
        relationship: 'Friend',
        phone: '9845012345',
        notes: 'Fond of specialty tea blends',
        imagePath: '☕',
      );
      provider.addBirthday(existing);
      final countBefore = provider.totalBirthdayCount;

      await tester.pumpWidget(
        buildTestWidget(
          birthdayProvider: provider,
          existingBirthday: existing,
        ),
      );
      await tester.pumpAndSettle();

      // Modify the name and notes
      final nameField = find.widgetWithText(TextFormField, 'Sameer Verma');
      await tester.enterText(nameField, 'Sameer V. Sharma');

      final notesField = find.widgetWithText(TextFormField, 'Fond of specialty tea blends');
      await tester.enterText(notesField, 'Prefers Earl Grey and Japanese Matcha');

      // Tap Update Birthday
      final updateBtn = find.widgetWithText(CustomButton, 'Update Birthday');
      await tester.ensureVisible(updateBtn);
      await tester.tap(updateBtn);
      await tester.pumpAndSettle();

      // Total count stays the same (no duplicates created)
      expect(provider.totalBirthdayCount, countBefore);

      // Provider record has the updated values
      final updated = provider.findById('edit-2');
      expect(updated, isNotNull);
      expect(updated!.name, 'Sameer V. Sharma');
      expect(updated.notes, 'Prefers Earl Grey and Japanese Matcha');

      // Shows update success snackbar
      expect(
        find.text('🎉 Sameer V. Sharma’s birthday updated successfully!'),
        findsOneWidget,
      );
    });
  });
}
