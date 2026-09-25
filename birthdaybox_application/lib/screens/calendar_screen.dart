import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Placeholder screen for Calendar.
/// Will be expanded in calendar view.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Calendar'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month_outlined, size: 64, color: colorScheme.secondary),
              const SizedBox(height: 16),
              Text('Birthday Calendar Screen', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Route: ${AppRoutes.calendar}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
