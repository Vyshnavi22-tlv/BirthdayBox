import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:birthdaybox_application/main.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';
import 'package:birthdaybox_application/providers/theme_provider.dart';

void main() {
  testWidgets('BirthdayBoxApp foundation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ],
        child: const BirthdayBoxApp(),
      ),
    );

    // Verify that the title appears.
    expect(find.text('BirthdayBox'), findsOneWidget);
  });
}
