import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Custom sort', () {
    final date = DateTime(2024, 01, 01);
    const oneHour = Duration(hours: 1);

    /// The bool value indicates if the event is "important" or "regular".

    final first = CalendarEventData(
      title: 'Regular event - first',
      event: false,
      date: date,
      startTime: date.add(oneHour),
      endTime: date.add(oneHour * 2),
    );

    final second = CalendarEventData(
      title: 'Important event - second',
      event: true,
      date: date,
      startTime: date.add(oneHour * 2),
      endTime: date.add(oneHour * 3),
    );

    final third = CalendarEventData(
      title: 'Important event - third',
      event: true,
      date: date,
      startTime: date.add(oneHour * 3),
      endTime: date.add(oneHour * 4),
    );

    final fourth = CalendarEventData(
      title: 'Regular event - fourth',
      event: false,
      date: date,
      startTime: date.add(oneHour * 4),
      endTime: date.add(oneHour * 5),
    );

    /// Events are in random order
    final events = <CalendarEventData<bool>>[
      first,
      third,
      fourth,
      second,
    ];

    late EventController<bool> controller;

    test('Should return events in startTimeWise order', () {
      controller = EventController();
      controller.addAll(events);

      final eventsOnDay = controller.getEventsOnDay(date);

      expect(eventsOnDay[0], first);
      expect(eventsOnDay[1], second);
      expect(eventsOnDay[2], third);
      expect(eventsOnDay[3], fourth);
    });

    group('with custom sorter', () {
      test('Should return events in custom order', () {
        final sorter = (CalendarEventData<bool> a, CalendarEventData<bool> b) {
          if (a.event == true && b.event == false) {
            return -1;
          } else if (a.event == false && b.event == true) {
            return 1;
          }
          return 0;
        };

        controller = EventController(
          eventSorter: sorter,
        );
        controller.addAll(events);

        final eventsOnDay = controller.getEventsOnDay(date);

        expect(eventsOnDay[0], second);
        expect(eventsOnDay[1], third);
        expect(eventsOnDay[2], first);
        expect(eventsOnDay[3], fourth);
      });

      test('Should fallback to default sorter if custom sorter returns 0', () {
        /// Sorter that will only sort the fourth event
        final sorter = (CalendarEventData<bool> a, CalendarEventData<bool> b) {
          if (a.title == 'Regular event - fourth') {
            return -1;
          }
          if (b.title == 'Regular event - fourth') {
            return 1;
          }
          return 0;
        };

        controller = EventController(
          eventSorter: sorter,
        );
        controller.addAll(events);

        final eventsOnDay = controller.getEventsOnDay(date);

        expect(eventsOnDay[0], fourth);
        expect(eventsOnDay[1], first);
        expect(eventsOnDay[2], second);
        expect(eventsOnDay[3], third);
      });
    });
  });
}
