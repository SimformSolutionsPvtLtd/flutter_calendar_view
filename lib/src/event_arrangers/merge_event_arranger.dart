// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

part of 'event_arrangers.dart';

/// Sweep event for the sweep line algorithm
class _SweepEvent<T extends Object?> {
  final int time;
  final _EventType type;
  final int eventIndex;
  final CalendarEventData<T> event;

  const _SweepEvent(this.time, this.type, this.eventIndex, this.event);
}

enum _EventType { start, end }

/// Union-Find data structure for efficient merge group detection
class _UnionFind {
  List<int> parent;
  List<int> rank;

  _UnionFind(int size)
      : parent = List.generate(size, (i) => i),
        rank = List.filled(size, 0);

  int find(int x) {
    if (parent[x] != x) {
      parent[x] = find(parent[x]); // Path compression
    }
    return parent[x];
  }

  void union(int x, int y) {
    final rootX = find(x);
    final rootY = find(y);

    if (rootX != rootY) {
      // Union by rank
      if (rank[rootX] < rank[rootY]) {
        parent[rootX] = rootY;
      } else if (rank[rootX] > rank[rootY]) {
        parent[rootY] = rootX;
      } else {
        parent[rootY] = rootX;
        rank[rootX]++;
      }
    }
  }

  /// Groups elements by their root parent
  Map<int, List<int>> getGroups(int size) {
    final groups = <int, List<int>>{};
    for (int i = 0; i < size; i++) {
      final root = find(i);
      groups.putIfAbsent(root, () => []).add(i);
    }
    return groups;
  }
}

/// Internal data structure for normalized event information
class _NormalizedEventData<T extends Object?> {
  final CalendarEventData<T> event;
  final int originalIndex;
  final int startMinutes;
  final int endMinutes;
  final DateTime originalStartTime;
  final DateTime originalEndTime;

  const _NormalizedEventData({
    required this.event,
    required this.originalIndex,
    required this.startMinutes,
    required this.endMinutes,
    required this.originalStartTime,
    required this.originalEndTime,
  });
}

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
  /// Optimized implementation using Sweep Line + Union-Find algorithm.
  /// Time complexity: O(n log n), Space complexity: O(n)
  /// 
  /// Note: Events no longer need to be pre-sorted by start time.
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
    
    // Step 1: Normalize and validate events - O(n)
    final normalizedEvents = <_NormalizedEventData<T>>[];
    
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      
      if (event.startTime == null || event.endTime == null) {
        debugLog('startTime or endTime is null for ${event.title}');
        continue;
      }

      // Checks if an event has valid start and end time.
      if (event.endDate.millisecondsSinceEpoch <
          event.date.millisecondsSinceEpoch) {
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

      // Check if event should be displayed on this calendar date
      if (!_shouldDisplayEventOnDate(event, calendarViewDate)) {
        continue;
      }

      final normalizedEvent = _normalizeEvent(
        event, calendarViewDate, startHourInMinutes, i);
      
      if (normalizedEvent != null) {
        normalizedEvents.add(normalizedEvent);
      }
    }

    if (normalizedEvents.isEmpty) return [];

    // Step 2: Use Sweep Line + Union-Find to find merge groups - O(n log n)
    final mergeGroups = _findMergeGroups(normalizedEvents);

    // Step 3: Build organized event data from merge groups - O(n)
    return _buildOrganizedEvents(
      mergeGroups, normalizedEvents, height, heightPerMinute, 
      startHourInMinutes, calendarViewDate);
  }

  /// Checks if an event should be displayed on the given calendar view date
  bool _shouldDisplayEventOnDate(CalendarEventData<T> event, DateTime calendarViewDate) {
    final viewDateWithoutTime = calendarViewDate.withoutTime;
    
    if (event.isRangingEvent) {
      // For multi-day events, check if the view date falls within the event range
      final eventStartDate = event.date.withoutTime;
      final eventEndDate = event.endDate.withoutTime;
      
      return !viewDateWithoutTime.isBefore(eventStartDate) && 
             !viewDateWithoutTime.isAfter(eventEndDate);
    } else {
      // For single-day events, check if the view date matches the event date
      return viewDateWithoutTime.isAtSameMomentAs(event.date.withoutTime);
    }
  }

  /// Normalizes event time coordinates for the given calendar view date
  _NormalizedEventData<T>? _normalizeEvent(
    CalendarEventData<T> event,
    DateTime calendarViewDate,
    int startHourInMinutes,
    int originalIndex,
  ) {
    final startTime = event.startTime!;
    final endTime = event.endTime!;

    int eventStart;
    int eventEnd;

    if (event.isRangingEvent) {
      // Handle multi-day events differently based on which day is currently being viewed
      final isStartDate =
          calendarViewDate.isAtSameMomentAs(event.date.withoutTime);
      final isEndDate =
          calendarViewDate.isAtSameMomentAs(event.endDate.withoutTime);

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

    return _NormalizedEventData<T>(
      event: event,
      originalIndex: originalIndex,
      startMinutes: eventStart,
      endMinutes: eventEnd,
      originalStartTime: startTime,
      originalEndTime: endTime,
    );
  }

  /// Uses Sweep Line + Union-Find to efficiently find merge groups
  List<List<int>> _findMergeGroups(List<_NormalizedEventData<T>> normalizedEvents) {
    if (normalizedEvents.isEmpty) return [];

    final eventCount = normalizedEvents.length;
    final unionFind = _UnionFind(eventCount);

    // Step 1: Create sweep events - O(n)
    final sweepEvents = <_SweepEvent<T>>[];
    for (int i = 0; i < eventCount; i++) {
      final normalized = normalizedEvents[i];
      sweepEvents.add(_SweepEvent(
        normalized.startMinutes, _EventType.start, i, normalized.event));
      sweepEvents.add(_SweepEvent(
        normalized.endMinutes, _EventType.end, i, normalized.event));
    }

    // Step 2: Sort sweep events by time - O(n log n)
    sweepEvents.sort((a, b) {
      final timeComparison = a.time.compareTo(b.time);
      if (timeComparison != 0) return timeComparison;
      
      // If times are equal, process end events before start events
      // This handles the includeEdges case properly
      if (a.type == _EventType.end && b.type == _EventType.start) {
        return includeEdges ? 1 : -1; // If includeEdges, end comes after start
      } else if (a.type == _EventType.start && b.type == _EventType.end) {
        return includeEdges ? -1 : 1; // If includeEdges, start comes before end
      }
      
      return 0;
    });

    // Step 3: Sweep line with Union-Find - O(n α(n))
    final activeEvents = <int>{};

    for (final sweepEvent in sweepEvents) {
      if (sweepEvent.type == _EventType.start) {
        // Union this event with all currently active events
        for (final activeIndex in activeEvents) {
          // Double-check overlap using the existing overlap logic
          final activeEvent = normalizedEvents[activeIndex];
          final currentEvent = normalizedEvents[sweepEvent.eventIndex];
          
          if (_checkIsOverlapping(
            activeEvent.startMinutes,
            activeEvent.endMinutes,
            currentEvent.startMinutes,
            currentEvent.endMinutes,
          )) {
            unionFind.union(activeIndex, sweepEvent.eventIndex);
          }
        }
        activeEvents.add(sweepEvent.eventIndex);
      } else {
        activeEvents.remove(sweepEvent.eventIndex);
      }
    }

    // Step 4: Extract groups from Union-Find - O(n)
    final groups = unionFind.getGroups(eventCount);
    return groups.values.toList();
  }

  /// Builds organized event data from merge groups
  List<OrganizedCalendarEventData<T>> _buildOrganizedEvents(
    List<List<int>> mergeGroups,
    List<_NormalizedEventData<T>> normalizedEvents,
    double height,
    double heightPerMinute,
    int startHourInMinutes,
    DateTime calendarViewDate,
  ) {
    final result = <OrganizedCalendarEventData<T>>[];

    for (final group in mergeGroups) {
      if (group.isEmpty) continue;

      // Find the merged time bounds for this group
      int mergedStart = normalizedEvents[group.first].startMinutes;
      int mergedEnd = normalizedEvents[group.first].endMinutes;
      final groupEvents = <CalendarEventData<T>>[];

      for (final eventIndex in group) {
        final normalized = normalizedEvents[eventIndex];
        mergedStart = math.min(mergedStart, normalized.startMinutes);
        mergedEnd = math.max(mergedEnd, normalized.endMinutes);
        groupEvents.add(normalized.event);
      }

      // Calculate visual positioning
      final top = mergedStart * heightPerMinute;
      final visibleMinutes = Constants.minutesADay - startHourInMinutes;
      final bottom = mergedEnd >= visibleMinutes
          ? 0.0 // Event extends to bottom of view
          : height - mergedEnd * heightPerMinute;

      // Calculate proper start and end duration times
      // For multi-day events, we need to show the actual time bounds for this day
      final startDurationTime = _calculateEventStartTimeForDay(groupEvents, calendarViewDate, mergedStart, startHourInMinutes);
      final endDurationTime = _calculateEventEndTimeForDay(groupEvents, calendarViewDate, mergedEnd, startHourInMinutes);
      
      result.add(OrganizedCalendarEventData<T>(
        top: top,
        bottom: bottom,
        left: 0,
        right: 0,
        startDuration: startDurationTime,
        endDuration: endDurationTime,
        events: groupEvents,
        calendarViewDate: calendarViewDate,
      ));
    }

    return result;
  }

  /// Calculate the start time for events on the given day
  DateTime _calculateEventStartTimeForDay(
    List<CalendarEventData<T>> groupEvents, 
    DateTime calendarViewDate, 
    int mergedStartMinutes,
    int startHourInMinutes,
  ) {
    // Find if any event in the group is a multi-day event
    final multiDayEvent = groupEvents.firstWhere(
      (e) => e.isRangingEvent,
      orElse: () => groupEvents.first,
    );
    
    if (multiDayEvent.isRangingEvent) {
      final isStartDate = calendarViewDate.isAtSameMomentAs(multiDayEvent.date.withoutTime);
      final isEndDate = calendarViewDate.isAtSameMomentAs(multiDayEvent.endDate.withoutTime);
      
      if (isStartDate && !isEndDate) {
        // Start date: use actual start time
        return multiDayEvent.startTime!;
      } else if (!isStartDate) {
        // Middle or end date: start at beginning of day
        return DateTime(calendarViewDate.year, calendarViewDate.month, calendarViewDate.day);
      }
    }
    
    // For single-day events or start+end on same date, use normalized minutes
    final totalMinutes = mergedStartMinutes + startHourInMinutes;
    return DateTime(
      calendarViewDate.year,
      calendarViewDate.month,
      calendarViewDate.day,
      totalMinutes ~/ 60,
      totalMinutes % 60,
    );
  }

  /// Calculate the end time for events on the given day
  DateTime _calculateEventEndTimeForDay(
    List<CalendarEventData<T>> groupEvents, 
    DateTime calendarViewDate, 
    int mergedEndMinutes,
    int startHourInMinutes,
  ) {
    // Find if any event in the group is a multi-day event
    final multiDayEvent = groupEvents.firstWhere(
      (e) => e.isRangingEvent,
      orElse: () => groupEvents.first,
    );
    
    if (multiDayEvent.isRangingEvent) {
      final isStartDate = calendarViewDate.isAtSameMomentAs(multiDayEvent.date.withoutTime);
      final isEndDate = calendarViewDate.isAtSameMomentAs(multiDayEvent.endDate.withoutTime);
      
      if (isEndDate && !isStartDate) {
        // End date: use actual end time
        return multiDayEvent.endTime!;
      } else if (!isEndDate) {
        // Start or middle date: end at end of day (midnight next day)
        return DateTime(calendarViewDate.year, calendarViewDate.month, calendarViewDate.day + 1);
      }
    }
    
    // For single-day events or start+end on same date, use normalized minutes
    final totalMinutes = mergedEndMinutes + startHourInMinutes;
    return DateTime(
      calendarViewDate.year,
      calendarViewDate.month,
      calendarViewDate.day,
      totalMinutes ~/ 60,
      totalMinutes % 60,
    );
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
