class CalendarLocalizations {
  final String more;
  final String am;
  final String pm;
  final List<String> weekdays;
  final List<String>? numbers;
  final bool isRTL;
  final List<String> months;
  final List<String>? monthsAbbr;

  const CalendarLocalizations({
    required this.am,
    required this.pm,
    required this.more,
    required this.weekdays,
    this.numbers = _numbers,
    this.isRTL = false,
    this.months = _months,
    this.monthsAbbr,
  });

  /// Create CalendarLocalizations from a Map (e.g., parsed ARB/JSON)
  factory CalendarLocalizations.fromMap(Map<String, dynamic> map) {
    return CalendarLocalizations(
      am: map['am'] ?? 'am',
      pm: map['pm'] ?? 'pm',
      more: map['more'] ?? '',
      weekdays: List<String>.from(map['weekdays'] ?? _weekdays),
      numbers: List<String>.from(map['numbers'] ?? _numbers),
      isRTL: map['isRTL'] ?? false,
      months: List<String>.from(map['months'] ?? _months),
      monthsAbbr: map['monthsAbbr'] != null
          ? List<String>.from(map['monthsAbbr'])
          : null,
    );
  }

  static const List<String> _months = [
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

  static const List<String> _numbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];

  static const List<String> _monthsAbbr = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  /// Built-in English localization
  static const CalendarLocalizations en = CalendarLocalizations(
    am: 'am',
    pm: 'pm',
    more: 'more',
    weekdays: _weekdays,
    numbers: _numbers,
    isRTL: false,
    months: _months,
    monthsAbbr: _monthsAbbr,
  );
}
