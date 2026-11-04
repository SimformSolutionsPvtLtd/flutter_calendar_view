import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('event controller ...', (tester) async {
    final controller = EventController();

    final now = DateTime.now();
    controller.add(CalendarEventData<String>(
        title: 'none',
        date: DateTime(now.year, now.month, now.day, now.hour, now.minute),
        endDate: DateTime(
            now.year, now.month, now.day, (now.hour + 1) % 24, now.minute)));
    controller.add(CalendarEventData<String>(
      title: 'All Day',
      date: now.withoutTime,
    ));

    expect(controller.getFullDayEvent(now).length, equals(1));
    expect(controller.getEventsOnDay(now).length, equals(2));
    expect(controller.allEvents.length, equals(2));
    controller.clear();
    expect(controller.allEvents.length, equals(0));
  });

  test('ranging events are returned for each day in the timed span', () {
    final controller = EventController<String>();
    final startDate = DateTime(2024, 1, 1);
    final endDate = startDate.add(Duration(days: 1));
    final event = CalendarEventData<String>.multiDay(
      title: 'Overnight support',
      date: DateTime(startDate.year, startDate.month, startDate.day, 10, 0),
      endDate: DateTime(endDate.year, endDate.month, endDate.day, 9, 0),
    );

    controller.add(event);

    expect(
      controller.getEventsOnDay(startDate, includeFullDayEvents: false),
      [event],
    );
    expect(
      controller.getEventsOnDay(endDate, includeFullDayEvents: false),
      [event],
    );
    expect(
      controller.getEventsOnDay(
        endDate.add(Duration(days: 1)),
        includeFullDayEvents: false,
      ),
      isEmpty,
    );
  });
}
