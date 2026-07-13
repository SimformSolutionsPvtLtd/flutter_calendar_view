import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Events ending exactly at midnight', () {
    test('shift ending at 12:00 AM does not occur on the next day', () {
      // Shift: 07/12 4:00 PM -> 07/13 12:00 AM (midnight).
      final start = DateTime(2026, 7, 12, 16, 0, 0);
      final end = DateTime(2026, 7, 13, 0, 0, 0);

      final event = CalendarEventData<Object?>(
        title: 'shift',
        date: start,
        endDate: end,
        startTime: start,
        endTime: end,
      );

      expect(event.occursOnDate(DateTime(2026, 7, 12)), isTrue);
      expect(event.occursOnDate(DateTime(2026, 7, 13)), isFalse);
      expect(event.isRangingEvent, isFalse);
      expect(event.endDate, DateTime(2026, 7, 12));
    });

    test('controller does not return midnight-ending shift on next day', () {
      final start = DateTime(2026, 7, 12, 16, 0, 0);
      final end = DateTime(2026, 7, 13, 0, 0, 0);

      final controller = EventController<Object?>();
      controller.add(CalendarEventData<Object?>(
        title: 'shift',
        date: start,
        endDate: end,
        startTime: start,
        endTime: end,
      ));

      expect(controller.getEventsOnDay(DateTime(2026, 7, 12)), hasLength(1));
      expect(controller.getEventsOnDay(DateTime(2026, 7, 13)), isEmpty);
    });

    test('genuine overnight shift still occurs on both days', () {
      // Shift: 07/12 8:00 PM -> 07/13 4:00 AM.
      final start = DateTime(2026, 7, 12, 20, 0, 0);
      final end = DateTime(2026, 7, 13, 4, 0, 0);

      final event = CalendarEventData<Object?>(
        title: 'overnight',
        date: start,
        endDate: end,
        startTime: start,
        endTime: end,
      );

      expect(event.occursOnDate(DateTime(2026, 7, 12)), isTrue);
      expect(event.occursOnDate(DateTime(2026, 7, 13)), isTrue);
      expect(event.isRangingEvent, isTrue);
    });

    test('multi-day shift ending at midnight excludes only the end day', () {
      // Shift: 07/10 4:00 PM -> 07/12 12:00 AM (midnight).
      final start = DateTime(2026, 7, 10, 16, 0, 0);
      final end = DateTime(2026, 7, 12, 0, 0, 0);

      final event = CalendarEventData<Object?>(
        title: 'long shift',
        date: start,
        endDate: end,
        startTime: start,
        endTime: end,
      );

      expect(event.occursOnDate(DateTime(2026, 7, 10)), isTrue);
      expect(event.occursOnDate(DateTime(2026, 7, 11)), isTrue);
      expect(event.occursOnDate(DateTime(2026, 7, 12)), isFalse);
    });

    test('full-day event keeps inclusive end date semantics', () {
      final event = CalendarEventData<Object?>(
        title: 'full day',
        date: DateTime(2026, 7, 12),
        endDate: DateTime(2026, 7, 13),
        startTime: DateTime(2026, 7, 12, 0, 0, 0),
        endTime: DateTime(2026, 7, 13, 0, 0, 0),
      );

      expect(event.isFullDayEvent, isTrue);
      expect(event.endDate, DateTime(2026, 7, 13));
    });

    test('date-only multi-day event keeps inclusive end date semantics', () {
      // No startTime/endTime — endDate is a plain inclusive calendar date.
      final event = CalendarEventData<Object?>(
        title: 'conference',
        date: DateTime(2026, 7, 10),
        endDate: DateTime(2026, 7, 13),
      );

      expect(event.occursOnDate(DateTime(2026, 7, 13)), isTrue);
      expect(event.endDate, DateTime(2026, 7, 13));
    });

    test('midnight end on first day of month rolls back correctly', () {
      // Shift: 07/31 4:00 PM -> 08/01 12:00 AM.
      final start = DateTime(2026, 7, 31, 16, 0, 0);
      final end = DateTime(2026, 8, 1, 0, 0, 0);

      final event = CalendarEventData<Object?>(
        title: 'month boundary shift',
        date: start,
        endDate: end,
        startTime: start,
        endTime: end,
      );

      expect(event.endDate, DateTime(2026, 7, 31));
      expect(event.occursOnDate(DateTime(2026, 8, 1)), isFalse);
    });
  });
}
