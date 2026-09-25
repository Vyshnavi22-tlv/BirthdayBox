import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Placeholder screen for Birthday list.
/// Will be expanded in custom widgets and list presentation.
class BirthdaysScreen extends StatelessWidget {
  const BirthdaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthdays List'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cake_outlined, size: 64, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text('All Birthdays Screen', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Route: ${AppRoutes.birthdays}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                icon: const Icon(Icons.add),
                label: const Text('Add New Birthday'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.birthdayDetails),
                icon: const Icon(Icons.info_outline),
                label: const Text('View Sample Birthday Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
