// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class SideEventArranger<T> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const SideEventArranger();

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    final durations = _getEventsDuration(events);
    final tempEvents = [...events]..sort((e1, e2) =>
        (e1.startTime?.getTotalMinutes ?? 0) -
        (e2.startTime?.getTotalMinutes ?? 0));

    final table = List.generate(
      events.length,
      (index) => List.generate(
        durations.length,
        (index) => null as CalendarEventData<T>?, // ignore: unnecessary_cast
      ),
    );

    var eventCounter = 0;
    var rowCounter = 0;

    while (tempEvents.isNotEmpty && rowCounter < events.length) {
      eventCounter = 0;

      var end = tempEvents[0].endTime?.getTotalMinutes ?? 0;

      _insertIntoTable(table, durations, rowCounter, tempEvents[0]);

      tempEvents.removeAt(0);

      while (tempEvents.isNotEmpty && eventCounter < tempEvents.length) {
        if ((tempEvents[eventCounter].startTime?.getTotalMinutes ?? 0) > end) {
          _insertIntoTable(
              table, durations, rowCounter, tempEvents[eventCounter]);

          end = tempEvents[eventCounter].endTime?.getTotalMinutes ?? 0;
          tempEvents.removeAt(eventCounter);
        } else {
          eventCounter++;
        }
      }
      rowCounter++;
    }

    final arrangedEvent = <OrganizedCalendarEventData<T>>[];

    final widthPerCol = width / rowCounter;

    for (var i = 0; i < rowCounter; i++) {
      CalendarEventData<T>? event;
      for (var j = 0; j < durations.length; j++) {
        if (table[i][j] != null && (event == null || table[i][j] != event)) {
          event = table[i][j];

          final top =
              (event!.startTime?.getTotalMinutes ?? 0) * heightPerMinute;
          final bottom = height -
              ((event.endTime?.getTotalMinutes ?? 0) * heightPerMinute);
          final left = widthPerCol * i;
          final right = width - (left + widthPerCol);

          final index = _containsEvent(arrangedEvent, event);

          if (index == -1) {
            final eventData = OrganizedCalendarEventData<T>(
              top: top,
              bottom: bottom,
              events: [event],
              left: left,
              right: right,
              startDuration: event.startTime ?? DateTime.now(),
              endDuration: event.endTime ?? DateTime.now(),
            );
            arrangedEvent.add(eventData);
          } else {
            arrangedEvent[index] = arrangedEvent[index]
                .getWithUpdatedRight(arrangedEvent[index].right - widthPerCol);
          }
        } else {
          continue;
        }
      }
    }
    return arrangedEvent;
  }

  int _containsEvent(
      List<OrganizedCalendarEventData<T>> events, CalendarEventData<T>? event) {
    for (var i = 0; i < events.length; i++) {
      if (events[i].events.isNotEmpty && events[i].events[0] == event) return i;
    }
    return -1;
  }

  void _insertIntoTable(List<List<CalendarEventData<T>?>> table,
      List<int> durations, int row, CalendarEventData<T> event) {
    var i = 0;

    final start = event.startTime?.getTotalMinutes ?? 0;
    final end = event.endTime?.getTotalMinutes ?? 0;

    while (i < durations.length && durations[i] != start) i++;

    while (i < durations.length && durations[i] <= end) {
      table[row][i++] = event;
    }
  }

  /// This method returns list of all durations (start and end)
  /// in ascending order.
  List<int> _getEventsDuration(List<CalendarEventData<T>> events) {
    final durations = <int>[];
    for (final event in events) {
      final startTime = event.startTime ?? DateTime.now();
      final endTime = event.endTime ?? startTime;
      assert(
          !(endTime.getTotalMinutes <= startTime.getTotalMinutes),
          "Assertion fail for event: \n$event\n"
          "startDate must be less than endDate.\n"
          "This error occurs when you does not provide startDate or endDate in "
          "CalendarEventDate or provided endDate occurs before startDate.");

      final start = startTime.getTotalMinutes;
      final end = endTime.getTotalMinutes;
      int i;

      /// Get position where we can add start duration
      for (i = 0; i < durations.length && durations[i] < start; i++) {}

      /// Check if start duration is not repeating or if i is equal to length
      /// of durations list then add duration because duration will not be
      /// repeating if there is no element at i index.
      if (i == durations.length || durations[i] != start)
        durations.insert(i, start);

      /// Get position where we can add end duration.
      for (i = i + 1; i < durations.length && durations[i] < end; i++) {}

      /// Check if end duration is not repeating or if i is equal to length of
      /// durations list then add duration because duration will not be
      /// repeating if there is no element at i index.
      if (i == durations.length || durations[i] != end)
        durations.insert(i, end);
    }
    return durations;
  }
}
