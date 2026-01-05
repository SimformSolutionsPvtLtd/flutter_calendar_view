// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

/// Arranges overlapping calendar events side by side, ensuring no visual overlap and optimal use of space.
/// Supports multi-day and full-day events, fixed or dynamic width allocation, and configurable edge overlap handling.
///
/// Events are grouped into columns to prevent overlaps, and each event is positioned and sized for best readability.
/// Use [maxWidth] to constrain event width, and [countAdjacentEventsAsOverlapping] to control whether touching events are treated as overlapping.
class SideEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const SideEventArranger({
    this.maxWidth,
    this.countAdjacentEventsAsOverlapping = false,
  });

  /// Controls how back-to-back events are positioned.
  ///
  /// **When `false` (default):**
  /// - Events touching at edges (e.g., Event A ends at 2:00 PM, Event B starts at 2:00 PM) are NOT overlapping
  /// - Each event expands to fill available width
  ///
  /// **When `true`:**
  /// - Events touching at edges ARE considered overlapping
  /// - Events are positioned side-by-side with reduced width
  ///
  /// Defaults to `false`.
  final bool countAdjacentEventsAsOverlapping;

  /// If enough space is available, the event slot will
  /// use the specified max width.
  /// Otherwise, it will reduce to fit all events in the cell.
  /// If max width is not specified, slots will expand to fill the cell.
  final double? maxWidth;

  /// Arranges events for a calendar day view.
  ///
  /// Normalizes, sorts, and groups events into columns, then calculates their positions and sizes for rendering.
  /// Returns a list of [OrganizedCalendarEventData] with pixel positions and event references.
  ///
  /// Handles edge cases like empty event lists, events outside the visible range, multi-day events, zero-duration events, and events spanning midnight.
  ///
  /// Optimized for typical calendar scenarios. Events may be provided in any order; they are sorted by start time internally before layout is computed.
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

    // Step 1: Filter out invalid events (null times, zero duration)
    final validEvents = _getValidEvents(events);
    if (validEvents.isEmpty) return [];

    // Step 2: Normalize all events for the current calendar view date
    final normalizedEvents = _normalizeEventsForDate(
        validEvents, calendarViewDate, startHourInMinutes);

    if (normalizedEvents.isEmpty) return [];

    // Step 3: Sort events by start time for optimal processing
    normalizedEvents
        .sort((a, b) => a.effectiveStartTime.compareTo(b.effectiveStartTime));

    // Step 4: Create columns using simple algorithm that prevents overlapping
    final columns = _createOptimalColumns(normalizedEvents);

    // Step 5: Convert columns to organized calendar event data
    return _convertColumnsToOrganizedData(columns, width, height,
        heightPerMinute, startHourInMinutes, calendarViewDate);
  }

  /// Filters out invalid events from the input list.
  ///
  /// Removes events with:
  /// - Null start or end times
  /// - Zero duration (same start and end time on the same date)
  ///
  /// Returns a list of valid events that can be safely processed for layout.
  /// Used to prevent rendering issues and ensure all events have valid time boundaries.
  List<CalendarEventData<T>> _getValidEvents(
      List<CalendarEventData<T>> events) {
    return events.where((event) {
      // Filter out events with null times
      if (event.startTime == null || event.endTime == null) return false;

      // Filter out events with zero duration (same start and end time)
      if (event.date.isAtSameMomentAs(event.endDate) &&
          event.startTime!.getTotalMinutes == event.endTime!.getTotalMinutes) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Normalizes events for the given date.
  ///
  /// Clips multi-day events to the current day's boundaries, filters out events outside visible hours,
  /// and converts each event to a standardized internal format for layout.
  ///
  /// Multi-day event cases:
  /// - Same day: uses original start/end times.
  /// - Start day: starts at event time, ends at day end.
  /// - End day: starts at day start, ends at event time.
  /// - Middle day: uses full day (0–1440 minutes).
  ///
  /// Skips events with null times or outside the visible range.
  ///
  /// Example:
  ///   Viewing Jan 2, 2024 for event Jan 1 10:00 PM – Jan 3 2:00 PM
  ///   → Result: Jan 2 0:00 AM – Jan 2 11:59 PM (full day for middle day)
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

  /// Groups events into columns so that no two events in the same column overlap.
  ///
  /// Uses a first-fit approach: each event is placed in the leftmost column where it does not overlap with existing events.
  /// This minimizes the number of columns and creates a compact layout.
  ///
  /// Handles edge cases like empty input, single events, no overlaps, and all events overlapping.
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

  /// Returns true if a new event can be placed in a column without overlapping any existing events.
  ///
  /// Optimization: Events are processed in non-decreasing start-time order and
  /// are always appended to the end of a column. This keeps each column's events
  /// in start-time order, so we only need to check the new event against the
  /// last event in the column. If it doesn't overlap the last one, it can't
  /// overlap any earlier ones.
  ///
  /// Used for column selection and layout validation.
  bool _canEventFitInColumn(
      _NormalizedEvent<T> event, List<_NormalizedEvent<T>> column) {
    if (column.isEmpty) return true;
    final lastEvent = column.last;
    return !_eventsOverlap(event, lastEvent);
  }

  /// Checks if two events overlap based on [countAdjacentEventsAsOverlapping].
  ///
  /// When `false`: Events touching at edges are NOT overlapping.
  /// Example: Event A (1:00-2:00) and Event B (2:00-3:00) → NO overlap
  ///
  /// When `true`: Events touching at edges ARE overlapping.
  /// Example: Event A (1:00-2:00) and Event B (2:00-3:00) → OVERLAP
  bool _eventsOverlap(_NormalizedEvent<T> event1, _NormalizedEvent<T> event2) {
    if (countAdjacentEventsAsOverlapping) {
      // Events overlap if they have any overlapping time (including touching edges)
      return event1.effectiveStartTime <= event2.effectiveEndTime &&
          event2.effectiveStartTime <= event1.effectiveEndTime;
    } else {
      // Events overlap only if they have actual time overlap (not just touching)
      return event1.effectiveStartTime < event2.effectiveEndTime &&
          event2.effectiveStartTime < event1.effectiveEndTime;
    }
  }

  /// Converts columns to organized event data and calculates positions and sizes for rendering.
  ///
  /// Uses either fixed maxWidth or dynamic width allocation based on [maxWidth].
  /// Handles time and width calculations, positioning, and result generation.
  ///
  /// Returns a list of [OrganizedCalendarEventData] with pixel positions and event references.
  /// Handles empty columns and invalid dimensions gracefully.
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

  /// Handles event positioning when a maximum width constraint is specified.
  ///
  /// Calculates optimal width for each event, applies [maxWidth], and positions events to minimize gaps.
  /// Uses actual column widths for positioning and ensures consistent appearance.
  ///
  /// Handles edge cases like maxWidth exceeding available space, multiple events per column, and very small maxWidth values.
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
    if (columnCount == 0) return;

    // Calculate actual widths for all events first to avoid gaps
    final eventWidths = <int, double>{};
    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final column = columns[columnIndex];
      for (final normalizedEvent in column) {
        // Calculate dynamic width available to the right
        final dynamicWidth = _calculateAvailableWidthToRight(
            normalizedEvent, columns, columnIndex, totalWidth);

        // Take minimum of dynamic width and maxWidth (maxWidth is absolute pixels)
        final maxWidthPixels = maxWidth!;
        eventWidths[normalizedEvent.hashCode] =
            math.min(dynamicWidth, maxWidthPixels);
      }
    }

    // Position events to eliminate gaps by tracking actual positions
    double currentLeftPosition = 0.0;

    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final column = columns[columnIndex];

      // Find the maximum width needed for this column
      double maxColumnWidth = double.maxFinite;
      for (final normalizedEvent in column) {
        final eventWidth = eventWidths[normalizedEvent.hashCode]!;
        maxColumnWidth = math.min(maxColumnWidth, eventWidth);
      }

      for (final normalizedEvent in column) {
        final event = normalizedEvent.originalEvent;

        final displayStartTime = math.max(
            0, normalizedEvent.effectiveStartTime - startHourInMinutes);
        final displayEndTime = math.min(
            Constants.minutesADay - startHourInMinutes,
            normalizedEvent.effectiveEndTime - startHourInMinutes);

        final actualWidth = eventWidths[normalizedEvent.hashCode]!;

        final top = displayStartTime * heightPerMinute;
        final visibleMinutes = Constants.minutesADay - startHourInMinutes;
        final bottom = displayEndTime >= visibleMinutes
            ? 0.0
            : height - displayEndTime * heightPerMinute;

        result.add(OrganizedCalendarEventData<T>(
          left: currentLeftPosition,
          right: math.max(0.0, totalWidth - currentLeftPosition - actualWidth),
          top: top,
          bottom: bottom,
          startDuration: event.startTime!.copyFromMinutes(displayStartTime),
          endDuration: event.endTime!.copyFromMinutes(displayEndTime),
          events: [event],
          calendarViewDate: calendarViewDate,
        ));
      }

      // Move to next column position based on actual width used
      currentLeftPosition += maxColumnWidth;
    }
  }

  /// Handles event positioning when no maximum width constraint is specified.
  ///
  /// Events expand to use all available horizontal space for optimal readability, stopping at overlapping events in columns to the right.
  /// Uses equal column distribution for left positioning and calculates available width for each event.
  ///
  /// Ensures maximum readability, no wasted space, and adapts to variable content and overlap scenarios.
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

  /// Calculates how much horizontal space an event can use by checking for blocking events in columns to the right.
  ///
  /// Scans columns to the right and limits width at the first blocking event, guaranteeing a minimum width.
  /// Optimized for early exit and efficient overlap detection.
  ///
  /// Handles edge cases like rightmost columns, all columns blocked, and zero available space.
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

/// Internal event data structure for calendar layout.
///
/// Stores normalized start/end times (minutes since midnight), multi-day/full-day flags, and a reference to the original event.
/// Used for efficient overlap detection, layout calculations, and rendering in calendar views.
class _NormalizedEvent<T extends Object?> {
  /// Reference to the original calendar event data
  final CalendarEventData<T> originalEvent;

  /// Event start time in minutes since midnight (0-1439)
  final int effectiveStartTime;

  /// Event end time in minutes since midnight (0-1440)
  final int effectiveEndTime;

  /// Whether this event spans multiple calendar days
  final bool isMultiDay;

  /// Whether this is a full-day event
  final bool isFullDay;

  const _NormalizedEvent({
    required this.originalEvent,
    required this.effectiveStartTime,
    required this.effectiveEndTime,
    required this.isMultiDay,
    required this.isFullDay,
  });
}
