import '../../calendar_view.dart';

class CalendarThemeData {
  const CalendarThemeData({
    required this.monthViewTheme,
    required this.dayViewTheme,
    required this.weekViewTheme,
    required this.multiDayViewTheme,
    required this.scheduleViewTheme,
  });

  final MonthViewThemeData monthViewTheme;
  final DayViewThemeData dayViewTheme;
  final WeekViewThemeData weekViewTheme;
  final MultiDayViewThemeData multiDayViewTheme;
  final ScheduleViewThemeData scheduleViewTheme;

  /// Creates a copy of this `CalendarThemeData` with optional overrides.
  CalendarThemeData copyWith({
    MonthViewThemeData? monthViewTheme,
    DayViewThemeData? dayViewTheme,
    WeekViewThemeData? weekViewTheme,
    MultiDayViewThemeData? multiDayViewTheme,
    ScheduleViewThemeData? scheduleViewTheme,
  }) {
    return CalendarThemeData(
      monthViewTheme: monthViewTheme ?? this.monthViewTheme,
      dayViewTheme: dayViewTheme ?? this.dayViewTheme,
      weekViewTheme: weekViewTheme ?? this.weekViewTheme,
      multiDayViewTheme: multiDayViewTheme ?? this.multiDayViewTheme,
      scheduleViewTheme: scheduleViewTheme ?? this.scheduleViewTheme,
    );
  }

  /// Merges another `CalendarThemeData` into this one.
  CalendarThemeData merge(CalendarThemeData? other) {
    if (other == null) return this;

    return copyWith(
      monthViewTheme: other.monthViewTheme,
      dayViewTheme: other.dayViewTheme,
      weekViewTheme: other.weekViewTheme,
      multiDayViewTheme: other.multiDayViewTheme,
      scheduleViewTheme: other.scheduleViewTheme,
    );
  }
}
