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
    required TextScaler textScaleFactor,
    bool isMinEventTileHeight = false,
  }) {
    // TODO: Right now all the events that are passed in this function must be
    // sorted in ascending order of the start time.
    //
    final arrangedEvents = <OrganizedCalendarEventData<T>>[];

    //Checking if startTime and endTime are correct
    for (final event in events) {
      // Checks if an event has valid start and end time.
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
            } catch (e) {} // ignore:empty_catches

            return true;
          }(), "Can not add event in the list.");
          continue;
        }
      }

      DateTime? newEndTime;
      int? newEventEnd;
      final startTime = event.startTime!;
      var endTime = event.endTime!;

      // startTime.getTotalMinutes returns the number of minutes from 00h00 to the beginning of the event
      // But the first hour to be displayed (startHour) could be 06h00, so we have to substract
      // The number of minutes from 00h00 to startHour which is equal to startHour * 60
      final eventStart = startTime.getTotalMinutes - (startHour * 60);
      final eventEnd = endTime.getTotalMinutes - (startHour * 60) == 0
          ? Constants.minutesADay - (startHour * 60)
          : endTime.getTotalMinutes - (startHour * 60);

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
            textScaler: textScaleFactor,
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
            arrangedEvents[i].endDuration.getTotalMinutes == 0
                ? Constants.minutesADay
                : arrangedEvents[i].endDuration.getTotalMinutes;

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
