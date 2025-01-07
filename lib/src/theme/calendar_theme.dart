import 'package:flutter/material.dart';

import '../../calendar_view.dart';

class CalendarTheme {
  final MonthViewTheme monthViewTheme;
  final DayViewTheme dayViewTheme;
  final WeekViewTheme weekViewTheme;

  CalendarTheme({
    required this.monthViewTheme,
    required this.dayViewTheme,
    required this.weekViewTheme,
  });

  // TODO(Shubham): Remove if not required
  // Light theme
  static final light = ThemeData.light().copyWith(
    extensions: [
      MonthViewTheme.light(),
      DayViewTheme.light(),
      WeekViewTheme.light(),
    ],
  );

  // Dark theme
  static final dark = ThemeData.dark().copyWith(
    extensions: [
      MonthViewTheme.dark(),
      DayViewTheme.dark(),
      WeekViewTheme.dark(),
    ],
  );
}
