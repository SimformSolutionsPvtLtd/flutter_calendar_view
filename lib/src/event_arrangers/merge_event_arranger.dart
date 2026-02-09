// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class MergeEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will merge all the simultaneous
  /// events. and that will act like one single event.
  /// [OrganizedCalendarEventData.events] will gives
  /// list of all the combined events.
  const MergeEventArranger({
    this.includeEdges = true,
  });

  /// Decides whether events that are overlapping on edge
  /// (ex, event1 has the same end-time as the start-time of event 2)
  /// should be merged together or not.
  ///
  /// If includeEdges is true, it will merge the events else it will not.
  ///
  final bool includeEdges;

  /// {@macro event_arranger_arrange_method_doc}
  ///
  /// Make sure that all the events that are passed in [events], must be in
  /// ascending order of start time.
  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
    required int startHour,
    required DateTime calendarViewDate,
  }) {
    // TODO: Right now all the events that are passed in this function must be
    // sorted in ascending order of the start time.
    //
    final arrangedEvents = <OrganizedCalendarEventData<T>>[];
    final startHourInMinutes = startHour * 60;
    final calendarDate = calendarViewDate.withoutTime;

    //Checking if startTime and endTime are correct
    for (final event in events) {
      if (event.startTime == null || event.endTime == null) {
        debugLog('startTime or endTime is null for ${event.title}');
        continue;
      }

      // Checks if an event has valid start and end time.
      if (event.endDate.millisecondsSinceEpoch <
          event.date.millisecondsSinceEpoch) {
        if (!(event.endTime!.getTotalMinutes == 0 &&
            event.startTime!.getTotalMinutes > 0)) {
          assert(() {
            try {
              debugPrint(
                  "Failed to add event because of one of the given reasons: "
                  "\n1. Start time or end time might be null"
                  "\n2. endTime occurs before or at the same time as startTime."
                  "\nEvent data: \n$event\n");
            } catch (e) {} // ignore:empty_catches

            return true;
          }(), "Can not add event in the list.");
          continue;
        }
      }

      final startTime = event.startTime!;
      final endTime = event.endTime!;

      // Use visible time range for this calendar date
      int eventStart =
          event.getVisibleStartMinutes(calendarDate) - startHourInMinutes;
      int eventEnd =
          event.getVisibleEndMinutes(calendarDate) - startHourInMinutes;

      // Ensure values are within valid range
      // Clamp to [0, minutesInView] where minutesInView = 1440 - startHourInMinutes
      eventStart = math.max(0, eventStart);
      eventEnd = math.max(
          0, eventEnd); // Prevent negative values from midnight handling
      eventEnd = math.min(
        Constants.minutesADay - startHourInMinutes,
        eventEnd,
      );

      final arrangeEventLen = arrangedEvents.length;

      // Find ALL overlapping arranged events and merge them together
      final overlappingIndices = <int>[];

      for (var i = 0; i < arrangeEventLen; i++) {
        final arrangedEventStart =
            arrangedEvents[i].startDuration.getTotalMinutes;

        final arrangedEventEnd =
            arrangedEvents[i].endDuration.getTotalMinutes == 0
                ? Constants.minutesADay
                : arrangedEvents[i].endDuration.getTotalMinutes;

        if (_checkIsOverlapping(
            arrangedEventStart, arrangedEventEnd, eventStart, eventEnd)) {
          overlappingIndices.add(i);
        }
      }

      if (overlappingIndices.isEmpty) {
        final top = eventStart * heightPerMinute;

        // Calculate visibleMinutes (the total minutes displayed in the view)
        final visibleMinutes = Constants.minutesADay - (startHourInMinutes);

        // Check if event ends at or beyond the visible area
        final bottom = eventEnd >= visibleMinutes
            ? 0.0 // Event extends to bottom of view
            : height - eventEnd * heightPerMinute;

        final newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          startDuration: startTime.copyFromMinutes(eventStart),
          endDuration: endTime.copyFromMinutes(eventEnd),
          events: [event],
          calendarViewDate: calendarViewDate,
        );

        arrangedEvents.add(newEvent);
      } else {
        // Merge with all overlapping events
        // Start with the current event's range
        var mergedStartDuration = eventStart;
        var mergedEndDuration = eventEnd;
        final mergedEvents = <CalendarEventData<T>>[event];

        // Collect all events from overlapping groups and expand the range
        for (final idx in overlappingIndices) {
          final arrangedEventData = arrangedEvents[idx];
          final arrangedEventStart =
              arrangedEventData.startDuration.getTotalMinutes;
          final arrangedEventEnd =
              arrangedEventData.endDuration.getTotalMinutes == 0
                  ? Constants.minutesADay
                  : arrangedEventData.endDuration.getTotalMinutes;

          mergedStartDuration =
              math.min(mergedStartDuration, arrangedEventStart);
          mergedEndDuration = math.max(mergedEndDuration, arrangedEventEnd);
          mergedEvents.addAll(arrangedEventData.events);
        }

        final top = mergedStartDuration * heightPerMinute;

        // Calculate visibleMinutes (the total minutes displayed in the view)
        final visibleMinutes = Constants.minutesADay - startHourInMinutes;

        // Check if event ends at or beyond the visible area
        final bottom = mergedEndDuration >= visibleMinutes
            ? 0.0 // Event extends to bottom of view
            : height - mergedEndDuration * heightPerMinute;

        final newMergedEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          startDuration: startTime.copyFromMinutes(mergedStartDuration),
          endDuration: endTime.copyFromMinutes(mergedEndDuration),
          events: mergedEvents,
          calendarViewDate: calendarViewDate,
        );

        // Remove all overlapping events (in reverse order to maintain indices)
        for (var i = overlappingIndices.length - 1; i >= 0; i--) {
          arrangedEvents.removeAt(overlappingIndices[i]);
        }

        // Add the merged event
        arrangedEvents.add(newMergedEvent);
      }
    }

    return arrangedEvents;
  }

  bool _checkIsOverlapping(int eStart1, int eEnd1, int eStart2, int eEnd2) {
    final result = (eStart1 >= eStart2 && eStart1 < eEnd2) ||
        (eEnd1 > eStart2 && eEnd1 <= eEnd2) ||
        (eStart2 >= eStart1 && eStart2 < eEnd1) ||
        (eEnd2 > eStart1 && eEnd2 <= eEnd1) ||
        (includeEdges &&
            (eStart1 == eEnd2 ||
                eEnd1 == eStart2 ||
                eStart2 == eEnd1 ||
                eEnd2 == eStart1));

    return result;
  }
}
