/// Birthday data model representing an individual's birthday entry.
/// Demonstrates Dart Basics (Lab Experiment 1b):
/// - Class definitions and constructors
/// - Encapsulation and getters
/// - Null safety and optional parameters
/// - DateTime calculations (age, days until birthday)
class BirthdayModel {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String relationship;
  final String phoneNumber;
  final String notes;
  final String avatarEmoji;

  const BirthdayModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.relationship,
    this.phoneNumber = '',
    this.notes = '',
    this.avatarEmoji = '🎂',
  });

  /// Calculate the person's current age based on birth year.
  int get age {
    final now = DateTime.now();
    int currentAge = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      currentAge--;
    }
    return currentAge >= 0 ? currentAge : 0;
  }

  /// Calculates the next occurrence of this birthday.
  DateTime get nextBirthday {
    final now = DateTime.now();
    DateTime next = DateTime(now.year, dateOfBirth.month, dateOfBirth.day);
    // If birthday has already occurred this year, next occurrence is next year
    if (next.isBefore(DateTime(now.year, now.month, now.day))) {
      next = DateTime(now.year + 1, dateOfBirth.month, dateOfBirth.day);
    }
    return next;
  }

  /// Calculates number of days remaining until next birthday.
  int get daysUntilNextBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = nextBirthday;
    return target.difference(today).inDays;
  }

  /// Checks if the birthday is today.
  bool get isToday {
    final now = DateTime.now();
    return dateOfBirth.month == now.month && dateOfBirth.day == now.day;
  }

  /// Month name helper without external dependencies.
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Human-readable birthday string (e.g. "15 October").
  String get formattedDate {
    final monthName = _monthNames[dateOfBirth.month - 1];
    return '${dateOfBirth.day} $monthName';
  }

  /// Returns full birth date formatted (e.g. "15 October 2004").
  String get formattedFullDate {
    final monthName = _monthNames[dateOfBirth.month - 1];
    return '${dateOfBirth.day} $monthName ${dateOfBirth.year}';
  }

  /// Creates a copy of this BirthdayModel with optional updated fields.
  BirthdayModel copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? relationship,
    String? phoneNumber,
    String? notes,
    String? avatarEmoji,
  }) {
    return BirthdayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relationship: relationship ?? this.relationship,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }

  /// Converts model to Map for storage or debugging.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'notes': notes,
      'avatarEmoji': avatarEmoji,
    };
  }

  /// Creates a BirthdayModel from Map data.
  factory BirthdayModel.fromMap(Map<String, dynamic> map) {
    return BirthdayModel(
      id: map['id'] as String,
      name: map['name'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      relationship: map['relationship'] as String,
      phoneNumber: (map['phoneNumber'] as String?) ?? '',
      notes: (map['notes'] as String?) ?? '',
      avatarEmoji: (map['avatarEmoji'] as String?) ?? '🎂',
    );
  }
}
