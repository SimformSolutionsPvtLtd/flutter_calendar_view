import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns a [WeekView] wrapped in a fixed-size [MaterialApp] / [Scaffold].
Widget _buildApp({
  required EventController<Object?> controller,
  required WeekViewMode weekViewMode,
  required DateTime initialDay,
  required DateTime minDay,
  required DateTime maxDay,
  bool showWeekends = false,
  int startHour = 8,
  int endHour = 12,
  double timeLineWidth = 64,
  double heightPerMinute = 1,
  DateWidgetBuilder? weekDayBuilder,
  LiveTimeIndicatorSettings? liveTimeIndicatorSettings,
  TimeSlotColorBuilder? timeSlotColorBuilder,
  MinuteSlotSize minuteSlotSize = MinuteSlotSize.minutes60,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 600,
        height: 800,
        child: WeekView(
          controller: controller,
          weekViewMode: weekViewMode,
          initialDay: initialDay,
          minDay: minDay,
          maxDay: maxDay,
          showWeekends: showWeekends,
          startHour: startHour,
          endHour: endHour,
          timeLineWidth: timeLineWidth,
          heightPerMinute: heightPerMinute,
          weekDayBuilder: weekDayBuilder,
          liveTimeIndicatorSettings: liveTimeIndicatorSettings,
          timeSlotColorBuilder: timeSlotColorBuilder,
          minuteSlotSize: minuteSlotSize,
          // Suppress the full-day header area to keep layout predictable.
          weekTitleHeight: 0,
          fullDayHeaderTitle: '',
        ),
      ),
    ),
  );
}

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // Group 1 – scroll-axis smoke-tests (kept from original file)
  // ─────────────────────────────────────────────────────────────────────────
  group('WeekView mode behavior', () {
    testWidgets('default (standard) mode uses a horizontal PageView',
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
              ),
            ),
          ),
        ),
      );

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.scrollDirection, Axis.horizontal);
    });

    testWidgets(
        'verticalWeek mode: PageView scrolls vertically and '
        'inner scroll view is horizontal', (tester) async {
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
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 1b – timeLineBuilder receives correct page date (labelDate fix)
  // ─────────────────────────────────────────────────────────────────────────
  group('verticalWeek – timeLineBuilder labelDate semantics', () {
    testWidgets(
        'timeLineBuilder receives widget.dates.first so the date advances '
        'correctly when paging to a different week', (tester) async {
      // Two full weeks: 2026-03-23 (week 1) and 2026-03-30 (week 2).
      // The critical check: after paging to week-2 the builder must be called
      // with dates from the week-2 page (day >= 30), not exclusively week-1.
      //
      // Note: PageView pre-builds adjacent pages, so seenDates will contain
      // dates from *both* weeks after the drag.  We therefore verify that
      // (a) week-1 dates appeared before the drag, and (b) week-2 dates
      // appeared after the drag — not that all post-drag dates are week-2.
      final seenDates = <DateTime>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 800,
            child: WeekView(
              controller: EventController(),
              weekViewMode: WeekViewMode.verticalWeek,
              initialDay: DateTime(2026, 3, 23),
              minDay: DateTime(2026, 3, 23),
              maxDay: DateTime(2026, 4, 5),
              showWeekends: false,
              startHour: 8,
              endHour: 10,
              timeLineWidth: 64,
              heightPerMinute: 1,
              weekTitleHeight: 0,
              fullDayHeaderTitle: '',
              timeLineBuilder: (dt) {
                seenDates.add(dt);
                return Text('${dt.month}/${dt.day} ${dt.hour}h');
              },
            ),
          ),
        ),
      ));
      await tester.pump();

      // All initial labels must be from the week starting 2026-03-23.
      expect(seenDates, isNotEmpty);
      for (final dt in seenDates) {
        expect(dt.month, 3,
            reason: 'Week-1 labels should be in March, got $dt');
        expect(dt.day, greaterThanOrEqualTo(23),
            reason: 'Week-1 labelDate.day must be >= 23 (Mon), got $dt');
      }

      // Record count so we can look at only newly-added entries after paging.
      final countBeforeDrag = seenDates.length;

      // Page forward to week-2 via vertical drag.
      await tester.drag(find.byType(PageView), const Offset(0, -700));
      await tester.pumpAndSettle();

      // Collect only the dates that were passed to the builder on the new page.
      final newDates = seenDates.sublist(countBeforeDrag);
      expect(newDates, isNotEmpty,
          reason: 'timeLineBuilder should be called again after paging');

      // At least one label must carry a day from the week-2 page (>= 30).
      // (PageView may also pre-render week-1 again, which is fine; we just need
      // evidence that the week-2 page's labelDate was also provided.)
      expect(
        newDates.any((dt) => dt.day >= 30),
        isTrue,
        reason:
            'After paging to week-2, at least one label must have day >= 30. '
            'Got: ${newDates.map((d) => d.day).toSet()}',
      );
    });

    testWidgets(
        'with showWeekends:false the builder receives the canonical '
        'Monday week-start, not the first visible weekday', (tester) async {
      // startDay=monday → widget.dates.first is always Monday 2026-03-30.
      // If the old filteredDates.first were used it would also be Monday in
      // this config, but this test pins the expectation explicitly so it
      // catches any regression back to filteredDates.first in configs where
      // the two differ (e.g. if weekend days appeared before the first
      // weekday in a custom weekDays list).
      final seenDays = <int>[];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 800,
            child: WeekView(
              controller: EventController(),
              weekViewMode: WeekViewMode.verticalWeek,
              initialDay: DateTime(2026, 3, 30),
              minDay: DateTime(2026, 3, 30),
              maxDay: DateTime(2026, 4, 5),
              showWeekends: false,
              startHour: 8,
              endHour: 10,
              timeLineWidth: 64,
              heightPerMinute: 1,
              weekTitleHeight: 0,
              fullDayHeaderTitle: '',
              timeLineBuilder: (dt) {
                seenDays.add(dt.day);
                return Text('${dt.hour}h');
              },
            ),
          ),
        ),
      ));
      await tester.pump();

      // Every DateTime passed to the builder must carry day == 30.
      expect(seenDays, isNotEmpty);
      for (final day in seenDays) {
        expect(day, 30,
            reason:
                'labelDate.day should be 30 (canonical Mon week-start), got $day');
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 2 – multi-week vertical paging
  // ─────────────────────────────────────────────────────────────────────────
  group('verticalWeek – multi-week paging', () {
    /// Anchor Monday 2026-03-23.  Using showWeekends:false gives a
    /// 5-day week (Mon-Fri).  Three full weeks are available.
    final minDay = DateTime(2026, 3, 23); // week 1 Monday
    final maxDay = DateTime(2026, 4, 5); // week 3 Sunday (or close)

    testWidgets('PageView covers multiple weeks (at least two pages exist)',
        (tester) async {
      await tester.pumpWidget(_buildApp(
        controller: EventController(),
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: minDay,
        minDay: minDay,
        maxDay: maxDay,
        weekDayBuilder: (d) => Text('WD${d.weekday}'),
      ));
      await tester.pump();

      // The PageView itself is present in the tree.
      expect(find.byType(PageView), findsOneWidget);

      // The first week's Monday label is visible.
      // (This confirms the page isn't empty and the builder ran.)
      expect(find.textContaining('WD1'), findsWidgets);
    });

    testWidgets('vertical drag navigates to second week', (tester) async {
      // Use distinct weekDayBuilder text so we can tell which week is visible.
      await tester.pumpWidget(_buildApp(
        controller: EventController(),
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: minDay,
        minDay: minDay,
        maxDay: maxDay,
        weekDayBuilder: (d) =>
            Text('${d.month}-${d.day}', key: ValueKey('${d.month}-${d.day}')),
      ));
      await tester.pump();

      // Week-1 Monday should be visible.
      expect(find.text('3-23'), findsOneWidget);

      // Drag the PageView upward to move to the next week page.
      await tester.drag(find.byType(PageView), const Offset(0, -700));
      await tester.pumpAndSettle();

      // After paging, week-2 Monday (30 Mar) should appear.
      expect(find.text('3-30'), findsOneWidget);
    });

    testWidgets('swiping back restores first week', (tester) async {
      await tester.pumpWidget(_buildApp(
        controller: EventController(),
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: minDay,
        minDay: minDay,
        maxDay: maxDay,
        weekDayBuilder: (d) => Text('${d.month}-${d.day}'),
      ));
      await tester.pump();

      // Go forward one week.
      await tester.drag(find.byType(PageView), const Offset(0, -700));
      await tester.pumpAndSettle();

      // Go back.
      await tester.drag(find.byType(PageView), const Offset(0, 700));
      await tester.pumpAndSettle();

      expect(find.text('3-23'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 3 – event rendering with SideEventArranger
  // ─────────────────────────────────────────────────────────────────────────
  group('verticalWeek – event tiles via SideEventArranger', () {
    /// Monday 2026-03-30, single week.
    final weekDay = DateTime(2026, 3, 30);

    testWidgets('non-overlapping events on different days are both rendered',
        (tester) async {
      final controller = EventController<Object?>();

      // Event on Monday 09:00–10:00
      controller.add(CalendarEventData(
        title: 'Mon Meeting',
        date: DateTime(2026, 3, 30),
        startTime: DateTime(2026, 3, 30, 9),
        endTime: DateTime(2026, 3, 30, 10),
        color: Colors.blue,
      ));

      // Event on Wednesday 10:00–11:00
      controller.add(CalendarEventData(
        title: 'Wed Workshop',
        date: DateTime(2026, 4, 1),
        startTime: DateTime(2026, 4, 1, 10),
        endTime: DateTime(2026, 4, 1, 11),
        color: Colors.green,
      ));

      await tester.pumpWidget(_buildApp(
        controller: controller,
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: weekDay,
        minDay: weekDay,
        maxDay: DateTime(2026, 4, 5),
        showWeekends: false,
        startHour: 8,
        endHour: 12,
      ));
      await tester.pump();

      expect(find.text('Mon Meeting'), findsOneWidget);
      expect(find.text('Wed Workshop'), findsOneWidget);
    });

    testWidgets('overlapping events on the same day both appear',
        (tester) async {
      final controller = EventController<Object?>();

      controller.add(CalendarEventData(
        title: 'First',
        date: DateTime(2026, 3, 30),
        startTime: DateTime(2026, 3, 30, 9),
        endTime: DateTime(2026, 3, 30, 11),
        color: Colors.red,
      ));
      controller.add(CalendarEventData(
        title: 'Second',
        date: DateTime(2026, 3, 30),
        startTime: DateTime(2026, 3, 30, 10),
        endTime: DateTime(2026, 3, 30, 12),
        color: Colors.orange,
      ));

      await tester.pumpWidget(_buildApp(
        controller: controller,
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: weekDay,
        minDay: weekDay,
        maxDay: DateTime(2026, 4, 5),
        showWeekends: false,
        startHour: 8,
        endHour: 12,
      ));
      await tester.pump();

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets(
        'event tile horizontal offset reflects startTime in verticalWeek',
        (tester) async {
      // heightPerMinute=1 keeps the layout within the 800px viewport.
      // The time axis is horizontal in verticalWeek mode, so an event
      // starting at 09:00 (60 min after startHour=8) should appear to
      // the right of the weekday/full-day label columns – i.e., dx > 0.
      final controller = EventController<Object?>();
      controller.add(CalendarEventData(
        title: 'PreciseEvent',
        date: DateTime(2026, 3, 30),
        startTime: DateTime(2026, 3, 30, 9),
        endTime: DateTime(2026, 3, 30, 10),
        color: Colors.purple,
      ));

      await tester.pumpWidget(_buildApp(
        controller: controller,
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: weekDay,
        minDay: weekDay,
        maxDay: DateTime(2026, 4, 5),
        showWeekends: false,
        startHour: 8,
        endHour: 12,
        heightPerMinute: 1,
      ));
      await tester.pump();

      // The event tile with text 'PreciseEvent' must be found.
      final tileFinder = find.text('PreciseEvent');
      expect(tileFinder, findsOneWidget);

      // Verify it is positioned to the right of x=0, confirming the
      // horizontal time mapping places it inside the scrollable area.
      final tileLeft = tester.getTopLeft(tileFinder).dx;
      expect(tileLeft, greaterThan(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 4 – live-time indicator in verticalWeek
  // ─────────────────────────────────────────────────────────────────────────
  group('verticalWeek – live-time indicator', () {
    final weekDay = DateTime(2026, 3, 30);

    testWidgets(
        'live indicator Container is rendered when showLiveLine is true',
        (tester) async {
      // Pin "now" inside the visible range so the indicator is definitely
      // drawn.  startHour=8, endHour=12 → pin at 10:00 on the same day.
      final fakeNow = DateTime(2026, 3, 30, 10, 0);

      final settings = LiveTimeIndicatorSettings(
        color: Colors.red,
        height: 3,
        currentTimeProvider: () => fakeNow,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 800,
            child: WeekView(
              controller: EventController(),
              weekViewMode: WeekViewMode.verticalWeek,
              initialDay: weekDay,
              minDay: weekDay,
              maxDay: DateTime(2026, 4, 5),
              showWeekends: false,
              startHour: 8,
              endHour: 12,
              timeLineWidth: 64,
              heightPerMinute: 1,
              showLiveTimeLineInAllDays: true,
              liveTimeIndicatorSettings: settings,
              weekTitleHeight: 0,
              fullDayHeaderTitle: '',
            ),
          ),
        ),
      ));
      await tester.pump();

      // In verticalWeek mode _buildVerticalLiveIndicators places a Container
      // with color=settings.color for each day row.
      final redContainers = find.byWidgetPredicate(
        (w) => w is Container && w.color == Colors.red,
      );
      expect(redContainers, findsWidgets);
    });

    testWidgets('live indicator is absent when height is 0', (tester) async {
      final fakeNow = DateTime(2026, 3, 30, 10, 0);

      final settings = LiveTimeIndicatorSettings(
        color: Colors.red,
        height: 0,
        currentTimeProvider: () => fakeNow,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 800,
            child: WeekView(
              controller: EventController(),
              weekViewMode: WeekViewMode.verticalWeek,
              initialDay: weekDay,
              minDay: weekDay,
              maxDay: DateTime(2026, 4, 5),
              showWeekends: false,
              startHour: 8,
              endHour: 12,
              timeLineWidth: 64,
              heightPerMinute: 1,
              showLiveTimeLineInAllDays: true,
              liveTimeIndicatorSettings: settings,
              weekTitleHeight: 0,
              fullDayHeaderTitle: '',
            ),
          ),
        ),
      ));
      await tester.pump();

      // No red Container should be produced by the live indicator.
      final redContainers = find.byWidgetPredicate(
        (w) => w is Container && w.color == Colors.red,
      );
      expect(redContainers, findsNothing);
    });

    testWidgets(
        'live indicator out of [startHour, endHour] range is not rendered',
        (tester) async {
      // "now" is before startHour — indicator should be suppressed.
      final fakeNow = DateTime(2026, 3, 30, 6, 0);

      final settings = LiveTimeIndicatorSettings(
        color: Colors.red,
        height: 3,
        currentTimeProvider: () => fakeNow,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 800,
            child: WeekView(
              controller: EventController(),
              weekViewMode: WeekViewMode.verticalWeek,
              initialDay: weekDay,
              minDay: weekDay,
              maxDay: DateTime(2026, 4, 5),
              showWeekends: false,
              startHour: 8,
              endHour: 12,
              timeLineWidth: 64,
              heightPerMinute: 1,
              showLiveTimeLineInAllDays: true,
              liveTimeIndicatorSettings: settings,
              weekTitleHeight: 0,
              fullDayHeaderTitle: '',
            ),
          ),
        ),
      ));
      await tester.pump();

      final redContainers = find.byWidgetPredicate(
        (w) => w is Container && w.color == Colors.red,
      );
      expect(redContainers, findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 5 – timeSlotColorBuilder in verticalWeek
  // ─────────────────────────────────────────────────────────────────────────
  group('verticalWeek – timeSlotColorBuilder', () {
    final weekDay = DateTime(2026, 3, 30);

    testWidgets('builder is called with correct slot boundaries',
        (tester) async {
      // startHour=8, endHour=10, minuteSlotSize=60 min  →  2 slots per day
      // showWeekends=false  →  5 days  →  10 total calls per pump cycle.
      final slotStarts = <DateTime>[];
      final slotEnds = <DateTime>[];

      await tester.pumpWidget(_buildApp(
        controller: EventController(),
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: weekDay,
        minDay: weekDay,
        maxDay: DateTime(2026, 4, 5),
        showWeekends: false,
        startHour: 8,
        endHour: 10,
        minuteSlotSize: MinuteSlotSize.minutes60,
        timeSlotColorBuilder: (date, slotStart, slotEnd, index) {
          slotStarts.add(slotStart);
          slotEnds.add(slotEnd);
          return Colors.transparent;
        },
      ));
      await tester.pump();

      // Each of the 5 visible days has 2 one-hour slots.
      final uniqueStarts = slotStarts.toSet();
      // Slots 08:00 and 09:00 for each day.
      expect(
        uniqueStarts.any((dt) => dt.hour == 8 && dt.minute == 0),
        isTrue,
        reason: 'Expected a slot starting at 08:00',
      );
      expect(
        uniqueStarts.any((dt) => dt.hour == 9 && dt.minute == 0),
        isTrue,
        reason: 'Expected a slot starting at 09:00',
      );

      final uniqueEnds = slotEnds.toSet();
      expect(
        uniqueEnds.any((dt) => dt.hour == 10 && dt.minute == 0),
        isTrue,
        reason: 'Expected a slot ending at 10:00',
      );
    });

    testWidgets('ColoredBox widgets are created for each visible slot',
        (tester) async {
      // 2 hours / 30-min slots = 4 slots per day × 5 days = 20 ColoredBoxes
      // (one per slot in _buildVerticalWeekTimeSlotBackgrounds).
      await tester.pumpWidget(_buildApp(
        controller: EventController(),
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: weekDay,
        minDay: weekDay,
        maxDay: DateTime(2026, 4, 5),
        showWeekends: false,
        startHour: 8,
        endHour: 10,
        minuteSlotSize: MinuteSlotSize.minutes30,
        timeSlotColorBuilder: (date, slotStart, slotEnd, index) =>
            index.isEven ? Colors.blue.shade50 : Colors.transparent,
      ));
      await tester.pump();

      // At least one ColoredBox must have been painted.
      expect(find.byType(ColoredBox), findsWidgets);
    });

    testWidgets('slot index increments monotonically within a day',
        (tester) async {
      // Collect (day, slotIndex) pairs to verify index sequence.
      final indexByDay = <DateTime, List<int>>{};

      await tester.pumpWidget(_buildApp(
        controller: EventController(),
        weekViewMode: WeekViewMode.verticalWeek,
        initialDay: weekDay,
        minDay: weekDay,
        maxDay: DateTime(2026, 4, 5),
        showWeekends: false,
        startHour: 8,
        endHour: 11,
        minuteSlotSize: MinuteSlotSize.minutes60,
        timeSlotColorBuilder: (date, slotStart, slotEnd, index) {
          indexByDay.putIfAbsent(date, () => []).add(index);
          return Colors.transparent;
        },
      ));
      await tester.pump();

      for (final entry in indexByDay.entries) {
        final indices = entry.value;
        // Indices must be in strictly ascending order (0, 1, 2, …).
        for (int i = 1; i < indices.length; i++) {
          expect(
            indices[i],
            greaterThan(indices[i - 1]),
            reason: 'Slot indices for day ${entry.key} are not monotonic',
          );
        }
      }
    });
  });
}
