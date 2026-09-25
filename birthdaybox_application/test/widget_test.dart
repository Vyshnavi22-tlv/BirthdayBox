import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/main.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';

void main() {
  testWidgets('BirthdayBoxApp foundation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const BirthdayBoxApp(),
      ),
    );

    // Verify home screen is loaded
    expect(find.text('BirthdayBox'), findsOneWidget);
    expect(find.text('Named Routes Navigation (Lab 4a & 4b)'), findsOneWidget);
  });

  testWidgets('Named routes navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const BirthdayBoxApp(),
      ),
    );

    // Tap on '/birthdays' route button
    await tester.tap(find.text('/birthdays'));
    await tester.pumpAndSettle();

    // Verify BirthdaysScreen placeholder is displayed
    expect(find.text('Birthdays List'), findsOneWidget);
    expect(find.text('Route: /birthdays'), findsOneWidget);
  });
}
