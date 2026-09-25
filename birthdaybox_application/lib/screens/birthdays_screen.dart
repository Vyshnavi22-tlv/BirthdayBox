import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/birthday_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/birthday_card.dart';
import '../widgets/custom_button.dart';

/// Screen displaying all birthdays using reusable BirthdayCard widgets.
/// Demonstrates Custom Widgets (Lab Experiment 6a) & State from Provider (Lab Experiment 5b).
class BirthdaysScreen extends StatelessWidget {
  const BirthdaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final birthdayProvider = Provider.of<BirthdayProvider>(context);
    final birthdays = birthdayProvider.upcomingBirthdays;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthdays List'),
        actions: [
          IconButton(
            tooltip: 'Add Birthday',
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: birthdays.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎂', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text('No birthdays added yet!', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        child: CustomButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                          text: 'Add Birthday',
                          icon: Icons.add,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    Row(
                      children: [
                        Text(
                          'All Birthdays (${birthdays.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Sorted by upcoming date',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...birthdays.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BirthdayCard(
                            birthday: b,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.birthdayDetails,
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                      text: 'Add New Birthday',
                      icon: Icons.add,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
