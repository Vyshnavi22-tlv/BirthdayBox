import 'package:flutter/material.dart';

/// Reusable CustomButton with support for icons, full-width styling, and loading states.
/// Demonstrates Custom Widgets (Lab Experiment 6a).
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      final spinner = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? colorScheme.primary : Colors.white,
          ),
        ),
      );

      if (isOutlined) {
        return OutlinedButton(
          onPressed: null,
          child: spinner,
        );
      }

      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.7),
        ),
        child: spinner,
      );
    }

    if (isOutlined) {
      if (icon != null) {
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(text),
        );
      }
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(text),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
