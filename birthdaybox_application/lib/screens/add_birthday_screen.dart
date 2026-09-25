import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Placeholder screen for Add Birthday Form.
/// Will be expanded in Forms & Validation (Lab 7a & 7b).
class AddBirthdayScreen extends StatelessWidget {
  const AddBirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Birthday'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cake, size: 64, color: colorScheme.secondary),
              const SizedBox(height: 16),
              Text('Add Birthday Screen', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Route: ${AppRoutes.addBirthday}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save & Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
