import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A fixed "now" on an old date. Using a date outside the visible page range
  // keeps the live-time indicator (and its periodic timer) from mounting, while
  // still driving the time-of-day used for the auto-scroll math.
  DateTime fixedNow(int hour, [int minute = 0]) =>
      DateTime(2020, 1, 1, hour, minute);

  // Single visible day so exactly one page (and one scroll position) attaches.
  final visibleDay = DateTime(2026, 3, 30);

  Future<DayViewState> pumpDayView(
    WidgetTester tester, {
    required DateTime Function()? now,
    bool scrollToCurrentTime = false,
    double heightPerMinute = 1,
    int startHour = 0,
    int endHour = 24,
    double height = 600,
  }) async {
    final key = GlobalKey<DayViewState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: height,
            child: DayView(
              key: key,
              controller: EventController(),
              initialDay: visibleDay,
              minDay: visibleDay,
              maxDay: visibleDay,
              heightPerMinute: heightPerMinute,
              startHour: startHour,
              endHour: endHour,
              timeLineWidth: 60,
              verticalLineOffset: 0,
              scrollToCurrentTime: scrollToCurrentTime,
              liveTimeIndicatorSettings:
                  LiveTimeIndicatorSettings(currentTimeProvider: now),
            ),
          ),
        ),
      ),
    );
    // Let the post-frame auto-scroll (and any retry) run.
    await tester.pump();
    await tester.pump();
    return key.currentState!;
  }

  Future<WeekViewState> pumpWeekView(
    WidgetTester tester, {
    required DateTime Function()? now,
    bool scrollToCurrentTime = false,
    double heightPerMinute = 1,
  }) async {
    final key = GlobalKey<WeekViewState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 700,
            child: WeekView(
              key: key,
              controller: EventController(),
              initialDay: visibleDay,
              minDay: visibleDay,
              maxDay: visibleDay,
              heightPerMinute: heightPerMinute,
              timeLineWidth: 60,
              weekTitleHeight: 0,
              scrollToCurrentTime: scrollToCurrentTime,
              liveTimeIndicatorSettings:
                  LiveTimeIndicatorSettings(currentTimeProvider: now),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return key.currentState!;
  }

  Future<MultiDayViewState> pumpMultiDayView(
    WidgetTester tester, {
    required DateTime Function()? now,
    bool scrollToCurrentTime = false,
    double heightPerMinute = 1,
  }) async {
    final key = GlobalKey<MultiDayViewState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 700,
            child: MultiDayView(
              key: key,
              controller: EventController(),
              daysInView: 3,
              initialDay: visibleDay,
              minDay: visibleDay,
              maxDay: visibleDay,
              heightPerMinute: heightPerMinute,
              timeLineWidth: 60,
              weekTitleHeight: 0,
              scrollToCurrentTime: scrollToCurrentTime,
              liveTimeIndicatorSettings:
                  LiveTimeIndicatorSettings(currentTimeProvider: now),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return key.currentState!;
  }

  double centeredExpectation(ScrollPosition position, double topOffset) =>
      (topOffset - position.viewportDimension / 2)
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();

  group('scrollToCurrentTime - DayView', () {
    testWidgets('auto-centers the current time on first build', (tester) async {
      final state = await pumpDayView(
        tester,
        now: () => fixedNow(12),
        scrollToCurrentTime: true,
      );

      final position = state.scrollController.position;
      // 12:00 => 720px from the top of a 1px/min timeline.
      expect(state.scrollController.offset,
          closeTo(centeredExpectation(position, 720), 0.5));
    });

    testWidgets('does not auto-scroll when the flag is false', (tester) async {
      final state = await pumpDayView(tester, now: () => fixedNow(12));

      // Default initial offset (no scrollOffset/startDuration) is the top.
      expect(state.scrollController.offset, 0);
    });

    testWidgets('jumpToCurrentTime(center: false) aligns time to the top',
        (tester) async {
      final state = await pumpDayView(tester, now: () => fixedNow(12));

      state.jumpToCurrentTime(center: false);
      await tester.pump();

      // Top-aligned 12:00 => 720px, well within the scroll range.
      expect(state.scrollController.offset, closeTo(720, 0.5));
    });

    testWidgets('animateToCurrentTime centers after the animation settles',
        (tester) async {
      final state = await pumpDayView(tester, now: () => fixedNow(12));
      expect(state.scrollController.offset, 0);

      // ignore: unawaited_futures
      state.animateToCurrentTime();
      // Drive the animation past its default 200ms duration.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      final position = state.scrollController.position;
      expect(state.scrollController.offset,
          closeTo(centeredExpectation(position, 720), 0.5));
    });

    testWidgets('falls back to DateTime.now() when no currentTimeProvider',
        (tester) async {
      final state = await pumpDayView(
        tester,
        now: null,
        scrollToCurrentTime: true,
      );

      // Read currentTime after the build so it exercises the same DateTime.now()
      // fallback the widget used; this keeps the drift window minimal instead of
      // snapshotting the clock before the post-frame scroll math runs.
      final now = state.currentTime;
      final position = state.scrollController.position;
      // offsetForTime only depends on hour/minute; 1px/min so a minute rollover
      // between the widget's read and this one is at most ~1px of drift.
      final topOffset = (now.hour * 60 + now.minute).toDouble();
      expect(state.scrollController.offset,
          closeTo(centeredExpectation(position, topOffset), 1.5));
    });

    testWidgets('clamps to the top for early-morning times', (tester) async {
      final state = await pumpDayView(
        tester,
        now: () => fixedNow(0, 5),
        scrollToCurrentTime: true,
      );

      // 00:05 centered would be negative, so it clamps to the start.
      expect(state.scrollController.offset, 0);
    });

    testWidgets('clamps to the bottom for late-night times', (tester) async {
      final state = await pumpDayView(
        tester,
        now: () => fixedNow(23, 55),
        scrollToCurrentTime: true,
      );

      final position = state.scrollController.position;
      expect(state.scrollController.offset, position.maxScrollExtent);
    });

    testWidgets('honors startHour when computing the offset', (tester) async {
      // startHour 8 => 14:00 is 360 minutes into the visible range.
      // With 2px/min that is 720px; without the startHour shift it would be
      // 1680px (and clamp to the bottom), so this distinguishes the two.
      final state = await pumpDayView(
        tester,
        now: () => fixedNow(14),
        heightPerMinute: 2,
        startHour: 8,
        endHour: 20,
      );

      state.jumpToCurrentTime(center: false);
      await tester.pump();

      expect(state.scrollController.offset, closeTo(720, 0.5));
    });
  });

  group('scrollToCurrentTime - WeekView', () {
    testWidgets('auto-centers the current time on first build', (tester) async {
      final state = await pumpWeekView(
        tester,
        now: () => fixedNow(12),
        scrollToCurrentTime: true,
      );

      final position = state.scrollController.position;
      expect(state.scrollController.offset,
          closeTo(centeredExpectation(position, 720), 0.5));
    });

    testWidgets('does not auto-scroll when the flag is false', (tester) async {
      final state = await pumpWeekView(tester, now: () => fixedNow(12));

      expect(state.scrollController.offset, 0);
    });

    testWidgets('jumpToCurrentTime(center: false) aligns time to the top',
        (tester) async {
      final state = await pumpWeekView(tester, now: () => fixedNow(12));

      state.jumpToCurrentTime(center: false);
      await tester.pump();

      expect(state.scrollController.offset, closeTo(720, 0.5));
    });
  });

  group('scrollToCurrentTime - MultiDayView', () {
    testWidgets('auto-centers the current time on first build', (tester) async {
      final state = await pumpMultiDayView(
        tester,
        now: () => fixedNow(12),
        scrollToCurrentTime: true,
      );

      final position = state.scrollController.position;
      expect(state.scrollController.offset,
          closeTo(centeredExpectation(position, 720), 0.5));
    });

    testWidgets('does not auto-scroll when the flag is false', (tester) async {
      final state = await pumpMultiDayView(tester, now: () => fixedNow(12));

      expect(state.scrollController.offset, 0);
    });

    testWidgets('jumpToCurrentTime(center: false) aligns time to the top',
        (tester) async {
      final state = await pumpMultiDayView(tester, now: () => fixedNow(12));

      state.jumpToCurrentTime(center: false);
      await tester.pump();

      expect(state.scrollController.offset, closeTo(720, 0.5));
    });
  });
}
