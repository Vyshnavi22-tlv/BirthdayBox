import 'package:flutter/foundation.dart';
import '../models/birthday.dart';

/// BirthdayProvider manages the list of birthdays and handles CRUD operations.
/// Demonstrates State Management with Provider (Lab Experiment 5b).
class BirthdayProvider extends ChangeNotifier {
  // Initialized with sample birthdays for development and testing
  final List<Birthday> _birthdays = List.from(Birthday.sampleBirthdays);

  /// Unmodifiable view of all birthdays
  List<Birthday> get birthdays => List.unmodifiable(_birthdays);

  /// Total number of birthdays saved
  int get totalCount => _birthdays.length;

  /// Birthdays occurring today
  List<Birthday> get todayBirthdays {
    return _birthdays.where((b) => b.isToday).toList();
  }

  /// Upcoming birthdays sorted by nearest upcoming date
  List<Birthday> get upcomingBirthdays {
    final list = List<Birthday>.from(_birthdays);
    list.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return list;
  }

  /// Count of birthdays in the next 30 days
  int get upcomingThisMonthCount {
    return _birthdays.where((b) => b.daysRemaining <= 30).length;
  }

  /// Add a new birthday
  void addBirthday(Birthday birthday) {
    _birthdays.add(birthday);
    notifyListeners();
  }

  /// Update an existing birthday entry
  void updateBirthday(Birthday updated) {
    final index = _birthdays.indexWhere((b) => b.id == updated.id);
    if (index != -1) {
      _birthdays[index] = updated;
      notifyListeners();
    }
  }

  /// Remove a birthday entry by ID
  void deleteBirthday(String id) {
    _birthdays.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// Find a birthday by ID
  Birthday? findById(String id) {
    try {
      return _birthdays.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
