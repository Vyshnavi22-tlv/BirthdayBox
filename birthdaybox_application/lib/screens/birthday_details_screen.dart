import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Placeholder screen for Birthday Details.
/// Will be expanded in details view and animations (Lab 8a & 8b).
class BirthdayDetailsScreen extends StatelessWidget {
  const BirthdayDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard, size: 64, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text('Birthday Details Screen', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Route: ${AppRoutes.birthdayDetails}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Previous Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
