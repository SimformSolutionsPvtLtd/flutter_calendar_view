import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeekView mode behavior', () {
    testWidgets('default mode keeps horizontal week paging', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 640,
              child: WeekView(
                controller: EventController(),
                initialDay: DateTime(2026, 3, 30),
                minDay: DateTime(2026, 3, 30),
                maxDay: DateTime(2026, 3, 30),
              ),
            ),
          ),
        ),
      );

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.scrollDirection, Axis.horizontal);
    });

    testWidgets(
        'verticalWeek mode uses vertical week pages and horizontal hours',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 640,
              child: WeekView(
                controller: EventController(),
                initialDay: DateTime(2026, 3, 30),
                minDay: DateTime(2026, 3, 30),
                maxDay: DateTime(2026, 3, 30),
                weekViewMode: WeekViewMode.verticalWeek,
                showWeekends: false,
                startHour: 8,
                endHour: 12,
                timeLineWidth: 64,
                weekDayBuilder: (date) => Text('Day ${date.weekday}'),
              ),
            ),
          ),
        ),
      );

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.scrollDirection, Axis.vertical);

      final horizontalScrollViewFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      );
      expect(horizontalScrollViewFinder, findsOneWidget);

      expect(find.text('Day 1'), findsOneWidget);
      await tester.drag(horizontalScrollViewFinder, const Offset(-120, 0));
      await tester.pumpAndSettle();
      expect(find.text('Day 1'), findsOneWidget);
    });
  });
}
