import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('event controller ...', (tester) async {
    final controller = EventController();

    final now = DateTime.now();
    controller.add(CalendarEventData<String>(
        title: 'none',
        date: now,
        startTime: now,
        endTime: now.add(Duration(hours: 1))));
    controller.add(CalendarEventData<String>(
      title: 'All Day',
      date: DateTime.now().withoutTime,
    ));

    expect(controller.getFullDayEvent(now).length, equals(1));
    expect(controller.getEventsOnDay(now).length, equals(2));
    expect(controller.allEvents.length, equals(2));
    controller.clear();
    expect(controller.allEvents.length, equals(0));
  });
}
