import 'package:calendar_view/calendar_view.dart';
import 'package:calendar_view/src/painters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeSlotColorBuilder', () {
    testWidgets(
      'DayView uses minuteSlotSize for slot generation and paints within bounds',
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
                  timeSlotColorBuilder: (
                    _,
                    slotStartTime,
                    slotEndTime,
                    index,
                  ) {
                    slotStarts.add(slotStartTime);
                    slotEnds.add(slotEndTime);
                    return index.isEven
                        ? Colors.green.shade50
                        : const Color.fromARGB(0, 255, 0, 0);
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

        final dayPainter = find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter is TimeSlotBackgroundPainter,
        );

        expect(dayPainter, findsOneWidget);
        final paintSize = tester.getSize(dayPainter);
        expect(paintSize.width, greaterThan(0));
        expect(paintSize.width, lessThan(300));
        expect(paintSize.height, 120);
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
                  timeSlotColorBuilder: (
                    _,
                    slotStartTime,
                    slotEndTime,
                    index,
                  ) {
                    slotStarts.add(slotStartTime);
                    slotEnds.add(slotEndTime);
                    return index == 0
                        ? Colors.orange.shade100
                        : Colors.transparent;
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
                  timeSlotColorBuilder: (
                    _,
                    slotStartTime,
                    slotEndTime,
                    index,
                  ) {
                    slotStarts.add(slotStartTime);
                    slotEnds.add(slotEndTime);
                    return index == 0
                        ? Colors.blue.shade50
                        : Colors.transparent;
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

        final painters = find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter is TimeSlotBackgroundPainter,
        );
        // One painter per visible day column.
        expect(painters, findsNWidgets(3));
      },
    );
  });
}
