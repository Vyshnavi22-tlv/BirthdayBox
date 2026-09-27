import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/routes/app_routes.dart';
import 'package:birthdaybox_application/screens/dashboard_screen.dart';
import 'package:birthdaybox_application/widgets/responsive_scaffold.dart';

void main() {
  group('BirthdayBox Responsive Navigation Tests', () {
    late ThemeProvider themeProvider;
    late BirthdayProvider birthdayProvider;

    setUp(() {
      themeProvider = ThemeProvider();
      birthdayProvider = BirthdayProvider();
    });

    Widget buildTestApp({
      Widget? home,
      String? initialRoute,
      NavigatorObserver? observer,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<BirthdayProvider>.value(value: birthdayProvider),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, tp, _) {
            return MaterialApp(
              theme: ThemeData.light(useMaterial3: true),
              darkTheme: ThemeData.dark(useMaterial3: true),
              themeMode: tp.themeMode,
              initialRoute: initialRoute,
              routes: {
                AppRoutes.dashboard: (_) => const DashboardScreen(),
                AppRoutes.birthdays: (_) => const Scaffold(body: Text('Birthdays Screen Target')),
                AppRoutes.calendar: (_) => const Scaffold(body: Text('Calendar Screen Target')),
                AppRoutes.profile: (_) => const Scaffold(body: Text('Profile Screen Target')),
                AppRoutes.addBirthday: (_) => const Scaffold(body: Text('Add Birthday Screen Target')),
              },
              home: initialRoute == null ? (home ?? const DashboardScreen()) : null,
              navigatorObservers: observer != null ? [observer] : [],
            );
          },
        ),
      );
    }

    testWidgets('Mobile (< 600px): Uses BottomNavigationBar with 4 destinations', (tester) async {
      tester.view.physicalSize = const Size(390, 844); // iPhone-like width
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Mobile bottom navigation is displayed
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify the 4 destinations
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Birthdays'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // NavigationRail is not present on mobile
      expect(find.byType(NavigationRail), findsNothing);

      // Tapping Birthdays navigates using named route
      await tester.tap(find.text('Birthdays'));
      await tester.pumpAndSettle();
      expect(find.text('Birthdays Screen Target'), findsOneWidget);
    });

    testWidgets('Tablet (600px–1023px): Uses NavigationRail with 4 destinations', (tester) async {
      tester.view.physicalSize = const Size(768, 1024); // iPad portrait width
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // NavigationRail is displayed
      expect(find.byType(NavigationRail), findsOneWidget);

      // BottomNavigationBar is not present on tablet
      expect(find.byType(BottomNavigationBar), findsNothing);

      // Verify destinations on rail
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Birthdays'), findsOneWidget);
      expect(find.text('Calendar'), findsWidgets);
      expect(find.text('Profile'), findsWidgets);

      // Tapping Calendar navigates using named route
      final calendarFinder = find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Calendar'),
      );
      expect(calendarFinder, findsOneWidget);
      await tester.tap(calendarFinder);
      await tester.pumpAndSettle();
      expect(find.text('Calendar Screen Target'), findsOneWidget);
    });

    testWidgets('Desktop (>= 1024px): Uses permanent sidebar with 4 destinations and branding', (tester) async {
      tester.view.physicalSize = const Size(1280, 800); // Desktop width
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Neither BottomNavigationBar nor NavigationRail should be used
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsNothing);

      // Desktop branding
      expect(find.text('BirthdayBox'), findsWidgets);
      expect(find.text('Reminder App'), findsOneWidget);

      // Sidebar destinations
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Birthdays'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Profile'), findsWidgets);

      // Quick action
      expect(find.text('Add Birthday'), findsWidgets);

      // Tapping Profile navigates to profile route
      final profileTile = find.widgetWithText(ListTile, 'Profile');
      expect(profileTile, findsOneWidget);
      await tester.tap(profileTile);
      await tester.pumpAndSettle();
      expect(find.text('Profile Screen Target'), findsOneWidget);
    });

    testWidgets('Visual consistency across Light and Dark themes', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Starts in light theme by default
      expect(themeProvider.isDarkMode, isFalse);
      expect(find.text('Dark Mode'), findsOneWidget);

      // Tap Dark Mode toggle tile in sidebar
      await tester.tap(find.text('Dark Mode'));
      await tester.pumpAndSettle();

      // Switched to Dark Mode
      expect(themeProvider.isDarkMode, isTrue);
      expect(find.text('Light Mode'), findsOneWidget);

      // Toggle back to Light Mode
      await tester.tap(find.text('Light Mode'));
      await tester.pumpAndSettle();
      expect(themeProvider.isDarkMode, isFalse);
    });

    testWidgets('ResponsiveScaffold handles custom nav index and callbacks', (tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
            ChangeNotifierProvider<BirthdayProvider>.value(value: birthdayProvider),
          ],
          child: MaterialApp(
            home: ResponsiveScaffold(
              title: const Text('Custom Nav'),
              currentNavIndex: 2,
              onNavIndexChanged: (idx) => tappedIndex = idx,
              body: const Text('Body Content'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // On mobile default size, tapping index 1 triggers callback with 1
      await tester.tap(find.text('Birthdays'));
      await tester.pump();
      expect(tappedIndex, 1);
    });
  });
}
