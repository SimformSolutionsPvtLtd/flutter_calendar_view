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
    if (events.isEmpty) return [];

    final startHourInMinutes = startHour * 60;

    // Step 1: Normalize all events for the current calendar view date
    final normalizedEvents =
        _normalizeEventsForDate(events, calendarViewDate, startHourInMinutes);

    if (normalizedEvents.isEmpty) return [];

    // Step 2: Sort events by start time for optimal processing
    normalizedEvents
        .sort((a, b) => a.effectiveStartTime.compareTo(b.effectiveStartTime));

    // Step 3: Create columns using an efficient sweep line algorithm
    final columns = _createOptimalColumns(normalizedEvents);

    // Step 4: Convert columns to organized calendar event data
    return _convertColumnsToOrganizedData(columns, width, height,
        heightPerMinute, startHourInMinutes, calendarViewDate);
  }

  /// Normalizes events for the specific calendar view date
  List<_NormalizedEvent<T>> _normalizeEventsForDate(
    List<CalendarEventData<T>> events,
    DateTime calendarViewDate,
    int startHourInMinutes,
  ) {
    final normalizedEvents = <_NormalizedEvent<T>>[];

    for (final event in events) {
      if (event.startTime == null || event.endTime == null) continue;

      int effectiveStartTime;
      int effectiveEndTime;

      if (event.isRangingEvent) {
        // Handle multi-day events based on which day we're viewing
        final isStartDate =
            calendarViewDate.isAtSameMomentAs(event.date.withoutTime);
        final isEndDate =
            calendarViewDate.isAtSameMomentAs(event.endDate.withoutTime);

        if (isStartDate && isEndDate) {
          // Event starts and ends on the same day (single day spanning event)
          effectiveStartTime = event.startTime!.getTotalMinutes;
          effectiveEndTime = event.endTime!.getTotalMinutes;
        } else if (isStartDate) {
          // First day of multi-day event - start at event time, end at day end
          effectiveStartTime = event.startTime!.getTotalMinutes;
          effectiveEndTime = Constants.minutesADay;
        } else if (isEndDate) {
          // Last day of multi-day event - start at day start, end at event time
          effectiveStartTime = 0;
          effectiveEndTime = event.endTime!.getTotalMinutes;
        } else {
          // Middle day of multi-day event - full day
          effectiveStartTime = 0;
          effectiveEndTime = Constants.minutesADay;
        }
      } else {
        // Regular single-day event
        effectiveStartTime = event.startTime!.getTotalMinutes;
        effectiveEndTime = event.endTime!.getTotalMinutes;
      }

      // Skip events that don't appear in the visible time range
      final visibleStart = startHourInMinutes;
      final visibleEnd = Constants.minutesADay;

      if (effectiveEndTime <= visibleStart ||
          effectiveStartTime >= visibleEnd) {
        continue;
      }

      normalizedEvents.add(_NormalizedEvent<T>(
        originalEvent: event,
        effectiveStartTime: effectiveStartTime,
        effectiveEndTime: effectiveEndTime,
        isMultiDay: event.isRangingEvent,
        isFullDay: event.isFullDayEvent,
      ));
    }

    return normalizedEvents;
  }

  /// Creates optimal columns using O(n²) algorithm that prevents overlapping
  List<List<_NormalizedEvent<T>>> _createOptimalColumns(
      List<_NormalizedEvent<T>> events) {
    if (events.isEmpty) return [];

    final columns = <List<_NormalizedEvent<T>>>[];

    for (final event in events) {
      int targetColumn = -1;

      // Check each existing column to see if this event can fit
      for (int i = 0; i < columns.length; i++) {
        if (_canEventFitInColumn(event, columns[i])) {
          targetColumn = i;
          break;
        }
      }

      // If no available column found, create a new one
      if (targetColumn == -1) {
        columns.add([event]);
      } else {
        columns[targetColumn].add(event);
      }
    }

    return columns;
  }

  /// Checks if an event can fit in a specific column without overlapping
  bool _canEventFitInColumn(
      _NormalizedEvent<T> event, List<_NormalizedEvent<T>> column) {
    for (final existing in column) {
      if (_eventsOverlap(event, existing)) {
        return false;
      }
    }
    return true;
  }

  /// Checks if two events overlap based on includeEdges setting
  bool _eventsOverlap(_NormalizedEvent<T> event1, _NormalizedEvent<T> event2) {
    if (includeEdges) {
      // Events overlap if they have any overlapping time (including touching edges)
      return event1.effectiveStartTime <= event2.effectiveEndTime &&
          event2.effectiveStartTime <= event1.effectiveEndTime;
    } else {
      // Events overlap only if they have actual time overlap (not just touching)
      return event1.effectiveStartTime < event2.effectiveEndTime &&
          event2.effectiveStartTime < event1.effectiveEndTime;
    }
  }

  /// Converts columns to organized calendar event data with proper width allocation
  List<OrganizedCalendarEventData<T>> _convertColumnsToOrganizedData(
    List<List<_NormalizedEvent<T>>> columns,
    double totalWidth,
    double height,
    double heightPerMinute,
    int startHourInMinutes,
    DateTime calendarViewDate,
  ) {
    final result = <OrganizedCalendarEventData<T>>[];
    final columnCount = columns.length;

    if (columnCount == 0) return result;

    // Two different strategies based on whether maxWidth is specified
    if (maxWidth != null) {
      // Strategy 1: Fixed width columns when maxWidth is specified
      _processWithFixedMaxWidth(columns, result, totalWidth, height,
          heightPerMinute, startHourInMinutes, calendarViewDate);
    } else {
      // Strategy 2: Dynamic width allocation when maxWidth is NOT specified
      _processWithDynamicWidth(columns, result, totalWidth, height,
          heightPerMinute, startHourInMinutes, calendarViewDate);
    }

    return result;
  }

  /// Process events with fixed maxWidth for each column
  /// Process events with fixed maxWidth for each column
  void _processWithFixedMaxWidth(
    List<List<_NormalizedEvent<T>>> columns,
    List<OrganizedCalendarEventData<T>> result,
    double totalWidth,
    double height,
    double heightPerMinute,
    int startHourInMinutes,
    DateTime calendarViewDate,
  ) {
    final columnCount = columns.length;
    final baseSlotWidth = totalWidth / columnCount;

    // Calculate actual widths for all events first to avoid gaps
    final eventWidths = <int, double>{};
    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final column = columns[columnIndex];
      for (final normalizedEvent in column) {
        // Calculate dynamic width available to the right
        final dynamicWidth = _calculateAvailableWidthToRight(
            normalizedEvent, columns, columnIndex, totalWidth);

        final maxWidthPixels = maxWidth ?? double.maxFinite;
        eventWidths[normalizedEvent.hashCode] =
            math.min(dynamicWidth, maxWidthPixels);
      }
    }

    // Position events by column
    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final column = columns[columnIndex];
      final leftPosition = columnIndex * maxWidth!;

      for (final normalizedEvent in column) {
        final event = normalizedEvent.originalEvent;

        final displayStartTime = math.max(
            0, normalizedEvent.effectiveStartTime - startHourInMinutes);
        final displayEndTime = math.min(
            Constants.minutesADay - startHourInMinutes,
            normalizedEvent.effectiveEndTime - startHourInMinutes);

        // Use the individual event width rather than column width
        final actualWidth = eventWidths[normalizedEvent.hashCode]!;

        final top = displayStartTime * heightPerMinute;
        final visibleMinutes = Constants.minutesADay - startHourInMinutes;
        final bottom = displayEndTime >= visibleMinutes
            ? 0.0
            : height - displayEndTime * heightPerMinute;

        result.add(OrganizedCalendarEventData<T>(
          left: leftPosition,
          right: math.max(0.0, totalWidth - leftPosition - actualWidth),
          top: top,
          bottom: bottom,
          startDuration: event.startTime!.copyFromMinutes(displayStartTime),
          endDuration: event.endTime!.copyFromMinutes(displayEndTime),
          events: [event],
          calendarViewDate: calendarViewDate,
        ));
      }
    }
  }

  /// Process events with dynamic width allocation (stretch to available space)
  void _processWithDynamicWidth(
    List<List<_NormalizedEvent<T>>> columns,
    List<OrganizedCalendarEventData<T>> result,
    double totalWidth,
    double height,
    double heightPerMinute,
    int startHourInMinutes,
    DateTime calendarViewDate,
  ) {
    final columnCount = columns.length;

    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final column = columns[columnIndex];

      for (final normalizedEvent in column) {
        final event = normalizedEvent.originalEvent;

        final displayStartTime = math.max(
            0, normalizedEvent.effectiveStartTime - startHourInMinutes);
        final displayEndTime = math.min(
            Constants.minutesADay - startHourInMinutes,
            normalizedEvent.effectiveEndTime - startHourInMinutes);

        // Calculate available width by checking what's to the right
        final availableWidth = _calculateAvailableWidthToRight(
            normalizedEvent, columns, columnIndex, totalWidth);

        // Use standard column positioning for left offset
        final baseSlotWidth = totalWidth / columnCount;
        final leftOffset = columnIndex * baseSlotWidth;

        // Use the available width (can extend beyond original column)
        final actualWidth = availableWidth;

        final top = displayStartTime * heightPerMinute;
        final visibleMinutes = Constants.minutesADay - startHourInMinutes;
        final bottom = displayEndTime >= visibleMinutes
            ? 0.0
            : height - displayEndTime * heightPerMinute;

        result.add(OrganizedCalendarEventData<T>(
          left: leftOffset,
          right: math.max(0.0, totalWidth - leftOffset - actualWidth),
          top: top,
          bottom: bottom,
          startDuration: event.startTime!.copyFromMinutes(displayStartTime),
          endDuration: event.endTime!.copyFromMinutes(displayEndTime),
          events: [event],
          calendarViewDate: calendarViewDate,
        ));
      }
    }
  }

  /// Calculates how much width is available to the right of an event
  double _calculateAvailableWidthToRight(
    _NormalizedEvent<T> targetEvent,
    List<List<_NormalizedEvent<T>>> allColumns,
    int targetColumnIndex,
    double totalWidth,
  ) {
    final columnCount = allColumns.length;
    final baseSlotWidth = totalWidth / columnCount;
    final startPosition = targetColumnIndex * baseSlotWidth;

    // Start with remaining space from current position to end
    double availableWidth = totalWidth - startPosition;

    // Check each column to the right to see if any events overlap with our target event
    for (int rightColumnIndex = targetColumnIndex + 1;
        rightColumnIndex < columnCount;
        rightColumnIndex++) {
      final rightColumn = allColumns[rightColumnIndex];
      bool hasBlockingEvent = false;

      // Check if any event in this right column overlaps with our target event
      for (final rightEvent in rightColumn) {
        if (_eventsOverlap(targetEvent, rightEvent)) {
          hasBlockingEvent = true;
          break;
        }
      }

      if (hasBlockingEvent) {
        // This column blocks further expansion, limit width to this position
        final blockingPosition = rightColumnIndex * baseSlotWidth;
        availableWidth = blockingPosition - startPosition;
        break;
      }
    }

    // Ensure minimum width of at least one column
    return math.max(baseSlotWidth, availableWidth);
  }
}

/// Internal class to normalize event data for efficient processing
class _NormalizedEvent<T extends Object?> {
  final CalendarEventData<T> originalEvent;
  final int effectiveStartTime;
  final int effectiveEndTime;
  final bool isMultiDay;
  final bool isFullDay;

  const _NormalizedEvent({
    required this.originalEvent,
    required this.effectiveStartTime,
    required this.effectiveEndTime,
    required this.isMultiDay,
    required this.isFullDay,
  });
}
