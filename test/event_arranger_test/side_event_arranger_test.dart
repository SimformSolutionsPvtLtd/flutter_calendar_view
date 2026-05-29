import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

const height = 1440.0;
const width = 500.0;
const heightPerMinute = 1.0;
const startHour = 0;

void main() {
  final now = DateTime(2024, 1, 1);

  group('SideEventArranger multi-day rendering', () {
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

      final arrangedEvents = SideEventArranger().arrange(
        events: [overnightEvent],
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now,
      );

      expect(arrangedEvents.single.events, [overnightEvent]);
      expect(arrangedEvents.single.top, 600);
      expect(arrangedEvents.single.bottom, 0);
      expect(arrangedEvents.single.startDuration.getTotalMinutes, 600);
      expect(arrangedEvents.single.endDuration.getTotalMinutes, 0);
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

      final arrangedEvents = SideEventArranger().arrange(
        events: [overnightEvent],
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        startHour: startHour,
        calendarViewDate: now.add(Duration(days: 1)),
      );

      expect(arrangedEvents.single.events, [overnightEvent]);
      expect(arrangedEvents.single.top, 0);
      expect(arrangedEvents.single.bottom, 900);
      expect(arrangedEvents.single.startDuration.getTotalMinutes, 0);
      expect(arrangedEvents.single.endDuration.getTotalMinutes, 540);
    });
  });
}
