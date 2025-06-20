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

      int eventStart;
      int eventEnd;

      if (event.isRangingEvent) {
        // Handle multi-day events differently based on which day is currently being viewed
        final isStartDate =
            calendarViewDate.isAtSameMomentAs(event.date.withoutTime);
        final isEndDate =
            calendarViewDate.isAtSameMomentAs(event.endDate.withoutTime);

        if (isStartDate && isEndDate) {
          // Single day event with start and end time
          eventStart = startTime.getTotalMinutes - (startHourInMinutes);
          eventEnd = endTime.getTotalMinutes - (startHourInMinutes) <= 0
              ? Constants.minutesADay - (startHourInMinutes)
              : endTime.getTotalMinutes - (startHourInMinutes);
        } else if (isStartDate) {
          // First day - show from start time to end of day
          eventStart = startTime.getTotalMinutes - (startHourInMinutes);
          eventEnd = Constants.minutesADay;
        } else if (isEndDate) {
          // Last day - show from start of day to end time
          eventStart = 0;
          eventEnd = endTime.getTotalMinutes - (startHourInMinutes) <= 0
              ? Constants.minutesADay - (startHourInMinutes)
              : endTime.getTotalMinutes - (startHourInMinutes);
        } else {
          // Middle days - show full day
          eventStart = 0;
          eventEnd = Constants.minutesADay;
        }
      } else {
        // Single day event - use normal start/end times
        eventStart = startTime.getTotalMinutes - (startHourInMinutes);
        eventEnd = endTime.getTotalMinutes - (startHourInMinutes) <= 0
            ? Constants.minutesADay - (startHourInMinutes)
            : endTime.getTotalMinutes - (startHourInMinutes);
      }

      // Ensure values are within valid range
      eventStart = math.max(0, eventStart);
      eventEnd = math.min(
        Constants.minutesADay - (startHourInMinutes),
        eventEnd,
      );

      final arrangeEventLen = arrangedEvents.length;

      var eventIndex = -1;

      for (var i = 0; i < arrangeEventLen; i++) {
        final arrangedEventStart =
            arrangedEvents[i].startDuration.getTotalMinutes;

        final arrangedEventEnd =
            arrangedEvents[i].endDuration.getTotalMinutes == 0
                ? Constants.minutesADay
                : arrangedEvents[i].endDuration.getTotalMinutes;

        if (_checkIsOverlapping(
            arrangedEventStart, arrangedEventEnd, eventStart, eventEnd)) {
          eventIndex = i;
          break;
        }
      }

      if (eventIndex == -1) {
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
        final arrangedEventData = arrangedEvents[eventIndex];

        final arrangedEventStart =
            arrangedEventData.startDuration.getTotalMinutes;
        final arrangedEventEnd =
            arrangedEventData.endDuration.getTotalMinutes == 0
                ? Constants.minutesADay
                : arrangedEventData.endDuration.getTotalMinutes;

        final startDuration = math.min(eventStart, arrangedEventStart);
        final endDuration = math.max(eventEnd, arrangedEventEnd);

        final top = startDuration * heightPerMinute;

        // Calculate visibleMinutes (the total minutes displayed in the view)
        final visibleMinutes = Constants.minutesADay - (startHourInMinutes);

        // Check if event ends at or beyond the visible area
        final bottom = endDuration >= visibleMinutes
            ? 0.0 // Event extends to bottom of view
            : height - endDuration * heightPerMinute;

        final newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          startDuration:
              arrangedEventData.startDuration.copyFromMinutes(startDuration),
          endDuration:
              arrangedEventData.endDuration.copyFromMinutes(endDuration),
          events: arrangedEventData.events..add(event),
          calendarViewDate: calendarViewDate,
        );

        arrangedEvents[eventIndex] = newEvent;
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
