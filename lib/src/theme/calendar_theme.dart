import 'package:flutter/material.dart';

import '../../calendar_view.dart';

class CalendarTheme {
  final MonthViewTheme monthViewTheme;
  final DayViewTheme dayViewTheme;
  final WeekViewTheme weekViewTheme;
  final MultiDayViewTheme multiDayViewTheme;

  CalendarTheme({
    required this.monthViewTheme,
    required this.dayViewTheme,
    required this.weekViewTheme,
    required this.multiDayViewTheme,
  });

  // TODO(Shubham): Remove if not required
  // Light theme
  static final light = ThemeData.light().copyWith(
    extensions: [
      MonthViewTheme.light(),
      DayViewTheme.light(),
      WeekViewTheme.light(),
      MultiDayViewTheme.light(),
    ],
  );

  // Dark theme
  static final dark = ThemeData.dark().copyWith(
    extensions: [
      MonthViewTheme.dark(),
      DayViewTheme.dark(),
      WeekViewTheme.dark(),
      MultiDayViewTheme.dark(),
    ],
  );
}
