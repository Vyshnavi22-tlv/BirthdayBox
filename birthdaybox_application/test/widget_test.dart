import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/main.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/login_screen.dart';

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

  testWidgets('LoginScreen succeeds with valid input and navigates to Home',
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

    // Advance through splash to login
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Enter valid email and password
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'), 'alex@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret123');

    // Tap Sign In
    await tester.tap(find.text('Sign In'));
    await tester.pump(); // Start loading state

    // Advance simulated authentication delay
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify navigation landed on Dashboard / HomeScreen
    expect(find.text('Total Birthdays'), findsOneWidget);
  });
}
