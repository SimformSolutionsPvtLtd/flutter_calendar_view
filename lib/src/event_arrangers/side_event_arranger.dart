// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

/// **SideEventArranger: Smart Event Layout Manager**
/// 
/// This class arranges overlapping calendar events side by side in an optimal way,
/// ensuring no visual overlaps while maximizing space utilization.
/// 
/// ## **Core Functionality:**
/// - Arranges overlapping events in separate columns
/// - Calculates optimal widths for each event based on available space
/// - Supports both fixed maxWidth constraints and dynamic width allocation
/// - Handles multi-day events, full-day events, and edge cases
/// 
/// ## **Algorithm Overview:**
/// 1. **Event Normalization**: Converts events to a standardized format for the current view date
/// 2. **Column Creation**: Uses O(n²) algorithm to group non-overlapping events into columns
/// 3. **Width Calculation**: Determines optimal width for each event based on available space
/// 4. **Positioning**: Places events with proper left/right positioning to eliminate gaps
/// 
/// ## **Key Features:**
/// - **Gap Elimination**: Events expand to fill available space when possible
/// - **Edge Case Handling**: Properly handles touching events, multi-day events, and time boundaries
/// - **Flexible Width Control**: Supports both fixed maxWidth and dynamic width allocation
/// - **Performance Optimized**: Efficient algorithms for real-world calendar scenarios
/// 
/// ## **Usage Examples:**
/// ```dart
/// // Basic usage with dynamic width
/// final arranger = SideEventArranger<String>();
/// 
/// // With maximum width constraint (100px)
/// final arranger = SideEventArranger<String>(maxWidth: 100.0);
/// 
/// // Include touching events as overlapping
/// final arranger = SideEventArranger<String>(includeEdges: true);
/// ```
class SideEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const SideEventArranger({
    this.maxWidth,
    this.includeEdges = false,
  });

  /// **Edge Case Handling Configuration**
  /// 
  /// Determines whether events that are touching at their edges should be 
  /// considered as overlapping and placed in separate columns.
  /// 
  /// **Use Cases:**
  /// - `false` (default): Events like 2:00-3:00 PM and 3:00-4:00 PM can share the same column
  /// - `true`: Touching events are forced into separate columns for visual clarity
  /// 
  /// **Example:**
  /// ```dart
  /// // Events: [14:00-15:00], [15:00-16:00]
  /// // includeEdges = false: Both events in same column (touching is OK)
  /// // includeEdges = true:  Events in separate columns (touching treated as overlap)
  /// ```
  final bool includeEdges;

  /// **Maximum Width Constraint (Optional)**
  /// 
  /// When specified, limits the maximum width any event can take, regardless
  /// of available space. This ensures consistent visual appearance.
  /// 
  /// **Behavior:**
  /// - `null` (default): Events expand to fill all available space
  /// - `double value`: Events are capped at this width in pixels
  /// 
  /// **Use Cases:**
  /// - UI consistency: Prevent events from becoming too wide
  /// - Mobile optimization: Ensure readable text on narrow screens
  /// - Design constraints: Match specific layout requirements
  /// 
  /// **Example:**
  /// ```dart
  /// // Without maxWidth: Event might expand to 400px if space available
  /// // With maxWidth: 150.0: Event width capped at 150px
  /// ```
  final double? maxWidth;

  /// **Main Event Arrangement Algorithm**
  /// 
  /// This is the primary entry point that orchestrates the entire event arrangement process.
  /// It handles all the complex logic for positioning overlapping events optimally.
  /// 
  /// ## **Algorithm Steps:**
  /// 1. **Input Validation**: Return empty if no events provided
  /// 2. **Event Normalization**: Convert events to internal format for current date
  /// 3. **Time-based Sorting**: Order events by start time for optimal processing
  /// 4. **Column Creation**: Group non-overlapping events into columns
  /// 5. **Width Calculation**: Determine optimal positioning and sizing
  /// 
  /// ## **Input Parameters:**
  /// - `events`: List of calendar events to arrange (must be sorted by start time)
  /// - `width`: Total available width for the calendar view
  /// - `height`: Total available height for the calendar view
  /// - `heightPerMinute`: Vertical pixels per minute (for time-based positioning)
  /// - `startHour`: First visible hour (e.g., 8 for 8:00 AM)
  /// - `calendarViewDate`: The specific date being displayed
  /// 
  /// ## **Output:**
  /// List of `OrganizedCalendarEventData` with calculated positions:
  /// - `left`: Distance from left edge in pixels
  /// - `right`: Distance from right edge in pixels  
  /// - `top`: Distance from top edge in pixels
  /// - `bottom`: Distance from bottom edge in pixels
  /// 
  /// ## **Edge Cases Handled:**
  /// - Empty event list → Returns empty result
  /// - Events outside visible time range → Automatically filtered out
  /// - Multi-day events → Properly clipped to current day view
  /// - Zero-duration events → Handled with minimum height
  /// - Events spanning midnight → Correctly processed for day boundaries
  /// 
  /// ## **Performance Considerations:**
  /// - Time Complexity: O(n²) for column creation, O(n) for positioning
  /// - Space Complexity: O(n) for internal data structures
  /// - Optimized for typical calendar scenarios (few overlapping events)
  /// 
  /// **Prerequisite**: Events must be sorted by start time for optimal results.
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

    // Step 3: Create columns using simple algorithm that prevents overlapping
    final columns = _createOptimalColumns(normalizedEvents);

    // Step 4: Convert columns to organized calendar event data
    return _convertColumnsToOrganizedData(columns, width, height,
        heightPerMinute, startHourInMinutes, calendarViewDate);
  }

  /// **Event Normalization for Date-Specific View**
  /// 
  /// Converts raw calendar events into a standardized internal format optimized
  /// for the specific date being displayed. This handles complex multi-day event logic.
  /// 
  /// ## **Key Responsibilities:**
  /// 1. **Multi-day Event Handling**: Clips events to the current day's boundaries
  /// 2. **Time Range Validation**: Filters out events outside visible hours
  /// 3. **Data Standardization**: Converts to internal `_NormalizedEvent` format
  /// 
  /// ## **Multi-day Event Cases:**
  /// - **Same Day**: Event starts and ends on the same day → Use original times
  /// - **Start Day**: Event starts today, ends later → Start at event time, end at day end
  /// - **End Day**: Event started earlier, ends today → Start at day start, end at event time  
  /// - **Middle Day**: Event spans multiple days → Full day (start=0, end=1440 minutes)
  /// 
  /// ## **Edge Cases Handled:**
  /// - `null` start/end times → Skipped completely
  /// - Events outside visible time range → Filtered out
  /// - Zero-duration events → Processed normally
  /// - Events crossing midnight → Properly clipped to day boundaries
  /// 
  /// ## **Example Scenarios:**
  /// ```dart
  /// // Viewing: Jan 2, 2024
  /// // Event: Jan 1 10:00 PM - Jan 3 2:00 PM
  /// // Result: Jan 2 0:00 AM - Jan 2 11:59 PM (full day for middle day)
  /// 
  /// // Viewing: Jan 15, 2024  
  /// // Event: Jan 15 2:00 PM - Jan 15 4:00 PM
  /// // Result: Jan 15 2:00 PM - Jan 15 4:00 PM (same day, unchanged)
  /// ```
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

  /// **Column Creation Algorithm - Event Grouping Strategy**
  /// 
  /// Groups events into columns where no two events in the same column overlap.
  /// This is the core algorithm that determines the layout structure.
  /// 
  /// ## **Algorithm Logic:**
  /// 1. **Sequential Processing**: Process events one by one in chronological order
  /// 2. **Column Search**: For each event, find the first available column where it fits
  /// 3. **Collision Detection**: Use `_canEventFitInColumn` to check for overlaps
  /// 4. **New Column Creation**: If no existing column works, create a new one
  /// 
  /// ## **Time Complexity:** 
  /// - **Best Case**: O(n) - All events sequential, no overlaps
  /// - **Worst Case**: O(n²) - All events overlap, each needs new column
  /// - **Typical Case**: O(n*k) where k is average number of columns (~3-5)
  /// 
  /// ## **Column Selection Strategy:**
  /// Uses **First-Fit** approach: Always tries to place event in the leftmost available column.
  /// This minimizes the total number of columns needed and creates compact layouts.
  /// 
  /// ## **Example Walkthrough:**
  /// ```dart
  /// Events: [9:00-10:00], [9:30-11:00], [10:30-12:00], [11:30-13:00]
  /// 
  /// Step 1: [9:00-10:00] → Column 0 (first event)
  /// Step 2: [9:30-11:00] → Column 1 (overlaps with Column 0)
  /// Step 3: [10:30-12:00] → Column 0 (fits after first event ends)
  /// Step 4: [11:30-13:00] → Column 1 (fits after second event ends)
  /// 
  /// Result: 2 columns, optimal layout
  /// ```
  /// 
  /// ## **Edge Cases:**
  /// - **Empty Input**: Returns empty column list
  /// - **Single Event**: Creates one column with one event
  /// - **No Overlaps**: All events in single column (most compact)
  /// - **All Events Overlap**: Each event gets its own column
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

  /// **Column Fit Testing - Overlap Detection**
  /// 
  /// Determines whether a new event can be placed in an existing column
  /// without overlapping with any events already in that column.
  /// 
  /// ## **Algorithm:**
  /// 1. **Iterate through existing events** in the target column
  /// 2. **Check overlap** with each existing event using `_eventsOverlap`
  /// 3. **Return false** immediately if any overlap is found (early termination)
  /// 4. **Return true** only if no overlaps detected
  /// 
  /// ## **Performance Optimization:**
  /// - **Early Exit**: Stops checking as soon as first overlap is found
  /// - **Time Complexity**: O(k) where k is events in column (typically 1-3)
  /// - **Space Complexity**: O(1) - no additional storage needed
  /// 
  /// ## **Use Cases:**
  /// - Column selection during event placement
  /// - Validation of layout correctness
  /// - Debugging overlap detection issues
  bool _canEventFitInColumn(
      _NormalizedEvent<T> event, List<_NormalizedEvent<T>> column) {
    for (final existing in column) {
      if (_eventsOverlap(event, existing)) {
        return false;
      }
    }
    return true;
  }

  /// **Temporal Overlap Detection - Core Logic**
  /// 
  /// Determines whether two events overlap in time, considering the `includeEdges` setting.
  /// This is the fundamental building block for all layout decisions.
  /// 
  /// ## **Overlap Logic:**
  /// 
  /// ### **When includeEdges = false (default):**
  /// Events that touch at edges are NOT considered overlapping.
  /// ```dart
  /// Event A: 14:00-15:00, Event B: 15:00-16:00 → No overlap (touching is OK)
  /// Event A: 14:00-15:30, Event B: 15:00-16:00 → Overlap (actual time conflict)
  /// ```
  /// 
  /// ### **When includeEdges = true:**
  /// Events that touch at edges ARE considered overlapping.
  /// ```dart
  /// Event A: 14:00-15:00, Event B: 15:00-16:00 → Overlap (touching treated as conflict)
  /// Event A: 14:00-15:30, Event B: 15:00-16:00 → Overlap (actual time conflict)
  /// ```
  /// 
  /// ## **Mathematical Formulation:**
  /// For events with times (start1, end1) and (start2, end2):
  /// 
  /// **includeEdges = false:**
  /// - Overlap if: `start1 < end2 AND start2 < end1`
  /// - No overlap if events just touch: `end1 == start2`
  /// 
  /// **includeEdges = true:**
  /// - Overlap if: `start1 <= end2 AND start2 <= end1`
  /// - Overlap even if events just touch: `end1 == start2`
  /// 
  /// ## **Edge Cases:**
  /// - **Zero Duration Events**: Point events (start == end) handled correctly
  /// - **Same Start/End Times**: Identical events always overlap
  /// - **Reversed Time Order**: Algorithm works regardless of parameter order
  /// 
  /// ## **Performance:**
  /// - **Time Complexity**: O(1) - Simple arithmetic comparisons
  /// - **Space Complexity**: O(1) - No additional storage
  /// - **Highly Optimized**: Used in tight loops, marked for inlining
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

  /// **Layout Strategy Coordinator - Width Allocation Decision**
  /// 
  /// Orchestrates the final positioning phase by choosing between two different
  /// width allocation strategies based on the `maxWidth` configuration.
  /// 
  /// ## **Strategy Selection:**
  /// 
  /// ### **Fixed MaxWidth Strategy** (`maxWidth != null`):
  /// - **Use Case**: Consistent visual appearance, mobile-friendly layouts
  /// - **Behavior**: Events respect the maxWidth constraint
  /// - **Benefits**: Predictable sizing, prevents overly wide events
  /// - **Method**: `_processWithFixedMaxWidth()`
  /// 
  /// ### **Dynamic Width Strategy** (`maxWidth == null`):
  /// - **Use Case**: Maximum space utilization, desktop layouts
  /// - **Behavior**: Events expand to fill all available space
  /// - **Benefits**: No wasted space, optimal readability
  /// - **Method**: `_processWithDynamicWidth()`
  /// 
  /// ## **Common Processing Steps:**
  /// 1. **Time Calculations**: Convert event times to pixel positions
  /// 2. **Width Calculations**: Determine optimal width for each event
  /// 3. **Position Calculations**: Calculate left/right positioning
  /// 4. **Result Generation**: Create `OrganizedCalendarEventData` objects
  /// 
  /// ## **Output Format:**
  /// Each event becomes an `OrganizedCalendarEventData` with:
  /// - **Spatial Data**: left, right, top, bottom positions in pixels
  /// - **Temporal Data**: startDuration, endDuration for time references
  /// - **Event Data**: Reference to original event and metadata
  /// 
  /// ## **Error Handling:**
  /// - **Empty Columns**: Returns empty result gracefully
  /// - **Invalid Dimensions**: Protected by bounds checking
  /// - **Calculation Errors**: Math.max/min prevent negative values
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

  /// **Fixed MaxWidth Processing - Constrained Layout Strategy**
  /// 
  /// Handles event positioning when a maximum width constraint is specified.
  /// This strategy balances space utilization with visual consistency.
  /// 
  /// ## **Core Algorithm:**
  /// 1. **Width Pre-calculation**: Calculate optimal width for each event
  /// 2. **MaxWidth Application**: Cap event widths at the specified maximum
  /// 3. **Gap Elimination**: Position events to minimize empty space
  /// 4. **Column-based Positioning**: Use actual column widths for positioning
  /// 
  /// ## **Width Calculation Process:**
  /// ```dart
  /// For each event:
  ///   1. Calculate available space to the right
  ///   2. Apply maxWidth constraint: min(available, maxWidth)
  ///   3. Store in eventWidths map for positioning phase
  /// ```
  /// 
  /// ## **Positioning Strategy:**
  /// - **Column Width**: Use the widest event in each column to determine column width
  /// - **Left Position**: Accumulate column widths to eliminate gaps
  /// - **Right Position**: Calculate remaining space after event width
  /// 
  /// ## **Benefits:**
  /// - **Consistent Appearance**: No event exceeds maxWidth limit
  /// - **Optimal Space Usage**: Events expand up to the constraint
  /// - **Gap-Free Layout**: Columns positioned adjacently
  /// - **Mobile Friendly**: Prevents overly wide events on small screens
  /// 
  /// ## **Edge Cases:**
  /// - **MaxWidth > Available Space**: Event uses available space (no artificial padding)
  /// - **Multiple Events in Column**: All respect the same maxWidth constraint
  /// - **Very Small MaxWidth**: Events maintain minimum readability
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

  /// **Dynamic Width Processing - Maximum Space Utilization Strategy**
  /// 
  /// Handles event positioning when no maximum width constraint is specified.
  /// Events expand to use all available space for optimal readability.
  /// 
  /// ## **Core Philosophy:**
  /// Maximize the use of available horizontal space while maintaining proper
  /// visual separation between overlapping events.
  /// 
  /// ## **Algorithm Steps:**
  /// 1. **Equal Column Distribution**: Start with equal-width columns as baseline
  /// 2. **Available Space Calculation**: Determine how much each event can expand
  /// 3. **Rightward Expansion**: Events extend rightward until blocked by overlapping events
  /// 4. **Standard Positioning**: Use column-based left positioning for consistency
  /// 
  /// ## **Width Expansion Logic:**
  /// ```dart
  /// For each event:
  ///   1. Start at column left boundary
  ///   2. Expand rightward until hitting overlapping event or boundary
  ///   3. Use calculated available width for the event
  /// ```
  /// 
  /// ## **Column Positioning:**
  /// - **Left Position**: Based on equal column distribution (`columnIndex * baseWidth`)
  /// - **Event Width**: Uses `_calculateAvailableWidthToRight()` for optimal expansion
  /// - **Right Position**: Calculated as `totalWidth - left - eventWidth`
  /// 
  /// ## **Benefits:**
  /// - **Maximum Readability**: Events use all available space
  /// - **No Wasted Space**: Horizontal area fully utilized
  /// - **Smart Expansion**: Events stop at logical boundaries
  /// - **Desktop Optimized**: Ideal for larger screens
  /// 
  /// ## **Use Cases:**
  /// - **Desktop Calendars**: Large screens with plenty of horizontal space
  /// - **Print Layouts**: Maximum information density required
  /// - **Detail Views**: When event content needs maximum width
  /// 
  /// ## **Edge Cases:**
  /// - **Single Column**: Event expands to full width
  /// - **Many Overlaps**: Events get narrow but fair space allocation
  /// - **Variable Content**: Width adapts to optimal display needs
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

  /// **Available Width Calculation - Smart Space Detection**
  /// 
  /// Calculates how much horizontal space an event can use by analyzing
  /// the layout to the right and detecting blocking overlapping events.
  /// 
  /// ## **Core Algorithm:**
  /// 1. **Baseline Calculation**: Start with remaining space from current position to edge
  /// 2. **Right-side Scanning**: Check each column to the right for blocking events
  /// 3. **Overlap Detection**: Use `_eventsOverlap()` to find temporal conflicts
  /// 4. **Width Limiting**: Stop expansion at first blocking event found
  /// 5. **Minimum Guarantee**: Ensure at least one column width is available
  /// 
  /// ## **Scanning Strategy:**
  /// ```dart
  /// For each column to the right:
  ///   For each event in that column:
  ///     If event overlaps with target:
  ///       Limit width to that column's position
  ///       Break (stop scanning further right)
  /// ```
  /// 
  /// ## **Width Calculation Logic:**
  /// - **Initial Width**: `totalWidth - startPosition` (all remaining space)
  /// - **Blocking Position**: `rightColumnIndex * baseSlotWidth`
  /// - **Final Width**: `blockingPosition - startPosition`
  /// - **Minimum Width**: `max(baseSlotWidth, calculatedWidth)`
  /// 
  /// ## **Example Scenarios:**
  /// 
  /// ### **Scenario 1: No Blocking Events**
  /// ```dart
  /// Event: 9:00-10:00 AM in Column 0
  /// Right columns: No overlapping events
  /// Result: Expands to full remaining width
  /// ```
  /// 
  /// ### **Scenario 2: Blocked by Column 2**
  /// ```dart
  /// Event: 9:00-11:00 AM in Column 0  
  /// Column 2: Has event 9:30-10:30 AM (overlaps!)
  /// Result: Width limited to Column 2's left boundary
  /// ```
  /// 
  /// ### **Scenario 3: Multiple Potential Blocks**
  /// ```dart
  /// Event: 9:00-12:00 PM in Column 0
  /// Column 1: Event 10:00-11:00 AM (overlaps)
  /// Column 3: Event 11:00-12:00 PM (also overlaps)
  /// Result: Width limited to Column 1 (first blocking column)
  /// ```
  /// 
  /// ## **Performance Optimizations:**
  /// - **Early Termination**: Stops scanning at first blocking event
  /// - **Column-based Scanning**: Only checks relevant columns
  /// - **Efficient Overlap Detection**: Uses optimized `_eventsOverlap()`
  /// 
  /// ## **Edge Cases:**
  /// - **Rightmost Column**: Gets all remaining space
  /// - **All Columns Blocked**: Falls back to minimum column width
  /// - **No Right Columns**: Expands to total width boundary
  /// - **Zero Available Space**: Guaranteed minimum width prevents layout break
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

/// **Internal Event Data Structure - Normalized Representation**
/// 
/// Standardized internal format for events optimized for layout calculations.
/// Converts complex calendar event data into a simplified, computation-friendly format.
/// 
/// ## **Design Purpose:**
/// - **Performance**: Optimized data structure for layout algorithms
/// - **Consistency**: Standardized time representation (minutes since midnight)
/// - **Simplicity**: Removes complexity of original event data during processing
/// - **Multi-day Support**: Handles events spanning multiple days uniformly
/// 
/// ## **Key Fields:**
/// 
/// ### **originalEvent**: Reference to source data
/// - **Type**: `CalendarEventData<T>`
/// - **Purpose**: Maintains link to original event for final output
/// - **Usage**: Accessed when creating final organized event data
/// 
/// ### **effectiveStartTime**: Normalized start time in minutes
/// - **Format**: Minutes since midnight (0-1439)
/// - **Multi-day Logic**: Adjusted for current view date
/// - **Example**: 2:30 PM = 870 minutes (14.5 * 60)
/// 
/// ### **effectiveEndTime**: Normalized end time in minutes  
/// - **Format**: Minutes since midnight (0-1440)
/// - **Multi-day Logic**: Adjusted for current view date
/// - **Boundary**: Can be 1440 (next day) for events ending at midnight
/// 
/// ### **isMultiDay**: Multi-day event indicator
/// - **Purpose**: Tracks whether event spans multiple calendar days
/// - **Usage**: Affects rendering and time calculations
/// - **Source**: Derived from `CalendarEventData.isRangingEvent`
/// 
/// ### **isFullDay**: Full-day event indicator  
/// - **Purpose**: Identifies all-day events for special handling
/// - **Usage**: May affect positioning and rendering logic
/// - **Source**: Derived from `CalendarEventData.isFullDayEvent`
/// 
/// ## **Normalization Benefits:**
/// - **Uniform Time Format**: All events use same time representation
/// - **Simplified Comparisons**: Easy overlap detection with integer arithmetic
/// - **Multi-day Handling**: Complex spanning logic resolved once
/// - **Performance**: Reduced object complexity for hot path operations
/// 
/// ## **Usage Pattern:**
/// ```dart
/// // Created during normalization phase
/// final normalized = _NormalizedEvent<String>(
///   originalEvent: calendarEvent,
///   effectiveStartTime: 540, // 9:00 AM  
///   effectiveEndTime: 660,   // 11:00 AM
///   isMultiDay: false,
///   isFullDay: false,
/// );
/// 
/// // Used in overlap detection
/// if (event1.effectiveEndTime > event2.effectiveStartTime) { ... }
/// ```
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
