import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Page change', () {
    testWidgets(
      'WeekView updates the header without rebuilding the displayed pages',
      (tester) async {
        final monday = DateTime(2026, 3, 30);
        final controller = EventController()
          ..add(CalendarEventData(
            title: 'Event',
            date: monday,
            startTime: monday.add(const Duration(hours: 9)),
            endTime: monday.add(const Duration(hours: 10)),
          ));
        final weekViewKey = GlobalKey<WeekViewState>();
        var tileBuilds = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeekView(
                key: weekViewKey,
                controller: controller,
                initialDay: monday,
                minDay: monday,
                maxDay: monday.add(const Duration(days: 13)),
                weekPageHeaderBuilder: (startDate, _) =>
                    Text('week of ${startDate.day}.${startDate.month}'),
                eventTileBuilder: (date, events, boundary, start, end) {
                  tileBuilds++;
                  return Text(events.first.title);
                },
              ),
            ),
          ),
        );
        expect(find.text('week of 30.3'), findsOneWidget);
        final tileBuildsBefore = tileBuilds;
        expect(tileBuildsBefore, greaterThan(0));

        weekViewKey.currentState!.nextPage();
        await tester.pumpAndSettle();

        expect(find.text('week of 6.4'), findsOneWidget);
        expect(
          tileBuilds,
          tileBuildsBefore,
          reason: 'the week that was swiped away is not built again',
        );
      },
    );
  });
}
