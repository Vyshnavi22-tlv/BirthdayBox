import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/dashboard_screen.dart';
import 'package:birthdaybox_application/widgets/celebration_card.dart';

void main() {
  group('Birthday Celebration Feature Tests', () {
    final now = DateTime.now();

    final todayCelebrant = Birthday(
      id: 'today-1',
      name: 'Sneha Reddy',
      dateOfBirth: DateTime(2001, now.month, now.day),
      relationship: 'Friend',
      phoneNumber: '9876543210',
      notes: 'Loves chocolate cake',
      avatarEmoji: '🎂',
    );

    final notTodayPerson = Birthday(
      id: 'not-today-1',
      name: 'Rohan Gupta',
      dateOfBirth: DateTime(1999, now.month == 12 ? 1 : now.month + 1, 15),
      relationship: 'Colleague',
      phoneNumber: '9123456789',
      avatarEmoji: '⭐',
    );

    testWidgets('CelebrationCard displays "🎉 Happy Birthday!" and "[Name] is celebrating today!"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelebrationCard(birthday: todayCelebrant),
          ),
        ),
      );

      // Verify exact required text
      expect(find.text('🎉 Happy Birthday!'), findsOneWidget);
      expect(find.text('Sneha Reddy is celebrating today!'), findsOneWidget);

      // Verify age and relationship are shown
      expect(find.text('Turning ${todayCelebrant.age} today'), findsOneWidget);
      expect(find.text('• Friend'), findsOneWidget);
    });

    testWidgets('CelebrationCard uses FadeTransition, ScaleTransition, SlideTransition, and AnimatedContainer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelebrationCard(birthday: todayCelebrant),
          ),
        ),
      );

      // Verify animations are present
      expect(find.descendant(of: find.byType(CelebrationCard), matching: find.byType(FadeTransition)), findsWidgets);
      expect(find.descendant(of: find.byType(CelebrationCard), matching: find.byType(ScaleTransition)), findsWidgets);
      expect(find.descendant(of: find.byType(CelebrationCard), matching: find.byType(SlideTransition)), findsWidgets);
      expect(find.descendant(of: find.byType(CelebrationCard), matching: find.byType(AnimatedContainer)), findsWidgets);

      // Advance animation frames and settle
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('🎉 Happy Birthday!'), findsOneWidget);
    });

    testWidgets('Works seamlessly in both Light and Dark themes', (tester) async {
      // 1. Light Theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          themeMode: ThemeMode.light,
          home: Scaffold(
            body: CelebrationCard(birthday: todayCelebrant),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('🎉 Happy Birthday!'), findsOneWidget);

      // 2. Dark Theme
      await tester.pumpWidget(
        MaterialApp(
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: ThemeMode.dark,
          home: Scaffold(
            body: CelebrationCard(birthday: todayCelebrant),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('🎉 Happy Birthday!'), findsOneWidget);
      expect(find.text('Sneha Reddy is celebrating today!'), findsOneWidget);
    });

    testWidgets('Dashboard shows CelebrationCard when someone has birthday today', (tester) async {
      final provider = BirthdayProvider();
      // Ensure todayCelebrant is in provider
      provider.addBirthday(todayCelebrant);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider.value(value: provider),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Celebration card is present on dashboard
      expect(find.byType(CelebrationCard), findsWidgets);
      expect(find.text('🎉 Happy Birthday!'), findsWidgets);
      expect(find.text('Sneha Reddy is celebrating today!'), findsOneWidget);
    });

    testWidgets('Dashboard does not show CelebrationCard when no one has birthday today', (tester) async {
      final provider = BirthdayProvider();
      // Clear any birthdays occurring today
      for (final b in List<Birthday>.from(provider.birthdays)) {
        if (b.isToday) {
          provider.deleteBirthday(b.id);
        }
      }
      provider.addBirthday(notTodayPerson);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider.value(value: provider),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // No celebration card displayed
      expect(find.byType(CelebrationCard), findsNothing);
      expect(find.text('🎉 Happy Birthday!'), findsNothing);
    });

    testWidgets('Tapping CelebrationCard triggers onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelebrationCard(
              birthday: todayCelebrant,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Sneha Reddy is celebrating today!'));
      expect(tapped, isTrue);
    });
  });
}
