import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('event controller ...', (tester) async {
    final controller = EventController();

    final now = DateTime.now();
    controller.add(CalendarEventData<String>(
        title: 'none',
        startDate: now,
        startTime: TimeOfDay(hour: now.hour, minute: now.minute),
        endTime: TimeOfDay(hour: (now.hour + 1) % 24, minute: now.minute)));
    controller.add(CalendarEventData<String>(
      title: 'All Day',
      startDate: now.withoutTime,
    ));

    expect(controller.getFullDayEvent(now).length, equals(1));
    expect(controller.getEventsOnDay(now).length, equals(2));
    expect(controller.allEvents.length, equals(2));
    controller.clear();
    expect(controller.allEvents.length, equals(0));
  });
}
