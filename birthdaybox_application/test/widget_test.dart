import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/main.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/home_screen.dart';

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

    // Clean up timer by pumping through duration
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

    // Verify currently on splash
    expect(find.text('Never miss a special day.'), findsOneWidget);

    // Fast-forward past navigation delay (2500ms)
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Verify that LoginScreen is now shown
    expect(find.text('Login Screen'), findsOneWidget);
    expect(find.text('Route: /login'), findsOneWidget);
  });

  testWidgets('HomeScreen named routes navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: MaterialApp(
          home: const HomeScreen(),
          routes: {
            '/birthdays': (_) => const Scaffold(body: Text('Birthdays List')),
          },
        ),
      ),
    );

    // Tap on '/birthdays' route chip
    await tester.tap(find.text('/birthdays'));
    await tester.pumpAndSettle();

    // Verify BirthdaysScreen placeholder is displayed
    expect(find.text('Birthdays List'), findsOneWidget);
  });
}
