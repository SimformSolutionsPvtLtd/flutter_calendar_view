// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class SideEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const SideEventArranger();

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
    required double textScaleFactor,
    bool isMinEventTileHeight = false,
  }) {
    final mergedEvents = MergeEventArranger<T>().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        isMinEventTileHeight: isMinEventTileHeight,
        textScaleFactor: textScaleFactor);

    final arrangedEvents = <OrganizedCalendarEventData<T>>[];

    for (final event in mergedEvents) {
      // If there is only one event in list that means, there
      // is no simultaneous events.
      if (event.events.length == 1) {
        arrangedEvents.add(event);
        continue;
      }

      final concurrentEvents = event.events;

      // if (isMinEventTileHeight) {
      //   concurrentEvents.sort(
      //     (a, b) => b.newEndTime!.getTotalMinutes
      //         .compareTo(a.newEndTime!.getTotalMinutes),
      //   );
      // }

      if (concurrentEvents.isEmpty) continue;

      var column = 1;
      final sideEventData = <_SideEventData<T>>[];
      var currentEventIndex = 0;

      while (concurrentEvents.isNotEmpty) {
        final event = concurrentEvents[currentEventIndex];
        final end = event.endTime!.getTotalMinutes == 0
            ? Constants.minutesADay
            : event.endTime!.getTotalMinutes;
        sideEventData.add(_SideEventData(column: column, event: event));
        concurrentEvents.removeAt(currentEventIndex);

        while (currentEventIndex < concurrentEvents.length) {
          if (end <
              concurrentEvents[currentEventIndex].startTime!.getTotalMinutes) {
            break;
          }

          currentEventIndex++;
        }

        if (concurrentEvents.isNotEmpty &&
            currentEventIndex >= concurrentEvents.length) {
          column++;
          currentEventIndex = 0;
        }
      }

      final slotWidth = width / column;

      for (final sideEvent in sideEventData) {
        if (sideEvent.event.startTime == null ||
            sideEvent.event.endTime == null) {
          assert(() {
            try {
              debugPrint("Start time or end time of an event can not be null. "
                  "This ${sideEvent.event} will be ignored.");
            } catch (e) {} // Suppress exceptions.

            return true;
          }(), "Can not add event in the list.");

          continue;
        }

        final startTime = sideEvent.event.startTime!;
        final endTime = sideEvent.event.endTime!;
        int? newEndTime;

        /// For getting the event title height as per its font size
        if (isMinEventTileHeight) {
          final endTimeInMin = endTime.getTotalMinutes;
          final eventTitleSpan = TextSpan(
            text: sideEvent.event.title,
            style: sideEvent.event.titleStyle ??
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
              (endTimeInMin - startTime.getTotalMinutes) * heightPerMinute;

          if (eventTileHeightAsPerDuration <= eventTitle.height) {
            final addHeight = eventTitle.height - eventTileHeightAsPerDuration;

            ///converting the height into time
            final addTime = (addHeight / heightPerMinute).ceil();

            newEndTime = endTimeInMin + addTime;
          }
        }

        final bottom = height -
            ((newEndTime ?? endTime.getTotalMinutes) == 0
                    ? Constants.minutesADay
                    : (newEndTime ?? endTime.getTotalMinutes)) *
                heightPerMinute;
        arrangedEvents.add(OrganizedCalendarEventData<T>(
          left: slotWidth * (sideEvent.column - 1),
          right: slotWidth * (column - sideEvent.column),
          top: startTime.getTotalMinutes * heightPerMinute,
          bottom: bottom,
          startDuration: startTime,
          endDuration: endTime,
          events: [sideEvent.event],
        ));
      }
    }

    return arrangedEvents;
  }
}

class _SideEventData<T> {
  final int column;
  final CalendarEventData<T> event;

  const _SideEventData({
    required this.column,
    required this.event,
  });
}
