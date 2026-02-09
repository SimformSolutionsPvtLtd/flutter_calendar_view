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
          final endMinutes = event.endDuration.getTotalMinutes == 0
              ? 1440
              : event.endDuration.getTotalMinutes;
          final columnedEvents = _extractSingleColumnEvents(
            event.events,
            endMinutes,
            calendarViewDate,
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
          arranged.addAll(event.event.map((e) {
            final startTime = e.startTime!;
            final endTime = e.endTime!;

            // Use visible time calculation for multi-day event support
            final visibleStart =
                e.getVisibleStartMinutes(calendarViewDate.withoutTime);
            final visibleEnd =
                e.getVisibleEndMinutes(calendarViewDate.withoutTime);

            // Calculate event times relative to startHour
            int eventStart = visibleStart - startHourInMinutes;
            int eventEnd = visibleEnd - startHourInMinutes;

            // Ensure values are within valid range
            // Clamp to [0, minutesInView] where minutesInView = 1440 - startHourInMinutes
            eventStart = math.max(0, eventStart);
            eventEnd = math.max(0, eventEnd); // Prevent negative values
            eventEnd = math.min(
              Constants.minutesADay - startHourInMinutes,
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
      List<CalendarEventData<T>> events, int end, DateTime calendarViewDate) {
    final calendarDate = calendarViewDate.withoutTime;

    // Find the longest visible event on this calendar date
    final longestEvent = events.fold<CalendarEventData<T>>(
      events.first,
      (e1, e2) => e1.getVisibleDuration(calendarDate) >
              e2.getVisibleDuration(calendarDate)
          ? e1
          : e2,
    );

    // Create a new list from events and remove the longest one from it.
    final searchEvents = [...events]..remove(longestEvent);

    // Create a new list for events in single column.
    final columnedEvents = [longestEvent];

    // Calculate effective end minute from latest columned event.
    var endMinutes = longestEvent.getVisibleEndMinutes(calendarDate);

    // Run the loop while effective end minute of columned events are
    // less than end.
    while (endMinutes < end && searchEvents.isNotEmpty) {
      // Maps the event with it's duration.
      final mappings = <int, CalendarEventData<T>>{};

      // Create a new list from searchEvents.
      for (final event in [...searchEvents]) {
        // Check if event overlaps with ANY event in columnedEvents
        var hasOverlap = false;

        // Get visible time range for event on this calendar date
        final eventStart = event.getVisibleStartMinutes(calendarDate);
        final eventEnd = event.getVisibleEndMinutes(calendarDate);

        for (final columnedEvent in columnedEvents) {
          // Get visible time range for columnedEvent on this calendar date
          final columnedStart =
              columnedEvent.getVisibleStartMinutes(calendarDate);
          final columnedEnd = columnedEvent.getVisibleEndMinutes(calendarDate);

          // Check for overlap
          final overlaps =
              (eventStart < columnedEnd && eventEnd > columnedStart) ||
                  (includeEdges &&
                      (eventStart == columnedEnd || eventEnd == columnedStart));

          if (overlaps) {
            hasOverlap = true;
            break;
          }
        }

        if (hasOverlap) {
          searchEvents.remove(event);
        } else {
          final diff = eventStart - endMinutes;
          mappings.addAll({
            diff: event,
          });
        }
      }

      // Sentinel value for finding minimum time difference between events.
      // Must be larger than any possible time difference in a day (max = 1440 minutes).
      // Using 3x Constants.minutesADay to ensure it's always greater than max difference.
      const maxPossibleMinuteDifference = Constants.minutesADay * 3;
      var min = maxPossibleMinuteDifference;

      for (final mapping in mappings.entries) {
        if (mapping.key < min) {
          min = mapping.key;
        }
      }

      if (mappings[min] != null) {
        columnedEvents.add(mappings[min]!);
        searchEvents.remove(mappings[min]);

        endMinutes = mappings[min]!.getVisibleEndMinutes(calendarDate);
      } else {
        // No non-overlapping events found, break to avoid infinite loop
        break;
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
