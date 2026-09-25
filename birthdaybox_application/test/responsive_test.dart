import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';
import 'package:birthdaybox_application/screens/birthdays_screen.dart';
import 'package:birthdaybox_application/screens/dashboard_screen.dart';
import 'package:birthdaybox_application/widgets/responsive_layout.dart';

void main() {
  group('BirthdayBox Responsive Behavior & Breakpoint Tests (Lab 3a & 3b)', () {
    Widget buildTestApp(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('Mobile (< 600px): Bottom Navigation and Single-Column Cards render without overflow at 320px',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      // Verify no overflow and mobile badge displayed
      expect(find.text('Mobile (Single Column)'), findsOneWidget);

      // Verify Bottom Navigation Bar is present
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Birthdays'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify Single-Column: no GridView on mobile dashboard
      expect(find.byType(GridView), findsNothing);

      // Verify Header & Stats
      expect(find.text('BirthdayBox'), findsOneWidget);
      expect(find.text('Total Birthdays'), findsOneWidget);
    });

    testWidgets('Mobile (< 600px): Standard 400px width renders cleanly without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Mobile (Single Column)'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Total Birthdays'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
      expect(find.text("Today's"), findsOneWidget);
    });

    testWidgets('Mobile (< 600px): Boundary test at 599px',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(599, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Mobile (Single Column)'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Tablet (600px - 1023px): Lower boundary at 600px renders 2-column cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(600, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      // Tablet badge
      expect(find.text('Tablet (2-Column Adaptive)'), findsOneWidget);

      // No Bottom Navigation Bar on tablet
      expect(find.byType(BottomNavigationBar), findsNothing);

      // Two-column GridView is rendered
      expect(find.byType(GridView), findsOneWidget);
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('Tablet (600px - 1023px): Standard 768px (iPad) renders with 2-column cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Tablet (2-Column Adaptive)'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Tablet (600px - 1023px): Upper boundary at 1023px renders as tablet',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1023, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Tablet (2-Column Adaptive)'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Desktop (>= 1024px): Lower boundary at 1024px renders Sidebar & Multi-Column',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      // Desktop layout badge
      expect(find.text('Dashboard (Sidebar + Multi-Column)'), findsOneWidget);

      // Sidebar links
      expect(find.text('All Birthdays'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('Desktop (>= 1024px): Widescreen 1440px renders Sidebar and Multi-Column without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(const DashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard (Sidebar + Multi-Column)'), findsOneWidget);
      expect(find.text('All Birthdays'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('BirthdaysScreen adapts responsively: 1 col on Mobile, 2 col on Tablet, 3 col on Desktop',
        (WidgetTester tester) async {
      // 1. Mobile (400px): Single-column list
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(buildTestApp(const BirthdaysScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Birthdays List'), findsOneWidget);
      expect(find.byType(GridView), findsNothing); // single column

      // 2. Tablet (768px): 2-column GridView
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pumpWidget(buildTestApp(const BirthdaysScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      var gridView = tester.widget<GridView>(find.byType(GridView));
      var delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);

      // 3. Desktop (1280px): 3-column GridView
      tester.view.physicalSize = const Size(1280, 900);
      await tester.pumpWidget(buildTestApp(const BirthdaysScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      gridView = tester.widget<GridView>(find.byType(GridView));
      delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3);

      tester.view.resetPhysicalSize();
    });

    testWidgets('ResponsiveLayout helper methods return correct values',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveLayout.isMobile(context), isTrue);
              expect(ResponsiveLayout.isTablet(context), isFalse);
              expect(ResponsiveLayout.isDesktop(context), isFalse);
              expect(ResponsiveLayout.getDeviceType(context), DeviceType.mobile);
              expect(ResponsiveLayout.cardColumnCount(context), 1);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
