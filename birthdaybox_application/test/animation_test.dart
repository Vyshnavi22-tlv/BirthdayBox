import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/birthdays_screen.dart';
import 'package:birthdaybox_application/screens/calendar_screen.dart';
import 'package:birthdaybox_application/screens/dashboard_screen.dart';
import 'package:birthdaybox_application/widgets/birthday_card.dart';
import 'package:birthdaybox_application/widgets/responsive_scaffold.dart';
import 'package:birthdaybox_application/widgets/stat_card.dart';

void main() {
  group('BirthdayBox Animation Tests', () {
    late ThemeProvider themeProvider;
    late BirthdayProvider birthdayProvider;

    final sampleBirthday = Birthday(
      id: 'anim-1',
      name: 'Priya Sharma',
      dateOfBirth: DateTime(2002, 5, 20),
      relationship: 'Friend',
      phoneNumber: '9876543210',
      notes: 'Birthday animation test',
      avatarEmoji: '🎉',
    );

    setUp(() {
      themeProvider = ThemeProvider();
      birthdayProvider = BirthdayProvider();
    });

    Widget createTestApp(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<BirthdayProvider>.value(value: birthdayProvider),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('1. Dashboard content has FadeTransition driven by AnimationController', (tester) async {
      await tester.pumpWidget(createTestApp(const DashboardScreen()));

      // Initially on frame 0, FadeTransition is mounted with opacity between 0.0 and 1.0
      final fadeFinder = find.byType(FadeTransition);
      expect(fadeFinder, findsWidgets);

      // Advance animation halfway
      await tester.pump(const Duration(milliseconds: 300));
      expect(fadeFinder, findsWidgets);

      // Settle fully
      await tester.pumpAndSettle();
      expect(find.text('Welcome back, Alex! 🎉'), findsOneWidget);
    });

    testWidgets('2. BirthdayCard implements SlideTransition and FadeTransition', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: BirthdayCard(birthday: sampleBirthday),
          ),
        ),
      );

      // Verify presence of SlideTransition and FadeTransition inside BirthdayCard
      expect(
        find.descendant(of: find.byType(BirthdayCard), matching: find.byType(SlideTransition)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(BirthdayCard), matching: find.byType(FadeTransition)),
        findsOneWidget,
      );

      // Verify widget text is present and accessible
      expect(find.text('Priya Sharma'), findsOneWidget);
      expect(find.text('Friend'), findsOneWidget);

      // Pump to settle animation
      await tester.pumpAndSettle();
      expect(find.text('Priya Sharma'), findsOneWidget);
    });

    testWidgets('3. AnimatedContainer is used for filter states in BirthdaysScreen', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(const BirthdaysScreen()));
      await tester.pumpAndSettle();

      // Find FilterChip widgets wrapped in AnimatedContainer
      expect(find.byType(AnimatedContainer), findsWidgets);

      final filterChipFinder = find.widgetWithText(FilterChip, 'Family');
      expect(filterChipFinder, findsOneWidget);

      // Tap to switch filter state
      await tester.tap(filterChipFinder);
      await tester.pump();
      await tester.pumpAndSettle();

      // Verified filter chip selected
      final selectedChip = tester.widget<FilterChip>(filterChipFinder);
      expect(selectedChip.selected, isTrue);
    });

    testWidgets('3b. AnimatedContainer is used in Calendar date cells', (tester) async {
      tester.view.physicalSize = const Size(900, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(const CalendarScreen()));
      await tester.pumpAndSettle();

      // Date cells use AnimatedContainer for selection highlighting
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('4. Smooth theme transition: AnimatedSwitcher used for theme toggles', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
            ChangeNotifierProvider<BirthdayProvider>.value(value: birthdayProvider),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, tp, _) => MaterialApp(
              home: Scaffold(
                body: ResponsiveScaffold.buildThemeSwitchButton(tp, tp.isDarkMode),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify AnimatedSwitcher is present for theme button
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Tap theme switch button
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(themeProvider.isDarkMode, isTrue);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('5. Statistics cards have animated appearance with SlideTransition and FadeTransition', (tester) async {
      await tester.pumpWidget(createTestApp(const DashboardScreen()));

      // Verify StatCards are present
      expect(find.byType(StatCard), findsNWidgets(3));

      // Each StatCard in the row is wrapped with FadeTransition and SlideTransition
      final slideFinder = find.descendant(
        of: find.byType(DashboardScreen),
        matching: find.byType(SlideTransition),
      );
      expect(slideFinder, findsWidgets);

      await tester.pumpAndSettle();
      expect(find.text('Total Birthdays'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
      expect(find.text("Today's"), findsOneWidget);
    });

    testWidgets('AnimationControllers are disposed cleanly when widgets are removed', (tester) async {
      // Mount DashboardScreen and then replace it to trigger dispose()
      await tester.pumpWidget(createTestApp(const DashboardScreen()));
      await tester.pump(const Duration(milliseconds: 100));

      // Replace with another widget to unmount and dispose controllers
      await tester.pumpWidget(createTestApp(const Scaffold(body: Text('Unmounted'))));
      await tester.pumpAndSettle();

      expect(find.text('Unmounted'), findsOneWidget);
      expect(find.byType(DashboardScreen), findsNothing);
    });
  });
}
