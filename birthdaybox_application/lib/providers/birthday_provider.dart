import 'package:flutter/foundation.dart';
import '../models/birthday.dart';

/// BirthdayProvider manages the state of the birthday list across the application.
/// Demonstrates State Management with Provider & ChangeNotifier (Lab Experiment 5b).
///
/// Implements:
/// - get birthdays
/// - addBirthday()
/// - updateBirthday()
/// - deleteBirthday()
/// - get upcoming birthdays
/// - get today's birthdays
/// - get this month's birthdays
/// - get total birthday count
class BirthdayProvider extends ChangeNotifier {
  // Initialized with existing sample birthday data for development and testing
  final List<Birthday> _birthdays = List.from(Birthday.sampleBirthdays);

  /// 1. get birthdays: Returns an unmodifiable list of all stored birthdays
  List<Birthday> get birthdays => List.unmodifiable(_birthdays);

  /// 2. get total birthday count: Total count of all birthdays
  int get totalBirthdayCount => _birthdays.length;
  int get totalBirthdays => totalBirthdayCount;
  int get totalCount => totalBirthdayCount;

  /// 3. get today's birthdays: List of birthdays occurring today
  List<Birthday> get todayBirthdays {
    return _birthdays.where((b) => b.isToday).toList();
  }
  List<Birthday> get todaysBirthdays => todayBirthdays;

  /// 4. get upcoming birthdays: Sorted chronologically by days remaining
  List<Birthday> get upcomingBirthdays {
    final list = List<Birthday>.from(_birthdays);
    list.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return list;
  }

  /// 5. get this month's birthdays: Birthdays occurring in the current calendar month
  List<Birthday> get thisMonthsBirthdays {
    final currentMonth = DateTime.now().month;
    return _birthdays.where((b) => b.dateOfBirth.month == currentMonth).toList();
  }
  int get thisMonthsBirthdayCount => thisMonthsBirthdays.length;

  /// Helper for 30-day upcoming countdown
  List<Birthday> get next30DaysBirthdays {
    return _birthdays.where((b) => b.daysRemaining <= 30).toList();
  }
  int get upcomingThisMonthCount => next30DaysBirthdays.length;

  /// 6. addBirthday(): Adds a new birthday and notifies listeners
  void addBirthday(Birthday birthday) {
    _birthdays.add(birthday);
    notifyListeners();
  }

  /// 7. updateBirthday(): Updates an existing birthday and notifies listeners
  void updateBirthday(Birthday updated) {
    final index = _birthdays.indexWhere((b) => b.id == updated.id);
    if (index != -1) {
      _birthdays[index] = updated;
      notifyListeners();
    }
  }

  /// 8. deleteBirthday(): Deletes a birthday by ID and notifies listeners
  void deleteBirthday(String id) {
    final initialLength = _birthdays.length;
    _birthdays.removeWhere((b) => b.id == id);
    if (_birthdays.length != initialLength) {
      notifyListeners();
    }
  }

  /// Helper: Look up a birthday by ID
  Birthday? findById(String id) {
    try {
      return _birthdays.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
