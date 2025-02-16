import 'package:flutter/material.dart';

import '../calendar_view.dart';

final DateTime fixedWeekStart = CalendarConstants.fixedWeekStart;

class WeeklyEvent<T> {
  final WeekDays weekday;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final T event;

  WeeklyEvent({
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.event,
  });

  CalendarEventData<T> toCalendarEvent() {
    int daysToAdd = weekday.index - WeekDays.monday.index;
    final date = fixedWeekStart.add(Duration(days: daysToAdd));
    return CalendarEventData(
      date: date,
      startTime: DateTime(
          date.year, date.month, date.day, startTime.hour, startTime.minute),
      endTime: DateTime(
          date.year, date.month, date.day, endTime.hour, endTime.minute),
      event: event,
      recurrenceSettings: RecurrenceSettings(
        frequency: RepeatFrequency.weekly,
        startDate: date,
      ),
      title: '',
    );
  }
}
