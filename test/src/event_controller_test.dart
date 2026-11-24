import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('removeWhere removes matching recurring and nonrecurring events', () {
    final controller = EventController<String>();
    addTearDown(controller.dispose);
    final date = DateTime(2026, 10, 26);
    final laterDate = DateTime(2026, 10, 27);
    final recurrenceSettings = RecurrenceSettings(
      startDate: date,
      frequency: RepeatFrequency.daily,
    );
    final removedRecurring = CalendarEventData<String>(
      title: 'Remove recurring',
      date: date,
      recurrenceSettings: recurrenceSettings,
    );
    final retainedRecurring = CalendarEventData<String>(
      title: 'Retain recurring',
      date: date,
      recurrenceSettings: recurrenceSettings,
    );
    final removedNonrecurring = CalendarEventData<String>(
      title: 'Remove nonrecurring',
      date: date,
    );
    final retainedNonrecurring = CalendarEventData<String>(
      title: 'Retain nonrecurring',
      date: date,
    );
    final events = [
      removedRecurring,
      retainedRecurring,
      removedNonrecurring,
      retainedNonrecurring,
    ];
    controller.addAll(events);

    expect(controller.allEvents, unorderedEquals(events));
    expect(controller.getEventsOnDay(date), unorderedEquals(events));
    expect(controller.getEventsOnDay(laterDate),
        unorderedEquals([removedRecurring, retainedRecurring]));

    controller.removeWhere((event) => event.title.startsWith('Remove'));

    final retainedEvents = [retainedRecurring, retainedNonrecurring];
    expect(controller.allEvents, unorderedEquals(retainedEvents));
    expect(controller.getEventsOnDay(date), unorderedEquals(retainedEvents));
    expect(controller.getEventsOnDay(laterDate),
        unorderedEquals([retainedRecurring]));
  });

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
