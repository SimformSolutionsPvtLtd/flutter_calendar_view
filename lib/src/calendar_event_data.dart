// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';

@immutable

/// {@macro calendar_event_data_doc}
class CalendarEventData<T extends Object?> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// Defines the start time of the event.
  /// This is required when you are using [CalendarEventData] for [DayView] or [WeekView]
  final TimeOfDay? startTime;

  /// Defines the end time of the event.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final TimeOfDay? endTime;

  /// Title of the event.
  final String title;

  /// Description of the event.
  final String? description;

  /// Defines color of event.
  /// This color will be used in default widgets provided by plugin.
  final Color color;

  /// Event on [date].
  final T? event;

  final DateTime? _endDate;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

  /// Define reoccurrence settings
  final RecurrenceSettings? recurrenceSettings;

  /// Private constructor for internal use
  const CalendarEventData._({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    DateTime? endDate,
    this.description,
    this.event,
    this.color = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
    this.recurrenceSettings,
  }) : _endDate = endDate;

  /// {@macro calendar_event_data_doc}
  /// Creates a basic calendar event.
  /// Use type-specific factories ([timeRanged], [wholeDay], [multiDay]) for better clarity.
  factory CalendarEventData({
    required String title,
    required DateTime startDate,
    String? description,
    T? event,
    Color color = Colors.blue,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
    // End date of the event (only date part is considered)
    DateTime? endDate,
  }) {
    return CalendarEventData._(
      title: title,
      date: startDate.withoutTime,
      startTime: startTime,
      endTime: endTime,
      endDate: endDate?.withoutTime,
      description: description,
      event: event,
      color: color,
      titleStyle: titleStyle,
      descriptionStyle: descriptionStyle,
      recurrenceSettings: recurrenceSettings,
    );
  }

  /// Creates a time-ranged event with specific start and end times on a single day.
  ///
  /// This factory is ideal for events that occur within a specific time range
  /// on a single day (e.g., "Meeting from 2 PM to 4 PM").
  ///
  /// Example:
  /// ```dart
  /// final meeting = CalendarEventData.timeRanged(
  ///   title: "Team Meeting",
  ///   date: DateTime(2024, 1, 15),
  ///   startTime: TimeOfDay(hour: 14, minute: 0), // 2 PM
  ///   endTime: TimeOfDay(hour: 16, minute: 0),   // 4 PM
  ///   description: "Weekly sync",
  /// );
  /// ```
  factory CalendarEventData.timeRanged({
    required String title,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    String? description,
    T? event,
    Color color = Colors.blue,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
  }) {
    return CalendarEventData._(
      title: title,
      date: date.withoutTime,
      startTime: startTime,
      endTime: endTime,
      endDate: null,
      description: description,
      event: event,
      color: color,
      titleStyle: titleStyle,
      descriptionStyle: descriptionStyle,
      recurrenceSettings: recurrenceSettings,
    );
  }

  /// Creates a whole day event that spans exactly one full day.
  ///
  /// This factory is ideal for all-day events like holidays, birthdays,
  /// or any event that doesn't have specific start/end times.
  ///
  /// Example:
  /// ```dart
  /// final holiday = CalendarEventData.wholeDay(
  ///   title: "Independence Day",
  ///   date: DateTime(2024, 7, 4),
  ///   description: "National Holiday",
  /// );
  /// ```
  factory CalendarEventData.wholeDay({
    required String title,
    required DateTime date,
    String? description,
    T? event,
    Color color = Colors.blue,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
  }) {
    return CalendarEventData._(
      title: title,
      date: date.withoutTime,
      startTime: null,
      endTime: null,
      endDate: null,
      description: description,
      event: event,
      color: color,
      titleStyle: titleStyle,
      descriptionStyle: descriptionStyle,
      recurrenceSettings: recurrenceSettings,
    );
  }

  /// Creates a multi-day event that spans multiple days.
  ///
  /// This factory supports two modes:
  /// 1. **Whole-day multi-day events**: Omit [startTime] and [endTime]
  /// 2. **Timed multi-day events**: Provide [startTime] and [endTime]
  ///
  /// Use this for events like conferences, vacations, workshops, or any event
  /// spanning multiple days with or without specific times.
  ///
  /// Examples:
  /// ```dart
  /// // Whole-day multi-day event (vacation, conference)
  /// final conference = CalendarEventData.multiDay(
  ///   title: "Tech Conference",
  ///   startDate: DateTime(2024, 3, 10),
  ///   endDate: DateTime(2024, 3, 12),
  ///   description: "3-day tech event",
  /// );
  ///
  /// // Multi-day event with specific times (e.g., 3 PM on 3rd to 6 PM on 6th)
  /// final workshop = CalendarEventData.multiDay(
  ///   title: "Extended Workshop",
  ///   startDate: DateTime(2024, 2, 3),
  ///   endDate: DateTime(2024, 2, 6),
  ///   startTime: TimeOfDay(hour: 15, minute: 0),  // 3 PM
  ///   endTime: TimeOfDay(hour: 18, minute: 0),    // 6 PM
  ///   description: "Workshop from 3 PM on 3rd to 6 PM on 6th",
  /// );
  /// ```
  factory CalendarEventData.multiDay({
    required String title,
    // Start date of the multi-day event (only date part is considered)
    required DateTime startDate,
    // End date of the multi-day event (only date part is considered)
    required DateTime endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? description,
    T? event,
    Color color = Colors.blue,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
  }) {
    return CalendarEventData._(
      title: title,
      date: startDate.withoutTime,
      startTime: startTime,
      endTime: endTime,
      endDate: endDate.withoutTime,
      description: description,
      event: event,
      color: color,
      titleStyle: titleStyle,
      descriptionStyle: descriptionStyle,
      recurrenceSettings: recurrenceSettings,
    );
  }

  DateTime get endDate => _endDate ?? date;

  /// If this flag returns true that means event is occurring on multiple
  /// days and is not a full day event.
  ///
  bool get isRangingEvent {
    final diff = endDate.withoutTime.difference(date.withoutTime).inDays;

    return diff > 0 && !isFullDayEvent;
  }

  /// Returns if the events is full day event or not.
  ///
  /// If it returns true that means the events is full day. but also it can
  /// span across multiple days.
  ///
  bool get isFullDayEvent {
    return (startTime == null ||
        endTime == null ||
        (startTime!.isDayStart && endTime!.isDayStart));
  }

  bool get isRecurringEvent {
    return recurrenceSettings != null &&
        recurrenceSettings!.frequency != RepeatFrequency.doNotRepeat;
  }

  Duration get duration {
    if (isFullDayEvent) {
      // For full-day events, calculate the number of days between start and end dates
      final daysDifference = endDate.difference(date).inDays;
      return Duration(days: daysDifference + 1);
    }

    // For events with specific times, check if it's a multi-day event
    if (isRangingEvent) {
      // Multi-day event with specific times
      // Calculate duration from startTime on start date to endTime on end date
      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startTime!.hour,
        startTime!.minute,
      );
      final endDateTime = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        endTime!.hour,
        endTime!.minute,
      );
      return endDateTime.difference(startDateTime);
    }

    // Single-day event with specific times
    final startMinutes = startTime!.getTotalMinutes;
    final endMinutes = endTime!.getTotalMinutes;

    // If end time is at day start (00:00), treat it as end of day
    if (endTime!.isDayStart) {
      // Duration from start time to end of day (23:59:59)
      final minutesUntilEndOfDay = (24 * 60) - startMinutes;
      return Duration(minutes: minutesUntilEndOfDay);
    } else if (endMinutes < startMinutes) {
      // End time is on the next day
      final minutesUntilMidnight = (24 * 60) - startMinutes;
      return Duration(minutes: minutesUntilMidnight + endMinutes);
    } else {
      // Same day event
      return Duration(minutes: endMinutes - startMinutes);
    }
  }

  /// Returns a boolean that defines whether current event is occurring on
  /// [currentDate] or not.
  ///
  bool occursOnDate(DateTime currentDate) {
    return currentDate == date ||
        currentDate == endDate ||
        (currentDate.isBefore(endDate.withoutTime) &&
            currentDate.isAfter(date.withoutTime));
  }

  /// Returns event data in [Map<String, dynamic>] format.
  Map<String, dynamic> toJson() => {
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "event": event,
        "title": title,
        "description": description,
        "endDate": endDate,
        "recurrenceSettings": recurrenceSettings,
      };

  /// Returns new object of [CalendarEventData] with the updated values defined
  /// as the arguments.
  ///
  CalendarEventData<T> copyWith({
    String? title,
    String? description,
    T? event,
    Color? color,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    DateTime? endDate,
    DateTime? date,
    RecurrenceSettings? recurrenceSettings,
  }) {
    return CalendarEventData(
      title: title ?? this.title,
      startDate: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      description: description ?? this.description,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      endDate: endDate ?? this.endDate,
      event: event ?? this.event,
      titleStyle: titleStyle ?? this.titleStyle,
      recurrenceSettings: recurrenceSettings ?? this.recurrenceSettings,
    );
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return other is CalendarEventData<T> &&
        date.compareWithoutTime(other.date) &&
        endDate.compareWithoutTime(other.endDate) &&
        ((event == null && other.event == null) ||
            (event != null && other.event != null && event == other.event)) &&
        ((startTime == null && other.startTime == null) ||
            (startTime != null &&
                other.startTime != null &&
                startTime!.isSameAs(other.startTime!))) &&
        ((endTime == null && other.endTime == null) ||
            (endTime != null &&
                other.endTime != null &&
                endTime!.isSameAs(other.endTime!))) &&
        title == other.title &&
        color == other.color &&
        titleStyle == other.titleStyle &&
        descriptionStyle == other.descriptionStyle &&
        description == other.description;
  }

  @override
  int get hashCode =>
      description.hashCode ^
      descriptionStyle.hashCode ^
      titleStyle.hashCode ^
      color.hashCode ^
      title.hashCode ^
      date.hashCode;
}

/// {@template calendar_event_data_doc}
/// Stores the event data.
///
/// [date] and [endDate] define the date range of the event.
/// [startTime] and [endTime] define the time of the event on the start and end dates respectively.
///
/// If [startTime] and [endTime] are null, the event is considered a full day event.
///
/// - [date] and [endDate] are used to define dates only. Any time information
///   provided with these arguments is ignored.
///
/// - [startTime] and [endTime] are of type [TimeOfDay], considering only hours and minutes.
///
/// - For multi-day events, [date] defines the start date and [endDate] defines
///   the end date. The [startTime] applies to the start date and
///   [endTime] applies to the end date.
/// {@endtemplate}
