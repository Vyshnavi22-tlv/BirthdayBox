import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/birthday_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BirthdayProvider()),
      ],
      child: const BirthdayBoxApp(),
    ),
  );
}

/// Root application widget for BirthdayBox.
/// Uses `Consumer<ThemeProvider>` to rebuild `MaterialApp` when the theme mode changes.
/// Demonstrates Provider state management (Lab Experiment 5b).
class BirthdayBoxApp extends StatelessWidget {
  const BirthdayBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
