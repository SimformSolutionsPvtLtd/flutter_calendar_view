---
name: calendar_view-expert
description: Expert guidance for the calendar_view Flutter package - EventController, CalendarControllerProvider, CalendarEventData, MonthView (MonthViewStyle/MonthViewBuilders), DayView, WeekView, MultiDayView, recurring events, theming, localization and navigation. Use when adding a calendar screen, adding/updating/removing events, fixing "No CalendarControllerProvider found", writing a cellBuilder or eventTileBuilder, date selection, timeline hours/zoom/taps, overnight or multi-day events, recurrence (weekdays, every other week, monthly, delete one occurrence), dark mode, translated labels, header styling, or migrating 1.x calendar_view code.
license: MIT
metadata:
  author: simform
  package: calendar_view
  version: "unreleased (after 2.0.0)"
---

# calendar_view Expert - Calendar UI & Event Management

**What:** Month, day, week and multi-day calendar widgets driven by one `EventController<T>`. Pure Flutter, no other dependencies. This skill ships inside the package. If it disagrees with the installed package source, trust the source and tell the user (`CHANGELOG.md` can lag or overstate).

**Version:** written for the source after 2.0.0 (CHANGELOG "Unreleased"). On pub.dev 2.0.0, `CellBuilder` has 5 arguments (no `isSelected`), and `MonthView.selectedDate`, `multiDateSelectionRange`, `onDateLongPressMoveUpdate`, `timeSlotColorBuilder`, `showMidnightHour` and `DividerSettings` don't exist. Check the installed `CellBuilder` typedef before using them.

## CRITICAL RULES

- **One `EventController<T>`, created once** (a `State` field, DI singleton or top-level), never inside `build()`. Share it across all views.
- **One `T` everywhere:** controller, `CalendarControllerProvider<T>`, `CalendarEventData<T>`, every view, `MonthViewBuilders<T>`, `GlobalKey<XxxViewState<T>>`. A bare `MonthView()` looks up `<Object?>` and throws `No CalendarControllerProvider<…> found`.
- **Every view needs a controller:** a `CalendarControllerProvider<T>` ancestor or `controller:`. Otherwise it asserts.
- **`MonthView` takes `monthViewStyle:` + `monthViewBuilders:`.** Passing `minMonth`, `initialMonth`, `startDay`, `cellBuilder`, `onCellTap` or colors directly to `MonthView` is the 1.x API and doesn't compile. Day/Week/MultiDay views still take their arguments flat.
- **`cellBuilder` has 6 arguments:** `(date, events, isToday, isInMonth, isSelected, hideDaysNotInMonth)`. A custom cell disables `onEventTap*` callbacks (see MonthView).
- **Recurrence weekdays are 0-based** (Monday = 0 … Sunday = 6). Always pass `weekdays: [WeekDays.monday.index, …]`. The default (`startDate.weekday`) and `DateTime.monday` are 1-based, so the series lands one day late.
- **Only `endDate` ends a series.** The plain `RecurrenceSettings(...)` constructor ignores `recurrenceEndOn` and `occurrences`. For "after n times" use `RecurrenceSettings.withCalculatedEndDate`.
- **Events match by value.** `update`/`remove` need the stored instance (or an `==` copy); adding an `==` duplicate is silently ignored. `==` ignores `recurrenceSettings`. Put a unique id in `event`.
- **Dark mode/colors go in `ThemeData.extensions`.** Views never read `CalendarThemeProvider`.
- **Never invent APIs** for the limitations listed below (`interval:`, sync, persistence, drag-to-resize). Say it's unsupported and use the workaround.
- Run `flutter analyze` after writing calendar code.

## Setup & Events

```dart
final eventController = EventController<Meeting>();

void main() => runApp(CalendarControllerProvider<Meeting>(
      controller: eventController,
      child: const MaterialApp(home: CalendarPage()),
    ));

eventController.add(CalendarEventData<Meeting>(
  title: 'Stand-up', date: day, event: const Meeting(id: 'm1'),
  startTime: DateTime(day.year, day.month, day.day, 9),
  endTime: DateTime(day.year, day.month, day.day, 9, 30),
));
eventController.addAll(list);
eventController.update(stored, stored.copyWith(title: 'Renamed'));
eventController.remove(stored);                            // works for recurring too
eventController.removeAll(eventController.allEvents
    .where((e) => e.event?.id == 'm1').toList());          // by id, incl. recurring
eventController.removeWhere((e) => e.event?.id == 'm1');   // NON-recurring only
eventController.clear();

eventController.allEvents;                 // NOT .events (deprecated)
eventController.getEventsOnDay(date);      // timed + full-day, recurrences expanded
eventController.getFullDayEvent(date);     // full-day only
```

- Views rebuild on every controller change. No `setState` needed.
- **`removeWhere` skips recurring events:** they stay in `allEvents` and keep rendering. Use `remove`, `removeAll` or `deleteRecurrenceEvent(deleteEventType: DeleteEvent.all)`.
- **Timed vs. full-day:** `date`/`endDate` drop their time; only the time of day of `startTime`/`endTime` counts. If either time is null, or both are 00:00, the event is full-day (shown in the all-day header). Set `endDate` for multi-day events.
- **`copyWith` can't clear a field:** `null` means "keep". To drop `recurrenceSettings`/`endDate` or turn a timed event full-day, build a new `CalendarEventData` and `update(stored, fresh)`.
- **`eventFilter` replaces lookup:** `EventController(eventFilter: (date, all) => …)` replaces `getEventsOnDay` only. It ignores `includeFullDayEvents`, gets `date` as passed (may include a time) and all events with recurrences **not** expanded. `getFullDayEvent` is unaffected, so the all-day header of Day/Week/MultiDay views still shows unfiltered full-day events. Change it later with `updateFilter(newFilter:)`.
- **Choosing a view:** `MonthView` = grid, no time axis. `DayView`/`WeekView` = timed blocks + all-day header. `MultiDayView(daysInView: n)` = any `n` days (default 3). No agenda or year view: build those from `getEventsOnDay`/`allEvents`.
- Use `withoutTime` (not deprecated `dateYMD`) to strip times.

## MonthView

```dart
final monthKey = GlobalKey<MonthViewState<Meeting>>();

MonthView<Meeting>(
  key: monthKey,
  selectedDate: selected,                  // optional: controlled selection
  monthViewStyle: MonthViewStyle(
    minMonth: DateTime(2020), maxMonth: DateTime(2030),
    initialMonth: DateTime.now(), startDay: WeekDays.sunday,
    useAvailableVerticalSpace: true, showWeekends: true,
  ),
  monthViewBuilders: MonthViewBuilders<Meeting>(
    onCellTap: (events, date) => setState(() => selected = date),
    onEventTap: (event, date) => openDetails(event),       // ONE event
    onEventTapDetails: (event, date, details) => showPopup(details), // tap position
    onHasReachedEnd: (date, page) => loadMore(date),
  ),
);

monthKey.currentState?.animateToMonth(DateTime(2026, 12)); // jumpToMonth, nextPage, previousPage
```

- **Custom cell:** `cellBuilder` replaces the default cell, so `onEventTap`, `onEventLongTap`, `onEventDoubleTap` and their `*Details` variants never fire and `multiDateSelectionRange` isn't drawn. `onCellTap` still fires, except for taps your own gesture widgets handle. Handle event taps inside your cell:

```dart
cellBuilder: (date, events, isToday, isInMonth, isSelected, hideDaysNotInMonth) =>
    MyCell(date: date, selected: isSelected, children: [
      for (final e in events)
        GestureDetector(onTap: () => openDetails(e), child: Text(e.title)),
    ]),
```

- **Selection:** without `selectedDate`, a tap selects the cell internally. With `selectedDate`, you own it: update it in `onCellTap`.
- **Range selection:** `onDateLongPressMoveUpdate: (date, details)` in builders + `MonthView(multiDateSelectionRange: Set<DateTime>, multiDateSelectionColor:)`. You maintain the set. Default cell only.
- **Narrow parent** (split view, dialog): pass `width:`; the default is the screen width.
- `MonthViewStyle(hideDaysNotInMonth: true)` also hides events on leading/trailing days. Hide the header with `MonthHeader.hidden`.

## DayView, WeekView, MultiDayView

```dart
final weekKey = GlobalKey<WeekViewState<Meeting>>();

WeekView<Meeting>(
  key: weekKey,
  startHour: 7, endHour: 21,
  heightPerMinute: zoom,                   // zoom: setState with a new value >= 0.02
  weekDays: const [WeekDays.monday, WeekDays.tuesday, WeekDays.wednesday,
      WeekDays.thursday, WeekDays.friday],
  eventArranger: const SideEventArranger<Meeting>(), // or MergeEventArranger
  onEventTap: (events, date) => openDetails(events.first), // a LIST here
  onDateTap: (dateTime) => createEventAt(dateTime),
  onPageChange: (date, page) => loadWeek(date),
  timeSlotColorBuilder: (date, slotStart, slotEnd, index) =>
      slotStart.hour < 9 ? Colors.grey.shade100 : Colors.white,
  liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
      currentTimeProvider: () => clock.now()), // custom "now" (time zones, tests)
);

weekKey.currentState?.jumpToWeek(DateTime.now()); // animateToWeek, animateToEvent, nextPage
// DayViewState: jumpToDate / animateToDate / jumpToEvent / animateToEvent
```

- Arguments are flat: `minDay`, `maxDay`, `initialDay`, `startHour`, `endHour`, `heightPerMinute`, `eventTileBuilder`, `fullDayEventBuilder`, `onPageChange`.
- **Per-view arguments:** `weekDays:`, `showWeekends:` and `startDay:` exist only on `WeekView`. `timeSlotColorBuilder` and `showMidnightHour` (default `false`, shows the `00:00` label) exist on `DayView` and `WeekView`. `dividerSettings: DividerSettings(...)` exists on `WeekView` and `MultiDayView`. `daysInView` is `MultiDayView` only.
- Hide headers with `DayHeader.hidden` / `WeekHeader.hidden`.
- **Zoom:** change `heightPerMinute`; the view keeps the visible time. `ZoomScrollController` isn't exported. Every indicator's `height` must stay below `heightPerMinute * 60`. Week/MultiDay draw a 1px quarter-hour line by default, so values ≤ 1/60 assert. Clamp to `>= 0.02` (higher if you pass thicker indicator settings).

## Recurring Events

```dart
CalendarEventData<Meeting>(
  title: 'Gym', date: start,
  startTime: start, endTime: start.add(const Duration(hours: 1)),
  recurrenceSettings: RecurrenceSettings(
    startDate: start,                      // keep equal to `date`
    frequency: RepeatFrequency.weekly,     // doNotRepeat / daily / weekly / monthly / yearly
    weekdays: [WeekDays.monday.index, WeekDays.wednesday.index],
    endDate: DateTime(2027, 6, 30),        // omit to repeat forever
    excludeDates: [DateTime(2026, 11, 16)], // date only, growable (not const)
  ),
);

// "After 10 times": only this constructor computes endDate from occurrences.
RecurrenceSettings.withCalculatedEndDate(
  startDate: start, frequency: RepeatFrequency.weekly,
  weekdays: [WeekDays.monday.index],       // growable: it's sorted in place
  recurrenceEndOn: RecurrenceEnd.after, occurrences: 10,
);

eventController.deleteRecurrenceEvent(
  date: tappedDate.withoutTime, event: stored, // date-only, or nothing is deleted
  deleteEventType: DeleteEvent.current,    // .following / .all
);
```

- **Series start:** the series is anchored to the event's `date`; `recurrenceSettings.startDate` isn't used to decide which days show. Keep them equal.
- **Ending:** only `endDate` stops a series, with either constructor. With the plain constructor, `recurrenceEndOn` and `occurrences` do nothing (`RecurrenceEnd.after, occurrences: 3` repeats forever). `withCalculatedEndDate` fills `endDate` for `RecurrenceEnd.after` + `occurrences`; with `RecurrenceEnd.never` it leaves it null.
- **Deleting:** `DeleteEvent.current` adds `date` to `excludeDates` (exact match, so pass `withoutTime`; a `const` list throws `Cannot add to an unmodifiable list`). `.following` sets `endDate` to the day before, or removes the series when `date == event.date`. `.all` removes it.
- `monthly` repeats the same day number. A start on the 29th–31st skips short months.

## Theme, Headers & Localization

```dart
MaterialApp(
  theme: ThemeData(extensions: [
    MonthViewThemeData.light(), DayViewThemeData.light(),
    WeekViewThemeData.light(), MultiDayViewThemeData.light(),
  ]),
  darkTheme: ThemeData(brightness: Brightness.dark, extensions: [
    MonthViewThemeData.dark(), DayViewThemeData.dark(),
    WeekViewThemeData.dark(), MultiDayViewThemeData.dark(),
  ]),
); // tweak: MonthViewThemeData.light().copyWith(...)

PackageStrings.addLocaleObject('pt', const CalendarLocalizations(
  am: 'AM', pm: 'PM', more: 'Mais',
  weekdays: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'], // Monday first
));
setState(() => PackageStrings.setLocale('pt'));  // setLocale doesn't rebuild by itself
```

- Views read only `Theme.of(context).extension<XxxViewThemeData>()` and fall back to light. `CalendarThemeProvider` is never read by the views (it only holds data for your own widgets), so it won't theme them.
- `copyWith` returns `ThemeExtension<X>`: fine inside `extensions:`; cast (`as MonthViewThemeData`) when storing it in a typed variable.
- Use theme data, not hard-coded colors, so dark mode works. Selected-cell colors: `MonthView(monthViewThemeSettings: MonthViewThemeSettings(selectedHighlightColor: …))`.
- Calendar labels come only from `PackageStrings`, not Flutter `Localizations`. Built-in: `en`, `es`, `ar` (RTL), `fr`, `de`, `hi`, `zh`, `ja`. An unknown locale asserts.
- **No month names:** default headers are numbers (`11 - 2026`, `2 - 11 - 2026`, `2 / 11 / 2026 to …`). `CalendarLocalizations` covers only am/pm/"more"/weekday letters/digits, and digits are localized only for 0–60 (needs all 61 `numbers`), so years stay Latin. For month names use `MonthViewBuilders(headerStringBuilder:)`, `DayView(dateStringBuilder:)` or `WeekView`/`MultiDayView(headerStringBuilder:)`, e.g. `(date, {secondaryDate}) => DateFormat.yMMMM('pt').format(date)` with `intl`.
- Header styling: `HeaderStyle(decoration:, leftIconConfig: IconDataConfig(...), rightIconConfig: …)`. `leftIconConfig: null` hides the icon. Day/Week/MultiDay take it as `headerStyle:`. **MonthView ignores `MonthViewStyle.headerStyle`**: pass `monthViewThemeSettings: MonthViewThemeSettings(headerStyle: …)`, which replaces the themed default header style entirely.

## Anti-Patterns

```dart
// ❌ 1.x MonthView API (old tutorials)
MonthView(initialMonth: m, cellBuilder: (date, events, isToday, isInMonth) => …);
// ✅
MonthView<T>(
  monthViewStyle: MonthViewStyle(initialMonth: m),
  monthViewBuilders: MonthViewBuilders<T>(
      cellBuilder: (date, events, isToday, isInMonth, isSelected, hide) => …),
);

// ❌ 1-based weekday → shows on Tuesday
RecurrenceSettings(startDate: d, frequency: RepeatFrequency.weekly, weekdays: [DateTime.monday]);
// ✅
RecurrenceSettings(startDate: d, frequency: RepeatFrequency.weekly, weekdays: [WeekDays.monday.index]);

// ❌ Never ends: plain constructor ignores occurrences
RecurrenceSettings(startDate: d, frequency: RepeatFrequency.daily,
    recurrenceEndOn: RecurrenceEnd.after, occurrences: 5);
// ✅
RecurrenceSettings.withCalculatedEndDate(startDate: d, frequency: RepeatFrequency.daily,
    recurrenceEndOn: RecurrenceEnd.after, occurrences: 5);

// ❌ Controller in build() → events vanish on rebuild
Widget build(context) => CalendarControllerProvider(controller: EventController(), …);

// ❌ Rebuilt event for remove → no-op if any field differs
controller.remove(CalendarEventData(title: e.title, date: e.date));
// ✅
controller.remove(storedEvent);

// ❌ removeWhere on a recurring series → still shown
controller.removeWhere((e) => e.event?.id == id);
// ✅
controller.removeAll(controller.allEvents.where((e) => e.event?.id == id).toList());

// ❌ CalendarThemeProvider → views stay light
CalendarThemeProvider(calendarTheme: CalendarThemeData(monthViewTheme: MonthViewThemeData.dark(), …), child: app);
// ✅
ThemeData(extensions: [MonthViewThemeData.dark(), …]);

// ❌ onEventTap together with cellBuilder → never fires
MonthViewBuilders(cellBuilder: …, onEventTap: …);

// ❌ Mutually exclusive pairs (assert)
MonthViewBuilders(onHeaderTitleTap: …, headerBuilder: …);
DayView(onHeaderTitleTap: …, dayTitleBuilder: …);
DayView(onDateLongPress: …, dayDetectorBuilder: …);
WeekView(onDateLongPress: …, weekDetectorBuilder: …);   // also MultiDayView
WeekView(onHeaderTitleTap: …, weekPageHeaderBuilder: …); // also MultiDayView

// ❌ Deprecated header params
HeaderStyle(leftIcon: …, leftIconVisible: false);   // → leftIconConfig: IconDataConfig(...) / null
MonthPageHeader(backgroundColor: …, iconColor: …);  // → headerStyle: HeaderStyle(decoration: …)
```

Other asserts: `heightPerMinute <= 0`, any indicator `height >= heightPerMinute * 60`, `startHour > 0` with `startHour == endHour`, `endHour > 24` (unless below `startHour`), empty `weekDays`, `minMonth`/`minDay` not strictly before the max in `MonthView`, `WeekView` and `MultiDayView` (week views compare after aligning to week boundaries; `DayView` allows the same day). `startHour > endHour` doesn't assert; it fails at layout with `BoxConstraints has a negative minimum height`.

## Known Limitations & Workarounds

| Need | What happens | Workaround |
| --- | --- | --- |
| Overnight event (22:00→06:00) | Same `date`: no error, but it renders as an invisible 0-height tile. | Set `endDate` = next day. Renders as two blocks; `startHour > 0` hides the morning part. |
| **Recurring** overnight shift | Recurring multi-day events are silently dropped. | Two series with the same `event` payload: evening 22:00–00:00 (Mon–Fri) and morning 00:00–06:00 (Tue–Sat). Cancel a night in both. |
| Every N weeks / N days | No interval field; shows every week/day. | Subclass the controller (below). |
| "2nd Tuesday" / last day of month | `monthly` matches the day number only. | Generate individual events. |
| Translated month names | Headers show numbers only. | `headerStringBuilder` / `dateStringBuilder` (see Localization). |

**Every N weeks**: define the series as weekly, then filter by week parity. Views read through `getEventsOnDay` and the all-day header through `getFullDayEvent`, so override both:

```dart
class IntervalEventController<T> extends EventController<T> {
  IntervalEventController(this.weeksBetween);
  final int Function(CalendarEventData<T> e) weeksBetween; // 1 = every week

  bool _keep(CalendarEventData<T> e, DateTime day) {
    final n = weeksBetween(e);
    if (n <= 1 || e.recurrenceSettings == null) return true;
    final days = DateTime.utc(day.year, day.month, day.day)
        .difference(DateTime.utc(e.date.year, e.date.month, e.date.day))
        .inDays; // UTC so DST can't shift the count
    return (days ~/ 7) % n == 0;
  }

  @override
  List<CalendarEventData<T>> getEventsOnDay(DateTime date,
          {bool includeFullDayEvents = true}) =>
      super.getEventsOnDay(date, includeFullDayEvents: includeFullDayEvents)
          .where((e) => _keep(e, date)).toList();

  @override
  List<CalendarEventData<T>> getFullDayEvent(DateTime date) =>
      super.getFullDayEvent(date).where((e) => _keep(e, date)).toList();
}
```

Parity counts in 7-day blocks from `date`, so keep `date` unchanged in `copyWith`/`update` and start the series on its first weekday. Direct calls to `getRecurringEventsOnDay` still see every week.

**Out of scope** (say so, don't invent APIs): persistence (own store → feed the controller), Google/Outlook/device sync and iCal/RRULE (another package → map to `CalendarEventData`), time zones (convert to local `DateTime` first), drag/resize (build with `eventTileBuilder` + gestures + `update`).

## Testing

```dart
testWidgets('shows event', (tester) async {
  final controller = EventController<String>()
    ..add(CalendarEventData(title: 'Gym', date: DateTime(2026, 11, 2)));
  await tester.pumpWidget(MaterialApp(
    home: CalendarControllerProvider<String>(
      controller: controller,
      child: Scaffold(                     // views need a Material ancestor
        body: MonthView<String>(
            monthViewStyle: MonthViewStyle(initialMonth: DateTime(2026, 11))),
      ),
    ),
  ));
  expect(find.text('Gym'), findsOneWidget);
});
```

- Put views under a `Scaffold`/`Material`, or they throw `No Material widget found`.
- Pin `initialMonth`/`initialDay` and `currentTimeProvider` so tests don't depend on today.
- Test recurrence and filters without widgets: `controller.getEventsOnDay(DateTime(...))`.

## Symptom → Fix

| Symptom | Fix |
| --- | --- |
| `No CalendarControllerProvider<X> found in context` | Add the provider or `controller:`; use one `T` everywhere. |
| `The named parameter 'initialMonth' isn't defined` | Move it into `MonthViewStyle` (builders into `MonthViewBuilders`). |
| `cellBuilder` type error / wrong argument count | Match the installed `CellBuilder` typedef: 6 args with `isSelected` (5 on 2.0.0). |
| `onEventTap` never fires in MonthView | You have a `cellBuilder`; handle taps inside the cell. |
| Weekly event one day late | `weekdays: [WeekDays.x.index]`. |
| Series never ends | Set `endDate`, or use `withCalculatedEndDate` for `occurrences`. |
| Deleted occurrence still shows | Pass `date: tapped.withoutTime` to `deleteRecurrenceEvent`. |
| `Cannot add/modify an unmodifiable list` | Don't pass `const` lists as `excludeDates`/`weekdays`. |
| Recurring event still shows after `removeWhere` | Use `remove`/`removeAll`/`DeleteEvent.all`. |
| Timed event in the all-day header | Give it real `startTime`/`endTime` (not null, not both 00:00). |
| Overnight event invisible | Set `endDate` to the next day. |
| Recurring overnight event never shows | Split into two series (see limitations). |
| `update`/`remove` does nothing | Pass the stored instance. |
| Events disappear after rebuild | Move the controller out of `build()`. |
| Dark theme not applied to the calendar | Put `XxxViewThemeData.dark()` in `ThemeData(extensions:)`, not `CalendarThemeProvider`. |
| Header shows `11 - 2026` | Use `headerStringBuilder`/`dateStringBuilder` for month names. |
| `No Material widget found` | Wrap the view in a `Scaffold` (common in widget tests). |
| Locale change not visible | Rebuild after `PackageStrings.setLocale`. |
| `Height per minute must be greater than 0.` / `…indicator height must be less than minuteHeight * 60` | Clamp zoom to `>= 0.02`. |
| `BoxConstraints has a negative minimum height` | `startHour` must be below `endHour`. |
