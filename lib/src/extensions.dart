// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';
import 'constants.dart';

T? ambiguate<T>(T? object) => object;

extension DateTimeExtensions on DateTime {
  /// Compares only [day], [month] and [year] of [DateTime].
  bool compareWithoutTime(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  /// Gets difference of months between [date] and calling object.
  int getMonthDifference(DateTime date) {
    if (year == date.year) return ((date.month - month).abs() + 1);

    var months = ((date.year - year).abs() - 1) * 12;

    if (date.year >= year) {
      months += date.month + (13 - month);
    } else {
      months += month + (13 - date.month);
    }

    return months;
  }

  /// Gets difference of days between [date] and calling object.
  int getDayDifference(DateTime date) => DateTime.utc(year, month, day)
      .difference(DateTime.utc(date.year, date.month, date.day))
      .inDays
      .abs();

  /// Gets difference of weeks between [date] and calling object.
  int getWeekDifference(DateTime date, {WeekDays start = WeekDays.monday}) =>
      (firstDayOfWeek(start: start)
                  .difference(date.firstDayOfWeek(start: start))
                  .inDays
                  .abs() /
              7)
          .ceil();

  /// Gets difference of multi-day between [date] and calling object.
  int getMultiDayDifference(
      {required DateTime startDate,
      required DateTime endDate,
      daysInView = 3}) {
    final daysDifference =
        startDate.withoutTime.difference(endDate.withoutTime).inDays.abs() + 1;

    return (daysDifference / daysInView).ceil();
  }

  /// Returns the list of [DateTime] for given [index] and [daysInView].
  List<DateTime> getMultiDateRangeList(DateTime startDate, int index,
      {int daysInView = 3}) {
    DateTime baseDate = startDate.add(Duration(days: index * daysInView));
    return List.generate(daysInView, (i) => baseDate.add(Duration(days: i)));
  }

  /// Returns The List of date of Current Week, all of the dates will be without
  /// time.
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates
  /// will return dates
  /// 6, 7, 8, 9, 10, 11, 12.
  /// Where on 6th there will be monday and on 12th there will be Sunday
  List<DateTime> datesOfWeek({
    WeekDays start = WeekDays.monday,
    bool showWeekEnds = true,
  }) {
    // Here %7 ensure that we do not subtract >6 and <0 days.
    // Initial formula is,
    //    difference = (weekday - startInt)%7
    // where weekday and startInt ranges from 1 to 7.
    // But in WeekDays enum index ranges from 0 to 6 so we are
    // adding 1 in index. So, new formula with WeekDays is,
    //    difference = (weekdays - (start.index + 1))%7
    //
    final startDay =
        DateTime(year, month, day - (weekday - start.index - 1) % 7);
    // Generate weekdays with weekends or without weekends
    final days = List.generate(
      7,
      (index) => DateTime(startDay.year, startDay.month, startDay.day + index),
    )
        .where(
          (date) =>
              showWeekEnds ||
              (date.weekday != DateTime.saturday &&
                  date.weekday != DateTime.sunday),
        )
        .toList();
    return days;
  }

  /// Returns the first date of week containing the current date
  DateTime firstDayOfWeek({WeekDays start = WeekDays.monday}) =>
      DateTime(year, month, day - ((weekday - start.index - 1) % 7));

  /// Returns the last date of week containing the current date
  DateTime lastDayOfWeek({WeekDays start = WeekDays.monday}) =>
      DateTime(year, month, day + (6 - (weekday - start.index - 1) % 7));

  DateTime firstDayOfMultiDay({
    required DateTime startDate,
    int daysInView = 3,
  }) {
    final diffDays = startDate.withoutTime
        .difference(DateTime.now().withoutTime)
        .inDays
        .abs();
    final offset = diffDays % daysInView;
    return offset == 0
        ? startDate.withoutTime
        : startDate.subtract(Duration(days: daysInView - offset)).withoutTime;
  }

  /// Returns the last date of week containing the current date
  DateTime lastDayOfMultiDay({
    required DateTime endDate,
    int daysInView = 3,
  }) {
    final diffDays = endDate.withoutTime
            .difference(DateTime.now().withoutTime)
            .inDays
            .abs() +
        1;
    final offset = diffDays % daysInView;
    return offset == 0
        ? endDate.withoutTime
        : endDate.add(Duration(days: daysInView - offset)).withoutTime;
  }

  /// Returns list of all dates of [month].
  /// All the dates are week based that means it will return array of size 42
  /// which will contain 6 weeks that is the maximum number of weeks a month
  /// can have.
  ///
  /// It excludes week if `hideDaysNotInMonth` is set true and
  /// if all dates in week comes in next month then it will excludes that week.
  List<DateTime> datesOfMonths({
    WeekDays startDay = WeekDays.monday,
    bool hideDaysNotInMonth = false,
    bool showWeekends = true,
  }) {
    final monthDays = <DateTime>[];
    // Start is the first weekday for each week in a month
    for (var i = 1, start = 1; i < 7; i++, start += 7) {
      final datesInWeek =
          DateTime(year, month, start).datesOfWeek(start: startDay).where(
                (day) =>
                    showWeekends ||
                    (day.weekday != DateTime.saturday &&
                        day.weekday != DateTime.sunday),
              );
      // Check does every date of week belongs to different month
      final allDatesNotInCurrentMonth = datesInWeek.every((date) {
        return date.month != month;
      });
      // if entire row contains dates of other month then skip it
      if (hideDaysNotInMonth && allDatesNotInCurrentMonth) {
        continue;
      }
      monthDays.addAll(datesInWeek);
    }
    return monthDays;
  }

  /// Returns total minutes this date is pointing at.
  /// if [DateTime] object is, DateTime(2021, 5, 13, 12, 4, 5)
  /// Then this getter will return 12*60 + 4 which evaluates to 724.
  int get getTotalMinutes => hour * 60 + minute;

  /// Returns [DateTime] without timestamp.
  DateTime get withoutTime => DateTime(year, month, day);

  /// Returns the corresponding [WeekDays] enum value for this DateTime's weekday.
  ///
  /// This provides an ergonomic way to convert DateTime.weekday (1-7, Monday-Sunday)
  /// to the [WeekDays] enum (0-6, monday-sunday).
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15); // Monday
  /// print(date.weekDayEnum); // WeekDays.monday
  /// ```
  WeekDays get weekDayEnum => WeekDays.values[weekday - 1];
}

extension TimeOfDayExtension on TimeOfDay {
  /// Returns true if this time represents the start of day (00:00).
  bool get isDayStart => hour == 0 && minute == 0;

  /// Returns total minutes since midnight for this `TimeOfDay`.
  ///
  /// Example: `14:30` \-\> `870`.
  int get getTotalMinutes => hour * 60 + minute;

  /// Compares if two TimeOfDay objects represent the same time.
  bool isSameAs(TimeOfDay other) {
    return hour == other.hour && minute == other.minute;
  }

  /// Creates a TimeOfDay from total minutes since midnight
  /// For example, 870 minutes = 14:30 (2:30 PM)
  static TimeOfDay copyFromMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours % 24, minute: minutes);
  }
}

extension ColorExtension on Color {
  /// TODO(Shubham): Update this getter as it uses `computeLuminance()`
  /// which is computationally expensive
  Color get accent {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return brightness == Brightness.light
        ? Color(0xff626262)
        : Color(0xfff0f0f0);
  }
}

extension MinutesExtension on MinuteSlotSize {
  /// Returns minutes for respective [MinuteSlotSize]
  int get minutes {
    switch (this) {
      case MinuteSlotSize.minutes15:
        return 15;
      case MinuteSlotSize.minutes30:
        return 30;
      case MinuteSlotSize.minutes60:
        return 60;
    }
  }
}

extension MyList<T extends Object?> on List<CalendarEventData<T>> {
  // Inserts [event] into a sorted position.
  // When [sorter] is provided and returns 0 for two events (tie), falls back
  // to [defaultEventSorter] to preserve start-time order within the same group.
  void addEventInSortedManner(
    CalendarEventData<T> event, [
    EventSorter<T>? sorter,
  ]) {
    var addIndex = -1;

    for (var i = 0; i < this.length; i++) {
      var result = sorter != null ? sorter.call(event, this[i]) : 0;
      if (result == 0) {
        result = defaultEventSorter(event, this[i]);
      }
      if (result <= 0) {
        addIndex = i;
        break;
      }
    }

    if (addIndex > -1) {
      insert(addIndex, event);
    } else {
      add(event);
    }
  }
}

/// Default [EventSorter] for [CalendarEventData]
/// It will sort the events based on their [CalendarEventData.startTime].
int defaultEventSorter<T extends Object?>(
  CalendarEventData<T> a,
  CalendarEventData<T> b,
) {
  return (a.startTime?.getTotalMinutes ?? 0) -
      (b.startTime?.getTotalMinutes ?? 0);
}

extension IntExtension on int {
  String appendLeadingZero() {
    return toString().padLeft(2, '0');
  }
}

void debugLog(String message) {
  assert(() {
    try {
      debugPrint(message);
    } catch (e) {} //ignore: empty_catches Suppress exception...

    return true;
  }());
}

/// For callbacks with one argument
extension NullableCallback1<A> on void Function(A)? {
  VoidCallback? safeVoidCall(A a) => this == null ? null : () => this!(a);
}

/// For callbacks with two arguments
extension NullableCallback2<A, B> on void Function(A, B)? {
  VoidCallback? safeVoidCall(A a, B b) =>
      this == null ? null : () => this!(a, b);
}

/// For callbacks with three arguments
extension NullableCallback3<A, B, C> on void Function(A, B, C)? {
  VoidCallback? safeVoidCall(A a, B b, C c) =>
      this == null ? null : () => this!(a, b, c);
}

extension BuildContextExtension on BuildContext {
  /// Get [MonthViewThemeData] from theme, if null returns light theme.
  /// [MonthViewThemeData] needs to be added in [MaterialApp] theme extensions
  /// to get theme data with this type.
  MonthViewThemeData get monthViewColors =>
      Theme.of(this).extension<MonthViewThemeData>() ??
      MonthViewThemeData.light();

  /// Get [DayViewThemeData] from theme, if null returns light theme.
  /// [DayViewThemeData] needs to be added in [MaterialApp] theme extensions
  /// to get theme data with this type.
  DayViewThemeData get dayViewColors =>
      Theme.of(this).extension<DayViewThemeData>() ?? DayViewThemeData.light();

  /// Get [WeekViewThemeData] from theme, if null returns light theme.
  /// [WeekViewThemeData] needs to be added in [MaterialApp] theme extensions
  /// to get theme data with this type.
  WeekViewThemeData get weekViewColors =>
      Theme.of(this).extension<WeekViewThemeData>() ??
      WeekViewThemeData.light();

  /// Get [MultiDayViewThemeData] from theme, if null returns light theme.
  /// [MultiDayViewThemeData] needs to be added in [MaterialApp] theme extensions
  /// to get theme data with this type.
  MultiDayViewThemeData get multiDayViewColors =>
      Theme.of(this).extension<MultiDayViewThemeData>() ??
      MultiDayViewThemeData.light();
}

extension BuildContextMultiDayViewThemeExtension on BuildContext {
  /// Get MultiDayViewTheme from Theme
  MultiDayViewThemeData get multiDayViewTheme {
    final theme = Theme.of(this).extension<MultiDayViewThemeData>();
    if (theme != null) {
      return theme;
    }

    // If no theme extension is available, return based on brightness
    return Theme.of(this).brightness == Brightness.dark
        ? MultiDayViewThemeData.dark()
        : MultiDayViewThemeData.light();
  }
}

/// Extension on CalendarEventData to calculate visible time ranges
/// for single-day and multi-day events on a specific calendar date.
extension CalendarEventDataVisibility<T extends Object?>
    on CalendarEventData<T> {
  /// Gets the visible start minute of the event on the given calendar date.
  ///
  /// Behavior:
  /// - Full-day events always start at 00:00.
  /// - Single-day events use their actual start time.
  /// - Multi-day events:
  ///   - Start day -> actual start time
  ///   - Middle/end days -> 00:00
  int getVisibleStartMinutes(DateTime calendarDate) {
    final visibleDate = calendarDate.withoutTime;

    // Full-day or invalid events always start at beginning of day.
    if (isFullDayEvent || startTime == null) {
      return 0;
    }

    // Multi-day events start at 00:00 on every day except the first day.
    final isStartDate = visibleDate.compareWithoutTime(date);

    return isRangingEvent && !isStartDate ? 0 : startTime!.getTotalMinutes;
  }

  /// Gets the visible end minute of the event on the given calendar date.
  ///
  /// Behavior:
  /// - Full-day events always end at 24:00 (1440 minutes).
  /// - Single-day events use their actual end time.
  /// - Multi-day events:
  ///   - Start/middle days -> 24:00
  ///   - End day -> actual end time
  ///
  /// For timed multi-day events where [endTime] is midnight (00:00),
  /// [occursOnDate] already excludes [endDate] from the event's visible days,
  /// so this method returns 0 for that boundary date, consistent with the
  /// exclusive-end semantics applied there.
  int getVisibleEndMinutes(DateTime calendarDate) {
    final visibleDate = calendarDate.withoutTime;

    // Full-day or invalid events always occupy the full day.
    if (isFullDayEvent || endTime == null) {
      return Constants.minutesADay;
    }

    // Multi-day events extend until end of day on every day
    // except the final day.
    final isEndDate = visibleDate.compareWithoutTime(endDate);

    if (isRangingEvent && !isEndDate) {
      return Constants.minutesADay;
    }

    // For single-day events ending at midnight (00:00), treat as end-of-day
    // (1440). Midnight is only an exclusive boundary for timed multi-day
    // events; for single-day events it represents the end of the current day.
    if (!isRangingEvent && endTime!.isDayStart) {
      return Constants.minutesADay;
    }

    // Return the actual end minute. For timed multi-day events where endTime
    // is midnight (00:00), occursOnDate excludes endDate, so reaching here
    // for that day only happens if called directly; returning 0 is correct.
    return endTime!.getTotalMinutes;
  }

  /// Gets the visible duration (in minutes) of the event
  /// on the given calendar date.
  int getVisibleDuration(DateTime calendarDate) {
    return getVisibleEndMinutes(calendarDate) -
        getVisibleStartMinutes(calendarDate);
  }
}
