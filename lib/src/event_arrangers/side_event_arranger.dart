// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

class SideEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const SideEventArranger({
    this.maxWidth,
    this.includeEdges = false,
  });

  /// Decides whether events that are overlapping on edge
  /// (ex, event1 has the same end-time as the start-time of event 2)
  /// should be offset or not.
  ///
  /// If includeEdges is true, it will offset the events else it will not.
  ///
  final bool includeEdges;

  /// If enough space is available, the event slot will
  /// use the specified max width.
  /// Otherwise, it will reduce to fit all events in the cell.
  /// If max width is not specified, slots will expand to fill the cell.
  final double? maxWidth;

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
    final totalWidth = width;
    final startHourInMinutes = startHour * 60;

    List<_SideEventConfigs<T>> _categorizedColumnedEvents(
        List<CalendarEventData<T>> events) {
      final merged = MergeEventArranger<T>(includeEdges: includeEdges).arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: calendarViewDate,
      );

      final arranged = <_SideEventConfigs<T>>[];

      for (final event in merged) {
        if (event.events.isEmpty) {
          // NOTE(parth): This is safety condition.
          // This condition should never be true.
          // If by chance this becomes true, there is something wrong with
          // logic. And that need to be fixed ASAP.

          continue;
        }

        if (event.events.length > 1) {
          // NOTE: This means all the events are overlapping with each other.
          // So, we will extract all the events that can be fit in
          // Single column without overlapping and run the function
          // again for the rest of the events.

          final columnedEvents = _extractSingleColumnEvents(
            event.events,
            event.endDuration.getTotalMinutes,
          );

          final sided = _categorizedColumnedEvents(
            event.events.where((e) => !columnedEvents.contains(e)).toList(),
          );

          var maxColumns = 1;

          for (final event in sided) {
            if (event.columns > maxColumns) {
              maxColumns = event.columns;
            }
          }

          arranged.add(_SideEventConfigs(
            columns: maxColumns + 1,
            event: columnedEvents,
            sideEvents: sided,
          ));
        } else {
          // If this block gets executed that means we have only one event.
          // Return the event as is.

          arranged.add(_SideEventConfigs(columns: 1, event: event.events));
        }
      }

      return arranged;
    }

    List<OrganizedCalendarEventData<T>> _arrangeEvents(
        List<_SideEventConfigs<T>> events, double width, double offset) {
      final arranged = <OrganizedCalendarEventData<T>>[];

      for (final event in events) {
        final slotWidth =
            math.min(width / event.columns, maxWidth ?? double.maxFinite);

        if (event.event.isNotEmpty) {
          // TODO(parth): Arrange events and add it in arranged.

          arranged.addAll(event.event.map((e) {
            final startTime = e.startTime!;
            final endTime = e.endTime!;

            int eventStart;
            int eventEnd;

            if (e.isRangingEvent) {
              // Handle multi-day events differently based on which day is currently being viewed
              final isStartDate =
                  calendarViewDate.isAtSameMomentAs(e.date.withoutTime);
              final isEndDate =
                  calendarViewDate.isAtSameMomentAs(e.endDate.withoutTime);

              if (isStartDate && isEndDate) {
                // Single day event with start and end time
                eventStart = startTime.getTotalMinutes - (startHourInMinutes);
                eventEnd = endTime.getTotalMinutes - (startHourInMinutes) <= 0
                    ? Constants.minutesADay - (startHourInMinutes)
                    : endTime.getTotalMinutes - (startHourInMinutes);
              } else if (isStartDate) {
                // First day - show from start time to end of day
                eventStart = startTime.getTotalMinutes - (startHourInMinutes);
                eventEnd = Constants.minutesADay - (startHourInMinutes);
              } else if (isEndDate) {
                // Last day - show from start of day to end time
                eventStart = 0;
                eventEnd = endTime.getTotalMinutes - (startHourInMinutes) <= 0
                    ? Constants.minutesADay - (startHourInMinutes)
                    : endTime.getTotalMinutes - (startHourInMinutes);
              } else {
                // Middle days - show full day
                eventStart = 0;
                eventEnd = Constants.minutesADay - (startHourInMinutes);
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

            final top = eventStart * heightPerMinute;

            // Calculate visibleMinutes (the total minutes displayed in the view)
            final visibleMinutes = Constants.minutesADay - (startHourInMinutes);

            // Check if event ends at or beyond the visible area
            final bottom = eventEnd >= visibleMinutes
                ? 0.0 // Event extends to bottom of view
                : height - eventEnd * heightPerMinute;

            return OrganizedCalendarEventData<T>(
              left: offset,
              right: totalWidth - (offset + slotWidth),
              top: top,
              bottom: bottom,
              startDuration: startTime.copyFromMinutes(eventStart),
              endDuration: endTime.copyFromMinutes(eventEnd),
              events: [e],
              calendarViewDate: calendarViewDate,
            );
          }));
        }

        if (event.sideEvents.isNotEmpty) {
          arranged.addAll(_arrangeEvents(
            event.sideEvents,
            math.max(0, width - slotWidth),
            slotWidth + offset,
          ));
        }
      }

      return arranged;
    }

    // By default the offset will be 0.

    final columned = _categorizedColumnedEvents(events);
    final arranged = _arrangeEvents(columned, totalWidth, 0);
    return arranged;
  }

  List<CalendarEventData<T>> _extractSingleColumnEvents(
      List<CalendarEventData<T>> events, int end) {
    // Find the longest event from the list.
    final longestEvent = events.fold<CalendarEventData<T>>(
      events.first,
      (e1, e2) => e1.duration > e2.duration ? e1 : e2,
    );

    // Create a new list from events and remove the longest one from it.
    final searchEvents = [...events]..remove(longestEvent);

    // Create a new list for events in single column.
    // Right now it has longest event,
    // By the end of the function, this will have the list of the events,
    // that are not intersecting with each other.
    // and this will be returned from the function.
    final columnedEvents = [longestEvent];

    // Calculate effective end minute from latest columned event.
    var endMinutes = longestEvent.endTime!.getTotalMinutes;

    // Run the loop while effective end minute of columned events are
    // less than end.
    while (endMinutes < end && searchEvents.isNotEmpty) {
      // Maps the event with it's duration.
      final mappings = <int, CalendarEventData<T>>{};

      // Create a new list from searchEvents.
      for (final event in [...searchEvents]) {
        // Need to add logic to include edges...
        final start = event.startTime!.getTotalMinutes;

        // TODO(parth): Need to improve this.
        // This does not handle the case where there is a event before the
        // longest event which is not intersecting.
        //
        if (start < endMinutes || (includeEdges && start == endMinutes)) {
          // Remove search event from list so, we do not iterate through it
          // again.
          searchEvents.remove(event);
        } else {
          // Add the event in mappings.
          final diff = event.startTime!.getTotalMinutes - endMinutes;

          mappings.addAll({
            diff: event,
          });
        }
      }

      // This can be any integer larger than 1440 as one day has 1440 minutes.
      // so, different of 2 events end and start time will never be greater than
      // 1440.
      var min = 4000;

      for (final mapping in mappings.entries) {
        if (mapping.key < min) {
          min = mapping.key;
        }
      }

      if (mappings[min] != null) {
        // If mapping had min event, add it in columnedEvents,
        // and remove it from searchEvents so, we do not iterate through it
        // again.
        columnedEvents.add(mappings[min]!);
        searchEvents.remove(mappings[min]);

        endMinutes = mappings[min]!.endTime!.getTotalMinutes;
      }
    }

    return columnedEvents;
  }
}

class _SideEventConfigs<T extends Object?> {
  final int columns;
  final List<CalendarEventData<T>> event;
  final List<_SideEventConfigs<T>> sideEvents;

  const _SideEventConfigs({
    this.event = const [],
    required this.columns,
    this.sideEvents = const [],
  });
}
