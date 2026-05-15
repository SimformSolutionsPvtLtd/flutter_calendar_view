// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

// Constants matching the merge_event_arranger_test conventions.
const height = 1440.0;
const width = 600.0; // 600 keeps arithmetic clean (divides evenly by 2, 3, 4)
const heightPerMinute = 1.0;
const startHour = 0;

OrganizedCalendarEventData<Object?> _findByTitle(
  List<OrganizedCalendarEventData<Object?>> results,
  String title,
) {
  return results.firstWhere(
    (r) => r.events.first.title == title,
    orElse: () => throw StateError('No result for event "$title"'),
  );
}

void main() {
  final now = DateTime.now().withoutTime;

  // Helper: arrange via SideEventArranger.
  List<OrganizedCalendarEventData<Object?>> arrange(
    List<CalendarEventData<Object?>> events, {
    DateTime? calendarViewDate,
    double? maxWidth,
    bool countAdjacentEventsAsOverlapping = false,
    int startHourOverride = startHour,
  }) =>
      SideEventArranger(
        maxWidth: maxWidth,
        countAdjacentEventsAsOverlapping: countAdjacentEventsAsOverlapping,
      ).arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHourOverride,
        calendarViewDate: calendarViewDate ?? now,
      );

  // ---------------------------------------------------------------------------
  // Filtering
  // ---------------------------------------------------------------------------
  group('SideEventArranger – filtering', () {
    test('returns empty list for empty input', () {
      expect(arrange([]), isEmpty);
    });

    test('filters out events with null startTime', () {
      final events = [
        CalendarEventData(
          title: 'No start',
          date: now,
          endTime: now.add(const Duration(hours: 10)),
        ),
      ];
      expect(arrange(events), isEmpty);
    });

    test('filters out events with null endTime', () {
      final events = [
        CalendarEventData(
          title: 'No end',
          date: now,
          startTime: now.add(const Duration(hours: 8)),
        ),
      ];
      expect(arrange(events), isEmpty);
    });

    test('filters out zero-duration single-day event', () {
      final events = [
        CalendarEventData(
          title: 'Zero',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 10)),
        ),
      ];
      expect(arrange(events), isEmpty);
    });

    test('includes single-day event ending at midnight (00:00)', () {
      // endTime of midnight has getTotalMinutes == 0; must be treated as 1440.
      final events = [
        CalendarEventData(
          title: 'Night owl',
          date: now,
          startTime: DateTime(now.year, now.month, now.day, 22, 0),
          endTime: DateTime(now.year, now.month, now.day, 0, 0), // midnight
        ),
      ];
      final results = arrange(events);
      expect(results, hasLength(1));
      // Event starts at 22:00 (1320 min) and extends to end of day.
      expect(results.first.top, 1320.0);
      expect(results.first.bottom, 0.0); // reaches the very bottom
    });

    test('filters out event whose effective range is entirely before startHour',
        () {
      // startHour=8, event is 06:00–07:00 → should not appear.
      final events = [
        CalendarEventData(
          title: 'Too early',
          date: now,
          startTime: now.add(const Duration(hours: 6)),
          endTime: now.add(const Duration(hours: 7)),
        ),
      ];
      expect(arrange(events, startHourOverride: 8), isEmpty);
    });

    test('includes event that straddles the startHour boundary', () {
      // startHour=8, event is 07:00–09:00 → partially visible.
      final events = [
        CalendarEventData(
          title: 'Straddles',
          date: now,
          startTime: now.add(const Duration(hours: 7)),
          endTime: now.add(const Duration(hours: 9)),
        ),
      ];
      expect(arrange(events, startHourOverride: 8), hasLength(1));
    });
  });

  // ---------------------------------------------------------------------------
  // Multi-day event normalization
  // ---------------------------------------------------------------------------
  group('SideEventArranger – multi-day normalization', () {
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    // A 3-day event (yesterday → tomorrow); today is the middle day.
    CalendarEventData<Object?> threeDayEvent() => CalendarEventData(
          title: 'Three-day',
          date: yesterday,
          endDate: tomorrow,
          // Only hours/minutes are used; the date component is ignored.
          startTime:
              DateTime(yesterday.year, yesterday.month, yesterday.day, 10, 0),
          endTime:
              DateTime(yesterday.year, yesterday.month, yesterday.day, 15, 0),
        );

    test('middle day: spans the full day (top=0, bottom=0)', () {
      final results = arrange([threeDayEvent()], calendarViewDate: now);
      expect(results, hasLength(1));
      expect(results.first.top, 0.0);
      expect(results.first.bottom, 0.0);
    });

    test('start day: starts at event startTime, ends at bottom of day', () {
      final results = arrange([threeDayEvent()], calendarViewDate: yesterday);
      expect(results, hasLength(1));
      expect(results.first.top, 600.0); // 10:00 = 600 min @ 1 px/min
      expect(results.first.bottom, 0.0); // extends to end of day
    });

    test('end day: starts at top of day, ends at event endTime', () {
      final results = arrange([threeDayEvent()], calendarViewDate: tomorrow);
      expect(results, hasLength(1));
      expect(results.first.top, 0.0);
      // bottom = height – endMinutes × heightPerMinute = 1440 – 900 = 540
      expect(results.first.bottom, 540.0);
    });

    test('end day with midnight endTime: treated as end-of-day', () {
      // Event runs from yesterday to today; ends at 00:00 today.
      final event = CalendarEventData(
        title: 'Ends midnight',
        date: yesterday,
        endDate: now,
        startTime:
            DateTime(yesterday.year, yesterday.month, yesterday.day, 20, 0),
        endTime: DateTime(
            yesterday.year, yesterday.month, yesterday.day, 0, 0), // midnight
      );
      final results = arrange([event], calendarViewDate: now);
      expect(results, hasLength(1));
      // Effective end = 1440 → bottom = 0.0 (reaches the very bottom).
      expect(results.first.top, 0.0);
      expect(results.first.bottom, 0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Column placement / overlap detection
  // ---------------------------------------------------------------------------
  group('SideEventArranger – column placement', () {
    test('single event gets full width', () {
      final events = [
        CalendarEventData(
          title: 'Solo',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
      ];
      final results = arrange(events);
      expect(results, hasLength(1));
      expect(results.first.left, 0.0);
      expect(results.first.right, 0.0);
    });

    test('two non-overlapping events share one column, each gets full width',
        () {
      final events = [
        CalendarEventData(
          title: 'A',
          date: now,
          startTime: now.add(const Duration(hours: 8)),
          endTime: now.add(const Duration(hours: 10)),
        ),
        CalendarEventData(
          title: 'B',
          date: now,
          startTime: now.add(const Duration(hours: 12)),
          endTime: now.add(const Duration(hours: 14)),
        ),
      ];
      final results = arrange(events);
      expect(results, hasLength(2));
      for (final r in results) {
        expect(r.left, 0.0);
        expect(r.right, 0.0);
      }
    });

    test('two overlapping events go into two columns each with half width', () {
      // width=600 → each column = 300.
      final events = [
        CalendarEventData(
          title: 'A',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
        CalendarEventData(
          title: 'B',
          date: now,
          startTime: now.add(const Duration(hours: 11)),
          endTime: now.add(const Duration(hours: 13)),
        ),
      ];
      final results = arrange(events);
      expect(results, hasLength(2));
      final a = _findByTitle(results, 'A');
      final b = _findByTitle(results, 'B');
      expect(a.left, 0.0);
      expect(a.right, 300.0);
      expect(b.left, 300.0);
      expect(b.right, 0.0);
    });

    test('three mutually overlapping events each go into their own column', () {
      final events = [
        CalendarEventData(
          title: 'A',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
        CalendarEventData(
          title: 'B',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
        CalendarEventData(
          title: 'C',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
      ];
      final results = arrange(events);
      expect(results, hasLength(3));
      final lefts = results.map((r) => r.left).toSet();
      expect(lefts, hasLength(3)); // three distinct horizontal positions
    });

    test('time positions (top/bottom) are computed correctly', () {
      final events = [
        CalendarEventData(
          title: 'Timed',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
      ];
      final results = arrange(events);
      expect(results.first.top, 600.0); // 10 * 60 * 1.0 px/min
      expect(results.first.bottom, 720.0); // 1440 – (12 * 60) = 720
    });
  });

  // ---------------------------------------------------------------------------
  // countAdjacentEventsAsOverlapping
  // ---------------------------------------------------------------------------
  group('SideEventArranger – countAdjacentEventsAsOverlapping', () {
    final touchingEvents = [
      CalendarEventData(
        title: 'A',
        date: now,
        startTime: now.add(const Duration(hours: 10)),
        endTime: now.add(const Duration(hours: 12)),
      ),
      CalendarEventData(
        title: 'B',
        date: now,
        startTime: now.add(const Duration(hours: 12)),
        endTime: now.add(const Duration(hours: 14)),
      ),
    ];

    test('false (default): adjacent events share a column', () {
      final results =
          arrange(touchingEvents, countAdjacentEventsAsOverlapping: false);
      expect(results, hasLength(2));
      // Only one distinct left position → one column.
      expect(results.map((r) => r.left).toSet(), hasLength(1));
    });

    test('true: adjacent events are considered overlapping → two columns', () {
      final results =
          arrange(touchingEvents, countAdjacentEventsAsOverlapping: true);
      expect(results, hasLength(2));
      expect(results.map((r) => r.left).toSet(), hasLength(2));
    });
  });

  // ---------------------------------------------------------------------------
  // Dynamic width expansion (no maxWidth)
  // ---------------------------------------------------------------------------
  group('SideEventArranger – dynamic width expansion', () {
    test('event without a right-column blocker expands to full available width',
        () {
      // Columns assigned (sorted by start time):
      //   Col 0: X (09:00–11:00), Z (13:00–14:00)
      //   Col 1: Y (10:00–12:00)
      //
      // X overlaps Y   → X is capped at half width (300).
      // Z does not overlap Y → Z should expand to full width (600).
      final events = [
        CalendarEventData(
          title: 'X',
          date: now,
          startTime: now.add(const Duration(hours: 9)),
          endTime: now.add(const Duration(hours: 11)),
        ),
        CalendarEventData(
          title: 'Y',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
        CalendarEventData(
          title: 'Z',
          date: now,
          startTime: now.add(const Duration(hours: 13)),
          endTime: now.add(const Duration(hours: 14)),
        ),
      ];
      final results = arrange(events);
      expect(results, hasLength(3));

      final x = _findByTitle(results, 'X');
      final y = _findByTitle(results, 'Y');
      final z = _findByTitle(results, 'Z');

      // X is blocked by Y → confined to half width.
      expect(x.left, 0.0);
      expect(x.right, 300.0);

      // Y occupies column 1 with no further columns to its right.
      expect(y.left, 300.0);
      expect(y.right, 0.0);

      // Z is in column 0 but never overlaps anything in column 1 → full width.
      expect(z.left, 0.0);
      expect(z.right, 0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Fixed maxWidth
  // ---------------------------------------------------------------------------
  group('SideEventArranger – fixed maxWidth', () {
    test('single event is constrained to maxWidth', () {
      const max = 200.0;
      final events = [
        CalendarEventData(
          title: 'Solo',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
      ];
      final results = arrange(events, maxWidth: max);
      expect(results, hasLength(1));
      final renderedWidth = width - results.first.left - results.first.right;
      expect(renderedWidth, max);
    });

    test('event uses dynamic slot width when maxWidth exceeds it', () {
      // width=600, 2 overlapping events → baseSlotWidth=300.
      // maxWidth=500 > 300, so each event gets 300.
      const max = 500.0;
      final events = [
        CalendarEventData(
          title: 'A',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
        CalendarEventData(
          title: 'B',
          date: now,
          startTime: now.add(const Duration(hours: 11)),
          endTime: now.add(const Duration(hours: 13)),
        ),
      ];
      final results = arrange(events, maxWidth: max);
      for (final r in results) {
        final renderedWidth = width - r.left - r.right;
        expect(renderedWidth, closeTo(300.0, 0.01));
      }
    });

    test(
        'two overlapping events with maxWidth < slot: each gets maxWidth,'
        ' columns advance by maxWidth', () {
      // width=600, 2 overlapping events → baseSlotWidth=300.
      // maxWidth=200 < 300 → each event gets 200.
      // Columns: A at left=0, B at left=200.
      const max = 200.0;
      final events = [
        CalendarEventData(
          title: 'A',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
        CalendarEventData(
          title: 'B',
          date: now,
          startTime: now.add(const Duration(hours: 11)),
          endTime: now.add(const Duration(hours: 13)),
        ),
      ];
      final results = arrange(events, maxWidth: max);
      expect(results, hasLength(2));

      final a = _findByTitle(results, 'A');
      final b = _findByTitle(results, 'B');

      expect(a.left, closeTo(0.0, 0.01));
      expect(width - a.left - a.right, closeTo(max, 0.01));

      expect(b.left, closeTo(max, 0.01));
      expect(width - b.left - b.right, closeTo(max, 0.01));
    });

    test('no event visually overflows into the next column', () {
      // 3 mutually overlapping events, maxWidth=150.
      // width=600 → baseSlotWidth=200; min(200,150)=150 per column.
      const max = 150.0;
      final events = List.generate(
        3,
        (i) => CalendarEventData(
          title: 'E$i',
          date: now,
          startTime: now.add(const Duration(hours: 10)),
          endTime: now.add(const Duration(hours: 12)),
        ),
      );
      final results = arrange(events, maxWidth: max);
      expect(results, hasLength(3));

      final sorted = results.toList()..sort((a, b) => a.left.compareTo(b.left));
      for (int i = 0; i < sorted.length - 1; i++) {
        final rightEdge =
            sorted[i].left + (width - sorted[i].left - sorted[i].right);
        expect(
          rightEdge,
          lessThanOrEqualTo(sorted[i + 1].left + 0.01),
          reason:
              'Event at left=${sorted[i].left} overflows into event at left=${sorted[i + 1].left}',
        );
      }
    });
  });
}
