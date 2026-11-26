import 'package:calendar_view/calendar_view.dart';
import 'package:calendar_view/src/components/_internal_components.dart'
    show TimeSlotBackgrounds;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeSlotBuilder', () {
    testWidgets(
      'DayView uses minuteSlotSize for slot generation and sizes slots within bounds',
      (tester) async {
        final slotStarts = <DateTime>[];
        final slotEnds = <DateTime>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 600,
                child: DayView(
                  controller: EventController(),
                  initialDay: DateTime(2026, 3, 30),
                  minDay: DateTime(2026, 3, 30),
                  maxDay: DateTime(2026, 3, 30),
                  startHour: 9,
                  endHour: 11,
                  minuteSlotSize: MinuteSlotSize.minutes30,
                  heightPerMinute: 1,
                  timeLineWidth: 60,
                  verticalLineOffset: 0,
                  timeSlotBuilder: (
                    _,
                    slotStartTime,
                    slotEndTime,
                    index,
                  ) {
                    slotStarts.add(slotStartTime);
                    slotEnds.add(slotEndTime);
                    return index.isEven
                        ? ColoredBox(color: Colors.green.shade50)
                        : null;
                  },
                ),
              ),
            ),
          ),
        );

        final uniqueSlotStarts = slotStarts.toSet();
        final uniqueSlotEnds = slotEnds.toSet();

        expect(uniqueSlotStarts.length, 4);
        expect(uniqueSlotEnds.length, 4);
        expect(uniqueSlotStarts.contains(DateTime(2026, 3, 30, 9)), true);
        expect(uniqueSlotStarts.contains(DateTime(2026, 3, 30, 9, 30)), true);
        expect(uniqueSlotStarts.contains(DateTime(2026, 3, 30, 10)), true);
        expect(uniqueSlotStarts.contains(DateTime(2026, 3, 30, 10, 30)), true);
        expect(uniqueSlotEnds.contains(DateTime(2026, 3, 30, 11)), true);

        final background = find.byType(TimeSlotBackgrounds);
        expect(background, findsOneWidget);
        expect(tester.getSize(background).height, 120);

        // Slots 0 and 2 return a ColoredBox, each filling one 30 minute slot
        // across the content area (excluding the time line).
        final coloredSlots = find.descendant(
          of: background,
          matching: find.byType(ColoredBox),
        );
        expect(coloredSlots, findsNWidgets(2));
        for (var i = 0; i < 2; i++) {
          final size = tester.getSize(coloredSlots.at(i));
          expect(size.height, 30);
          expect(size.width, greaterThan(0));
          expect(size.width, lessThan(300));
        }

        // Slots 1 and 3 return null, so no widget is built for them.
        expect(
          find.descendant(of: background, matching: find.byType(Positioned)),
          findsNWidgets(2),
        );
      },
    );

    testWidgets(
      'DayView renders any widget returned by the builder in each slot',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 600,
                child: DayView(
                  controller: EventController(),
                  initialDay: DateTime(2026, 3, 30),
                  minDay: DateTime(2026, 3, 30),
                  maxDay: DateTime(2026, 3, 30),
                  startHour: 9,
                  endHour: 11,
                  minuteSlotSize: MinuteSlotSize.minutes30,
                  heightPerMinute: 1,
                  timeLineWidth: 60,
                  verticalLineOffset: 0,
                  timeSlotBuilder: (_, __, ___, index) =>
                      Icon(Icons.restaurant, key: ValueKey('slot-$index')),
                ),
              ),
            ),
          ),
        );

        // 2 hours / 30 minutes = 4 slots, each with its own widget.
        for (var i = 0; i < 4; i++) {
          expect(find.byKey(ValueKey('slot-$i')), findsOneWidget);
        }
        expect(
          find.descendant(
            of: find.byType(TimeSlotBackgrounds),
            matching: find.byType(Icon),
          ),
          findsNWidgets(4),
        );
      },
    );

    testWidgets(
      'WeekView uses minuteSlotSize for slot generation',
      (tester) async {
        final slotStarts = <DateTime>[];
        final slotEnds = <DateTime>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 700,
                child: WeekView(
                  controller: EventController(),
                  initialDay: DateTime(2026, 3, 30),
                  minDay: DateTime(2026, 3, 30),
                  maxDay: DateTime(2026, 3, 30),
                  showWeekends: false,
                  startHour: 9,
                  endHour: 11,
                  minuteSlotSize: MinuteSlotSize.minutes30,
                  heightPerMinute: 1,
                  timeLineWidth: 60,
                  weekTitleHeight: 0,
                  fullDayHeaderTitle: '',
                  timeSlotBuilder: (
                    _,
                    slotStartTime,
                    slotEndTime,
                    index,
                  ) {
                    slotStarts.add(slotStartTime);
                    slotEnds.add(slotEndTime);
                    return index == 0
                        ? ColoredBox(color: Colors.orange.shade100)
                        : null;
                  },
                ),
              ),
            ),
          ),
        );

        // 5 weekdays x 4 half-hour slots (9:00 to 11:00)
        final uniqueSlotStarts = slotStarts.toSet();
        final uniqueSlotEnds = slotEnds.toSet();

        expect(uniqueSlotStarts.length, 20);
        expect(uniqueSlotEnds.length, 20);
        expect(uniqueSlotStarts.contains(DateTime(2026, 3, 30, 9)), true);
        expect(uniqueSlotStarts.contains(DateTime(2026, 3, 30, 10, 30)), true);
        expect(uniqueSlotEnds.contains(DateTime(2026, 3, 30, 11)), true);
      },
    );

    testWidgets(
      'MultiDayView uses minuteSlotSize for slot generation',
      (tester) async {
        final slotStarts = <DateTime>[];
        final slotEnds = <DateTime>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 700,
                child: MultiDayView(
                  controller: EventController(),
                  daysInView: 3,
                  initialDay: DateTime(2026, 3, 30),
                  minDay: DateTime(2026, 3, 28),
                  maxDay: DateTime(2026, 4, 5),
                  weekTitleHeight: 0,
                  startHour: 9,
                  endHour: 11,
                  minuteSlotSize: MinuteSlotSize.minutes30,
                  heightPerMinute: 1,
                  timeLineWidth: 60,
                  timeSlotBuilder: (
                    _,
                    slotStartTime,
                    slotEndTime,
                    index,
                  ) {
                    slotStarts.add(slotStartTime);
                    slotEnds.add(slotEndTime);
                    return index == 0
                        ? ColoredBox(color: Colors.blue.shade50)
                        : null;
                  },
                ),
              ),
            ),
          ),
        );

        // The visible page always shows exactly 3 days, each with 4 half-hour
        // slots between 9:00 and 11:00, giving 12 unique date-time combinations.
        // We do not assert on specific calendar dates because MultiDayView aligns
        // its page boundaries relative to DateTime.now(), which would make exact
        // date checks fragile across test runs on different days.
        final uniqueSlotStarts = slotStarts.toSet();
        final uniqueSlotEnds = slotEnds.toSet();

        // 3 days × 4 slots = 12 unique (date + time) combinations.
        expect(uniqueSlotStarts.length, 12);
        expect(uniqueSlotEnds.length, 12);
        // Each of the 3 visible days must have a 9:00 start and a 10:30 start.
        expect(
          uniqueSlotStarts.where((dt) => dt.hour == 9 && dt.minute == 0).length,
          3,
        );
        expect(
          uniqueSlotStarts
              .where((dt) => dt.hour == 10 && dt.minute == 30)
              .length,
          3,
        );
        // Each day's last slot ends at 11:00.
        expect(
          uniqueSlotEnds.where((dt) => dt.hour == 11 && dt.minute == 0).length,
          3,
        );

        // Slot 0 of each visible day column returns a ColoredBox.
        expect(
          find.descendant(
            of: find.byType(TimeSlotBackgrounds),
            matching: find.byType(ColoredBox),
          ),
          findsNWidgets(3),
        );
      },
    );
  });
}
