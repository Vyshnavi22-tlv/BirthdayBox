import 'package:flutter_test/flutter_test.dart';
import 'package:birthdaybox_application/models/birthday.dart';
import 'package:birthdaybox_application/providers/birthday_provider.dart';

void main() {
  group('BirthdayProvider Tests (Lab 5b Provider State Management)', () {
    late BirthdayProvider provider;

    setUp(() {
      provider = BirthdayProvider();
    });

    test('Initializes with sample birthdays', () {
      expect(provider.birthdays.isNotEmpty, isTrue);
      expect(provider.totalBirthdayCount, equals(provider.birthdays.length));
    });

    test('addBirthday adds entry and notifies listeners', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      final initialCount = provider.totalBirthdayCount;
      final newBirthday = Birthday(
        id: 'new-test-id',
        name: 'New Friend',
        dateOfBirth: DateTime(2002, 7, 20),
        relationship: 'Friend',
      );

      provider.addBirthday(newBirthday);

      expect(provider.totalBirthdayCount, equals(initialCount + 1));
      expect(provider.findById('new-test-id'), isNotNull);
      expect(notified, isTrue);
    });

    test('updateBirthday updates entry and notifies listeners', () {
      bool notified = false;
      final targetId = provider.birthdays.first.id;

      provider.addListener(() {
        notified = true;
      });

      final updated = provider.birthdays.first.copyWith(
        name: 'Updated Name',
        notes: 'Updated special note',
      );

      provider.updateBirthday(updated);

      final found = provider.findById(targetId);
      expect(found?.name, equals('Updated Name'));
      expect(found?.notes, equals('Updated special note'));
      expect(notified, isTrue);
    });

    test('deleteBirthday removes entry and notifies listeners', () {
      bool notified = false;
      final targetId = provider.birthdays.first.id;
      final initialCount = provider.totalBirthdayCount;

      provider.addListener(() {
        notified = true;
      });

      provider.deleteBirthday(targetId);

      expect(provider.totalBirthdayCount, equals(initialCount - 1));
      expect(provider.findById(targetId), isNull);
      expect(notified, isTrue);
    });

    test('upcomingBirthdays is sorted by daysRemaining', () {
      final upcoming = provider.upcomingBirthdays;
      for (int i = 0; i < upcoming.length - 1; i++) {
        expect(
          upcoming[i].daysRemaining <= upcoming[i + 1].daysRemaining,
          isTrue,
        );
      }
    });

    test('todayBirthdays correctly identifies birthdays happening today', () {
      final now = DateTime.now();
      final todayEntry = Birthday(
        id: 'today-id',
        name: 'Today Celebrant',
        dateOfBirth: DateTime(1996, now.month, now.day),
        relationship: 'Family',
      );
      provider.addBirthday(todayEntry);

      final todayList = provider.todayBirthdays;
      expect(todayList.any((b) => b.id == 'today-id'), isTrue);
    });

    test('thisMonthsBirthdays returns birthdays occurring in current month', () {
      final currentMonth = DateTime.now().month;
      final monthList = provider.thisMonthsBirthdays;
      for (final b in monthList) {
        expect(b.dateOfBirth.month, equals(currentMonth));
      }
      expect(provider.thisMonthsBirthdayCount, equals(monthList.length));
    });
  });
}
