import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const height = 1440.0;
const width = 500.0;
const heightPerMinute = 1.0;
const startHour = 0;

void main() {
  final now = DateTime.now().withoutTime;

  group('MergeEventArrangerTest', () {
    test('Events which does not overlap.', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 1, 0),
          endDate: DateTime(now.year, now.month, now.day, 2, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 2, 15),
          endDate: DateTime(now.year, now.month, now.day, 3, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 3',
          date: DateTime(now.year, now.month, now.day, 3, 15),
          endDate: DateTime(now.year, now.month, now.day, 4, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 4',
          date: DateTime(now.year, now.month, now.day, 4, 15),
          endDate: DateTime(now.year, now.month, now.day, 5, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 5',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 13, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, events.length);
    });

    test('Only start time is overlapping', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 8, 0),
          endDate: DateTime(now.year, now.month, now.day, 10, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 1);
    });

    test('Only end time is overlapping', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 8, 0),
          endDate: DateTime(now.year, now.month, now.day, 10, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 1);
    });

    test('Event1 is smaller than event 2 and overlapping', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 8, 0),
          endDate: DateTime(now.year, now.month, now.day, 14, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 1);
    });

    test('Event2 is smaller than event 1 and overlapping', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 8, 0),
          endDate: DateTime(now.year, now.month, now.day, 14, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 1);
    });

    test('Both events are of same duration and occurs at the same time', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 1);
    });

    test('Only few events overlaps', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 1, 0),
          endDate: DateTime(now.year, now.month, now.day, 2, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 4',
          date: DateTime(now.year, now.month, now.day, 7, 0),
          endDate: DateTime(now.year, now.month, now.day, 11, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 6',
          date: DateTime(now.year, now.month, now.day, 3, 0),
          endDate: DateTime(now.year, now.month, now.day, 3, 30),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 5',
          date: DateTime(now.year, now.month, now.day, 1, 15),
          endDate: DateTime(now.year, now.month, now.day, 2, 15),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 3',
          date: DateTime(now.year, now.month, now.day, 5, 0),
          endDate: DateTime(now.year, now.month, now.day, 6, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 8, 0),
          endDate: DateTime(now.year, now.month, now.day, 9, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 4);
    });

    test('All events overlaps with each other', () {
      final events = [
        CalendarEventData.timeRanged(
          title: 'Event 1',
          date: DateTime(now.year, now.month, now.day, 1, 0),
          endDate: DateTime(now.year, now.month, now.day, 2, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: DateTime(now.year, now.month, now.day, 4, 0),
          endDate: DateTime(now.year, now.month, now.day, 5, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 3',
          date: DateTime(now.year, now.month, now.day, 2, 0),
          endDate: DateTime(now.year, now.month, now.day, 6, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 4',
          date: DateTime(now.year, now.month, now.day, 7, 0),
          endDate: DateTime(now.year, now.month, now.day, 10, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 5',
          date: DateTime(now.year, now.month, now.day, 5, 0),
          endDate: DateTime(now.year, now.month, now.day, 7, 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 6',
          date: DateTime(now.year, now.month, now.day, 3, 0),
          endDate: DateTime(now.year, now.month, now.day, 6, 0),
        ),
      ];

      final mergedEvents = MergeEventArranger().arrange(
        events: events
          ..sort((e1, e2) =>
              (e1.startTime?.getTotalMinutes ?? 0) -
              (e2.startTime?.getTotalMinutes ?? 0)),
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(mergedEvents.length, 1);
    });

    group('Edge event should not merge', () {
      test('End of Event 1 and Start of Event 2 is same', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'Event 1',
            date: DateTime(now.year, now.month, now.day, 1, 0),
            endDate: DateTime(now.year, now.month, now.day, 2, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: DateTime(now.year, now.month, now.day, 2, 0),
            endDate: DateTime(now.year, now.month, now.day, 3, 0),
          ),
        ];

        final mergedEvents = MergeEventArranger(includeEdges: false).arrange(
          events: events
            ..sort((e1, e2) =>
                (e1.startTime?.getTotalMinutes ?? 0) -
                (e2.startTime?.getTotalMinutes ?? 0)),
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(mergedEvents.length, 2);
      });

      test('Start of Event 1 and End of Event 2 is same', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'Event 1',
            date: DateTime(now.year, now.month, now.day, 2, 0),
            endDate: DateTime(now.year, now.month, now.day, 3, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: DateTime(now.year, now.month, now.day, 1, 0),
            endDate: DateTime(now.year, now.month, now.day, 2, 0),
          ),
        ];

        final mergedEvents = MergeEventArranger(includeEdges: false).arrange(
          events: events
            ..sort((e1, e2) =>
                (e1.startTime?.getTotalMinutes ?? 0) -
                (e2.startTime?.getTotalMinutes ?? 0)),
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(mergedEvents.length, 2);
      });
    });

    group('Edge event should merge', () {
      test('End of Event 1 and Start of Event 2 is same', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'Event 1',
            date: DateTime(now.year, now.month, now.day, 1, 0),
            endDate: DateTime(now.year, now.month, now.day, 2, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: DateTime(now.year, now.month, now.day, 2, 0),
            endDate: DateTime(now.year, now.month, now.day, 3, 0),
          ),
        ];

        final mergedEvents = MergeEventArranger(includeEdges: true).arrange(
          events: events
            ..sort((e1, e2) =>
                (e1.startTime?.getTotalMinutes ?? 0) -
                (e2.startTime?.getTotalMinutes ?? 0)),
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(mergedEvents.length, 1);
      });

      test('Start of Event 1 and End of Event 2 is same', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'Event 1',
            date: DateTime(now.year, now.month, now.day, 2, 0),
            endDate: DateTime(now.year, now.month, now.day, 3, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: DateTime(now.year, now.month, now.day, 1, 0),
            endDate: DateTime(now.year, now.month, now.day, 2, 0),
          ),
        ];

        final mergedEvents = MergeEventArranger(includeEdges: true).arrange(
          events: events
            ..sort((e1, e2) =>
                (e1.startTime?.getTotalMinutes ?? 0) -
                (e2.startTime?.getTotalMinutes ?? 0)),
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(mergedEvents.length, 1);
      });
    });

    group('Multi-day events', () {
      test('Multi-day event with specific times', () {
        final events = [
          CalendarEventData.multiDay(
            title: 'Workshop',
            date: DateTime(now.year, now.month, now.day, 9, 0),
            endDate: DateTime(
                now.add(Duration(days: 2)).year,
                now.add(Duration(days: 2)).month,
                now.add(Duration(days: 2)).day,
                17,
                0),
          ),
        ];

        final mergedEvents = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(mergedEvents.length, 1);
      });

      test('Overnight multi-day event renders to end of start day', () {
        final overnightEvent = CalendarEventData.multiDay(
          title: 'Overnight support',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(
              now.add(Duration(days: 1)).year,
              now.add(Duration(days: 1)).month,
              now.add(Duration(days: 1)).day,
              9,
              0),
        );

        final mergedEvents = MergeEventArranger().arrange(
          events: [overnightEvent],
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(mergedEvents.single.events, [overnightEvent]);
        expect(mergedEvents.single.top, 600);
        expect(mergedEvents.single.bottom, 0);
        expect(mergedEvents.single.startDuration.getTotalMinutes, 600);
        expect(mergedEvents.single.endDuration.getTotalMinutes, 0);
      });

      test('Overnight multi-day event renders from midnight on end day', () {
        final overnightEvent = CalendarEventData.multiDay(
          title: 'Overnight support',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(
              now.add(Duration(days: 1)).year,
              now.add(Duration(days: 1)).month,
              now.add(Duration(days: 1)).day,
              9,
              0),
        );

        final mergedEvents = MergeEventArranger().arrange(
          events: [overnightEvent],
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now.add(Duration(days: 1)),
        );

        expect(mergedEvents.single.events, [overnightEvent]);
        expect(mergedEvents.single.top, 0);
        expect(mergedEvents.single.bottom, 900);
        expect(mergedEvents.single.startDuration.getTotalMinutes, 0);
        expect(mergedEvents.single.endDuration.getTotalMinutes, 540);
      });
    });

// TODO: add tests for the events where start or end time is not valid.
  });

  group('CalendarEventData Constructor Tests', () {
    group('General Constructor', () {
      test('should create event with all parameters', () {
        final event = CalendarEventData(
          title: 'Test Event',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
          description: 'Test Description',
          color: Colors.red,
        );

        expect(event.title, 'Test Event');
        expect(event.date, now);
        expect(event.startTime, TimeOfDay(hour: 10, minute: 0));
        expect(event.endTime, TimeOfDay(hour: 12, minute: 0));
        expect(event.description, 'Test Description');
        expect(event.color, Colors.red);
      });

      test('should create event with minimal parameters', () {
        final event = CalendarEventData(
          title: 'Minimal Event',
          date: now,
        );

        expect(event.title, 'Minimal Event');
        expect(event.date, now);
        // startTime is always derived from the date's time component (00:00 for midnight).
        expect(event.startTime, const TimeOfDay(hour: 0, minute: 0));
        // endTime is null when no end date is provided.
        expect(event.endTime, isNull);
        expect(event.color, Colors.blue);
      });

      test('should strip time from startDate', () {
        final dateWithTime = DateTime(2024, 1, 15, 10, 30);
        final event = CalendarEventData(
          title: 'Event',
          date: dateWithTime,
        );

        expect(event.date.hour, 0);
        expect(event.date.minute, 0);
        expect(event.date.second, 0);
        expect(event.date.millisecond, 0);
      });
    });

    group('CalendarEventData.timeRanged Constructor', () {
      test('should create time-ranged event on single day', () {
        final event = CalendarEventData.timeRanged(
          title: 'Meeting',
          date: DateTime(now.year, now.month, now.day, 14, 0),
          endDate: DateTime(now.year, now.month, now.day, 16, 0),
          description: 'Team meeting',
        );

        expect(event.title, 'Meeting');
        expect(event.date, now);
        expect(event.startTime, TimeOfDay(hour: 14, minute: 0));
        expect(event.endTime, TimeOfDay(hour: 16, minute: 0));
        expect(event.isFullDayEvent, false);
        expect(event.isRangingEvent, false);
      });

      test('should not be a full day event', () {
        final event = CalendarEventData.timeRanged(
          title: 'Meeting',
          date: DateTime(now.year, now.month, now.day, 9, 0),
          endDate: DateTime(now.year, now.month, now.day, 17, 0),
        );

        expect(event.isFullDayEvent, false);
      });

      test('should not be a ranging event', () {
        final event = CalendarEventData.timeRanged(
          title: 'Meeting',
          date: DateTime(now.year, now.month, now.day, 9, 0),
          endDate: DateTime(now.year, now.month, now.day, 17, 0),
        );

        expect(event.isRangingEvent, false);
        expect(event.endDate, now);
      });
    });

    group('CalendarEventData.wholeDay Constructor', () {
      test('should create whole day event', () {
        final event = CalendarEventData.wholeDay(
          title: 'Holiday',
          date: now,
          description: 'National Holiday',
        );

        expect(event.title, 'Holiday');
        expect(event.date, now);
        // startTime is derived from midnight; endTime is null for single whole-day event.
        expect(event.startTime, const TimeOfDay(hour: 0, minute: 0));
        expect(event.endTime, isNull);
        expect(event.isFullDayEvent, true);
      });

      test('should be a full day event', () {
        final event = CalendarEventData.wholeDay(
          title: 'Birthday',
          date: now,
        );

        expect(event.isFullDayEvent, true);
      });

      test('should not be a ranging event for single day', () {
        final event = CalendarEventData.wholeDay(
          title: 'Holiday',
          date: now,
        );

        expect(event.isRangingEvent, false);
        expect(event.endDate, now);
      });
    });

    group('CalendarEventData.multiDay Constructor', () {
      test('should create whole-day multi-day event', () {
        final startDate = now;
        final endDate = now.add(Duration(days: 2));

        final event = CalendarEventData.multiDay(
          title: 'Conference',
          date: startDate,
          endDate: endDate,
          description: '3-day conference',
        );

        expect(event.title, 'Conference');
        expect(event.date, startDate);
        expect(event.endDate, endDate);
        // startTime and endTime are derived from midnight (date-only inputs).
        expect(event.startTime, const TimeOfDay(hour: 0, minute: 0));
        expect(event.endTime, const TimeOfDay(hour: 0, minute: 0));
        expect(event.isFullDayEvent, true);
        expect(event.isRangingEvent, false);
      });

      test('should create timed multi-day event', () {
        final startDate = now;
        final endDate = now.add(Duration(days: 3));

        final event = CalendarEventData.multiDay(
          title: 'Workshop',
          date: DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
          endDate: DateTime(endDate.year, endDate.month, endDate.day, 17, 0),
          description: 'Extended workshop',
        );

        expect(event.title, 'Workshop');
        expect(event.date, startDate);
        expect(event.endDate, endDate);
        expect(event.startTime, TimeOfDay(hour: 9, minute: 0));
        expect(event.endTime, TimeOfDay(hour: 17, minute: 0));
        expect(event.isFullDayEvent, false);
        expect(event.isRangingEvent, true);
      });

      test('should strip time from both dates', () {
        final startDateWithTime = DateTime(2024, 1, 15, 10, 30);
        final endDateWithTime = DateTime(2024, 1, 17, 15, 45);

        final event = CalendarEventData.multiDay(
          title: 'Event',
          date: startDateWithTime,
          endDate: endDateWithTime,
        );

        expect(event.date.hour, 0);
        expect(event.date.minute, 0);
        expect(event.endDate.hour, 0);
        expect(event.endDate.minute, 0);
      });
    });
  });

  group('CalendarEventData Duration Tests', () {
    group('Single-day event durations', () {
      test('should calculate duration for same-day event', () {
        final event = CalendarEventData.timeRanged(
          title: 'Meeting',
          date: DateTime(now.year, now.month, now.day, 10, 0),
          endDate: DateTime(now.year, now.month, now.day, 12, 0),
        );

        expect(event.duration.inHours, 2);
        expect(event.duration.inMinutes, 120);
      });

      test('should calculate duration for event with minutes', () {
        final event = CalendarEventData.timeRanged(
          title: 'Quick Meeting',
          date: DateTime(now.year, now.month, now.day, 14, 30),
          endDate: DateTime(now.year, now.month, now.day, 15, 45),
        );

        expect(event.duration.inMinutes, 75);
      });

      test(
          'should calculate duration when endTime is before startTime (next day)',
          () {
        final event = CalendarEventData(
          title: 'Night Shift',
          date: DateTime(now.year, now.month, now.day, 22, 0),
          endDate: DateTime(now.year, now.month, now.day, 6, 0),
        );

        expect(event.duration.inHours, 8);
      });

      test('should handle midnight (00:00) as end time', () {
        final event = CalendarEventData(
          title: 'Event until midnight',
          date: DateTime(now.year, now.month, now.day, 18, 0),
          endDate: DateTime(now.year, now.month, now.day, 0, 0),
        );

        expect(event.duration.inMinutes, 360);
      });
    });

    group('Full-day event durations', () {
      test('should return 1 day duration for single whole-day event', () {
        final event = CalendarEventData.wholeDay(
          title: 'Holiday',
          date: now,
        );

        expect(event.duration.inDays, 1);
        expect(event.duration.inHours, 24);
      });

      test('should calculate correct duration for multi-day whole-day event',
          () {
        final event = CalendarEventData.multiDay(
          title: 'Conference',
          date: now,
          endDate: now.add(Duration(days: 2)),
        );

        expect(event.duration.inDays, 3);
      });

      test('should calculate duration for 5-day conference', () {
        final event = CalendarEventData.multiDay(
          title: 'Week-long Conference',
          date: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 5),
        );

        expect(event.duration.inDays, 5);
      });
    });

    group('Multi-day event with times (ranging events)', () {
      test(
          'should calculate duration for multi-day event with times - reviewer case',
          () {
        final event = CalendarEventData.multiDay(
          title: 'Extended Workshop',
          date: DateTime(2024, 1, 1, 9, 0),
          endDate: DateTime(2024, 1, 3, 17, 0),
        );

        expect(event.isRangingEvent, true);
        expect(event.duration.inHours, 56);
        expect(event.duration.inMinutes, 3360);
      });

      test('should calculate duration for 2-day event with same times', () {
        final event = CalendarEventData.multiDay(
          title: 'Workshop',
          date: DateTime(2024, 1, 1, 10, 0),
          endDate: DateTime(2024, 1, 2, 10, 0),
        );

        expect(event.duration.inHours, 24);
      });

      test(
          'should calculate duration for multi-day event ending before start time',
          () {
        final event = CalendarEventData.multiDay(
          title: 'Event',
          date: DateTime(2024, 1, 1, 15, 0),
          endDate: DateTime(2024, 1, 3, 10, 0),
        );

        expect(event.duration.inHours, 43);
      });

      test('should calculate duration for week-long event with specific times',
          () {
        final event = CalendarEventData.multiDay(
          title: 'Training',
          date: DateTime(2024, 3, 4, 9, 0),
          endDate: DateTime(2024, 3, 8, 17, 0),
        );

        expect(event.duration.inHours, 104);
      });

      test('should handle multi-day event with minutes precision', () {
        final event = CalendarEventData.multiDay(
          title: 'Precise Event',
          date: DateTime(2024, 2, 10, 14, 30),
          endDate: DateTime(2024, 2, 12, 16, 45),
        );

        expect(event.duration.inMinutes, 3015);
      });
    });
  });

  group('CalendarEventData Property Tests', () {
    test('isFullDayEvent should return true when no times provided', () {
      final event = CalendarEventData(
        title: 'All Day',
        date: now,
      );

      expect(event.isFullDayEvent, true);
    });

    test('isFullDayEvent should return true when both times are midnight', () {
      final event = CalendarEventData(
        title: 'Event',
        date: DateTime(now.year, now.month, now.day, 0, 0),
        endDate: DateTime(now.year, now.month, now.day, 0, 0),
      );

      expect(event.isFullDayEvent, true);
    });

    test('isRangingEvent should return true for multi-day timed event', () {
      final event = CalendarEventData.multiDay(
        title: 'Multi-day',
        date: DateTime(now.year, now.month, now.day, 10, 0),
        endDate: DateTime(
            now.add(Duration(days: 2)).year,
            now.add(Duration(days: 2)).month,
            now.add(Duration(days: 2)).day,
            16,
            0),
      );

      expect(event.isRangingEvent, true);
    });

    test('isRangingEvent should return false for multi-day full-day event', () {
      final event = CalendarEventData.multiDay(
        title: 'Multi-day Full Day',
        date: now,
        endDate: now.add(Duration(days: 2)),
      );

      expect(event.isRangingEvent, false);
    });

    test('isRecurringEvent should return false when no recurrence settings',
        () {
      final event = CalendarEventData(
        title: 'One-time Event',
        date: now,
      );

      expect(event.isRecurringEvent, false);
    });

    test('isRecurringEvent should return true with recurrence settings', () {
      final event = CalendarEventData(
        title: 'Daily Standup',
        date: DateTime(now.year, now.month, now.day, 9, 0),
        endDate: DateTime(now.year, now.month, now.day, 9, 30),
        recurrenceSettings: RecurrenceSettings(
          startDate: now,
          frequency: RepeatFrequency.daily,
        ),
      );

      expect(event.isRecurringEvent, true);
    });

    test('occursOnDate should return true for event date', () {
      final event = CalendarEventData(
        title: 'Event',
        date: now,
      );

      expect(event.occursOnDate(now), true);
    });

    test('occursOnDate should return true for dates in multi-day range', () {
      final startDate = DateTime(2024, 1, 10);
      final endDate = DateTime(2024, 1, 15);

      final event = CalendarEventData.multiDay(
        title: 'Conference',
        date: startDate,
        endDate: endDate,
      );

      expect(event.occursOnDate(DateTime(2024, 1, 10)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 12)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 15)), true);
      expect(event.occursOnDate(DateTime(2024, 1, 9)), false);
      expect(event.occursOnDate(DateTime(2024, 1, 16)), false);
    });
  });

  group('CalendarEventData.copyWith Tests', () {
    test('should create copy with updated title', () {
      final original = CalendarEventData.timeRanged(
        title: 'Original',
        date: DateTime(now.year, now.month, now.day, 10, 0),
        endDate: DateTime(now.year, now.month, now.day, 12, 0),
      );

      final copy = original.copyWith(title: 'Updated');

      expect(copy.title, 'Updated');
      expect(copy.date, original.date);
      expect(copy.startTime, original.startTime);
    });

    test('should create copy with updated times', () {
      final original = CalendarEventData.timeRanged(
        title: 'Event',
        date: DateTime(now.year, now.month, now.day, 10, 0),
        endDate: DateTime(now.year, now.month, now.day, 12, 0),
      );

      final copy = original.copyWith(
        date: DateTime(now.year, now.month, now.day, 14, 0),
        endDate: DateTime(now.year, now.month, now.day, 16, 0),
      );

      expect(copy.startTime, TimeOfDay(hour: 14, minute: 0));
      expect(copy.endTime, TimeOfDay(hour: 16, minute: 0));
      expect(copy.title, original.title);
    });

    test('should create copy with recurrence settings', () {
      final original = CalendarEventData(
        title: 'Event',
        date: now,
      );

      final recurrence = RecurrenceSettings(
        startDate: now,
        frequency: RepeatFrequency.weekly,
      );

      final copy = original.copyWith(recurrenceSettings: recurrence);

      expect(copy.recurrenceSettings, recurrence);
      expect(copy.isRecurringEvent, true);
    });
  });

  group('CalendarEventData Recurring Event Tests', () {
    test('should create daily recurring event', () {
      final event = CalendarEventData.timeRanged(
        title: 'Daily Standup',
        date: DateTime(now.year, now.month, now.day, 9, 0),
        endDate: DateTime(now.year, now.month, now.day, 9, 30),
        recurrenceSettings: RecurrenceSettings(
          startDate: now,
          frequency: RepeatFrequency.daily,
          recurrenceEndOn: RecurrenceEnd.after,
          occurrences: 5,
        ),
      );

      expect(event.isRecurringEvent, true);
      expect(event.recurrenceSettings!.frequency, RepeatFrequency.daily);
      expect(event.recurrenceSettings!.occurrences, 5);
    });

    test('should create weekly recurring event with specific weekdays', () {
      final event = CalendarEventData.timeRanged(
        title: 'Team Meeting',
        date: DateTime(now.year, now.month, now.day, 14, 0),
        endDate: DateTime(now.year, now.month, now.day, 15, 0),
        recurrenceSettings: RecurrenceSettings(
          startDate: now,
          frequency: RepeatFrequency.weekly,
          weekdays: [WeekDays.monday, WeekDays.wednesday, WeekDays.friday],
        ),
      );

      expect(event.isRecurringEvent, true);
      expect(event.recurrenceSettings!.weekdays.length, 3);
      expect(
        event.recurrenceSettings!.weekdays,
        contains(WeekDays.monday),
      );
    });

    test('should create monthly recurring event', () {
      final event = CalendarEventData.wholeDay(
        title: 'Monthly Review',
        date: DateTime(2024, 1, 15),
        recurrenceSettings: RecurrenceSettings(
          startDate: DateTime(2024, 1, 15),
          frequency: RepeatFrequency.monthly,
          endDate: DateTime(2024, 12, 15),
        ),
      );

      expect(event.isRecurringEvent, true);
      expect(event.recurrenceSettings!.frequency, RepeatFrequency.monthly);
    });
  });
}
