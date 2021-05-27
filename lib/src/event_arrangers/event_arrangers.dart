import 'dart:math' as math;

import '../calendar_event_data.dart';
import '../extensions.dart';

part 'merge_event_arranger.dart';
part 'side_event_arranger.dart';
part 'stack_event_arranger.dart';

abstract class EventArranger<T> {
  /// [EventArranger] defines how simultaneous events will be arranged.
  /// Implement [arrange] method to define how events will be arranged.
  ///
  /// There are three predefined class that implements of [EventArranger].
  ///
  /// [StackEventArranger], [SideEventArranger] and [MergeEventArranger].
  ///
  const EventArranger();

  /// This method will arrange all the events in and return List of [OrganizedCalendarEventData].
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
  final double top;
  final double bottom;
  final double left;
  final double right;
  final List<CalendarEventData<T>?> events;
  final DateTime? startDuration;
  final DateTime? endDuration;

  /// Provides event data with its [left], [right], [top], and [bottom] boundary.
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
      : this.startDuration = DateTime.now(),
        this.endDuration = DateTime.now(),
        this.right = 0,
        this.left = 0,
        this.events = const [],
        this.top = 0,
        this.bottom = 0;

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
