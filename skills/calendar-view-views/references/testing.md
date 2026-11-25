# Testing calendar code

```dart
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows an event', (tester) async {
    final controller = EventController<String>()
      ..add(CalendarEventData<String>.wholeDay(
        title: 'Gym',
        date: DateTime(2026, 11, 2),
      ));

    await tester.pumpWidget(MaterialApp(
      home: CalendarControllerProvider<String>(
        controller: controller,
        child: Scaffold(
          body: MonthView<String>(
            monthViewStyle: MonthViewStyle(initialMonth: DateTime(2026, 11)),
          ),
        ),
      ),
    ));

    expect(find.text('Gym'), findsOneWidget);
  });

  test('recurrence without widgets', () {
    final controller = EventController<String>();
    expect(controller.getEventsOnDay(DateTime(2026, 11, 2)), isEmpty);
  });
}
```

- Put views under a `Scaffold` or `Material`, or they throw
  `No Material widget found`.
- Pin `initialMonth`, `initialDay` and `currentTimeProvider` so tests do not
  depend on today's date.
- Test recurrence, filters and sorting without widgets by calling
  `controller.getEventsOnDay(DateTime(...))`.
