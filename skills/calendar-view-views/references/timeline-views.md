# DayView, WeekView and MultiDayView

```dart
final weekKey = GlobalKey<WeekViewState<Meeting>>();

WeekView<Meeting>(
  key: weekKey,
  startHour: 7,
  endHour: 21,
  heightPerMinute: zoom, // setState with a new value to zoom
  weekDays: const [
    WeekDays.monday, WeekDays.tuesday, WeekDays.wednesday,
    WeekDays.thursday, WeekDays.friday,
  ],
  eventArranger: const SideEventArranger<Meeting>(), // or MergeEventArranger
  onEventTap: (events, date) => openDetails(events.first), // a LIST here
  onDateTap: (dateTime) => createEventAt(dateTime),
  onPageChange: (date, page) => loadWeek(date),
  scrollToCurrentTime: true,
  timeSlotColorBuilder: (date, slotStart, slotEnd, index) =>
      slotStart.hour < 9 ? Colors.grey.shade100 : Colors.white,
  liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
    currentTimeProvider: () => DateTime.now(), // custom "now": time zones, tests
  ),
);

weekKey.currentState?.jumpToWeek(DateTime.now());
```

`zoom`, `openDetails`, `createEventAt` and `loadWeek` stand for the app's own
state and functions.

## Arguments

- Arguments are flat: `minDay`, `maxDay`, `initialDay`, `startHour`, `endHour`,
  `heightPerMinute`, `eventTileBuilder`, `fullDayEventBuilder`, `onPageChange`.
- **Per view:** `weekDays`, `showWeekends` and `startDay` exist only on
  `WeekView`. `daysInView` exists only on `MultiDayView`.
  `timeSlotColorBuilder` and `showMidnightHour` (default `false`, shows the
  `00:00` label) exist on `DayView` and `WeekView`. `dividerSettings:
  DividerSettings(...)` exists on `WeekView` and `MultiDayView`.
- `eventTileBuilder` receives `(date, events, boundary, startDuration,
  endDuration)`. `startDuration` and `endDuration` are `TimeOfDay`.
- Hide a header with `dayTitleBuilder: DayHeader.hidden` (`DayView`) or
  `weekPageHeaderBuilder: WeekHeader.hidden` (`WeekView`, `MultiDayView`).
- `onEventTap` here receives a **list** of events; `MonthView.onEventTap`
  receives one event.

## Zoom

Change `heightPerMinute` and the view keeps the visible time. `ZoomScrollController`
is internal and not exported, so zoom with `heightPerMinute`. Every indicator's
`height` must stay below `heightPerMinute * 60`. `WeekView` and `MultiDayView`
draw a 1 px quarter-hour line by default, so values at or below `1/60` assert.
Clamp to `>= 0.02` (higher with thicker indicator settings).

## Asserts

- `heightPerMinute <= 0`.
- Any indicator `height >= heightPerMinute * 60`.
- `startHour > 0` together with `startHour == endHour`.
- `endHour > 24` unless `endHour < startHour`.
- Empty `weekDays` (`WeekView`, `MultiDayView`).
- `minDay` not before `maxDay`: strictly before for `WeekView` and
  `MultiDayView`; `DayView` allows the same day.
- Mutually exclusive pairs: `onHeaderTitleTap` with `dayTitleBuilder`
  (`DayView`) or `weekPageHeaderBuilder` (`WeekView`, `MultiDayView`);
  `onDateLongPress` with `dayDetectorBuilder` (`DayView`) or
  `weekDetectorBuilder` (`WeekView`, `MultiDayView`).
- `startHour > endHour` does not assert; it fails at layout with
  `BoxConstraints has a negative minimum height`.

## Events that span midnight

Overnight and multi-day timed events show as one block per day, and the all-day
header shows full-day events. Creating them is covered in `calendar-view-events`.
With `startHour > 0`, the part of an overnight event before `startHour` is hidden.
