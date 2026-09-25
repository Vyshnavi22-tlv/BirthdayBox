import 'package:flutter/foundation.dart';
import '../models/birthday_model.dart';

/// BirthdayProvider manages the list of birthdays and handles CRUD operations.
/// Demonstrates State Management with Provider (Lab Experiment 5b).
class BirthdayProvider extends ChangeNotifier {
  final List<BirthdayModel> _birthdays = [
    BirthdayModel(
      id: '1',
      name: 'Ananya Sharma',
      dateOfBirth: DateTime(2003, 10, 15),
      relationship: 'Friend',
      phoneNumber: '9876543210',
      notes: 'Loves chocolate cake and books',
      avatarEmoji: '🌸',
    ),
    BirthdayModel(
      id: '2',
      name: 'Rahul Verma',
      dateOfBirth: DateTime(1998, 5, 20),
      relationship: 'Colleague',
      phoneNumber: '9123456780',
      notes: 'Coffee enthusiast',
      avatarEmoji: '⭐',
    ),
    BirthdayModel(
      id: '3',
      name: 'Mom',
      dateOfBirth: DateTime(1975, 12, 5),
      relationship: 'Family',
      phoneNumber: '9848022338',
      notes: 'Make sure to order flowers early',
      avatarEmoji: '💖',
    ),
  ];

  /// Unmodifiable view of all birthdays
  List<BirthdayModel> get birthdays => List.unmodifiable(_birthdays);

  /// Total number of birthdays saved
  int get totalCount => _birthdays.length;

  /// Birthdays occurring today
  List<BirthdayModel> get todayBirthdays {
    return _birthdays.where((b) => b.isToday).toList();
  }

  /// Upcoming birthdays sorted by nearest upcoming date
  List<BirthdayModel> get upcomingBirthdays {
    final list = List<BirthdayModel>.from(_birthdays);
    list.sort((a, b) => a.daysUntilNextBirthday.compareTo(b.daysUntilNextBirthday));
    return list;
  }

  /// Count of birthdays in the next 30 days
  int get upcomingThisMonthCount {
    return _birthdays.where((b) => b.daysUntilNextBirthday <= 30).length;
  }

  /// Add a new birthday
  void addBirthday(BirthdayModel birthday) {
    _birthdays.add(birthday);
    notifyListeners();
  }

  /// Update an existing birthday entry
  void updateBirthday(BirthdayModel updated) {
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
  BirthdayModel? findById(String id) {
    try {
      return _birthdays.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
