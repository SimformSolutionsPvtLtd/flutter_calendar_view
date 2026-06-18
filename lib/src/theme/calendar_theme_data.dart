import '../../calendar_view.dart';

class CalendarThemeData {
  CalendarThemeData({
    required this.monthViewTheme,
    required this.dayViewTheme,
    required this.weekViewTheme,
    required this.multiDayViewTheme,
    ResizableMonthViewThemeData? resizableMonthViewTheme,
  }) : resizableMonthViewTheme =
            resizableMonthViewTheme ?? ResizableMonthViewThemeData.light();

  final MonthViewThemeData monthViewTheme;
  final DayViewThemeData dayViewTheme;
  final WeekViewThemeData weekViewTheme;
  final MultiDayViewThemeData multiDayViewTheme;
  final ResizableMonthViewThemeData resizableMonthViewTheme;

  /// Creates a copy of this `CalendarThemeData` with optional overrides.
  CalendarThemeData copyWith({
    MonthViewThemeData? monthViewTheme,
    DayViewThemeData? dayViewTheme,
    WeekViewThemeData? weekViewTheme,
    MultiDayViewThemeData? multiDayViewTheme,
    ResizableMonthViewThemeData? resizableMonthViewTheme,
  }) {
    return CalendarThemeData(
      monthViewTheme: monthViewTheme ?? this.monthViewTheme,
      dayViewTheme: dayViewTheme ?? this.dayViewTheme,
      weekViewTheme: weekViewTheme ?? this.weekViewTheme,
      multiDayViewTheme: multiDayViewTheme ?? this.multiDayViewTheme,
      resizableMonthViewTheme:
          resizableMonthViewTheme ?? this.resizableMonthViewTheme,
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
      resizableMonthViewTheme: other.resizableMonthViewTheme,
    );
  }
}
