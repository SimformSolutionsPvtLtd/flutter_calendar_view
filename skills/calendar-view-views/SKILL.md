---
name: calendar-view-views
description: >-
  Add and control calendar widgets with calendar_view: MonthView, DayView,
  WeekView, MultiDayView and ScheduleView, CalendarControllerProvider, builders
  and tap callbacks, date selection, timeline hours, zoom (heightPerMinute),
  scroll to current time, navigating with GlobalKey states, widget tests.
  Use when adding a calendar screen, writing a cellBuilder or eventTileBuilder,
  reacting to taps, jumping to a date, or fixing "No CalendarControllerProvider
  found", assertion errors or layout errors in a calendar view.
---

# calendar_view: calendar views

`MonthView`, `DayView`, `WeekView`, `MultiDayView` and `ScheduleView` show the
events of one `EventController<T>`. To create and change events, use the
`calendar-view-events` skill. For colors, headers and translations, use
`calendar-view-theming`.

## Workflow

1. **Inspect the project first.** Check whether a calendar screen,
   `EventController` or `CalendarControllerProvider` already exists, which
   state management the app uses, and the event payload type `T`.
2. **Add the dependency** if missing: `flutter pub add calendar_view`. Never
   hard-code a version.
3. **Pick the view** with the table below, wire the controller, then read the
   matching reference file for its parameters.
4. Run `flutter analyze`. Test with a widget test (`references/testing.md`).

| Need | Widget | Reference |
| --- | --- | --- |
| Month grid, no time axis | `MonthView` | `references/month-view.md` |
| One day with a time axis | `DayView` | `references/timeline-views.md` |
| A week with a time axis | `WeekView` | `references/timeline-views.md` |
| Any number of days (default 3) | `MultiDayView(daysInView: n)` | `references/timeline-views.md` |
| Scrollable agenda grouped by day and month | `ScheduleView` | `references/schedule-view.md` |

There is no year view. Build one from `getEventsOnDay` or `allEvents`.

## Rules

- **Every view needs a controller:** a `CalendarControllerProvider<T>`
  ancestor, or `controller:`. Without one it asserts.
- **One `T` everywhere:** controller, `CalendarControllerProvider<T>`, every
  view, `MonthViewBuilders<T>` and `GlobalKey<XxxViewState<T>>`. A bare
  `MonthView()` looks up `<Object?>` and throws
  `No CalendarControllerProvider<…> found`.
- **Create the controller once** (see `calendar-view-events`), never in `build()`.
- **Put `MonthView`, `DayView`, `WeekView` and `MultiDayView` under a
  `Scaffold` or `Material`.** Without one they throw `No Material widget
  found` and overflow (`ScheduleView` does not need it).
- **`MonthView` takes `monthViewStyle:`, `monthViewBuilders:` and
  `monthViewThemeSettings:`.** Day, Week and MultiDay views take flat
  arguments.
- Views rebuild on every controller change. No `setState` needed.

## Setup

```dart
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class Meeting {
  const Meeting({required this.id});
  final String id;
}

final eventController = EventController<Meeting>();

void main() => runApp(
      CalendarControllerProvider<Meeting>(
        controller: eventController,
        child: const MaterialApp(home: CalendarPage()),
      ),
    );

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MonthView<Meeting>(
          monthViewStyle: MonthViewStyle(initialMonth: DateTime.now()),
          monthViewBuilders: MonthViewBuilders<Meeting>(
            onEventTap: (event, date) => debugPrint(event.title),
          ),
        ),
      );
}
```

## Navigate and control from code

Give the view a `GlobalKey` typed with the same `T`:

```dart
final weekKey = GlobalKey<WeekViewState<Meeting>>();
final monthKey = GlobalKey<MonthViewState<Meeting>>();

// WeekView(key: weekKey, ...), MonthView(key: monthKey, ...)
weekKey.currentState?.jumpToWeek(DateTime.now());
monthKey.currentState?.animateToMonth(DateTime(2026, 12));
```

- State methods (the main ones; the month, day, week and multi-day states also
  have `jumpToPage` and `animateToPage`): `MonthViewState` has `jumpToMonth`, `animateToMonth`,
  `nextPage`, `previousPage`. `DayViewState` has `jumpToDate`, `animateToDate`,
  `jumpToEvent`, `animateToEvent`, `nextPage`, `previousPage`. `WeekViewState`
  and `MultiDayViewState` have `jumpToWeek`, `animateToWeek`, `jumpToEvent`,
  `animateToEvent`, `nextPage`, `previousPage`. `ScheduleViewState` has
  `jumpToDate`.
- Timeline views (`DayView`, `WeekView`, `MultiDayView`) also have
  `scrollToCurrentTime: true` to center the timeline on the current time at
  start, and `animateToCurrentTime()` / `jumpToCurrentTime()` on their states.
- `scrollController` on those states is nullable: it is `null` while no page is
  attached.

## Symptom to fix

| Symptom | Fix |
| --- | --- |
| `No CalendarControllerProvider<X> found` | Add the provider or `controller:`; one `T` everywhere. |
| `The named parameter 'initialMonth' isn't defined` | Move it into `MonthViewStyle`; see `references/month-view.md`. |
| `cellBuilder` type error | `CellBuilder` takes 6 arguments, including `isSelected`. |
| `onEventTap` never fires in `MonthView` | A `cellBuilder` is set; handle taps in the cell. |
| `No Material widget found` | Wrap the view in a `Scaffold` (common in tests). |
| `Height per minute must be greater than 0.` | `heightPerMinute` must be above 0. |
| `quarterHourIndicator height must be less than minuteHeight * 60` | `WeekView` and `MultiDayView` need `heightPerMinute` above `1/60` with default indicators; use `0.02` or more. |
| Another `…indicator height must be less than minuteHeight * 60` | Lower that indicator's `height` or raise `heightPerMinute`. |
| `BoxConstraints has a negative minimum height` | `startHour` must be below `endHour`. |
| Events disappear after a rebuild | Move the controller out of `build()`. |
| Locale change not visible | Rebuild after `PackageStrings.setLocale`; see `calendar-view-theming`. |
