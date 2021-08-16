import 'package:flutter/material.dart';

import 'enumerations.dart';

export 'typedefs.dart';

extension DateTimeExtensions on DateTime {
  /// Compares only [day], [month] and [year] of [DateTime].
  bool compareWithoutTime(DateTime date) {
    return this.day == date.day &&
        this.month == date.month &&
        this.year == date.year;
  }

  /// Checks if time stamp of [date] is same as [this].
  /// This method only checks hours and minutes.
  bool hasSameTimeAs(DateTime date) =>
      this.getTotalMinutes == date.getTotalMinutes;

  /// Gets difference of months between [date] and calling object.
  int getMonthDifference(DateTime date) {
    if (this.year == date.year) return ((date.month - this.month).abs() + 1);

    int months = ((date.year - this.year).abs() - 1) * 12;

    if (date.year >= this.year) {
      months += date.month + (13 - this.month);
    } else {
      months += this.month + (13 - date.month);
    }

    return months;
  }

  /// Gets difference of days between [date] and calling object.
  int getDayDifference(DateTime date) => this.difference(date).inDays.abs();

  /// Gets difference of weeks between [date] and calling object.
  int getWeekDifference(DateTime date) =>
      (this.difference(date).inDays.abs() / 7).ceil();

  /// Returns The List of date of Current Week
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates will return dates
  /// [6,7,8,9,10,11,12]
  /// Where on 6th there will be monday and on 12th there will be Sunday
  List<DateTime> datesOfWeek({WeekDays startDay = WeekDays.monday}) {
    int day = this.weekday;
    DateTime start = this.subtract(Duration(days: day - startDay.index));

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

  /// Returns list of all dates of [month].
  /// All the dates are week based that means it will return array of size 42
  /// which will contain 6 weeks that is the maximum number of weeks a month can have.
  List<DateTime> get datesOfMonths {
    List<DateTime> monthDays = [];
    for (int i = 1, start = 1; i < 7; i++, start += 7) {
      monthDays.addAll(DateTime(this.year, this.month, start).datesOfWeek());
    }
    return monthDays;
  }

  /// Gives formatted date in form of 'month - year'.
  String get formatted => "${this.month}-${this.year}";

  /// Returns total minutes this date is pointing at.
  /// if [DateTime] object is, DateTime(2021, 5, 13, 12, 4, 5)
  /// Then this getter will return 12*60 + 4 which evaluates to 724.
  int get getTotalMinutes => this.hour * 60 + this.minute;

  /// Returns a new [DateTime] object with hour and minutes calculated from [totalMinutes].
  DateTime copyFromMinutes([int totalMinutes = 0]) => DateTime(
        this.year,
        this.month,
        this.day,
        totalMinutes ~/ 60,
        totalMinutes % 60,
        0,
      );
}

extension ColorExtension on Color {
  Color get accent => (this.blue / 2 >= 255 / 2 ||
          this.red / 2 >= 255 / 2 ||
          this.green / 2 >= 255 / 2)
      ? Colors.black
      : Colors.white;
}

extension MaterialColorExtension on MaterialColor {
  Color get accent => (this.blue / 2 >= 255 / 2 ||
          this.red / 2 >= 255 / 2 ||
          this.green / 2 >= 255 / 2)
      ? Colors.black
      : Colors.white;
}
