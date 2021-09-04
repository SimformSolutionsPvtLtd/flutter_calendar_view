// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:math' as math;

import '../calendar_event_data.dart';
import '../extensions.dart';

part 'merge_event_arranger.dart';
part 'side_event_arranger.dart';

abstract class EventArranger<T> {
  /// [EventArranger] defines how simultaneous events will be arranged.
  /// Implement [arrange] method to define how events will be arranged.
  ///
  /// There are three predefined class that implements of [EventArranger].
  ///
  /// [_StackEventArranger], [SideEventArranger] and [MergeEventArranger].
  ///
  const EventArranger();

  /// This method will arrange all the events in and return List of
  /// [OrganizedCalendarEventData].
  ///
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  });
}

/// Provides event data with its [left], [right], [top], and [bottom] boundary.
class OrganizedCalendarEventData<T> {
  /// Top position from where event tile will start.
  final double top;

  /// End position from where event tile will end.
  final double bottom;

  /// Left position from where event tile will start.
  final double left;

  /// Right position where event tile will end.
  final double right;

  /// List of events to display in given tile.
  final List<CalendarEventData<T>> events;

  /// Start duration of event/event list.
  final DateTime? startDuration;

  /// End duration of event/event list.
  final DateTime? endDuration;

  /// Provides event data with its [left], [right], [top], and [bottom]
  /// boundary.
  OrganizedCalendarEventData({
    this.startDuration,
    this.endDuration,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.events,
  });

  OrganizedCalendarEventData.empty()
      : startDuration = DateTime.now(),
        endDuration = DateTime.now(),
        right = 0,
        left = 0,
        events = const [],
        top = 0,
        bottom = 0;

  OrganizedCalendarEventData<T> getWithUpdatedRight(double right) =>
      OrganizedCalendarEventData<T>(
        top: top,
        bottom: bottom,
        endDuration: endDuration,
        events: events,
        left: left,
        right: right,
        startDuration: startDuration,
      );
}
