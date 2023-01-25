// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class MergeEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will merge all the simultaneous
  /// events. and that will act like one single event.
  /// [OrganizedCalendarEventData.events] will gives
  /// list of all the combined events.
  const MergeEventArranger();

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    final arrangedEvents = <OrganizedCalendarEventData<T>>[];

    for (final event in events) {
      if (event.startTime == null ||
          event.endTime == null ||
          event.endTime!.getTotalMinutes <= event.startTime!.getTotalMinutes) {
        if (!(event.endTime!.getTotalMinutes == 0 &&
            event.startTime!.getTotalMinutes > 0)) {
          assert(() {
            try {
              debugPrint(
                  "Failed to add event because of one of the given reasons: "
                  "\n1. Start time or end time might be null"
                  "\n2. endTime occurs before or at the same time as startTime."
                  "\nEvent data: \n$event\n");
            } catch (e) {} // Suppress exceptions.

            return true;
          }(), "Can not add event in the list.");
          continue;
        }
      }

      final startTime = event.startTime!;
      final endTime = event.endTime!;

      final eventStart = startTime.getTotalMinutes;
      final eventEnd = endTime.getTotalMinutes == 0
          ? Constants.minutesADay
          : endTime.getTotalMinutes;

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
        final bottom = eventEnd * heightPerMinute == height
            ? 0.0
            : height - eventEnd * heightPerMinute;

        final newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          startDuration: startTime.copyFromMinutes(eventStart),
          endDuration: endTime.copyFromMinutes(eventEnd),
          events: [event],
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
        final bottom = endDuration * heightPerMinute == height
            ? 0.0
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
        );

        arrangedEvents[eventIndex] = newEvent;
      }
    }

    return arrangedEvents;
  }

  bool _checkIsOverlapping(int arrangedEventStart, int arrangedEventEnd,
      int eventStart, int eventEnd) {
    return (arrangedEventStart >= eventStart &&
            arrangedEventStart <= eventEnd) ||
        (arrangedEventEnd >= eventStart && arrangedEventEnd <= eventEnd) ||
        (eventStart >= arrangedEventStart && eventStart <= arrangedEventEnd) ||
        (eventEnd >= arrangedEventStart && eventEnd <= arrangedEventEnd);
  }
}
