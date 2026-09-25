import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/dashboard_screen.dart';

void main() {
  group('DashboardScreen Responsive & Auto-Update Tests', () {
    testWidgets('Dashboard renders Mobile layout with Header, Stats, and FAB',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => BirthdayProvider()),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header & Welcome
      expect(find.text('BirthdayBox'), findsOneWidget);
      expect(find.text('Welcome back, Alex! 🎉'), findsOneWidget);
      expect(find.text('Mobile (Single Column)'), findsOneWidget);

      // Verify 3 Statistics
      expect(find.text('Total Birthdays'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
      expect(find.text("Today's"), findsOneWidget);

      // Verify FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Birthday'), findsOneWidget);
    });

    testWidgets('Dashboard renders Tablet layout with 2-column cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => BirthdayProvider()),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tablet (2-Column Adaptive)'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Dashboard renders Desktop layout with Sidebar and Multi-Column',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => BirthdayProvider()),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Sidebar components
      expect(find.text('Dashboard (Sidebar + Multi-Column)'), findsOneWidget);
      expect(find.text('All Birthdays'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('Dashboard updates automatically when birthday is added or deleted',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final provider = BirthdayProvider();

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

      final initialCount = provider.totalBirthdayCount;
      expect(find.text('$initialCount'), findsOneWidget);

      // Add a birthday programmatically through provider
      provider.addBirthday(
        Birthday(
          id: 'test-auto-add',
          name: 'Zoe AutoCelebrant',
          dateOfBirth: DateTime(2000, 8, 12),
          relationship: 'Friend',
        ),
      );

      await tester.pumpAndSettle();

      // Verify dashboard counter auto-updated
      expect(find.text('${initialCount + 1}'), findsOneWidget);
      expect(find.text('Zoe AutoCelebrant'), findsOneWidget);

      // Delete the birthday
      provider.deleteBirthday('test-auto-add');
      await tester.pumpAndSettle();

      // Verify count decreased back and name disappeared
      expect(find.text('$initialCount'), findsOneWidget);
      expect(find.text('Zoe AutoCelebrant'), findsNothing);
    });
  });
}
