# MonthView

```dart
final monthKey = GlobalKey<MonthViewState<Meeting>>();

MonthView<Meeting>(
  key: monthKey,
  selectedDate: selected, // optional: controlled selection
  monthViewStyle: MonthViewStyle(
    minMonth: DateTime(2020),
    maxMonth: DateTime(2030),
    initialMonth: DateTime.now(),
    startDay: WeekDays.sunday,
    useAvailableVerticalSpace: true,
    showWeekends: true,
  ),
  monthViewBuilders: MonthViewBuilders<Meeting>(
    onCellTap: (events, date) => setState(() => selected = date),
    onEventTap: (event, date) => openDetails(event), // ONE event
    onEventTapDetails: (event, date, details) => showPopup(details), // tap position
    onHasReachedEnd: (date, page) => loadMore(date),
  ),
);
```

`selected`, `setState`, `openDetails`, `showPopup` and `loadMore` stand for the
app's own state and functions.

## Where each argument goes

- `monthViewStyle: MonthViewStyle(...)`: `minMonth`, `maxMonth`, `initialMonth`,
  `startDay`, `showWeekends`, `useAvailableVerticalSpace`, `cellAspectRatio`,
  `hideDaysNotInMonth`, `showBorder`, `borderColor`, page transitions and
  physics.
- `monthViewBuilders: MonthViewBuilders<T>(...)`: `cellBuilder`, `headerBuilder`,
  `headerStringBuilder`, `dateStringBuilder`, `weekDayStringBuilder`,
  `weekDayBuilder`, and every callback (`onCellTap`, `onEventTap`,
  `onEventLongTap`, `onEventDoubleTap`, their `*Details` variants,
  `onDateLongPress`, `onDateLongPressMoveUpdate`, `onHeaderTitleTap`,
  `onPageChange`, `onHasReachedStart`, `onHasReachedEnd`).
- `monthViewThemeSettings: MonthViewThemeSettings(...)`: colors, text styles
  and `headerStyle` (see `calendar-view-theming`).
- Directly on `MonthView`: `selectedDate`, `multiDateSelectionRange`,
  `multiDateSelectionColor`, `width`.

## Custom cell

`CellBuilder` takes six arguments:
`(date, events, isToday, isInMonth, isSelected, hideDaysNotInMonth)`.

A `cellBuilder` replaces the default cell, so `onEventTap`, `onEventLongTap`,
`onEventDoubleTap` and their `*Details` variants never fire, and
`multiDateSelectionRange` is not drawn. `onCellTap` still fires, except for taps
your own gesture widgets handle. Handle event taps inside your cell:

```dart
MonthViewBuilders<Meeting>(
  cellBuilder: (date, events, isToday, isInMonth, isSelected, hideDays) =>
      MyCell(
        date: date,
        selected: isSelected,
        children: [
          for (final e in events)
            GestureDetector(onTap: () => openDetails(e), child: Text(e.title)),
        ],
      ),
);
```

`MyCell` stands for your own cell widget.

## Selection

- Without `selectedDate`, a tap selects the cell internally.
- With `selectedDate`, you own the selection: update it in `onCellTap`.
- Range selection: set `onDateLongPressMoveUpdate: (date, details)` in the
  builders and pass `multiDateSelectionRange: Set<DateTime>` and
  `multiDateSelectionColor` to `MonthView`. You maintain the set. It is drawn by
  the default cell only.

## Other

- Narrow parent (split view, dialog): pass `width:`. The default is the screen
  width.
- `MonthViewStyle(hideDaysNotInMonth: true)` also hides the events on leading
  and trailing days.
- `onHeaderTitleTap` and `headerBuilder` are mutually exclusive (assert).
- `minMonth` must be before `maxMonth` (assert).
