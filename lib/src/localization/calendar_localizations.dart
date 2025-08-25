class CalendarLocalizations {
  final String more;
  final String am;
  final String pm;
  final List<String> weekdays;
  final List<String>? numbers;
  final bool isRTL;

  const CalendarLocalizations({
    required this.am,
    required this.pm,
    required this.more,
    required this.weekdays,
    this.numbers = const ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    this.isRTL = false,
  });

  /// Create CalendarLocalizations from a Map (e.g., parsed ARB/JSON)
  factory CalendarLocalizations.fromMap(Map<String, dynamic> map) {
    return CalendarLocalizations(
      am: map['am'] ?? 'am',
      pm: map['pm'] ?? 'pm',
      more: map['more'] ?? '',
      weekdays: List<String>.from(map['weekdays'] ?? []),
      numbers: List<String>.from(map['numbers'] ?? []),
      isRTL: map['isRTL'] ?? false,
    );
  }

  /// Built-in English localization
  static const CalendarLocalizations en = CalendarLocalizations(
    am: 'am',
    pm: 'pm',
    more: 'more',
    weekdays: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    numbers: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    isRTL: false,
  );
}
