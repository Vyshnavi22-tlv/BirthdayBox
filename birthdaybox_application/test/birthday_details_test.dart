import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/routes/app_routes.dart';
import 'package:birthdaybox_application/screens/add_birthday_screen.dart';
import 'package:birthdaybox_application/screens/birthday_details_screen.dart';

void main() {
  group('BirthdayDetailsScreen Comprehensive Tests', () {
    Widget buildTestWidget({
      Birthday? birthday,
      BirthdayProvider? birthdayProvider,
      bool withNamedRoute = false,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider.value(
            value: birthdayProvider ?? BirthdayProvider(),
          ),
        ],
        child: MaterialApp(
          routes: {
            AppRoutes.root: (context) => withNamedRoute
                ? Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.birthdayDetails,
                          arguments: birthday,
                        ),
                        child: const Text('Open Details'),
                      ),
                    ),
                  )
                : BirthdayDetailsScreen(birthday: birthday),
            AppRoutes.birthdayDetails: (context) => const BirthdayDetailsScreen(),
            AppRoutes.birthdays: (context) => const Scaffold(
                  body: Text('Birthdays Screen'),
                ),
          },
        ),
      );
    }

    testWidgets('Renders all required fields, Stack hero section, and details',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testBirthday = Birthday(
        id: 'test-1',
        name: 'Meera Nambiar',
        dateOfBirth: DateTime(1995, 8, 20),
        relationship: 'Family',
        phone: '+91 9876543210',
        notes: 'Loves hand-made ceramic mugs and dark roast coffee.',
        imagePath: '🌸',
      );

      final provider = BirthdayProvider();
      provider.addBirthday(testBirthday);

      await tester.pumpWidget(
        buildTestWidget(birthday: testBirthday, birthdayProvider: provider),
      );
      await tester.pumpAndSettle();

      // 1. Stack is used naturally in the hero section
      expect(find.byType(Stack), findsWidgets);

      // 2. Avatar Emoji / Icon
      expect(find.text('🌸'), findsWidgets);

      // 3. Name
      expect(find.text('Meera Nambiar'), findsWidgets);

      // 4. Relationship
      expect(find.text('Family'), findsWidgets);

      // 5. Date of Birth
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('20 August 1995'), findsOneWidget);

      // 6. Next Birthday
      expect(find.text('Next Birthday'), findsOneWidget);

      // 7. Phone number
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);

      // 8. Notes & Gift Ideas
      expect(find.text('Notes & Gift Ideas'), findsOneWidget);
      expect(
        find.text('Loves hand-made ceramic mugs and dark roast coffee.'),
        findsOneWidget,
      );

      // 9. Action buttons
      expect(find.text('Edit Birthday'), findsWidgets);
      expect(find.text('Delete Birthday'), findsWidgets);
    });

    testWidgets('Tapping [ Edit Birthday ] opens AddBirthdayScreen with prefilled data',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testBirthday = Birthday(
        id: 'test-2',
        name: 'Kavita Krishnan',
        dateOfBirth: DateTime(1992, 5, 12),
        relationship: 'Friend',
        phone: '9123456780',
        notes: 'Vegan chocolate cake enthusiast',
        imagePath: '🎂',
      );

      final provider = BirthdayProvider();
      provider.addBirthday(testBirthday);

      await tester.pumpWidget(
        buildTestWidget(birthday: testBirthday, birthdayProvider: provider),
      );
      await tester.pumpAndSettle();

      // Tap [ Edit Birthday ] button in the body
      final editBtn = find.widgetWithText(ElevatedButton, 'Edit Birthday');
      expect(editBtn, findsOneWidget);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      // AddBirthdayScreen should now be mounted in edit mode
      expect(find.byType(AddBirthdayScreen), findsOneWidget);
      expect(find.text('Update Celebration'), findsOneWidget);
      expect(find.text('Update Birthday'), findsOneWidget);

      // Check pre-filled text in TextFormField
      expect(find.widgetWithText(TextFormField, 'Kavita Krishnan'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '9123456780'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Vegan chocolate cake enthusiast'), findsOneWidget);
    });

    testWidgets('Tapping [ Delete Birthday ] displays confirmation dialog and deletes on confirm',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testBirthday = Birthday(
        id: 'test-3',
        name: 'Rohan Mehra',
        dateOfBirth: DateTime(1990, 11, 25),
        relationship: 'Colleague',
        phone: '9988776655',
        notes: 'Loves mechanical keyboards',
        imagePath: '💻',
      );

      final provider = BirthdayProvider();
      provider.addBirthday(testBirthday);
      final initialCount = provider.totalBirthdayCount;

      // Wrap with navigation parent route to test pop on delete
      await tester.pumpWidget(
        buildTestWidget(
          birthday: testBirthday,
          birthdayProvider: provider,
          withNamedRoute: true,
        ),
      );
      await tester.pumpAndSettle();

      // Open details
      await tester.tap(find.text('Open Details'));
      await tester.pumpAndSettle();
      expect(find.text('Rohan Mehra'), findsWidgets);

      // Tap Delete Birthday button
      final deleteBtn = find.widgetWithText(OutlinedButton, 'Delete Birthday');
      expect(deleteBtn, findsOneWidget);
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Confirmation dialog should be displayed
      expect(find.text('Delete Birthday'), findsWidgets);
      expect(
        find.text('Are you sure you want to delete Rohan Mehra’s birthday? This action cannot be undone.'),
        findsOneWidget,
      );

      // Tap Cancel first to ensure dialog dismisses without deleting
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(provider.totalBirthdayCount, initialCount);

      // Tap Delete again and confirm
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      final confirmDeleteBtn = find.widgetWithText(FilledButton, 'Delete');
      await tester.tap(confirmDeleteBtn);
      await tester.pumpAndSettle();

      // Birthday is removed from provider
      expect(provider.totalBirthdayCount, initialCount - 1);
      expect(provider.findById('test-3'), isNull);

      // Screen is popped back and SnackBar is displayed
      expect(find.text('Rohan Mehra’s birthday deleted'), findsOneWidget);
    });

    testWidgets('Responsive Layout renders on Mobile, Tablet, and Desktop without overflow',
        (WidgetTester tester) async {
      final testBirthday = Birthday(
        id: 'test-4',
        name: 'Aarav Patel',
        dateOfBirth: DateTime(2001, 3, 15),
        relationship: 'Friend',
        phone: '9876501234',
        notes: 'Classic rock vinyl records',
        imagePath: '🎸',
      );

      // 1. Mobile (360x700)
      tester.view.physicalSize = const Size(360, 700);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(buildTestWidget(birthday: testBirthday));
      await tester.pumpAndSettle();
      expect(find.text('Aarav Patel'), findsWidgets);

      // 2. Tablet (768x1024)
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(buildTestWidget(birthday: testBirthday));
      await tester.pumpAndSettle();
      expect(find.text('Aarav Patel'), findsWidgets);

      // 3. Desktop (1280x900)
      tester.view.physicalSize = const Size(1280, 900);
      await tester.pumpWidget(buildTestWidget(birthday: testBirthday));
      await tester.pumpAndSettle();
      expect(find.text('Aarav Patel'), findsWidgets);

      tester.view.resetPhysicalSize();
    });

    testWidgets('Displays fallback UI when birthday cannot be found',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget(birthday: null));
      await tester.pumpAndSettle();

      expect(find.text('Birthday Not Found'), findsOneWidget);
      expect(find.text('Back to Birthdays'), findsOneWidget);
    });
  });
}
