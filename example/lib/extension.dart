import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeStampFormat { parse_12, parse_24 }

extension NavigationExtension on State {
  void pushRoute(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

extension NavigatorExtention on BuildContext {
  Future<T?> pushRoute<T>(Widget page) async => await Navigator.of(this)
      .push<T>(MaterialPageRoute(builder: (context) => page));

  void popRoute([dynamic value]) => Navigator.of(this).pop(value);

  void showSnackBarWithText(String text) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

extension DateUtils on DateTime {
  String get weekdayToFullString {
    switch (this.weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "Error";
    }
  }

  String get weekdayToAbbreviatedString {
    switch (this.weekday) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
      default:
        return "Err";
    }
  }

  int get totalMinutes => this.hour * 60 + this.minute;

  TimeOfDay get timeOfDay => TimeOfDay(hour: this.hour, minute: this.minute);

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  String dateToStringWithFormat({String format = 'y-M-d'}) {
    return DateFormat(format).format(this);
  }

  DateTime stringToDateWithFormat({
    required String format,
    required String dateString,
  }) =>
      DateFormat(format).parse(dateString);

  String getTimeInFormat(TimeStampFormat format) =>
      DateFormat('h:mm${format == TimeStampFormat.parse_12 ? " a" : ""}')
          .format(this)
          .toUpperCase();

  bool compareWithoutTime(DateTime date) =>
      this.day == date.day &&
      this.month == date.month &&
      this.year == date.year;

  bool compareTime(DateTime date) =>
      this.hour == date.hour &&
      this.minute == date.minute &&
      this.second == date.second;
}
