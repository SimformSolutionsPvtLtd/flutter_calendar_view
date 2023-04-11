// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'extensions.dart';

/// Stores all the events on [date]
@immutable
class CalendarEventData<T extends Object?> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// Defines the start time of the event.
  /// [endTime] and [startTime] will defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime? startTime;

  /// Defines the end time of the event.
  /// [endTime] and [startTime] defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime? endTime;

  /// Title of the event.
  final String title;

  /// Description of the event.
  final String description;

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

  /// Stores all the events on [date]
  const CalendarEventData({
    required this.title,
    this.description = "",
    this.event,
    this.color = Colors.blue,
    this.startTime,
    this.endTime,
    this.titleStyle,
    this.descriptionStyle,
    DateTime? endDate,
    required this.date,
  }) : _endDate = endDate;

  DateTime get endDate => _endDate ?? date;

  Map<String, dynamic> toJson() => {
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "event": event,
        "title": title,
        "description": description,
        "endDate": endDate,
      };

  @override
  String toString() => toJson().toString();

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
                startTime!.hasSameTimeAs(other.startTime!))) &&
        ((endTime == null && other.endTime == null) ||
            (endTime != null &&
                other.endTime != null &&
                endTime!.hasSameTimeAs(other.endTime!))) &&
        title == other.title &&
        color == other.color &&
        titleStyle == other.titleStyle &&
        descriptionStyle == other.descriptionStyle &&
        description == other.description;
  }

  @override
  int get hashCode => super.hashCode;

  /// Updates this eventData's startTime.
  CalendarEventData<T>? updateEventStartTime({
    required double primaryDelta,
    required double heightPerMinute,
    Duration minimumDuration = const Duration(minutes: 15),
  }) {
    assert(
      startTime != null,
      "To resize event, startTime can't be null",
    );
    assert(
      endTime != null,
      "To resize event, endTime can't be null",
    );

    // Calculate the change in duration.
    final deltaDuration = (primaryDelta / heightPerMinute).toDuration;

    // Calculate the new start time.
    var newStartTime = startTime!.add(deltaDuration);

    if (newStartTime.isAfter(endTime!.subtract(minimumDuration))) {
      // If the new start time is after the endTime - minimumDuration.
      newStartTime = endTime!.subtract(minimumDuration);
    } else if (newStartTime.isBefore(date.startOfToday)) {
      // If the new start time is before the start of this day then set it to
      // start of today.
      newStartTime = date.startOfToday;
    }

    return copyWith(
      startTime: newStartTime,
    );
  }

  /// Updates this event's endTime.
  CalendarEventData<T>? updateEventEndTime({
    required double primaryDelta,
    required double heightPerMinute,
    Duration minimumDuration = const Duration(minutes: 15),
  }) {
    assert(
      startTime != null,
      "To resize event, startTime can't be null",
    );
    assert(
      endTime != null,
      "To resize event, endTime can't be null",
    );

    // Calculate the change in duration.
    final deltaDuration = (primaryDelta / heightPerMinute).toDuration;

    // Calculate the new start time.
    var newEndTime = endTime!.add(deltaDuration);

    if (newEndTime.isBefore(startTime!.add(minimumDuration))) {
      // If the new end time is before the startTime + minimumDuration.
      newEndTime = endTime!.add(minimumDuration);
    } else if (newEndTime.isAfter(date.endOfToday)) {
      // If the new end time is after the end of this day then set it to end
      // of today.
      newEndTime = date.endOfToday;
    }

    return copyWith(
      endTime: newEndTime,
    );
  }

  /// Reschedule the event.
  CalendarEventData<T>? rescheduleEvent({
    required double primaryDelta,
    required double heightPerMinute,
  }) {
    assert(
      startTime != null,
      "To resize event, startTime can't be null",
    );
    assert(
      endTime != null,
      "To resize event, endTime can't be null",
    );

    // Calculate the change in duration.
    final deltaDuration = (primaryDelta / heightPerMinute).toDuration;
    // Calculate the new start time.
    final newStartTime = startTime!.add(deltaDuration);
    // Calculate the new end time.
    final newEndTime = endTime!.add(deltaDuration);

    if (newStartTime.isAfter(date.startOfToday) &&
        newEndTime.isBefore(date.endOfToday)) {
      // If the new start time is after the start of this day and before the end
      // of this day.
      return copyWith(
        startTime: newStartTime,
        endTime: newEndTime,
        date: newStartTime,
        endDate: newEndTime,
      );
    } else {
      return null;
    }
  }

  /// Copy the [CalendarEventData] with new values.
  CalendarEventData<T>? copyWith({
    String? taskPath,
    Color? color,
    DateTime? date,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? endDate,
    T? event,
  }) {
    return CalendarEventData(
      color: color ?? this.color,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      endDate: endDate ?? this.endDate,
      event: event ?? this.event,
    );
  }
}
