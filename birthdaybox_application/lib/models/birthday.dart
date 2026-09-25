/// Birthday data model representing a person's birthday record.
/// Demonstrates Dart Basics (Lab Experiment 1b):
/// - Class definitions, constructors, and encapsulation
/// - Null safety and default values
/// - DateTime calculations (handling past birthdays, leap years, days remaining, age)
class Birthday {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String relationship;
  final String phone;
  final String notes;
  final String imagePath; // Image path or emoji identifier (e.g. '🎂', 'assets/...')

  Birthday({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.relationship,
    String? phone,
    String? phoneNumber,
    this.notes = '',
    String? imagePath,
    String? avatarEmoji,
  })  : phone = phone ?? phoneNumber ?? '',
        imagePath = imagePath ?? avatarEmoji ?? '🎂';

  // Backward compatibility getter for existing widgets
  String get phoneNumber => phone;
  String get avatarEmoji => imagePath.isNotEmpty ? imagePath : '🎂';

  /// Helper: Calculates the next upcoming occurrence of this birthday.
  /// Correctly handles birthdays that have already occurred earlier this year.
  DateTime get nextBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int month = dateOfBirth.month;
    int day = dateOfBirth.day;

    DateTime thisYearBirthday;
    // Handle leap day (Feb 29) on non-leap years
    if (month == 2 && day == 29 && !_isLeapYear(now.year)) {
      thisYearBirthday = DateTime(now.year, 2, 28);
    } else {
      thisYearBirthday = DateTime(now.year, month, day);
    }

    // If birthday has already occurred this year, the next birthday is next year
    if (thisYearBirthday.isBefore(today)) {
      final nextYear = now.year + 1;
      if (month == 2 && day == 29 && !_isLeapYear(nextYear)) {
        return DateTime(nextYear, 2, 28);
      }
      return DateTime(nextYear, month, day);
    }

    return thisYearBirthday;
  }

  /// Helper: Calculates number of days remaining until the next birthday.
  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return nextBirthday.difference(today).inDays;
  }

  // Backward compatibility alias for days remaining
  int get daysUntilNextBirthday => daysRemaining;

  /// Helper: Determines whether today is the person's birthday.
  bool get isToday {
    final now = DateTime.now();
    return dateOfBirth.month == now.month && dateOfBirth.day == now.day;
  }

  /// Helper: Calculates the person's current age.
  int get age {
    final now = DateTime.now();
    int currentAge = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      currentAge--;
    }
    return currentAge >= 0 ? currentAge : 0;
  }

  /// Leap year helper
  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Month name list
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

  /// Human-readable formatted date string (e.g. "15 October")
  String get formattedDate {
    final monthName = _monthNames[dateOfBirth.month - 1];
    return '${dateOfBirth.day} $monthName';
  }

  /// Full birth date (e.g. "15 October 2003")
  String get formattedFullDate {
    final monthName = _monthNames[dateOfBirth.month - 1];
    return '${dateOfBirth.day} $monthName ${dateOfBirth.year}';
  }

  /// Copy with helper
  Birthday copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? relationship,
    String? phone,
    String? notes,
    String? imagePath,
  }) {
    return Birthday(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  /// Converts to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'relationship': relationship,
      'phone': phone,
      'notes': notes,
      'imagePath': imagePath,
    };
  }

  /// Constructs from Map
  factory Birthday.fromMap(Map<String, dynamic> map) {
    return Birthday(
      id: map['id'] as String,
      name: map['name'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      relationship: map['relationship'] as String,
      phone: (map['phone'] as String?) ?? (map['phoneNumber'] as String?) ?? '',
      notes: (map['notes'] as String?) ?? '',
      imagePath: (map['imagePath'] as String?) ?? (map['avatarEmoji'] as String?) ?? '🎂',
    );
  }

  // ==========================================
  // SAMPLE BIRTHDAYS FOR DEVELOPMENT & TESTING
  // ==========================================
  static List<Birthday> get sampleBirthdays {
    final now = DateTime.now();

    // 1. Birthday occurring in 3 days (upcoming)
    final upcomingDate = now.add(const Duration(days: 3));

    // 2. Birthday that occurred 15 days ago this year (tests next year handling)
    final pastDate = now.subtract(const Duration(days: 15));

    // 3. Birthday occurring today
    final todayDate = now;

    return [
      Birthday(
        id: 'sample-1',
        name: 'Ananya Sharma',
        dateOfBirth: DateTime(2003, upcomingDate.month, upcomingDate.day),
        relationship: 'Friend',
        phone: '9876543210',
        notes: 'Loves fantasy novels and blueberry cheesecake',
        imagePath: '🌸',
      ),
      Birthday(
        id: 'sample-2',
        name: 'Dad',
        dateOfBirth: DateTime(1972, todayDate.month, todayDate.day),
        relationship: 'Family',
        phone: '9848022338',
        notes: 'Order customized watch and dinner reservation',
        imagePath: '💖',
      ),
      Birthday(
        id: 'sample-3',
        name: 'Rahul Verma',
        dateOfBirth: DateTime(1998, pastDate.month, pastDate.day),
        relationship: 'Colleague',
        phone: '9123456780',
        notes: 'Coffee lover; birthday celebrated already this year',
        imagePath: '⭐',
      ),
      Birthday(
        id: 'sample-4',
        name: 'Priya Patel',
        dateOfBirth: DateTime(2001, 11, 28),
        relationship: 'Relative',
        phone: '9988776655',
        notes: 'Send greeting card',
        imagePath: '🎁',
      ),
    ];
  }
}

/// Backward compatibility alias
typedef BirthdayModel = Birthday;
