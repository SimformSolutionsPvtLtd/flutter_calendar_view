// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  /// Compares only [day], [month] and [year] of [DateTime].
  bool compareWithoutTime(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  /// Checks if time stamp of [date] is same as [this].
  /// This method only checks hours and minutes.
  bool hasSameTimeAs(DateTime date) => getTotalMinutes == date.getTotalMinutes;

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
  int getDayDifference(DateTime date) => difference(date).inDays.abs();

  /// Gets difference of weeks between [date] and calling object.
  int getWeekDifference(DateTime date) =>
      (firstDayOfWeek.difference(date.firstDayOfWeek).inDays.abs() / 7).ceil();

  /// Returns The List of date of Current Week
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates
  /// will return dates
  /// [6,7,8,9,10,11,12]
  /// Where on 6th there will be monday and on 12th there will be Sunday
  List<DateTime> datesOfWeek() {
    // weekday can very from 1(Monday) to 7(Sunday).
    // If we have a date that has week day of 3 (Wednesday) and
    // we want to find first date of the week that contains this date
    // we need to move 2 days back. Wednesday -> Tuesday -> Monday.
    // That is same as 3 - 1 (weekday - 1).
    //
    final start = subtract(Duration(days: weekday - 1));

    return [
      start,
      start.add(Duration(days: 1)),
      start.add(Duration(days: 2)),
      start.add(Duration(days: 3)),
      start.add(Duration(days: 4)),
      start.add(Duration(days: 5)),
      start.add(Duration(days: 6)),
    ];
  }

  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));
  DateTime get lastDayOfWeek => add(Duration(days: 7 - weekday));

  /// Returns list of all dates of [month].
  /// All the dates are week based that means it will return array of size 42
  /// which will contain 6 weeks that is the maximum number of weeks a month
  /// can have.
  List<DateTime> get datesOfMonths {
    final monthDays = <DateTime>[];
    for (var i = 1, start = 1; i < 7; i++, start += 7) {
      monthDays.addAll(DateTime(year, month, start).datesOfWeek());
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
}

extension ColorExtension on Color {
  Color get accent =>
      (blue / 2 >= 255 / 2 || red / 2 >= 255 / 2 || green / 2 >= 255 / 2)
          ? Colors.black
          : Colors.white;
}

extension MaterialColorExtension on MaterialColor {
  Color get accent =>
      (blue / 2 >= 255 / 2 || red / 2 >= 255 / 2 || green / 2 >= 255 / 2)
          ? Colors.black
          : Colors.white;
}
