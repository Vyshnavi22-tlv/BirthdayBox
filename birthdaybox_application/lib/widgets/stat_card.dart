import 'package:flutter/material.dart';

/// StatCard displays a summary metric on the dashboard.
/// Demonstrates Custom Widgets (Lab Experiment 6a) & Row/Column layouts (Lab Experiment 2b).
class StatCard extends StatelessWidget {
  final dynamic icon; // Can be an IconData, String (emoji), or Widget
  final String number;
  final String label;
  final Color? accentColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.number,
    required this.label,
    this.accentColor,
    this.onTap,
  });

  Widget _buildIcon(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    if (icon is IconData) {
      return Icon(icon as IconData, size: 28, color: color);
    } else if (icon is String) {
      return Text(
        icon as String,
        style: const TextStyle(fontSize: 28),
      );
    } else if (icon is Widget) {
      return icon as Widget;
    }
    return Icon(Icons.cake, size: 28, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = accentColor ?? colorScheme.primary;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(context),
          const SizedBox(height: 8),
          Text(
            number,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Card(
      child: content,
    );
  }
}
