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
    required double textScaleFactor,
    bool isMinEventTileHeight = false,
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

      DateTime? newEndTime;
      int? newEventEnd;
      final startTime = event.startTime!;
      var endTime = event.endTime!;

      final eventStart = startTime.getTotalMinutes;
      var eventEnd = endTime.getTotalMinutes == 0
          ? Constants.minutesADay
          : endTime.getTotalMinutes;

      /// For getting the event title height as per its font size
      if (isMinEventTileHeight) {
        final eventTitleSpan = TextSpan(
          text: event.title,
          style: event.titleStyle ??
              TextStyle(
                fontSize: Constants.maxFontSize,
              ),
        );
        final eventTitle = TextPainter(
            textScaleFactor: textScaleFactor,
            text: eventTitleSpan,
            textDirection: TextDirection.ltr);
        eventTitle.layout();

        final eventTileHeightAsPerDuration =
            (eventEnd - eventStart) * heightPerMinute;

        if (eventTileHeightAsPerDuration <= eventTitle.height) {
          final addHeight = eventTitle.height - eventTileHeightAsPerDuration;

          ///converting the height into time
          final addTime = (addHeight / heightPerMinute).ceil();

          newEventEnd = eventEnd + addTime;

          newEndTime = endTime.copyWith(
              hour: newEventEnd ~/ 60, minute: newEventEnd % 60);
        }
      }

      final arrangeEventLen = arrangedEvents.length;

      var eventIndex = -1;

      for (var i = 0; i < arrangeEventLen; i++) {
        final arrangedEventStart =
            arrangedEvents[i].startDuration.getTotalMinutes;
        final arrangedEventEnd =
            (arrangedEvents[i].newEndDuration ?? arrangedEvents[i].endDuration)
                        .getTotalMinutes ==
                    0
                ? Constants.minutesADay
                : (arrangedEvents[i].newEndDuration ??
                        arrangedEvents[i].endDuration)
                    .getTotalMinutes;

        if (_checkIsOverlapping(arrangedEventStart, arrangedEventEnd,
            eventStart, (newEventEnd ?? eventEnd))) {
          eventIndex = i;
          break;
        }
      }

      if (eventIndex == -1) {
        final top = eventStart * heightPerMinute;
        final bottom = (newEventEnd ?? eventEnd) * heightPerMinute == height
            ? 0.0
            : height - (newEventEnd ?? eventEnd) * heightPerMinute;

        final newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: 0,
          right: 0,
          startDuration: startTime.copyFromMinutes(eventStart),
          endDuration: endTime.copyFromMinutes(eventEnd),
          events: [
            isMinEventTileHeight
                ? event.updateEventTime(newEndTime: newEndTime ?? endTime)
                : event,
          ],
          newEndDuration: endTime.copyFromMinutes(newEventEnd ?? eventEnd),
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
        final endDuration = math.max(newEventEnd ?? eventEnd, arrangedEventEnd);

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
          events: arrangedEventData.events
            ..add(
              isMinEventTileHeight
                  ? event.updateEventTime(
                      newEndTime: arrangedEventData.endDuration
                          .copyFromMinutes(newEventEnd ?? eventEnd))
                  : event,
            ),
          newEndDuration:
              arrangedEventData.endDuration.copyFromMinutes(endDuration),
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
