// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class SideEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const SideEventArranger({
    this.includeEdges = false,
  });

  /// Decides whether events that are overlapping on edge
  /// (ex, event1 has the same end-time as the start-time of event 2)
  /// should be offset or not.
  ///
  /// If includeEdges is true, it will offset the events else it will not.
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
  }) {
    final mergedEvents = MergeEventArranger<T>(
      includeEdges: includeEdges,
    ).arrange(
      events: events,
      height: height,
      width: width,
      heightPerMinute: heightPerMinute,
      startHour: startHour,
    );

    final arrangedEvents = <OrganizedCalendarEventData<T>>[];

    for (final event in mergedEvents) {
      // If there is only one event in list that means, there
      // is no simultaneous events.
      if (event.events.length == 1) {
        arrangedEvents.add(event);
        continue;
      }

      final concurrentEvents = event.events;

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
            } catch (e) {} // ignore:empty_catches

            return true;
          }(), "Can not add event in the list.");

          continue;
        }

        final startTime = sideEvent.event.startTime!;
        final endTime = sideEvent.event.endTime!;

        // startTime.getTotalMinutes returns the number of minutes from 00h00 to the beginning hour of the event
        // But the first hour to be displayed (startHour) could be 06h00, so we have to substract
        // The number of minutes from 00h00 to startHour which is equal to startHour * 60

        final bottom = height -
            (endTime.getTotalMinutes - (startHour * 60) == 0
                    ? Constants.minutesADay - (startHour * 60)
                    : endTime.getTotalMinutes - (startHour * 60)) *
                heightPerMinute;

        final top =
            (startTime.getTotalMinutes - (startHour * 60)) * heightPerMinute;

        arrangedEvents.add(OrganizedCalendarEventData<T>(
          left: slotWidth * (sideEvent.column - 1),
          right: slotWidth * (column - sideEvent.column),
          top: top,
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
