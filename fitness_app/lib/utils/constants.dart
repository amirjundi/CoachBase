class Constants {
  // App Info
  static const String appName = 'مدرب مجدل';
  static const String appVersion = '1.0.0';

  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'مبتدئ',
    'متوسط',
    'متقدم',
    'خبير',
  ];

  // Subscription Durations (in months)
  static const List<Map<String, dynamic>> subscriptionDurations = [
    {'label': 'شهر واحد', 'months': 1},
    {'label': '3 أشهر', 'months': 3},
    {'label': '6 أشهر', 'months': 6},
    {'label': 'سنة واحدة', 'months': 12},
  ];

  // Days of the week (starting from Saturday)
  static const List<String> weekDays = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  static const List<String> weekDaysShort = [
    'سبت',
    'أحد',
    'اثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
  ];

  // Muscle Groups
  static const List<String> muscleGroups = [
    'صدر',
    'ظهر',
    'أكتاف',
    'باي',
    'تراي',
    'أرجل',
    'بطن',
    'كارديو',
    'كامل الجسم',
    'أخرى',
  ];

  // Focus Areas for workout days
  static const List<String> focusAreas = [
    'صدر وتراي',
    'ظهر وباي',
    'أكتاف وذراعين',
    'أرجل ومؤخرة',
    'بطن ووسط',
    'الجزء العلوي',
    'الجزء السفلي',
    'كامل الجسم',
    'كارديو وهيت',
    'إطالة واستشفاء',
  ];
}

// Subscription Status Enum
enum SubscriptionStatus {
  active,
  expired,
  cancelled,
}

extension SubscriptionStatusExtension on SubscriptionStatus {
  String get label {
    return switch (this) {
      SubscriptionStatus.active => 'نشط',
      SubscriptionStatus.expired => 'منتهي',
      SubscriptionStatus.cancelled => 'ملغي',
    };
  }
}
