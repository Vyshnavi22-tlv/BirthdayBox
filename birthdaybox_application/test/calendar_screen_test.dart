import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/routes/app_routes.dart';
import 'package:birthdaybox_application/screens/calendar_screen.dart';
import 'package:birthdaybox_application/widgets/birthday_card.dart';

void main() {
  group('CalendarScreen Comprehensive Tests', () {
    Widget buildTestWidget({BirthdayProvider? birthdayProvider}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider.value(
            value: birthdayProvider ?? BirthdayProvider(),
          ),
        ],
        child: MaterialApp(
          routes: {
            AppRoutes.root: (_) => const CalendarScreen(),
            AppRoutes.calendar: (_) => const CalendarScreen(),
            AppRoutes.birthdayDetails: (_) => const Scaffold(
                  body: Text('Birthday Details Screen'),
                ),
            AppRoutes.addBirthday: (_) => const Scaffold(
                  body: Text('Add Birthday Screen'),
                ),
          },
        ),
      );
    }

    testWidgets('Renders month navigation, weekday headers, and calendar grid',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // AppBar title
      expect(find.text('Birthday Calendar'), findsOneWidget);

      // Weekday headers
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Thu'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);

      // Month navigation buttons
      expect(find.byTooltip('Previous Month'), findsOneWidget);
      expect(find.byTooltip('Next Month'), findsOneWidget);

      // Calendar GridView
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Navigates between previous and next months and resets with Today',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final now = DateTime.now();
      final currentMonthText = '${months[now.month - 1]} ${now.year}';
      expect(find.text(currentMonthText), findsOneWidget);

      // Tap Next Month
      await tester.tap(find.byTooltip('Next Month'));
      await tester.pumpAndSettle();

      final nextMonthDate = DateTime(now.year, now.month + 1, 1);
      final nextMonthText = '${months[nextMonthDate.month - 1]} ${nextMonthDate.year}';
      expect(find.text(nextMonthText), findsOneWidget);

      // Tap Previous Month twice
      await tester.tap(find.byTooltip('Previous Month'));
      await tester.pumpAndSettle();
      expect(find.text(currentMonthText), findsOneWidget);

      await tester.tap(find.byTooltip('Previous Month'));
      await tester.pumpAndSettle();
      final prevMonthDate = DateTime(now.year, now.month - 1, 1);
      final prevMonthText = '${months[prevMonthDate.month - 1]} ${prevMonthDate.year}';
      expect(find.text(prevMonthText), findsOneWidget);

      // Tap 'Go to Today' action in AppBar
      await tester.tap(find.byTooltip('Go to Today'));
      await tester.pumpAndSettle();
      expect(find.text(currentMonthText), findsOneWidget);
    });

    testWidgets('Selecting a date displays birthdays on that date',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final now = DateTime.now();
      final testBirthday = Birthday(
        id: 'cal-test-1',
        name: 'Devika Pillai',
        dateOfBirth: DateTime(1997, now.month, 15),
        relationship: 'Friend',
        phone: '9876543210',
        notes: 'Photography enthusiast',
        imagePath: '📷',
      );

      final provider = BirthdayProvider();
      provider.addBirthday(testBirthday);

      await tester.pumpWidget(buildTestWidget(birthdayProvider: provider));
      await tester.pumpAndSettle();

      // Tap on day 15 in the calendar grid
      final day15Finder = find.text('15');
      expect(day15Finder, findsWidgets);
      await tester.tap(day15Finder.first);
      await tester.pumpAndSettle();

      // Birthday card for Devika Pillai is displayed in the selected date panel
      expect(find.text('Devika Pillai'), findsOneWidget);
      expect(find.widgetWithText(BirthdayCard, 'Devika Pillai'), findsOneWidget);
    });

    testWidgets('Tapping birthday card in selected date panel opens Birthday Details',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final now = DateTime.now();
      final testBirthday = Birthday(
        id: 'cal-test-2',
        name: 'Arjun Sengupta',
        dateOfBirth: DateTime(1994, now.month, 22),
        relationship: 'Family',
        phone: '9123456789',
        notes: 'Loves artisanal chocolate',
        imagePath: '🍫',
      );

      final provider = BirthdayProvider();
      provider.addBirthday(testBirthday);

      await tester.pumpWidget(buildTestWidget(birthdayProvider: provider));
      await tester.pumpAndSettle();

      // Select day 22
      final day22 = find.text('22').first;
      await tester.tap(day22);
      await tester.pumpAndSettle();

      // Tap the displayed birthday card
      final card = find.widgetWithText(BirthdayCard, 'Arjun Sengupta');
      expect(card, findsOneWidget);
      await tester.tap(card);
      await tester.pumpAndSettle();

      // Verifies details screen opened
      expect(find.text('Birthday Details Screen'), findsOneWidget);
    });

    testWidgets('Responsive Layout renders on Mobile (360x700)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Birthday Calendar'), findsOneWidget);
    });

    testWidgets('Responsive Layout renders on Tablet (768x1024)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Birthday Calendar'), findsOneWidget);
    });

    testWidgets('Responsive Layout renders on Desktop (1280x900)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Birthday Calendar'), findsOneWidget);
    });
  });
}
