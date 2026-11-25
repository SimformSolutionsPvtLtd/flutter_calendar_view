---
name: calendar-view-migration
description: >-
  Migrate an app from calendar_view 2.0.0 to 3.x: CalendarEventData without
  startTime/endTime arguments, RecurrenceSettings.weekdays as List<WeekDays>,
  TimeOfDay in EventTileBuilder, the 6-argument CellBuilder, removed
  backgroundColor and renamed theme fields, nullable scrollController, removed
  extensions. Use when upgrading calendar_view, or when code fails with
  "The named parameter 'startTime' isn't defined", "can't be assigned to the
  list type 'WeekDays'", "backgroundColor isn't defined" or a CellBuilder
  type error.
---

# calendar_view: migrate 2.0.0 to 3.x

3.x moves the time of an event into `date` and `endDate`, types recurrence
weekdays as `WeekDays`, and moves view colors into theme data.

## Workflow

1. **Detect what is used.** Search `lib/` (and every package of a monorepo) for
   `startTime:`, `endTime:`, `weekdays:`, `eventTileBuilder`,
   `startDuration`, `cellBuilder`, `backgroundColor:` on calendar views,
   `weekTitleBackgroundColor`, `multiDayTileColor`, `multiDayTextColor`,
   `weekDayBuilder`, `scrollController`, `dateYMD`, `copyFromMinutes`,
   `hasSameTimeAs`, and extensions on `BuildContext` (name clashes). Report the
   findings before editing.
2. **Upgrade:** `flutter pub upgrade --major-versions calendar_view`.
3. **Apply the tables below**, then run `flutter analyze` and fix what remains.
4. **Review behavior changes** (last section): they compile but change output.
5. Run `dart run skills@ get` so the 3.x skills replace the old ones.

## Events

| 2.0.0 | 3.x |
| --- | --- |
| `CalendarEventData(startTime: DateTime(...), endTime: DateTime(...))` | Put the time in `date` and `endDate` |
| `copyWith(startTime:, endTime:)` | `copyWith(date:, endDate:)` with the time included |
| `event.startTime` as `DateTime?` | `TimeOfDay?`, read-only, derived from `date` |
| `event.endTime` as `DateTime?` | `TimeOfDay?`, read-only, derived from `endDate` |

Before:

```dart
CalendarEventData<Meeting>(
  title: 'Review',
  date: DateTime(2026, 11, 2),
  startTime: DateTime(2026, 11, 2, 14),
  endTime: DateTime(2026, 11, 2, 16),
);
```

After:

```dart
CalendarEventData<Meeting>.timeRanged(
  title: 'Review',
  date: DateTime(2026, 11, 2, 14),
  endDate: DateTime(2026, 11, 2, 16),
);
```

- All-day events: `CalendarEventData.wholeDay(title:, date:)`. Several days:
  `CalendarEventData.multiDay(title:, date:, endDate:)`.
- An overnight event needs the **next day** as `endDate`.
- A midnight `endDate` time on a timed multi-day event is exclusive.
- `copyWith(date:)` with a date-only value resets the start time to `00:00`.
  Carry the time over when you only want to change the day.
- See `calendar-view-events` for the full event model.

## Recurrence

| 2.0.0 | 3.x |
| --- | --- |
| `weekdays: [WeekDays.monday.index]` or `[DateTime.monday - 1]` | `weekdays: [WeekDays.monday]` |
| `recurrenceSettings.weekdays` as `List<int>` | `List<WeekDays>` |
| `MonthViewBuilders(weekDayBuilder: (int day) => ...)` | `weekDayBuilder: (WeekDays weekDay) => ...` |

`DateTime.weekDayEnum` converts a `DateTime` to a `WeekDays` value.

## Builders and callbacks

| 2.0.0 | 3.x |
| --- | --- |
| `EventTileBuilder`: `startDuration`, `endDuration` as `DateTime` | `TimeOfDay` |
| `CellBuilder`: 5 arguments `(date, events, isToday, isInMonth, hideDaysNotInMonth)` | 6 arguments `(date, events, isToday, isInMonth, isSelected, hideDaysNotInMonth)` |
| `OrganizedCalendarEventData.empty()`, `getWithUpdatedRight()` | Removed |

Use the `TimeOfDay` extensions (`getTotalMinutes`, `isDayStart`, `isSameAs`,
`copyFromMinutes(int)`) where you used the old `DateTime` helpers.

## Theme

| 2.0.0 | 3.x |
| --- | --- |
| `backgroundColor:` on `DayView`, `WeekView`, `MultiDayView` | `pageBackgroundColor` in the view's theme data |
| `weekTitleBackgroundColor:` on `WeekView` | `weekDayTileColor` in `WeekViewThemeData` |
| `MultiDayViewThemeData.multiDayTileColor` | `weekDayTileColor` |
| `MultiDayViewThemeData.multiDayTextColor` | `weekDayTextColor` |

See `calendar-view-theming` for how to supply theme data.

## Name clashes

`BuildContextExtension` is now public API. It adds the getters
`monthViewColors`, `dayViewColors`, `weekViewColors`, `multiDayViewColors` and
`scheduleViewColors` to `BuildContext`. If the app has its own `BuildContext`
extension with one of these names, the call becomes ambiguous. Rename yours, or
hide the package's:

```dart
import 'package:calendar_view/calendar_view.dart' hide BuildContextExtension;
```

## State

`DayViewState.scrollController`, `WeekViewState.scrollController` and
`MultiDayViewState.scrollController` are now `ScrollController?`: they return
the controller of the visible page, or `null` while no page is attached. Add a
null check.

## Removed helpers

| Removed | Use instead |
| --- | --- |
| `DateTime.dateYMD` | `DateTime.withoutTime` |
| `DateTime.copyFromMinutes()`, `hasSameTimeAs()`, `formatted`, `isDayStart` | `TimeOfDay` extensions, or compare the fields |
| `MaterialColorExtension.accent` | Pick the color yourself |

## Behavior changes to review

- Multi-day events now show in `DayView` and `WeekView`.
- `eventSorter` is respected by `getEventsOnDay` (ties fall back to start time).
- `MultiDayView` week day titles use `weekDayTileColor` (like `WeekView`)
  instead of `headerBackgroundColor`, and `pageBackgroundColor` is applied.
- `CalendarEventData.occursOnDate` ignores the time component.

## New in 3.x

`ScheduleView`, `showMidnightHour`, `timeSlotColorBuilder`, `DividerSettings`,
`MonthView.selectedDate`, multi-date selection, `scrollToCurrentTime`, and
localized month names. See `calendar-view-views` and `calendar-view-theming`.
