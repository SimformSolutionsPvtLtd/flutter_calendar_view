import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MergeEventArranger - Multi-Day and Midnight Edge Cases', () {
    final now = DateTime(2026, 2, 9);
    const height = 1000.0;
    const width = 400.0;
    const heightPerMinute = 1.0;
    const startHour = 0;

    group('Multi-Day Event Tests', () {
      test('should handle multi-day event on first day', () {
        final startDate = now;
        final endDate = now.add(Duration(days: 2));

        final events = [
          CalendarEventData(
            title: '3-Day Workshop',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime:
                DateTime(startDate.year, startDate.month, startDate.day, 17, 0),
            endDate: endDate,
            color: Colors.blue,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: startDate, // Viewing first day
        );

        expect(arranged.length, 1);

        // On first day, should start at 9:00 and extend to end of day
        // endDuration will be 0 (representing 1440/end-of-day)
        expect(arranged[0].startDuration.getTotalMinutes, equals(9 * 60));
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(0)); // 0 represents end-of-day (1440)
      });

      test('should handle multi-day event on middle day', () {
        final startDate = now;
        final middleDate = now.add(Duration(days: 1));
        final endDate = now.add(Duration(days: 2));

        final events = [
          CalendarEventData(
            title: '3-Day Workshop',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime:
                DateTime(startDate.year, startDate.month, startDate.day, 17, 0),
            endDate: endDate,
            color: Colors.blue,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: middleDate, // Viewing middle day
        );

        expect(arranged.length, 1);

        // On middle day, should span full day (0 to end-of-day)
        // endDuration will be 0 (representing 1440/end-of-day)
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(0)); // 0 represents end-of-day (1440)
      });

      test('should handle multi-day event on last day', () {
        final startDate = now;
        final endDate = now.add(Duration(days: 2));

        final events = [
          CalendarEventData(
            title: '3-Day Workshop',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime:
                DateTime(startDate.year, startDate.month, startDate.day, 17, 0),
            endDate: endDate,
            color: Colors.blue,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: endDate, // Viewing last day
        );

        expect(arranged.length, 1);

        // On last day, should start at beginning and end at 17:00
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        expect(arranged[0].endDuration.getTotalMinutes, equals(17 * 60));
      });

      test('should merge overlapping multi-day and single-day events', () {
        final startDate = now;
        final middleDate = now.add(Duration(days: 1));
        final endDate = now.add(Duration(days: 2));

        final events = [
          CalendarEventData(
            title: '3-Day Workshop',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime:
                DateTime(startDate.year, startDate.month, startDate.day, 17, 0),
            endDate: endDate,
            color: Colors.blue,
          ),
          CalendarEventData(
            title: 'Marathon Coding',
            date: middleDate,
            startTime: DateTime(
                middleDate.year, middleDate.month, middleDate.day, 8, 0),
            endTime: DateTime(
                middleDate.year, middleDate.month, middleDate.day, 22, 0),
            color: Colors.red,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: middleDate, // Viewing middle day
        );

        // Should merge into 1 event since they overlap on middle day
        expect(arranged.length, 1);
        expect(arranged[0].events.length, 2);

        // Merged event should span from 0 (workshop start) to end-of-day (workshop end on middle day)
        // Note: Marathon is 8:00-22:00, Workshop on middle day is 0:00-23:59
        // endDuration will be 0 (representing 1440/end-of-day)
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(0)); // 0 represents end-of-day (1440)
      });
    });

    group('Midnight (endTime == 0) Edge Cases', () {
      test('should treat endTime of 00:00 as end of day (1440)', () {
        final events = [
          CalendarEventData(
            title: 'Event Ending at Midnight',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 22, 0),
            endTime: DateTime(now.year, now.month, now.day, 0, 0), // midnight
            color: Colors.purple,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        expect(arranged.length, 1);
        expect(arranged[0].startDuration.getTotalMinutes, equals(22 * 60));
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(0)); // 0 represents end-of-day (1440)
      });

      test('should merge events when one ends at midnight', () {
        final events = [
          CalendarEventData(
            title: 'Event 1',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 20, 0),
            endTime: DateTime(now.year, now.month, now.day, 0, 0), // midnight
            color: Colors.purple,
          ),
          CalendarEventData(
            title: 'Event 2',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 23, 0),
            endTime: DateTime(now.year, now.month, now.day, 23, 59),
            color: Colors.orange,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now,
        );

        // Should merge because Event 1 (20:00-24:00) overlaps Event 2 (23:00-23:59)
        expect(arranged.length, 1);
        expect(arranged[0].events.length, 2);
        expect(arranged[0].startDuration.getTotalMinutes, equals(20 * 60));
        // Merged end is 1440 (end of day), which getTotalMinutes returns as 0
        expect(arranged[0].endDuration.getTotalMinutes, equals(0));
      });

      test('should handle multi-day event ending at midnight on last day', () {
        final startDate = now;
        final endDate = now.add(Duration(days: 2));

        final events = [
          CalendarEventData(
            title: '3-Day Event Ending at Midnight',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime: DateTime(startDate.year, startDate.month, startDate.day, 0,
                0), // midnight
            endDate: endDate,
            color: Colors.green,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: endDate, // Viewing last day
        );

        expect(arranged.length, 1);
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        // Multi-day event ending at midnight: endTime=0 is treated as 1440,
        // but copyFromMinutes(1440) creates 24:00 which wraps to 0:00
        expect(arranged[0].endDuration.getTotalMinutes, equals(0));
      });
    });

    group('Non-Zero startHour Tests', () {
      const startHourNonZero = 8; // Start at 8 AM
      const startHourInMinutes = startHourNonZero * 60;

      test(
          'should handle multi-day event with non-zero startHour on middle day',
          () {
        final startDate = now;
        final middleDate = now.add(Duration(days: 1));
        final endDate = now.add(Duration(days: 2));

        final events = [
          CalendarEventData(
            title: '3-Day Workshop',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime:
                DateTime(startDate.year, startDate.month, startDate.day, 17, 0),
            endDate: endDate,
            color: Colors.blue,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHourNonZero,
          calendarViewDate: middleDate,
        );

        expect(arranged.length, 1);

        // On middle day with startHour=8, visible range is 8:00-23:59
        // Multi-day event spans 0:00-23:59 on this day
        // eventStart = 0 - 480 = -480, but gets clamped to 0
        // eventEnd = 1440 - 480 = 960
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(1440 - startHourInMinutes));
      });

      test('should handle event ending at midnight with non-zero startHour',
          () {
        final events = [
          CalendarEventData(
            title: 'Event Ending at Midnight',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 22, 0),
            endTime: DateTime(now.year, now.month, now.day, 0, 0), // midnight
            color: Colors.purple,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHourNonZero,
          calendarViewDate: now,
        );

        expect(arranged.length, 1);
        // 22:00 - 8:00 = 14:00 = 840 minutes from start
        expect(arranged[0].startDuration.getTotalMinutes,
            equals(22 * 60 - startHourInMinutes));
        // midnight (1440) - 8:00 = 16:00 = 960 minutes from start
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(1440 - startHourInMinutes));
      });

      test(
          'should handle event starting before visible hours with non-zero startHour',
          () {
        final events = [
          CalendarEventData(
            title: 'Early Morning Event',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 6, 0),
            endTime: DateTime(now.year, now.month, now.day, 10, 0),
            color: Colors.yellow,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHourNonZero,
          calendarViewDate: now,
        );

        expect(arranged.length, 1);
        // Event starts at 6:00 but view starts at 8:00, so it should be clamped to 0
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        // Event ends at 10:00, which is 2 hours after startHour (8:00)
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(10 * 60 - startHourInMinutes));
      });
    });

    group('Complex Overlap Scenarios', () {
      test('should merge multiple overlapping events including multi-day', () {
        final startDate = now.subtract(Duration(days: 1));
        final endDate = now.add(Duration(days: 1));

        final events = [
          CalendarEventData(
            title: '3-Day Workshop',
            date: startDate,
            startTime:
                DateTime(startDate.year, startDate.month, startDate.day, 9, 0),
            endTime:
                DateTime(startDate.year, startDate.month, startDate.day, 17, 0),
            endDate: endDate,
            color: Colors.blue,
          ),
          CalendarEventData(
            title: 'Morning Meeting',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 10, 0),
            endTime: DateTime(now.year, now.month, now.day, 11, 0),
            color: Colors.green,
          ),
          CalendarEventData(
            title: 'Afternoon Session',
            date: now,
            startTime: DateTime(now.year, now.month, now.day, 14, 0),
            endTime: DateTime(now.year, now.month, now.day, 16, 0),
            color: Colors.red,
          ),
        ];

        final arranged = MergeEventArranger().arrange(
          events: events,
          height: height,
          width: width,
          heightPerMinute: heightPerMinute,
          startHour: startHour,
          calendarViewDate: now, // Viewing middle day of workshop
        );

        // All should merge because workshop spans full day and overlaps both events
        expect(arranged.length, 1);
        expect(arranged[0].events.length, 3);
        expect(arranged[0].startDuration.getTotalMinutes, equals(0));
        expect(arranged[0].endDuration.getTotalMinutes,
            equals(0)); // 0 represents end-of-day (1440)
      });
    });
  });
}
