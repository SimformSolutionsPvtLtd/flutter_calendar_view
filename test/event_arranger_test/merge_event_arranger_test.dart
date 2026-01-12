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
          date: now,
          startTime: TimeOfDay(hour: 1, minute: 0),
          endTime: TimeOfDay(hour: 2, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 2, minute: 15),
          endTime: TimeOfDay(hour: 3, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 3',
          date: now,
          startTime: TimeOfDay(hour: 3, minute: 15),
          endTime: TimeOfDay(hour: 4, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 4',
          date: now,
          startTime: TimeOfDay(hour: 4, minute: 15),
          endTime: TimeOfDay(hour: 5, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 5',
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 13, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 14, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 14, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 1, minute: 0),
          endTime: TimeOfDay(hour: 2, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 4',
          date: now,
          startTime: TimeOfDay(hour: 7, minute: 0),
          endTime: TimeOfDay(hour: 11, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 6',
          date: now,
          startTime: TimeOfDay(hour: 3, minute: 0),
          endTime: TimeOfDay(hour: 3, minute: 30),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 5',
          date: now,
          startTime: TimeOfDay(hour: 1, minute: 15),
          endTime: TimeOfDay(hour: 2, minute: 15),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 3',
          date: now,
          startTime: TimeOfDay(hour: 5, minute: 0),
          endTime: TimeOfDay(hour: 6, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 9, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 1, minute: 0),
          endTime: TimeOfDay(hour: 2, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 2',
          date: now,
          startTime: TimeOfDay(hour: 4, minute: 0),
          endTime: TimeOfDay(hour: 5, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 3',
          date: now,
          startTime: TimeOfDay(hour: 2, minute: 0),
          endTime: TimeOfDay(hour: 6, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 4',
          date: now,
          startTime: TimeOfDay(hour: 7, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 5',
          date: now,
          startTime: TimeOfDay(hour: 5, minute: 0),
          endTime: TimeOfDay(hour: 7, minute: 0),
        ),
        CalendarEventData.timeRanged(
          title: 'Event 6',
          date: now,
          startTime: TimeOfDay(hour: 3, minute: 0),
          endTime: TimeOfDay(hour: 6, minute: 0),
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
            date: now,
            startTime: TimeOfDay(hour: 1, minute: 0),
            endTime: TimeOfDay(hour: 2, minute: 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: now,
            startTime: TimeOfDay(hour: 2, minute: 0),
            endTime: TimeOfDay(hour: 3, minute: 0),
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
            date: now,
            startTime: TimeOfDay(hour: 2, minute: 0),
            endTime: TimeOfDay(hour: 3, minute: 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: now,
            startTime: TimeOfDay(hour: 1, minute: 0),
            endTime: TimeOfDay(hour: 2, minute: 0),
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
            date: now,
            startTime: TimeOfDay(hour: 1, minute: 0),
            endTime: TimeOfDay(hour: 2, minute: 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: now,
            startTime: TimeOfDay(hour: 2, minute: 0),
            endTime: TimeOfDay(hour: 3, minute: 0),
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
            date: now,
            startTime: TimeOfDay(hour: 2, minute: 0),
            endTime: TimeOfDay(hour: 3, minute: 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Event 2',
            date: now,
            startTime: TimeOfDay(hour: 1, minute: 0),
            endTime: TimeOfDay(hour: 2, minute: 0),
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
            startDate: now,
            endDate: now.add(Duration(days: 2)),
            startTime: TimeOfDay(hour: 9, minute: 0),
            endTime: TimeOfDay(hour: 17, minute: 0),
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
    });

// TODO: add tests for the events where start or end time is not valid.
  });

  group('CalendarEventData Constructor Tests', () {
    group('General Constructor', () {
      test('should create event with all parameters', () {
        final event = CalendarEventData(
          title: 'Test Event',
          startDate: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
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
          startDate: now,
        );

        expect(event.title, 'Minimal Event');
        expect(event.date, now);
        expect(event.startTime, isNull);
        expect(event.endTime, isNull);
        expect(event.color, Colors.blue);
      });

      test('should strip time from startDate', () {
        final dateWithTime = DateTime(2024, 1, 15, 10, 30);
        final event = CalendarEventData(
          title: 'Event',
          startDate: dateWithTime,
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
          date: now,
          startTime: TimeOfDay(hour: 14, minute: 0),
          endTime: TimeOfDay(hour: 16, minute: 0),
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
          date: now,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        );

        expect(event.isFullDayEvent, false);
      });

      test('should not be a ranging event', () {
        final event = CalendarEventData.timeRanged(
          title: 'Meeting',
          date: now,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
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
        expect(event.startTime, isNull);
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
          startDate: startDate,
          endDate: endDate,
          description: '3-day conference',
        );

        expect(event.title, 'Conference');
        expect(event.date, startDate);
        expect(event.endDate, endDate);
        expect(event.startTime, isNull);
        expect(event.endTime, isNull);
        expect(event.isFullDayEvent, true);
        expect(event.isRangingEvent, false);
      });

      test('should create timed multi-day event', () {
        final startDate = now;
        final endDate = now.add(Duration(days: 3));

        final event = CalendarEventData.multiDay(
          title: 'Workshop',
          startDate: startDate,
          endDate: endDate,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
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
          startDate: startDateWithTime,
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
          date: now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
        );

        expect(event.duration.inHours, 2);
        expect(event.duration.inMinutes, 120);
      });

      test('should calculate duration for event with minutes', () {
        final event = CalendarEventData.timeRanged(
          title: 'Quick Meeting',
          date: now,
          startTime: TimeOfDay(hour: 14, minute: 30),
          endTime: TimeOfDay(hour: 15, minute: 45),
        );

        expect(event.duration.inMinutes, 75);
      });

      test(
          'should calculate duration when endTime is before startTime (next day)',
          () {
        final event = CalendarEventData(
          title: 'Night Shift',
          startDate: now,
          startTime: TimeOfDay(hour: 22, minute: 0),
          endTime: TimeOfDay(hour: 6, minute: 0),
        );

        expect(event.duration.inHours, 8);
      });

      test('should handle midnight (00:00) as end time', () {
        final event = CalendarEventData(
          title: 'Event until midnight',
          startDate: now,
          startTime: TimeOfDay(hour: 18, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0),
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
          startDate: now,
          endDate: now.add(Duration(days: 2)),
        );

        expect(event.duration.inDays, 3);
      });

      test('should calculate duration for 5-day conference', () {
        final event = CalendarEventData.multiDay(
          title: 'Week-long Conference',
          startDate: DateTime(2024, 1, 1),
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
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 3),
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        );

        expect(event.isRangingEvent, true);
        expect(event.duration.inHours, 56);
        expect(event.duration.inMinutes, 3360);
      });

      test('should calculate duration for 2-day event with same times', () {
        final event = CalendarEventData.multiDay(
          title: 'Workshop',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 2),
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
        );

        expect(event.duration.inHours, 24);
      });

      test(
          'should calculate duration for multi-day event ending before start time',
          () {
        final event = CalendarEventData.multiDay(
          title: 'Event',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 3),
          startTime: TimeOfDay(hour: 15, minute: 0),
          endTime: TimeOfDay(hour: 10, minute: 0),
        );

        expect(event.duration.inHours, 43);
      });

      test('should calculate duration for week-long event with specific times',
          () {
        final event = CalendarEventData.multiDay(
          title: 'Training',
          startDate: DateTime(2024, 3, 4),
          endDate: DateTime(2024, 3, 8),
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
        );

        expect(event.duration.inHours, 104);
      });

      test('should handle multi-day event with minutes precision', () {
        final event = CalendarEventData.multiDay(
          title: 'Precise Event',
          startDate: DateTime(2024, 2, 10),
          endDate: DateTime(2024, 2, 12),
          startTime: TimeOfDay(hour: 14, minute: 30),
          endTime: TimeOfDay(hour: 16, minute: 45),
        );

        expect(event.duration.inMinutes, 3015);
      });
    });
  });

  group('CalendarEventData Property Tests', () {
    test('isFullDayEvent should return true when no times provided', () {
      final event = CalendarEventData(
        title: 'All Day',
        startDate: now,
      );

      expect(event.isFullDayEvent, true);
    });

    test('isFullDayEvent should return true when both times are midnight', () {
      final event = CalendarEventData(
        title: 'Event',
        startDate: now,
        startTime: TimeOfDay(hour: 0, minute: 0),
        endTime: TimeOfDay(hour: 0, minute: 0),
      );

      expect(event.isFullDayEvent, true);
    });

    test('isRangingEvent should return true for multi-day timed event', () {
      final event = CalendarEventData.multiDay(
        title: 'Multi-day',
        startDate: now,
        endDate: now.add(Duration(days: 2)),
        startTime: TimeOfDay(hour: 10, minute: 0),
        endTime: TimeOfDay(hour: 16, minute: 0),
      );

      expect(event.isRangingEvent, true);
    });

    test('isRangingEvent should return false for multi-day full-day event', () {
      final event = CalendarEventData.multiDay(
        title: 'Multi-day Full Day',
        startDate: now,
        endDate: now.add(Duration(days: 2)),
      );

      expect(event.isRangingEvent, false);
    });

    test('isRecurringEvent should return false when no recurrence settings',
        () {
      final event = CalendarEventData(
        title: 'One-time Event',
        startDate: now,
      );

      expect(event.isRecurringEvent, false);
    });

    test('isRecurringEvent should return true with recurrence settings', () {
      final event = CalendarEventData(
        title: 'Daily Standup',
        startDate: now,
        startTime: TimeOfDay(hour: 9, minute: 0),
        endTime: TimeOfDay(hour: 9, minute: 30),
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
        startDate: now,
      );

      expect(event.occursOnDate(now), true);
    });

    test('occursOnDate should return true for dates in multi-day range', () {
      final startDate = DateTime(2024, 1, 10);
      final endDate = DateTime(2024, 1, 15);

      final event = CalendarEventData.multiDay(
        title: 'Conference',
        startDate: startDate,
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
        date: now,
        startTime: TimeOfDay(hour: 10, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );

      final copy = original.copyWith(title: 'Updated');

      expect(copy.title, 'Updated');
      expect(copy.date, original.date);
      expect(copy.startTime, original.startTime);
    });

    test('should create copy with updated times', () {
      final original = CalendarEventData.timeRanged(
        title: 'Event',
        date: now,
        startTime: TimeOfDay(hour: 10, minute: 0),
        endTime: TimeOfDay(hour: 12, minute: 0),
      );

      final copy = original.copyWith(
        startTime: TimeOfDay(hour: 14, minute: 0),
        endTime: TimeOfDay(hour: 16, minute: 0),
      );

      expect(copy.startTime, TimeOfDay(hour: 14, minute: 0));
      expect(copy.endTime, TimeOfDay(hour: 16, minute: 0));
      expect(copy.title, original.title);
    });

    test('should create copy with recurrence settings', () {
      final original = CalendarEventData(
        title: 'Event',
        startDate: now,
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
        date: now,
        startTime: TimeOfDay(hour: 9, minute: 0),
        endTime: TimeOfDay(hour: 9, minute: 30),
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
        date: now,
        startTime: TimeOfDay(hour: 14, minute: 0),
        endTime: TimeOfDay(hour: 15, minute: 0),
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
