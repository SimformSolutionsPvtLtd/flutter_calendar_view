// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class MergeEventArranger<T> extends EventArranger<T> {
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
      final startTime = event.startTime ?? DateTime.now();
      final endTime = event.endTime ?? startTime;

      assert(
          !(endTime.getTotalMinutes <= startTime.getTotalMinutes),
          "Assertion fail for event: \n$event\n"
          "startDate must be less than endDate.\n"
          "This error occurs when you does not provide startDate or endDate in "
          "CalendarEventDate or provided endDate occurs before startDate.");

      final eventStart = startTime.getTotalMinutes;
      final eventEnd = endTime.getTotalMinutes;

      final arrangeEventLen = arrangedEvents.length;

      var eventIndex = -1;

      for (var i = 0; i < arrangeEventLen; i++) {
        final arrangedEventStart =
            arrangedEvents[i].startDuration?.getTotalMinutes ?? 0;
        final arrangedEventEnd =
            arrangedEvents[i].endDuration?.getTotalMinutes ?? 0;

        if ((arrangedEventStart >= eventStart &&
                arrangedEventStart <= eventEnd) ||
            (arrangedEventEnd >= eventStart && arrangedEventEnd <= eventEnd) ||
            (eventStart >= arrangedEventStart &&
                eventStart <= arrangedEventEnd) ||
            (eventEnd >= arrangedEventStart && eventEnd <= arrangedEventEnd)) {
          eventIndex = i;
          break;
        }
      }

      if (eventIndex == -1) {
        final top = eventStart * heightPerMinute;
        final bottom = height - eventEnd * heightPerMinute;

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
            arrangedEventData.startDuration?.getTotalMinutes ?? 0;
        final arrangedEventEnd =
            arrangedEventData.endDuration?.getTotalMinutes ?? 0;

        final startDuration = math.min(eventStart, arrangedEventStart);
        final endDuration = math.max(eventEnd, arrangedEventEnd);

        final top = startDuration * heightPerMinute;
        final bottom = height - endDuration * heightPerMinute;

        final newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          startDuration:
              arrangedEventData.startDuration?.copyFromMinutes(startDuration),
          endDuration:
              arrangedEventData.endDuration?.copyFromMinutes(endDuration),
          events: arrangedEventData.events..add(event),
        );

        arrangedEvents[eventIndex] = newEvent;
      }
    }

    return arrangedEvents;
  }
}
