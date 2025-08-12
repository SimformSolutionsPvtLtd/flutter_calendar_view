// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';

/// Comprehensive test data for MergeEventArranger covering all edge cases,
/// algorithmic correctness scenarios, and real-world use cases.
class MergeEventArrangerTestData {
  static final DateTime baseDate = DateTime(2025, 9, 19);

  // MARK: - Basic Functionality Test Data

  // Passed
  /// Empty event list - should return empty result
  static List<CalendarEventData<String>> get emptyEvents => [];

  // Passed
  /// Single event - should return single organized event
  static List<CalendarEventData<String>> get singleEvent => [
        CalendarEventData(
          title: 'Single Event',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11)),
          event: 'single',
        ),
      ];

  // MARK: - Union-Find Algorithm Correctness Test Data

  // Passed
  /// Two overlapping events - should merge into single group
  static List<CalendarEventData<String>> get twoOverlappingEvents => [
        CalendarEventData(
          title: 'Event 1',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 12)),
          event: 'event1',
        ),
        CalendarEventData(
          title: 'Event 2',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 11)),
          endTime: baseDate.add(const Duration(hours: 13)),
          event: 'event2',
        ),
      ];

  // Passed
  /// Chain of overlapping events - should form single group (A->B->C->D)
  static List<CalendarEventData<String>> get chainOverlappingEvents => [
        CalendarEventData(
          title: 'Event A',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11, minutes: 30)),
          event: 'eventA',
        ),
        CalendarEventData(
          title: 'Event B',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 11)),
          endTime: baseDate.add(const Duration(hours: 12, minutes: 30)),
          event: 'eventB',
        ),
        CalendarEventData(
          title: 'Event C',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 12)),
          endTime: baseDate.add(const Duration(hours: 13, minutes: 30)),
          event: 'eventC',
        ),
        CalendarEventData(
          title: 'Event D',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 13)),
          endTime: baseDate.add(const Duration(hours: 14)),
          event: 'eventD',
        ),
      ];

  // Passed
  /// Multiple independent groups - should remain separate
  static List<CalendarEventData<String>> get multipleIndependentGroups => [
        // Group 1: 10:00-11:30, 11:00-12:00 (overlapping)
        CalendarEventData(
          title: 'Group 1 Event 1',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11, minutes: 30)),
          event: 'g1e1',
        ),
        CalendarEventData(
          title: 'Group 1 Event 2',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 11)),
          endTime: baseDate.add(const Duration(hours: 12)),
          event: 'g1e2',
        ),
        // Group 2: 14:00-15:30, 15:00-16:00 (overlapping)
        CalendarEventData(
          title: 'Group 2 Event 1',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 14)),
          endTime: baseDate.add(const Duration(hours: 15, minutes: 30)),
          event: 'g2e1',
        ),
        CalendarEventData(
          title: 'Group 2 Event 2',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 15)),
          endTime: baseDate.add(const Duration(hours: 16)),
          event: 'g2e2',
        ),
        // Isolated event
        CalendarEventData(
          title: 'Isolated Event',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 18)),
          endTime: baseDate.add(const Duration(hours: 19)),
          event: 'isolated',
        ),
      ];

  // MARK: - Edge Cases - includeEdges Parameter Test Data

  // Passed
  /// Touching events for includeEdges testing
  static List<CalendarEventData<String>> get touchingEvents => [
        CalendarEventData(
          title: 'Event 1',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11)),
          event: 'event1',
        ),
        CalendarEventData(
          title: 'Event 2',
          date: baseDate,
          startTime: baseDate.add(
              const Duration(hours: 11)), // Starts exactly when Event 1 ends
          endTime: baseDate.add(const Duration(hours: 12)),
          event: 'event2',
        ),
      ];

  // MARK: - Critical Edge Cases - Sweep Line Algorithm Test Data

  // Passed
  /// Events with identical start and end times
  static List<CalendarEventData<String>> get identicalTimeEvents => [
        CalendarEventData(
          title: 'Event 1',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11)),
          event: 'event1',
        ),
        CalendarEventData(
          title: 'Event 2 (Identical)',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)), // Same start
          endTime: baseDate.add(const Duration(hours: 11)), // Same end
          event: 'event2',
        ),
        CalendarEventData(
          title: 'Event 3 (Identical)',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)), // Same start
          endTime: baseDate.add(const Duration(hours: 11)), // Same end
          event: 'event3',
        ),
      ];

  // Failed - Zero duration events should be skipped. Instead this is including it in the merged event.
  /// Zero-duration events (start time = end time)
  static List<CalendarEventData<String>> get zeroDurationEvents => [
        CalendarEventData(
          title: 'Zero Duration Event 1',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 10)), // Same as start
          event: 'zero1',
        ),
        CalendarEventData(
          title: 'Zero Duration Event 2',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 10)), // Same as start
          event: 'zero2',
        ),
        CalendarEventData(
          title: 'Normal Event',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11)),
          event: 'normal',
        ),
      ];

  // Passed
  /// Events sorted in reverse chronological order (stress test sorting)
  static List<CalendarEventData<String>> get reverseSortedEvents => [
        CalendarEventData(
          title: 'Event Z (Latest)',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 15)),
          endTime: baseDate.add(const Duration(hours: 16)),
          event: 'eventZ',
        ),
        CalendarEventData(
          title: 'Event Y',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 12)),
          endTime: baseDate.add(const Duration(hours: 13)),
          event: 'eventY',
        ),
        CalendarEventData(
          title: 'Event A (Earliest)',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 9)),
          endTime: baseDate.add(const Duration(hours: 10)),
          event: 'eventA',
        ),
      ];

  // Passed
  /// Complex overlapping pattern (stress test Union-Find)
  static List<CalendarEventData<String>> get complexOverlappingPattern {
    final events = <CalendarEventData<String>>[];

    // Create 10 events with complex overlap pattern
    for (int i = 0; i < 10; i++) {
      events.add(CalendarEventData(
        title: 'Event $i',
        date: baseDate,
        startTime: baseDate.add(Duration(hours: 10 + i, minutes: i * 15)),
        endTime: baseDate.add(Duration(hours: 12 + i, minutes: i * 10)),
        event: 'event$i',
      ));
    }

    return events;
  }

  // MARK: - Multi-day Event Test Data

  // Passed
  /// Multi-day event for testing on start date
  static CalendarEventData<String> get multiDayEventForStartDate {
    final startDate = DateTime(2025, 9, 15, 10, 0); // 10:00 AM
    final endDate = DateTime(2025, 9, 17, 14, 0); // 2:00 PM, 2 days later

    return CalendarEventData(
      title: 'Multi-day Event',
      date: startDate,
      startTime: startDate,
      endTime: endDate,
      endDate: endDate, // This is needed for isRangingEvent to work
      event: 'multiday',
    );
  }

  // Passed
  /// Multi-day event for testing on middle date
  static CalendarEventData<String> get multiDayEventForMiddleDate {
    final startDate = DateTime(2025, 9, 15, 10, 0);
    final endDate = DateTime(2025, 9, 17, 14, 0);

    return CalendarEventData(
      title: 'Multi-day Event',
      date: startDate,
      startTime: startDate,
      endTime: endDate,
      endDate: endDate, // This is needed for isRangingEvent to work
      event: 'multiday',
    );
  }

  // Passed
  /// Multi-day event for testing on end date
  static CalendarEventData<String> get multiDayEventForEndDate {
    final startDate = DateTime(2025, 9, 15, 10, 0);
    final endDate = DateTime(2025, 9, 17, 14, 0);

    return CalendarEventData(
      title: 'Multi-day Event',
      date: startDate,
      startTime: startDate,
      endTime: endDate,
      endDate: endDate, // This is needed for isRangingEvent to work
      event: 'multiday',
    );
  }

  // MARK: - Performance Test Data

  // Passed
  /// Large number of non-overlapping events (performance test)
  static List<CalendarEventData<String>> get largeNonOverlappingEvents {
    final events = <CalendarEventData<String>>[];

    // Create 100 non-overlapping events (should complete quickly)
    for (int i = 0; i < 100; i++) {
      events.add(CalendarEventData(
        title: 'Event $i',
        date: baseDate,
        startTime: baseDate.add(Duration(minutes: i * 10)), // Every 10 minutes
        endTime:
            baseDate.add(Duration(minutes: i * 10 + 5)), // 5 minute duration
        event: 'event$i',
      ));
    }

    return events;
  }

  // Passed
  /// Large number of all-overlapping events (worst case performance)
  static List<CalendarEventData<String>> get largeOverlappingEvents {
    final events = <CalendarEventData<String>>[];

    // Create 50 events that all overlap (worst case for Union-Find)
    for (int i = 0; i < 50; i++) {
      events.add(CalendarEventData(
        title: 'Overlapping Event $i',
        date: baseDate,
        startTime: baseDate.add(const Duration(hours: 10)),
        endTime: baseDate.add(const Duration(hours: 12)),
        event: 'overlap$i',
      ));
    }

    return events;
  }

  // MARK: - Data Integrity and Validation Test Data

  // Partially Passed
  // NOTE: Instead of throwing assertion error, the arranger now simply skips these invalid events.
  /// Events with null start/end times (should be filtered out)
  static List<CalendarEventData<String>> get nullTimeEvents => [
        CalendarEventData(
          title: 'Valid Event',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          event: 'valid',
        ),
      ];

  // Passed
  /// Events outside visible time range (should be filtered)
  static List<CalendarEventData<String>> get outsideRangeEvents => [
        CalendarEventData(
          title: 'Before Range',
          date: baseDate.subtract(const Duration(days: 1)), // Previous day
          startTime: baseDate.subtract(const Duration(hours: 2)),
          endTime: baseDate.subtract(const Duration(hours: 1)),
          event: 'before',
        ),
        CalendarEventData(
          title: 'In Range',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11)),
          event: 'inrange',
        ),
        CalendarEventData(
          title: 'After Range',
          date: baseDate.add(const Duration(days: 1)), // Next day
          startTime: baseDate.add(const Duration(days: 1, hours: 1)),
          endTime: baseDate.add(const Duration(days: 1, hours: 2)),
          event: 'after',
        ),
      ];

  // Passed
  /// Event for visual positioning calculations test
  static List<CalendarEventData<String>> get visualPositioningEvent => [
        CalendarEventData(
          title: 'Test Event',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10, minutes: 30)),
          endTime: baseDate.add(const Duration(hours: 11, minutes: 45)),
          event: 'test',
        ),
      ];

  // MARK: - Regression Test Data

  // Passed
  /// Events for deterministic ordering test
  static List<CalendarEventData<String>> get deterministicOrderingEvents => [
        CalendarEventData(
          title: 'Event A',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11, minutes: 30)),
          event: 'eventA',
        ),
        CalendarEventData(
          title: 'Event B',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 11)),
          endTime: baseDate.add(const Duration(hours: 12)),
          event: 'eventB',
        ),
        CalendarEventData(
          title: 'Event C',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 14)),
          endTime: baseDate.add(const Duration(hours: 15)),
          event: 'eventC',
        ),
      ];

  // Passed
  /// Backward compatibility test events
  static List<CalendarEventData<String>> get backwardCompatibilityEvents => [
        CalendarEventData(
          title: 'Morning Meeting',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 9)),
          endTime: baseDate.add(const Duration(hours: 10)),
          event: 'meeting1',
        ),
        CalendarEventData(
          title: 'Overlapping Call',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 9, minutes: 30)),
          endTime: baseDate.add(const Duration(hours: 10, minutes: 30)),
          event: 'call1',
        ),
        CalendarEventData(
          title: 'Lunch Break',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 12)),
          endTime: baseDate.add(const Duration(hours: 13)),
          event: 'lunch',
        ),
        CalendarEventData(
          title: 'Afternoon Meeting',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 14)),
          endTime: baseDate.add(const Duration(hours: 15)),
          event: 'meeting2',
        ),
        CalendarEventData(
          title: 'Overlapping Workshop',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 14, minutes: 30)),
          endTime: baseDate.add(const Duration(hours: 16)),
          event: 'workshop',
        ),
      ];

  // MARK: - Real-world Scenario Test Data

  // Passed
  /// Real-world calendar day scenario
  static List<CalendarEventData<String>> get realWorldCalendarDay => [
        CalendarEventData(
          title: 'Daily Standup',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 9)),
          endTime: baseDate.add(const Duration(hours: 9, minutes: 30)),
          event: 'standup',
        ),
        CalendarEventData(
          title: 'Client Call',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10)),
          endTime: baseDate.add(const Duration(hours: 11)),
          event: 'client_call',
        ),
        CalendarEventData(
          title: 'Code Review',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 10, minutes: 30)),
          endTime: baseDate.add(const Duration(
              hours: 11, minutes: 30)), // Overlaps with client call
          event: 'code_review',
        ),
        CalendarEventData(
          title: 'Lunch',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 12)),
          endTime: baseDate.add(const Duration(hours: 13)),
          event: 'lunch',
        ),
        CalendarEventData(
          title: 'Team Meeting',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 14)),
          endTime: baseDate.add(const Duration(hours: 15)),
          event: 'team_meeting',
        ),
        CalendarEventData(
          title: 'Sprint Planning',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 14, minutes: 30)),
          endTime: baseDate
              .add(const Duration(hours: 16)), // Overlaps with team meeting
          event: 'sprint_planning',
        ),
        CalendarEventData(
          title: 'Documentation',
          date: baseDate,
          startTime: baseDate.add(const Duration(hours: 16, minutes: 30)),
          endTime: baseDate.add(const Duration(hours: 17, minutes: 30)),
          event: 'documentation',
        ),
      ];

  // MARK: - Helper Methods for Date Generation

  /// Get multi-day event dates for testing
  static Map<String, DateTime> get multiDayEventDates => {
        'startDate': DateTime(2025, 9, 15),
        'middleDate': DateTime(2025, 9, 16),
        'endDate': DateTime(2025, 9, 17),
      };

  /// Generate events with specific time pattern
  static List<CalendarEventData<String>> generateTimePatternEvents({
    required int count,
    required Duration interval,
    required Duration duration,
    DateTime? startDate,
  }) {
    final date = startDate ?? baseDate;
    final events = <CalendarEventData<String>>[];

    for (int i = 0; i < count; i++) {
      final startTime = date.add(Duration(minutes: i * interval.inMinutes));
      final endTime = startTime.add(duration);

      events.add(CalendarEventData(
        title: 'Generated Event $i',
        date: date,
        startTime: startTime,
        endTime: endTime,
        event: 'generated_$i',
      ));
    }

    return events;
  }

  /// Generate overlapping events with specific overlap percentage
  static List<CalendarEventData<String>> generateOverlappingEvents({
    required int count,
    required Duration baseDuration,
    required double overlapPercentage, // 0.0 to 1.0
    DateTime? startDate,
  }) {
    final date = startDate ?? baseDate;
    final events = <CalendarEventData<String>>[];
    final overlapMinutes = (baseDuration.inMinutes * overlapPercentage).round();

    for (int i = 0; i < count; i++) {
      final startTime = date.add(Duration(
        hours: 10,
        minutes: i * (baseDuration.inMinutes - overlapMinutes),
      ));
      final endTime = startTime.add(baseDuration);

      events.add(CalendarEventData(
        title: 'Overlap Event $i',
        date: date,
        startTime: startTime,
        endTime: endTime,
        event: 'overlap_$i',
      ));
    }

    return events;
  }
}
