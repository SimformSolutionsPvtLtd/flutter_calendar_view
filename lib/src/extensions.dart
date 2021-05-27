export 'typedefs.dart';

extension DateTimeExtensions on DateTime {
  bool compareWithoutTime(DateTime date) {
    return this.day == date.day &&
        this.month == date.month &&
        this.year == date.year;
  }

  bool hasSameTimeAs(DateTime date) =>
      this.getTotalMinutes == date.getTotalMinutes;

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

  int getDayDifference(DateTime date) => this.difference(date).inDays.abs();
  int getWeekDifference(DateTime date) =>
      (this.difference(date).inDays.abs() / 7).ceil();

  /// Returns The List of date of Current Week
  /// Day will start from Monday to Sunday.
  ///
  /// ex: if Current Date instance is 8th and day is wednesday then weekDates will return dates
  /// [6,7,8,9,10,11,12]
  /// Where on 6th there will be monday and on 12th there will be Sunday
  List<DateTime> get datesOfWeek {
    int day = this.weekday;
    DateTime start = this.subtract(Duration(days: day - 1));

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

  List<DateTime> get datesOfMonths {
    List<DateTime> monthDays = [];
    for (int i = 1, start = 1; i < 7; i++, start += 7) {
      monthDays.addAll(DateTime(this.year, this.month, start).datesOfWeek);
    }
    return monthDays;
  }

  String get formatted => "${this.month}-${this.year}";

  int get getTotalMinutes => this.hour * 60 + this.minute;

  DateTime copyFromMinutes([int totalMinutes = 0]) => DateTime(
        this.year,
        this.month,
        this.day,
        totalMinutes ~/ 60,
        totalMinutes % 60,
        0,
      );
}
