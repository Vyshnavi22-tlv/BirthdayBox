import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/main.dart';
import 'package:birthdaybox_application/models/birthday_model.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/login_screen.dart';
import 'package:birthdaybox_application/screens/signup_screen.dart';
import 'package:birthdaybox_application/widgets/birthday_card.dart';
import 'package:birthdaybox_application/widgets/countdown_card.dart';
import 'package:birthdaybox_application/widgets/custom_button.dart';
import 'package:birthdaybox_application/widgets/custom_textfield.dart';
import 'package:birthdaybox_application/widgets/stat_card.dart';

void main() {
  testWidgets('SplashScreen renders with logo, name, tagline, and transitions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const BirthdayBoxApp(),
      ),
    );

    // Verify initial splash state
    expect(find.text('BirthdayBox'), findsOneWidget);
    expect(find.text('Never miss a special day.'), findsOneWidget);
    expect(find.byType(FadeTransition), findsWidgets);
    expect(find.byType(ScaleTransition), findsWidgets);

    // Fast-forward through splash
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
  });

  testWidgets('SplashScreen automatically navigates to LoginScreen after delay',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const BirthdayBoxApp(),
      ),
    );

    // Fast-forward past navigation delay (2500ms)
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Verify that LoginScreen is now shown
    expect(find.text('Welcome Back! 👋'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
  });

  testWidgets('LoginScreen validates empty and invalid inputs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Tap Sign In with empty fields
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Verify error messages for empty fields
    expect(find.text('Email cannot be empty'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);

    // Enter invalid email format and short password
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'), 'invalid-email');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Navigation: Login -> Sign Up -> Login',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const BirthdayBoxApp(),
      ),
    );

    // Advance to Login
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Tap Create Account on Login screen
    final createAccountFinder = find.text('Create Account');
    await tester.ensureVisible(createAccountFinder);
    await tester.pumpAndSettle();
    await tester.tap(createAccountFinder);
    await tester.pumpAndSettle();

    // Verify Signup screen is open
    expect(find.text('Get Started with BirthdayBox'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);

    // Tap Sign In link to go back
    final signInFinder = find.text('Sign In');
    await tester.ensureVisible(signInFinder);
    await tester.pumpAndSettle();
    await tester.tap(signInFinder);
    await tester.pumpAndSettle();

    // Verify back on Login screen
    expect(find.text('Welcome Back! 👋'), findsOneWidget);
  });

  testWidgets('SignupScreen validates required fields and password mismatch',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const MaterialApp(
          home: SignupScreen(),
        ),
      ),
    );

    // Tap Create Account button with empty fields
    final createBtnFinder = find.widgetWithText(CustomButton, 'Create Account');
    await tester.ensureVisible(createBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(createBtnFinder);
    await tester.pumpAndSettle();

    expect(find.text('Full Name cannot be empty'), findsOneWidget);
    expect(find.text('Email cannot be empty'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);

    // Enter mismatching passwords
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'), 'Vyshnavi');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'), 'vyshu@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'), 'different456');

    await tester.ensureVisible(createBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(createBtnFinder);
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Custom Widgets: StatCard, BirthdayCard, and CountdownCard render correctly',
      (WidgetTester tester) async {
    final sampleBirthday = BirthdayModel(
      id: 'test-1',
      name: 'Ananya Sharma',
      dateOfBirth: DateTime(2003, 10, 15),
      relationship: 'Friend',
      phoneNumber: '9876543210',
      notes: 'Loves books',
      avatarEmoji: '🌸',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const StatCard(
                  icon: '🎂',
                  number: '12',
                  label: 'Total Birthdays',
                ),
                BirthdayCard(birthday: sampleBirthday),
                CountdownCard(birthday: sampleBirthday),
                CustomButton(onPressed: () {}, text: 'Action Button'),
                const CustomTextField(labelText: 'Custom Input'),
              ],
            ),
          ),
        ),
      ),
    );

    // Verify StatCard
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Total Birthdays'), findsOneWidget);

    // Verify BirthdayCard
    expect(find.text('Ananya Sharma'), findsNWidgets(2)); // in BirthdayCard & CountdownCard
    expect(find.text('Friend'), findsOneWidget);
    expect(find.text('🌸'), findsNWidgets(2));

    // Verify CountdownCard units
    expect(find.text('DAYS'), findsOneWidget);
    expect(find.text('HOURS'), findsOneWidget);

    // Verify CustomButton & CustomTextField
    expect(find.text('Action Button'), findsOneWidget);
    expect(find.text('Custom Input'), findsOneWidget);
  });
}
