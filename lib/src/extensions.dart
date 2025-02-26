// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';

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
  int getWeekDifference(DateTime date,
      {WeekDays start = WeekDays.monday, int daysInView = 7}) {
    return (firstDayOfWeek(start: start)
                .difference(date.firstDayOfWeek(start: start))
                .inDays
                .abs() /
            daysInView)
        .ceil();
  }

  /// Returns The List of date of Current Week, all of the dates will be without
  /// time.
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates
  /// will return dates
  /// [6,7,8,9,10,11,12]
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

  /// Gives formatted date in form of 'month - year'.
  String get formatted => "$month-$year";

  /// Returns total minutes this date is pointing at.
  /// if [DateTime] object is, DateTime(2021, 5, 13, 12, 4, 5)
  /// Then this getter will return 12*60 + 4 which evaluates to 724.
  int get getTotalMinutes => hour * 60 + minute;

  /// Returns a new [DateTime] object with hour and minutes calculated from
  /// [totalMinutes].
  DateTime copyFromMinutes([int totalMinutes = 0]) => DateTime(
        year,
        month,
        day,
        totalMinutes ~/ 60,
        totalMinutes % 60,
      );

  /// Returns [DateTime] without timestamp.
  DateTime get withoutTime => DateTime(year, month, day);

  /// Compares time of two [DateTime] objects.
  bool hasSameTimeAs(DateTime other) {
    return other.hour == hour &&
        other.minute == minute &&
        other.second == second &&
        other.millisecond == millisecond &&
        other.microsecond == microsecond;
  }

  bool get isDayStart => hour == 0 && minute == 0;

  @Deprecated(
      "This extension is not being used in this package and will be removed "
      "in next major release. Please use withoutTime instead.")
  DateTime get dateYMD => DateTime(year, month, day);
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

extension MaterialColorExtension on MaterialColor {
  @Deprecated(
      "This extension is not being used in this package and will be removed "
      "in next major release.")
  Color get accent =>
      (blue / 2 >= 255 / 2 || red / 2 >= 255 / 2 || green / 2 >= 255 / 2)
          ? Colors.black
          : Colors.white;
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
  // Below function will add the new event in sorted manner(startTimeWise) in
  // the existing list of CalendarEventData.

  void addEventInSortedManner(
    CalendarEventData<T> event, [
    EventSorter<T>? sorter,
  ]) {
    var addIndex = -1;

    for (var i = 0; i < this.length; i++) {
      var result = (sorter ?? defaultEventSorter).call(event, this[i]);
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

extension TimerOfDayExtension on TimeOfDay {
  int get getTotalMinutes => hour * 60 + minute;
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

    return false;
  }(), '');
}
