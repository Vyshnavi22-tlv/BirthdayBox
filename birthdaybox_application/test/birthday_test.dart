import 'package:flutter_test/flutter_test.dart';
import 'package:birthdaybox_application/models/birthday.dart';

void main() {
  group('Birthday Model Tests (Lab 1b Dart Basics)', () {
    test('Calculates next birthday correctly for future date this year', () {
      final now = DateTime.now();
      // Future date 10 days from today
      final futureDate = now.add(const Duration(days: 10));

      final birthday = Birthday(
        id: '1',
        name: 'Future Friend',
        dateOfBirth: DateTime(2000, futureDate.month, futureDate.day),
        relationship: 'Friend',
      );

      final next = birthday.nextBirthday;
      expect(next.year, equals(now.year));
      expect(next.month, equals(futureDate.month));
      expect(next.day, equals(futureDate.day));
      expect(birthday.daysRemaining, equals(10));
      expect(birthday.isToday, isFalse);
    });

    test('Calculates next birthday correctly when birthday has already passed this year', () {
      final now = DateTime.now();
      // Past date 10 days before today
      final pastDate = now.subtract(const Duration(days: 10));

      final birthday = Birthday(
        id: '2',
        name: 'Past Colleague',
        dateOfBirth: DateTime(1995, pastDate.month, pastDate.day),
        relationship: 'Colleague',
      );

      final next = birthday.nextBirthday;
      // Should roll over to next year!
      expect(next.year, equals(now.year + 1));
      expect(next.month, equals(pastDate.month));
      expect(next.day, equals(pastDate.day));
      expect(birthday.daysRemaining, greaterThan(350));
      expect(birthday.isToday, isFalse);
    });

    test('Identifies today as birthday correctly', () {
      final now = DateTime.now();
      final birthday = Birthday(
        id: '3',
        name: 'Birthday Star',
        dateOfBirth: DateTime(1999, now.month, now.day),
        relationship: 'Family',
      );

      expect(birthday.isToday, isTrue);
      expect(birthday.daysRemaining, equals(0));
      expect(birthday.nextBirthday.year, equals(now.year));
    });

    test('Calculates correct age', () {
      final now = DateTime.now();
      final birthday = Birthday(
        id: '4',
        name: 'Age Test',
        dateOfBirth: DateTime(now.year - 20, now.month, now.day),
        relationship: 'Friend',
      );

      expect(birthday.age, equals(20));
    });

    test('Provides diverse sample birthdays for development and testing', () {
      final samples = Birthday.sampleBirthdays;
      expect(samples.length, greaterThanOrEqualTo(3));
      expect(samples.any((b) => b.isToday), isTrue);
      expect(samples.any((b) => b.relationship == 'Friend'), isTrue);
      expect(samples.any((b) => b.relationship == 'Family'), isTrue);
    });
  });
}
