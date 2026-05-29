import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

const height = 1440.0;
const width = 500.0;
const heightPerMinute = 1.0;
const startHour = 0;

/// Helper: arrange events with default settings.
List<OrganizedCalendarEventData> _arrange(
  List<CalendarEventData> events, {
  double? maxWidth,
  bool includeEdges = false,
  DateTime? calendarViewDate,
}) {
  final date = calendarViewDate ?? DateTime(2024, 1, 1);
  return SideEventArranger(
    maxWidth: maxWidth,
    includeEdges: includeEdges,
  ).arrange(
    events: events,
    height: height,
    width: width,
    heightPerMinute: heightPerMinute,
    startHour: startHour,
    calendarViewDate: date,
  );
}

void main() {
  final date = DateTime(2024, 1, 1);

  group('SideEventArranger overlap', () {
    group('two overlapping events', () {
      test('each gets half the available width', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'A',
            date: DateTime(date.year, date.month, date.day, 9, 0),
            endDate: DateTime(date.year, date.month, date.day, 11, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'B',
            date: DateTime(date.year, date.month, date.day, 10, 0),
            endDate: DateTime(date.year, date.month, date.day, 12, 0),
          ),
        ];

        final arranged = _arrange(events, calendarViewDate: date);

        expect(arranged.length, 2);
        // Each event's visual width (= totalWidth - left - right) must be half.
        for (final e in arranged) {
          expect(width - e.left - e.right, closeTo(width / 2, 0.01));
        }
        // They must not overlap horizontally.
        final leftSlot = arranged.firstWhere((e) => e.left == 0);
        final rightSlot = arranged.firstWhere((e) => e.left > 0);
        // The right edge of the left slot == left edge of the right slot.
        expect(leftSlot.left + (width / 2), closeTo(rightSlot.left, 0.01));
      });

      test('non-overlapping events take the full width', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'Morning',
            date: DateTime(date.year, date.month, date.day, 8, 0),
            endDate: DateTime(date.year, date.month, date.day, 10, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'Afternoon',
            date: DateTime(date.year, date.month, date.day, 12, 0),
            endDate: DateTime(date.year, date.month, date.day, 14, 0),
          ),
        ];

        final arranged = _arrange(events, calendarViewDate: date);

        expect(arranged.length, 2);
        for (final e in arranged) {
          expect(e.left, 0);
          expect(e.right, 0);
        }
      });
    });

    group('three overlapping events', () {
      test('each gets one third of the available width', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'A',
            date: DateTime(date.year, date.month, date.day, 9, 0),
            endDate: DateTime(date.year, date.month, date.day, 12, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'B',
            date: DateTime(date.year, date.month, date.day, 10, 0),
            endDate: DateTime(date.year, date.month, date.day, 13, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'C',
            date: DateTime(date.year, date.month, date.day, 11, 0),
            endDate: DateTime(date.year, date.month, date.day, 14, 0),
          ),
        ];

        final arranged = _arrange(events, calendarViewDate: date);

        expect(arranged.length, 3);
        final slotWidth = width / 3;
        for (final e in arranged) {
          expect(width - e.left - e.right, closeTo(slotWidth, 0.01));
        }
      });
    });

    group('includeEdges', () {
      test('edge-touching events treated as NOT overlapping by default', () {
        // Event A ends exactly when Event B starts.
        final events = [
          CalendarEventData.timeRanged(
            title: 'A',
            date: DateTime(date.year, date.month, date.day, 9, 0),
            endDate: DateTime(date.year, date.month, date.day, 10, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'B',
            date: DateTime(date.year, date.month, date.day, 10, 0),
            endDate: DateTime(date.year, date.month, date.day, 11, 0),
          ),
        ];

        final arranged = _arrange(
          events,
          includeEdges: false,
          calendarViewDate: date,
        );

        // With includeEdges: false, edge-touching events are independent.
        expect(arranged.length, 2);
        for (final e in arranged) {
          expect(e.left, 0);
          expect(e.right, 0);
        }
      });

      test('edge-touching events ARE side-by-side when includeEdges is true',
          () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'A',
            date: DateTime(date.year, date.month, date.day, 9, 0),
            endDate: DateTime(date.year, date.month, date.day, 10, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'B',
            date: DateTime(date.year, date.month, date.day, 10, 0),
            endDate: DateTime(date.year, date.month, date.day, 11, 0),
          ),
        ];

        final arranged = _arrange(
          events,
          includeEdges: true,
          calendarViewDate: date,
        );

        // With includeEdges: true, edge-touching events are placed side by side.
        expect(arranged.length, 2);
        for (final e in arranged) {
          expect(width - e.left - e.right, closeTo(width / 2, 0.01));
        }
      });
    });

    group('maxWidth', () {
      test('slot width is capped at maxWidth when space is available', () {
        final events = [
          CalendarEventData.timeRanged(
            title: 'Solo',
            date: DateTime(date.year, date.month, date.day, 9, 0),
            endDate: DateTime(date.year, date.month, date.day, 10, 0),
          ),
        ];

        const cap = 200.0;
        final arranged = _arrange(
          events,
          maxWidth: cap,
          calendarViewDate: date,
        );

        expect(arranged.length, 1);
        final slotWidth = width - arranged.first.right - arranged.first.left;
        expect(slotWidth, closeTo(cap, 0.01));
      });

      test('slot width falls below maxWidth when columns force a smaller size',
          () {
        // Two overlapping events: each would normally get width/2 = 250.
        // With maxWidth: 100, they are forced to 250 anyway because that is
        // less than the cap… actually 250 > 100, so maxWidth wins at 100.
        final events = [
          CalendarEventData.timeRanged(
            title: 'A',
            date: DateTime(date.year, date.month, date.day, 9, 0),
            endDate: DateTime(date.year, date.month, date.day, 11, 0),
          ),
          CalendarEventData.timeRanged(
            title: 'B',
            date: DateTime(date.year, date.month, date.day, 10, 0),
            endDate: DateTime(date.year, date.month, date.day, 12, 0),
          ),
        ];

        const cap = 100.0;
        final arranged = _arrange(
          events,
          maxWidth: cap,
          calendarViewDate: date,
        );

        expect(arranged.length, 2);
        for (final e in arranged) {
          final slotWidth = width - e.right - e.left;
          expect(slotWidth, lessThanOrEqualTo(cap + 0.01));
        }
      });
    });

    group('vertical positioning', () {
      test('top equals startMinutes * heightPerMinute', () {
        final event = CalendarEventData.timeRanged(
          title: 'E',
          date: DateTime(date.year, date.month, date.day, 2, 30),
          endDate: DateTime(date.year, date.month, date.day, 3, 0),
        );

        final arranged = _arrange([event], calendarViewDate: date);

        expect(arranged.length, 1);
        expect(arranged.first.top, closeTo(2 * 60 + 30, 0.01));
      });

      test('bottom reflects height minus endMinutes * heightPerMinute', () {
        final event = CalendarEventData.timeRanged(
          title: 'E',
          date: DateTime(date.year, date.month, date.day, 1, 0),
          endDate: DateTime(date.year, date.month, date.day, 4, 0),
        );

        final arranged = _arrange([event], calendarViewDate: date);

        expect(arranged.length, 1);
        expect(arranged.first.bottom, closeTo(height - 4 * 60, 0.01));
      });
    });
  });
}
