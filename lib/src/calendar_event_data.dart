// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';
import 'constants.dart';

/// Stores metadata for a calendar event and its date/time boundaries.
@immutable
class CalendarEventData<T extends Object?> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// The start time of the event as a [TimeOfDay].
  ///
  /// Derived automatically from the time component of [date]. For whole-day
  /// events created via [CalendarEventData.wholeDay] or when [date] has no
  /// time component, this will be `TimeOfDay(hour: 0, minute: 0)`.
  ///
  /// This field is read-only. To change the start time, create a new event
  /// or use [copyWith] with an updated [date].
  ///
  /// Required (non-zero) when using [CalendarEventData] in [DayView] or
  /// [WeekView] to position the event on the timeline.
  final TimeOfDay? startTime;

  /// The end time of the event as a [TimeOfDay].
  ///
  /// Derived automatically from the time component of [endDate]. Is `null`
  /// when no end date is provided (i.e. a single whole-day event). For
  /// whole-day multi-day events where [endDate] has no time component, both
  /// [startTime] and [endTime] will be `TimeOfDay(hour: 0, minute: 0)`,
  /// which causes [isFullDayEvent] to return `true`.
  ///
  /// A value of `TimeOfDay(hour: 0, minute: 0)` on a timed multi-day event
  /// means the event ends at the very **start** of [endDate] (an exclusive
  /// boundary). In that case [occursOnDate] will not include [endDate] as a
  /// visible day, and [getVisibleEndMinutes] returns 0 for that day.
  ///
  /// This field is read-only. To change the end time, create a new event
  /// or use [copyWith] with an updated [endDate].
  ///
  /// Required (non-zero) when using [CalendarEventData] in [DayView] or
  /// [WeekView] to position the event on the timeline.
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

  /// Specifies the end date of the event.
  final DateTime? _endDate;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

  /// Define reoccurrence settings
  final RecurrenceSettings? recurrenceSettings;

  /// Private constructor for internal use
  ///
  /// [date] specifies when the event starts including date and time both.
  /// [endDate] specifies when the event ends including date and time both.
  CalendarEventData._({
    required this.title,
    required DateTime date,
    DateTime? endDate,
    this.description,
    this.event,
    this.color = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
    this.recurrenceSettings,
  })  : date = date.withoutTime,
        _endDate = endDate?.withoutTime,
        startTime = TimeOfDay(hour: date.hour, minute: date.minute),
        endTime = endDate == null
            ? null
            : TimeOfDay(hour: endDate.hour, minute: endDate.minute);

  /// {@macro calendar_event_data_doc}
  /// Creates a basic calendar event.
  ///
  /// [date] sets both the start date and start time of the event. The time
  /// portion of [date] is captured as [startTime].
  ///
  /// [endDate] sets both the end date and end time of the event. The time
  /// portion of [endDate] is captured as [endTime]. Omit for whole-day
  /// events that have no explicit end time.
  ///
  /// Use type-specific factories ([timeRanged], [wholeDay], [multiDay]) for
  /// better clarity.
  factory CalendarEventData({
    required String title,
    required DateTime date,
    String? description,
    T? event,
    Color color = Colors.blue,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
    DateTime? endDate,
  }) {
    // Full start datetime; time portion is used as the start time.
    // Full end datetime; time portion is used as the end time.
    return CalendarEventData._(
      title: title,
      date: date,
      endDate: endDate,
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
  /// [date] carries both the date and the start time. [endDate] carries both
  /// the date and the end time (typically the same calendar day). For overnight
  /// events that cross midnight, pass the **next** calendar day as [endDate]
  /// (or use the default [CalendarEventData] constructor directly).
  ///
  /// Example:
  /// ```dart
  /// final meeting = CalendarEventData.timeRanged(
  ///   title: "Team Meeting",
  ///   date: DateTime(2024, 1, 15, 14, 0),    // 2 PM on Jan 15
  ///   endDate: DateTime(2024, 1, 15, 16, 0), // 4 PM on Jan 15
  ///   description: "Weekly sync",
  /// );
  /// ```
  factory CalendarEventData.timeRanged({
    required String title,
    required DateTime date,
    required DateTime endDate,
    String? description,
    T? event,
    Color color = Colors.blue,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
  }) {
    return CalendarEventData._(
      title: title,
      date: date,
      endDate: endDate,
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
  /// The time portion of [date] is ignored; the event covers the entire day.
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
  /// [date] carries both the start date and the start time. Pass
  /// `DateTime(year, month, day)` (date-only) for whole-day starts.
  /// [endDate] carries both the end date and the end time. Pass
  /// `DateTime(year, month, day)` (date-only) for whole-day ends.
  ///
  /// Use this for events like conferences, vacations, workshops, or any event
  /// spanning multiple days with or without specific times.
  ///
  /// Examples:
  /// ```dart
  /// // Whole-day multi-day event (vacation, conference)
  /// final conference = CalendarEventData.multiDay(
  ///   title: "Tech Conference",
  ///   date: DateTime(2024, 3, 10),
  ///   endDate: DateTime(2024, 3, 12),
  ///   description: "3-day tech event",
  /// );
  ///
  /// // Multi-day event with specific times (e.g., 9 AM on 3rd to 5 PM on 6th)
  /// final workshop = CalendarEventData.multiDay(
  ///   title: "Extended Workshop",
  ///   date: DateTime(2024, 2, 3, 9, 0),    // 9 AM on Feb 3
  ///   endDate: DateTime(2024, 2, 6, 17, 0), // 5 PM on Feb 6
  ///   description: "Workshop from 9 AM on 3rd to 5 PM on 6th",
  /// );
  /// ```
  factory CalendarEventData.multiDay({
    required String title,
    // Start date+time of the event; time portion is used as the start time.
    required DateTime date,
    // End date+time of the event; time portion is used as the end time.
    required DateTime endDate,
    String? description,
    T? event,
    Color color = Colors.blue,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
  }) {
    return CalendarEventData._(
      title: title,
      date: date,
      endDate: endDate,
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
  /// An event is considered full-day if:
  /// - Both [startTime] and [endTime] are null, OR
  /// - Both [startTime] and [endTime] are at day start (00:00)
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
      // Multi-day event with specific times.
      // Calculate duration from startTime on start date to endTime on end date.
      // A midnight endTime (00:00) means the event ends at the start of endDate
      // (exclusive boundary); no extra day is added.
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

    // Single-day event with specific times.
    // If endTime is at or before startTime (including midnight 00:00), the
    // event crosses midnight: treat the end as belonging to the next day.
    final endMinutes = endTime!.getTotalMinutes;
    final startMinutes = startTime!.getTotalMinutes;
    if (endMinutes <= startMinutes) {
      return Duration(
        minutes: Constants.minutesADay - startMinutes + endMinutes,
      );
    }
    return Duration(minutes: endMinutes - startMinutes);
  }

  /// Returns a boolean that defines whether current event is occurring on
  /// [currentDate] or not.
  ///
  /// For timed multi-day events whose [endTime] is exactly midnight (00:00),
  /// [endDate] is treated as exclusive: the event ends at the very start of
  /// that day and does not appear on it.
  bool occursOnDate(DateTime currentDate) {
    // For timed ranging events that end exactly at midnight, endDate is an
    // exclusive boundary (the event ends at the start of that day, not during
    // it). Shift the effective end back by one day so the endDate itself is
    // not included as a visible day.
    final exclusiveEnd =
        isRangingEvent && endTime != null && endTime!.isDayStart;
    final effectiveEndDate =
        exclusiveEnd ? endDate.subtract(const Duration(days: 1)) : endDate;

    return currentDate.compareWithoutTime(date) ||
        currentDate.compareWithoutTime(effectiveEndDate) ||
        (currentDate.withoutTime.isBefore(effectiveEndDate) &&
            currentDate.withoutTime.isAfter(date));
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
  /// [date] carries both the new start date and start time. When omitted, the
  /// existing [date] and [startTime] are preserved.
  ///
  /// [endDate] carries both the new end date and end time. When omitted, the
  /// existing [endDate] and [endTime] are preserved. Pass `null` explicitly
  /// via a separate constructor to clear the end date (not supported in
  /// `copyWith` — create a new instance instead).
  CalendarEventData<T> copyWith({
    String? title,
    String? description,
    T? event,
    Color? color,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    DateTime? endDate,
    DateTime? date,
    RecurrenceSettings? recurrenceSettings,
  }) {
    // When date is omitted, reconstruct from stored date + existing startTime
    // so that the time portion is preserved.
    final DateTime effectiveDate = date ??
        DateTime(
          this.date.year,
          this.date.month,
          this.date.day,
          startTime?.hour ?? 0,
          startTime?.minute ?? 0,
        );
    // When endDate is omitted, reconstruct from stored _endDate + existing
    // endTime if an end date was originally set, otherwise keep it null.
    final DateTime? effectiveEndDate = endDate ??
        (_endDate != null
            ? DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
                this.endTime?.hour ?? 0,
                this.endTime?.minute ?? 0,
              )
            : null);
    return CalendarEventData._(
      title: title ?? this.title,
      date: effectiveDate,
      endDate: effectiveEndDate,
      description: description ?? this.description,
      event: event ?? this.event,
      color: color ?? this.color,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
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
/// [date] defines the start date and time of the event. Its time component
/// is automatically captured as [startTime].
///
/// [endDate] defines the end date and time of the event. Its time component
/// is automatically captured as [endTime]. Omit [endDate] for a whole-day
/// event with no explicit end time.
///
/// The event is considered a full-day event when [endDate] is omitted, or
/// when both [date] and [endDate] have no time component (both at midnight
/// `00:00`).
///
/// [startTime] and [endTime] are derived automatically from [date] and
/// [endDate] respectively; they are read-only and cannot be set directly.
///
/// For multi-day events, [date] defines the start date+time and [endDate]
/// defines the end date+time. When [endDate] has a time component of
/// midnight (`00:00`) on a timed multi-day event, it is treated as an
/// exclusive boundary: the event ends at the very start of [endDate] and
/// does **not** appear on that day. To create an overnight event that
/// crosses midnight, pass the next calendar day as [endDate] with the
/// desired end time (e.g. `DateTime(year, month, day + 1, 2, 0)` for 2 AM).
/// {@endtemplate}
