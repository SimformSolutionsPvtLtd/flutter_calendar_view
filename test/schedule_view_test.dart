import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Fixed "today" keeps these widget tests deterministic — DateTime.now() can
// flake around midnight or under odd test-host clocks/timezones.
final today = DateTime(2024, 6, 15);

void main() {
  group('ScheduleView sparse mode (showEmptyMonths: false)', () {
    // Builds a ScheduleView whose date range spans 20 years but whose only
    // event is a single day near "now". This is the configuration that used to
    // freeze the UI: the prefetch loop walked every empty month back to
    // [minDay] trying (and failing) to fill the viewport.
    Future<void> pumpSparseSchedule(
      WidgetTester tester, {
      required EventController controller,
      required DateTime initialDay,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              width: 400,
              child: ScheduleView(
                controller: controller,
                initialDay: initialDay,
                minDay: DateTime(initialDay.year - 10),
                maxDay: DateTime(initialDay.year + 10),
                showEmptyMonths: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('does not scan the whole min/max range when events are sparse',
        (tester) async {
      // Count how many distinct days are queried from the controller. With the
      // bug this ran into the tens of thousands (≈ 240 months × 30 days);
      // with the fix only the months around the single event are inspected.
      var queriedDays = 0;
      final controller = EventController(
        eventFilter: (date, events) {
          queriedDays++;
          return events
              .where((e) => e.date.withoutTime == date.withoutTime)
              .toList();
        },
      );
      controller.add(
        CalendarEventData(
          title: 'Lonely event',
          date: DateTime(today.year, today.month, today.day),
        ),
      );

      await pumpSparseSchedule(tester,
          controller: controller, initialDay: today);

      expect(find.text('Lonely event'), findsOneWidget);
      // A couple of months' worth of day lookups is plenty of headroom; the
      // broken implementation blew far past this.
      expect(queriedDays, lessThan(500),
          reason: 'sparse mode should not walk the entire date range');
    });

    testWidgets('reports the start once it reaches the earliest event month',
        (tester) async {
      var reachedStart = false;
      final controller = EventController()
        ..add(
          CalendarEventData(
            title: 'Lonely event',
            date: DateTime(today.year, today.month, today.day),
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              width: 400,
              child: ScheduleView(
                controller: controller,
                initialDay: today,
                minDay: DateTime(today.year - 10),
                maxDay: DateTime(today.year + 10),
                showEmptyMonths: false,
                onHasReachedStart: () => reachedStart = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The past direction is bounded to the earliest event's month, so the
      // start is reached without scrolling through a decade of empty months.
      expect(reachedStart, isTrue);
    });
  });

  group('ScheduleView dateLayout: top', () {
    testWidgets('renders the inline date header without overflow', (
      tester,
    ) async {
      final controller = EventController()
        ..add(
          CalendarEventData(
            title: 'Today event',
            date: DateTime(today.year, today.month, today.day),
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              width: 400,
              child: ScheduleView(
                controller: controller,
                initialDay: today,
                dateLayout: ScheduleDateLayout.top,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // pumpAndSettle would surface any RenderFlex overflow as a test failure.
      expect(tester.takeException(), isNull);
      expect(find.text('Today event'), findsOneWidget);
      // The top layout's default header draws a divider beneath each date.
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('applies dividerSettings to the default header divider', (
      tester,
    ) async {
      final controller = EventController()
        ..add(
          CalendarEventData(
            title: 'Today event',
            date: DateTime(today.year, today.month, today.day),
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              width: 400,
              child: ScheduleView(
                controller: controller,
                initialDay: today,
                dateLayout: ScheduleDateLayout.top,
                defaultDateHeaderDividerSettings:
                    const DividerSettings(thickness: 3, color: Colors.purple),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final divider = tester.widget<Divider>(find.byType(Divider).first);
      expect(divider.thickness, 3);
      expect(divider.color, Colors.purple);
    });

    testWidgets('passes the active layout to dayDetectorBuilder', (
      tester,
    ) async {
      final controller = EventController()
        ..add(
          CalendarEventData(
            title: 'Today event',
            date: DateTime(today.year, today.month, today.day),
          ),
        );

      final seenLayouts = <ScheduleDateLayout>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              width: 400,
              child: ScheduleView(
                controller: controller,
                initialDay: today,
                dateLayout: ScheduleDateLayout.top,
                dayDetectorBuilder: (date, events, layout) {
                  seenLayouts.add(layout);
                  return const SizedBox(height: 24);
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(seenLayouts, contains(ScheduleDateLayout.top));
      expect(seenLayouts, isNot(contains(ScheduleDateLayout.left)));
    });
  });

  group('ScheduleView dense mode (showEmptyMonths: true)', () {
    testWidgets('renders the current month and settles', (tester) async {
      final controller = EventController()
        ..add(
          CalendarEventData(
            title: 'Today event',
            date: DateTime(today.year, today.month, today.day),
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              width: 400,
              child: ScheduleView(
                controller: controller,
                initialDay: today,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Today event'), findsOneWidget);
    });
  });
}
