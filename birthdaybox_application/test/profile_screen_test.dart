import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/routes/app_routes.dart';
import 'package:birthdaybox_application/screens/profile_screen.dart';

void main() {
  group('ProfileScreen Comprehensive Tests', () {
    Widget buildTestWidget({ThemeProvider? themeProvider}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: themeProvider ?? ThemeProvider(),
          ),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: MaterialApp(
          routes: {
            AppRoutes.root: (_) => const ProfileScreen(),
            AppRoutes.profile: (_) => const ProfileScreen(),
            AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
          },
        ),
      );
    }

    testWidgets('Renders User Avatar, Name, Email, and Member Badge',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Vyshnavi Rao'), findsWidgets);
      expect(find.text('vyshnavi.rao@birthdaybox.app'), findsWidgets);
      expect(find.text('BirthdayBox Pro Member'), findsOneWidget);
      expect(find.text('👑'), findsWidgets);
    });

    testWidgets('Renders Personal Information Card with full details',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('15 August 2003'), findsOneWidget);
      expect(find.text('Location & Timezone'), findsOneWidget);
      expect(find.text('Hyderabad, India (IST)'), findsOneWidget);
    });

    testWidgets('Edits Personal Information via dialog and updates state',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap edit button in AppBar or Personal Info card
      final editButton = find.byTooltip('Edit Profile');
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('Edit Profile'), findsOneWidget);

      // Modify Name
      final nameField = find.widgetWithText(TextFormField, 'Full Name');
      await tester.enterText(nameField, 'Vyshnavi TLV');

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // State is updated
      expect(find.text('Vyshnavi TLV'), findsWidgets);
      expect(find.text('Profile information updated successfully!'), findsOneWidget);
    });

    testWidgets('Theme Settings: Uses ThemeProvider and updates immediately',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final themeProvider = ThemeProvider();
      expect(themeProvider.isDarkMode, isFalse);

      await tester.pumpWidget(buildTestWidget(themeProvider: themeProvider));
      await tester.pumpAndSettle();

      expect(find.text('Theme Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsWidgets);

      // Tap Dark Mode switch
      final switchFinder = find.byWidgetPredicate(
        (widget) => widget is SwitchListTile && widget.title is Text && (widget.title as Text).data == 'Dark Mode',
      );
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // ThemeProvider state changed immediately
      expect(themeProvider.isDarkMode, isTrue);

      // Tap Light Mode button
      await tester.tap(find.text('Light Mode'));
      await tester.pumpAndSettle();
      expect(themeProvider.isDarkMode, isFalse);

      // Tap Dark Mode button
      final darkModeButtons = find.widgetWithText(OutlinedButton, 'Dark Mode');
      expect(darkModeButtons, findsOneWidget);
      await tester.tap(darkModeButtons);
      await tester.pumpAndSettle();
      expect(themeProvider.isDarkMode, isTrue);
    });

    testWidgets('Notification Settings: Interactive switches and time picker UI',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Notification Settings'), findsOneWidget);
      expect(find.text('Birthday Reminders'), findsOneWidget);
      expect(find.text('Advance Notification'), findsOneWidget);
      expect(find.text('Celebration Sounds'), findsOneWidget);
      expect(find.text('Reminder Time'), findsOneWidget);

      // Toggle Birthday Reminders
      final reminderTile = find.widgetWithText(SwitchListTile, 'Birthday Reminders');
      await tester.tap(reminderTile);
      await tester.pumpAndSettle();

      // Toggle Advance Notification
      final advanceTile = find.widgetWithText(SwitchListTile, 'Advance Notification');
      await tester.ensureVisible(advanceTile);
      await tester.tap(advanceTile);
      await tester.pumpAndSettle();
    });

    testWidgets('About BirthdayBox: Displays app info, version, and features',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('About BirthdayBox'), findsOneWidget);
      expect(find.text('BirthdayBox'), findsWidgets);
      expect(find.text('v1.0.0'), findsOneWidget);
      expect(find.text('Smart Birthday Management & Reminder'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Licenses'), findsOneWidget);

      // Tap Privacy button
      final privacyBtn = find.text('Privacy');
      await tester.ensureVisible(privacyBtn);
      await tester.tap(privacyBtn);
      await tester.pumpAndSettle();
      expect(find.text('Privacy & Terms'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('Logout: Shows confirmation dialog and navigates to LoginScreen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find Logout button
      final logoutBtn = find.text('Log Out of BirthdayBox');
      expect(logoutBtn, findsOneWidget);
      await tester.ensureVisible(logoutBtn);
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Dialog confirmation
      expect(find.text('Log Out'), findsWidgets);
      expect(
        find.text(
          'Are you sure you want to log out of BirthdayBox? You will need to sign in again to access your birthdays.',
        ),
        findsOneWidget,
      );

      // Tap Log Out in dialog
      final dialogLogoutBtn = find.widgetWithText(ElevatedButton, 'Log Out');
      await tester.tap(dialogLogoutBtn);
      await tester.pumpAndSettle();

      // Navigated to Login
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Responsive Layout renders on Mobile (360x700)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Vyshnavi Rao'), findsWidgets);
    });

    testWidgets('Responsive Layout renders on Tablet (768x1024)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Personal Information'), findsOneWidget);
    });

    testWidgets('Responsive Layout renders on Desktop (1280x900)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Theme Settings'), findsOneWidget);
    });
  });
}
