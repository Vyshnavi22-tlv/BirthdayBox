import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/routes/app_routes.dart';
import 'package:birthdaybox_application/screens/birthdays_screen.dart';
import 'package:birthdaybox_application/widgets/birthday_card.dart';

void main() {
  group('BirthdaysScreen Comprehensive Tests', () {
    Widget buildTestWidget({
      BirthdayProvider? birthdayProvider,
      NavigatorObserver? observer,
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
            AppRoutes.root: (_) => const BirthdaysScreen(),
            AppRoutes.birthdays: (_) => const BirthdaysScreen(),
            AppRoutes.birthdayDetails: (_) => const Scaffold(
                  body: Text('Birthday Details Screen'),
                ),
            AppRoutes.addBirthday: (_) => const Scaffold(
                  body: Text('Add Birthday Screen'),
                ),
          },
          navigatorObservers: observer != null ? [observer] : [],
        ),
      );
    }

    testWidgets('Renders search bar, filter chips, sort selector, and BirthdayCards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // AppBar title
      expect(find.text('Birthdays List'), findsOneWidget);

      // Search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search birthdays by name...'), findsOneWidget);

      // Filter chips: All, Family, Friend, Colleague, Relative, Other
      expect(find.widgetWithText(FilterChip, 'All'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Family'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Friend'), findsOneWidget);

      // Birthday cards rendered
      expect(find.byType(BirthdayCard), findsWidgets);
    });

    testWidgets('Filters birthdays by name search query',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final provider = BirthdayProvider();
      await tester.pumpWidget(buildTestWidget(birthdayProvider: provider));
      await tester.pumpAndSettle();

      final firstPerson = provider.birthdays.first;

      // Enter search text matching first person's name
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, firstPerson.name);
      await tester.pumpAndSettle();

      // Only the matching person should be shown
      expect(find.widgetWithText(BirthdayCard, firstPerson.name), findsOneWidget);

      // Clear search using clear button
      final clearBtn = find.byTooltip('Clear search');
      expect(clearBtn, findsOneWidget);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // All cards are restored
      expect(find.byType(BirthdayCard), findsWidgets);
    });

    testWidgets('Filters birthdays by relationship category chip',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final provider = BirthdayProvider();
      await tester.pumpWidget(buildTestWidget(birthdayProvider: provider));
      await tester.pumpAndSettle();

      // Tap 'Friend' filter chip
      final friendChip = find.widgetWithText(FilterChip, 'Friend');
      await tester.tap(friendChip);
      await tester.pumpAndSettle();

      // All displayed birthday cards must have 'Friend' relationship
      final cards = tester.widgetList<BirthdayCard>(find.byType(BirthdayCard));
      expect(cards.isNotEmpty, isTrue);
      for (final card in cards) {
        expect(card.birthday.relationship.toLowerCase(), 'friend');
      }

      // Tap 'All' chip to reset filter
      await tester.tap(find.widgetWithText(FilterChip, 'All'));
      await tester.pumpAndSettle();

      expect(find.byType(BirthdayCard).evaluate().length, provider.totalBirthdayCount);
    });

    testWidgets('Sorts birthdays by upcoming date by default and allows sorting by name',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // By default, sorted by upcoming birthday (daysRemaining ascending)
      final initialCards = tester.widgetList<BirthdayCard>(find.byType(BirthdayCard)).toList();
      for (int i = 0; i < initialCards.length - 1; i++) {
        expect(
          initialCards[i].birthday.daysRemaining <= initialCards[i + 1].birthday.daysRemaining,
          isTrue,
        );
      }

      // Open sort popup and pick 'Sort by name (A-Z)'
      final sortButton = find.byType(PopupMenuButton<BirthdaySortOption>);
      await tester.tap(sortButton);
      await tester.pumpAndSettle();

      final sortByNameOption = find.text('Name (A-Z)');
      await tester.tap(sortByNameOption);
      await tester.pumpAndSettle();

      // Verify sorted alphabetically
      final sortedCards = tester.widgetList<BirthdayCard>(find.byType(BirthdayCard)).toList();
      for (int i = 0; i < sortedCards.length - 1; i++) {
        expect(
          sortedCards[i].birthday.name.toLowerCase().compareTo(
                sortedCards[i + 1].birthday.name.toLowerCase(),
              ) <=
              0,
          isTrue,
        );
      }
    });

    testWidgets('Tapping BirthdayCard navigates to Birthday Details route',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap the first birthday card
      final firstCard = find.byType(BirthdayCard).first;
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Expect navigation to details screen
      expect(find.text('Birthday Details Screen'), findsOneWidget);
    });

    testWidgets('Shows empty state UI when search returns no matching birthdays',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Search for nonexistent person
      await tester.enterText(find.byType(TextField), 'NonexistentPersonXYZ');
      await tester.pumpAndSettle();

      expect(find.text('No birthdays found'), findsOneWidget);
      expect(find.text('Reset Search & Filters'), findsOneWidget);

      // Tap Reset Search & Filters
      await tester.tap(find.text('Reset Search & Filters'));
      await tester.pumpAndSettle();

      expect(find.byType(BirthdayCard), findsWidgets);
    });

    testWidgets('Shows global empty state UI when no birthdays exist in provider',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final emptyProvider = BirthdayProvider();
      // Remove all birthdays
      for (final b in List<Birthday>.from(emptyProvider.birthdays)) {
        emptyProvider.deleteBirthday(b.id);
      }

      await tester.pumpWidget(buildTestWidget(birthdayProvider: emptyProvider));
      await tester.pumpAndSettle();

      expect(find.text('No birthdays added yet!'), findsOneWidget);
      expect(find.text('Add Birthday'), findsWidgets);
    });
  });
}
