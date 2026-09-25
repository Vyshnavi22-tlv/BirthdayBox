import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/birthday_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/birthday_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_layout.dart';

/// Screen displaying all birthdays using reusable BirthdayCard widgets.
/// Demonstrates Custom Widgets (Lab Experiment 6a), Responsive UI (Lab Experiments 3a & 3b),
/// and State Management with Provider (Lab Experiment 5b).
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
          constraints: const BoxConstraints(maxWidth: 1100),
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
              : ResponsiveLayout.builder(
                  builder: (context, constraints, deviceType) {
                    final horizontalPadding = switch (deviceType) {
                      DeviceType.mobile => 16.0,
                      DeviceType.tablet => 24.0,
                      DeviceType.desktop => 32.0,
                    };

                    final gridColumns = switch (deviceType) {
                      DeviceType.mobile => 1,
                      DeviceType.tablet => 2,
                      DeviceType.desktop => 3,
                    };

                    return ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              'All Birthdays (${birthdays.length})',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Sorted by upcoming date',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (gridColumns == 1)
                          // Mobile: Single-column list
                          ...birthdays.map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: BirthdayCard(
                                  birthday: b,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.birthdayDetails,
                                  ),
                                ),
                              ))
                        else
                          // Tablet & Desktop: Multi-column grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridColumns,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              mainAxisExtent: 115,
                            ),
                            itemCount: birthdays.length,
                            itemBuilder: (context, index) {
                              final b = birthdays[index];
                              return BirthdayCard(
                                birthday: b,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.birthdayDetails,
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.addBirthday),
                          text: 'Add New Birthday',
                          icon: Icons.add,
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
