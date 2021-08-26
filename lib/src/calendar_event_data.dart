// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extensions.dart';

/// Stores all the events on [date]
@immutable
class CalendarEventData<T> {
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

  /// Stores all the events on [date]
  CalendarEventData({
    required this.date,
    required this.title,
    this.description = "",
    this.event,
    this.color = Colors.blue,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() => {
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "event": event,
        "title": title,
        "description": description,
      };

  @override
  String toString() => this.toJson().toString();

  @override
  bool operator ==(Object other) {
    return other is CalendarEventData<T> &&
        this.date.compareWithoutTime(other.date) &&
        this.event == other.event &&
        this.title == other.title &&
        this.description == other.description;
  }

  @override
  int get hashCode => super.hashCode;
}
