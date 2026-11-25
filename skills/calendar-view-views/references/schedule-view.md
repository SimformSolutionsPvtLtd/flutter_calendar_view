# ScheduleView

An agenda: a scrollable list grouped by month, one row per day. Months build
lazily.

```dart
final scheduleKey = GlobalKey<ScheduleViewState<Meeting>>();

ScheduleView<Meeting>(
  key: scheduleKey,
  initialDay: DateTime.now(),
  minDay: DateTime(2020),
  maxDay: DateTime(2030),
  dateLayout: ScheduleDateLayout.left, // or .top
  showDaysWithoutEvents: false,
  showEmptyMonths: true,
  onEventTap: (events, date) => openDetails(events.first), // a LIST
  onDateTap: (date) => createEventOn(date),
  onVisibleMonthChanged: (month) => debugPrint('$month'),
);

scheduleKey.currentState?.jumpToDate(DateTime(2026, 12, 1));
```

`openDetails` and `createEventOn` stand for the app's own functions.

## Arguments

- Content: `eventTileBuilder: (event, date)`, `monthHeaderBuilder: (date)`,
  `dateHeaderBuilder: (date, events, layout)`, `emptyTextWidget`,
  `todayEmptyWidget`, `emptyMonthBuilder`, `floatingMonthHeaderBuilder`.
- Behavior: `showDaysWithoutEvents` (default `false`: only days with events, and
  today, show a row), `showEmptyMonths` (default `true`), `eventSorter`,
  `onHasReachedStart`, `onHasReachedEnd`.
- Strings: `dateStringBuilder` (month header text), `weekDayStringBuilder`
  (`1` = Monday).
- Month names in the default header come from `CalendarLocalizations.months`.
  See `calendar-view-theming`.

## Asserts

- `dayDetectorBuilder` with `dateHeaderBuilder`.
- `dayDetectorBuilder` with `onDateTap` or `onDateLongPress`.
- `monthHeaderBuilder` with `dateStringBuilder`.
- `emptyTextWidget` while `showDaysWithoutEvents` is `false`: use
  `todayEmptyWidget` for the empty state of today, or set
  `showDaysWithoutEvents: true`.
- `initialDay` or a `jumpToDate` target outside `[minDay, maxDay]` (debug
  only; release builds clamp it into range).

## Tips

- `emptyMonthBuilder` must return a widget with a non-zero height, or the lazy
  list keeps building months.
- With `showEmptyMonths: false`, the scroll range is limited to the months that
  hold events (plus today), which keeps very wide `minDay`/`maxDay` ranges fast.
- A recurring event with no end date extends to `maxDay`, so
  `onHasReachedEnd` effectively never fires.
