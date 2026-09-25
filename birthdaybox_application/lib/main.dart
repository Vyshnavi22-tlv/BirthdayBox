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
/// Configures MaterialApp with Light/Dark themes and AppRoutes.
class BirthdayBoxApp extends StatelessWidget {
  const BirthdayBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
