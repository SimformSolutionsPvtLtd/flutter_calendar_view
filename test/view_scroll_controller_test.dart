import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adapts DayView, WeekView and MultiDayView to one interface so the same
/// scroll-controller tests run against all three. Their states share no
/// common supertype, hence the closures.
class _ViewHarness {
  const _ViewHarness({
    required this.name,
    required this.build,
    required this.controller,
    required this.next,
    required this.previous,
    required this.animateTo,
  });

  final String name;
  final Widget Function(GlobalKey key, {required bool keepScrollOffset}) build;
  final ScrollController? Function(GlobalKey key) controller;
  final void Function(GlobalKey key) next;
  final void Function(GlobalKey key) previous;
  final void Function(GlobalKey key, double offset) animateTo;
}

final _initialDay = DateTime(2026, 3, 30);
final _minDay = DateTime(2026, 1, 1);
final _maxDay = DateTime(2026, 12, 31);

final _harnesses = <_ViewHarness>[
  _ViewHarness(
    name: 'DayView',
    build: (key, {required keepScrollOffset}) => DayView(
      key: key,
      controller: EventController(),
      initialDay: _initialDay,
      minDay: _minDay,
      maxDay: _maxDay,
      heightPerMinute: 1,
      keepScrollOffset: keepScrollOffset,
    ),
    controller: (key) => (key.currentState! as DayViewState).scrollController,
    next: (key) => (key.currentState! as DayViewState).nextPage(),
    previous: (key) => (key.currentState! as DayViewState).previousPage(),
    animateTo: (key, offset) =>
        (key.currentState! as DayViewState).animateTo(offset),
  ),
  _ViewHarness(
    name: 'WeekView',
    build: (key, {required keepScrollOffset}) => WeekView(
      key: key,
      controller: EventController(),
      initialDay: _initialDay,
      minDay: _minDay,
      maxDay: _maxDay,
      heightPerMinute: 1,
      keepScrollOffset: keepScrollOffset,
    ),
    controller: (key) => (key.currentState! as WeekViewState).scrollController,
    next: (key) => (key.currentState! as WeekViewState).nextPage(),
    previous: (key) => (key.currentState! as WeekViewState).previousPage(),
    animateTo: (key, offset) =>
        (key.currentState! as WeekViewState).animateTo(offset),
  ),
  _ViewHarness(
    name: 'MultiDayView',
    build: (key, {required keepScrollOffset}) => MultiDayView(
      key: key,
      controller: EventController(),
      initialDay: _initialDay,
      minDay: _minDay,
      maxDay: _maxDay,
      heightPerMinute: 1,
      keepScrollOffset: keepScrollOffset,
    ),
    controller: (key) =>
        (key.currentState! as MultiDayViewState).scrollController,
    next: (key) => (key.currentState! as MultiDayViewState).nextPage(),
    previous: (key) => (key.currentState! as MultiDayViewState).previousPage(),
    animateTo: (key, offset) =>
        (key.currentState! as MultiDayViewState).animateTo(offset),
  ),
];

Future<void> _pumpView(
  WidgetTester tester,
  _ViewHarness harness,
  GlobalKey key, {
  required bool keepScrollOffset,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 600,
          child: harness.build(key, keepScrollOffset: keepScrollOffset),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final harness in _harnesses) {
    group('${harness.name} scrollController', () {
      testWidgets('is attached to the visible page after the first frame',
          (tester) async {
        final key = GlobalKey();
        await _pumpView(tester, harness, key, keepScrollOffset: false);

        final controller = harness.controller(key);
        expect(controller, isNotNull);
        expect(controller!.hasClients, isTrue);
      });

      testWidgets('is a different controller after a page change',
          (tester) async {
        final key = GlobalKey();
        await _pumpView(tester, harness, key, keepScrollOffset: false);
        final firstPageController = harness.controller(key);

        harness.next(key);
        await tester.pumpAndSettle();

        final secondPageController = harness.controller(key);
        expect(secondPageController, isNotNull);
        expect(secondPageController!.hasClients, isTrue);
        expect(identical(firstPageController, secondPageController), isFalse);
      });

      testWidgets('is usable while two pages are visible mid-swipe',
          (tester) async {
        final key = GlobalKey();
        await _pumpView(tester, harness, key, keepScrollOffset: false);

        // Drag in small steps so the next page is built and attached while
        // the current one is still on screen. Before the fix, every page
        // shared one controller, so reading `offset` here threw
        // "ScrollController attached to multiple scroll views".
        final gesture = await tester.startGesture(const Offset(300, 300));
        for (var i = 0; i < 5; i++) {
          await gesture.moveBy(const Offset(-30, 0));
          await tester.pump();
        }

        final controller = harness.controller(key);
        expect(controller, isNotNull);
        expect(controller!.offset, isA<double>());

        harness.animateTo(key, 300);
        await tester.pump();
        expect(tester.takeException(), isNull);

        await gesture.up();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('restores each page offset when keepScrollOffset is true',
          (tester) async {
        final key = GlobalKey();
        await _pumpView(tester, harness, key, keepScrollOffset: true);

        harness.animateTo(key, 300);
        await tester.pumpAndSettle();
        expect(harness.controller(key)!.offset, 300);

        harness.next(key);
        await tester.pumpAndSettle();
        harness.previous(key);
        await tester.pumpAndSettle();

        expect(harness.controller(key)!.offset, 300);
      });

      testWidgets('resets to the default offset when keepScrollOffset is false',
          (tester) async {
        final key = GlobalKey();
        await _pumpView(tester, harness, key, keepScrollOffset: false);

        harness.animateTo(key, 300);
        await tester.pumpAndSettle();
        expect(harness.controller(key)!.offset, 300);

        harness.next(key);
        await tester.pumpAndSettle();

        expect(harness.controller(key)!.offset, 0);
      });
    });
  }
}
