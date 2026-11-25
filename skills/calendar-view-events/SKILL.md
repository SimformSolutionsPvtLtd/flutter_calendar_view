---
name: calendar-view-events
description: >-
  Create, update, remove, filter and sort calendar events with calendar_view:
  EventController, CalendarEventData (timeRanged, wholeDay and multiDay
  factories), full-day and overnight events, copyWith, eventFilter and
  eventSorter, and recurring events (RecurrenceSettings, WeekDays, end date,
  occurrences, deleting one occurrence, every N weeks). Use when adding events
  to a calendar, when an event is missing, in the wrong slot or in the all-day
  header, when update or remove does nothing, or when a recurring event is a
  day late, never ends or survives removal.
---

# calendar_view: events

All views read events from one `EventController<T>`. This skill covers
creating and changing the events. For the widgets that show them, use the
`calendar-view-views` skill.

## Workflow

1. **Inspect the project first.** Find any existing `EventController`, the
   event payload type `T` (or `Object?` when none), and where events come from
   (backend, local database). Reuse them. Don't create a second controller.
2. **Add the dependency** if missing: `flutter pub add calendar_view`. Never
   hard-code a version.
3. Create the controller **once** and map your data into `CalendarEventData`.
4. Run `flutter analyze` after writing calendar code.

## Rules

- **One controller, created once:** a `State` field, a DI singleton or a
  top-level variable. A controller created in `build()` loses its events on
  every rebuild. Share it with every view.
- **One `T` everywhere:** `EventController<T>`, `CalendarEventData<T>` and
  every view must use the same `T`. A bare `MonthView()` looks up
  `CalendarControllerProvider<Object?>` and throws if you registered another
  type.
- **Give the `event` payload `==` and `hashCode`** (a plain class with an `id`
  and both overrides, a record, or a `freezed` class). Events compare by value
  and that includes `event`. Without them, a rebuilt event never equals the
  stored one: duplicates are added and `remove` does nothing.
- **Never invent APIs** for the limitations below (`interval:` on recurrence,
  sync, persistence, drag-to-resize). Say it is unsupported and use the
  workaround.

## Controller

```dart
class Meeting {
  const Meeting({required this.id});
  final String id;

  @override
  bool operator ==(Object other) => other is Meeting && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final eventController = EventController<Meeting>();

void demo(DateTime day, List<CalendarEventData<Meeting>> list) {
  eventController.add(CalendarEventData<Meeting>.timeRanged(
    title: 'Stand-up',
    date: DateTime(day.year, day.month, day.day, 9),
    endDate: DateTime(day.year, day.month, day.day, 9, 30),
    event: const Meeting(id: 'm1'),
  ));
  eventController.addAll(list);

  final stored = eventController.allEvents.first;
  eventController.update(stored, stored.copyWith(title: 'Renamed'));
  eventController.remove(stored); // also removes a whole recurring series
  eventController.removeAll(eventController.allEvents
      .where((e) => e.event?.id == 'm1')
      .toList()); // by id, includes recurring events
  eventController.clear();

  eventController.allEvents; // not `.events`, which is deprecated
  eventController.getEventsOnDay(day); // timed + full-day, recurrences expanded
  eventController.getFullDayEvent(day); // full-day only
}
```

- Views rebuild on every controller change. No `setState` needed.
- `update` and `remove` match by value (title, date, times, color, styles,
  description and `event`). Pass the stored instance, or a copy that is `==`.
  Adding an event that is `==` to a stored one is silently ignored.
- `==` ignores `recurrenceSettings`: two events that differ only in recurrence
  count as the same event.
- `removeWhere` does not remove recurring events: they stay in `allEvents` and
  keep rendering. Use `remove`, `removeAll` or
  `deleteRecurrenceEvent(deleteEventType: DeleteEvent.all)`.
- Use `date.withoutTime` to strip the time of a `DateTime`.

## Creating events

Time lives **inside** `date` and `endDate`. There are no `startTime` or
`endTime` constructor arguments.

```dart
// Timed, one day.
CalendarEventData<Meeting>.timeRanged(
  title: 'Review',
  date: DateTime(2026, 11, 2, 14),
  endDate: DateTime(2026, 11, 2, 16),
);

// All day (the time of `date` is ignored).
CalendarEventData<Meeting>.wholeDay(title: 'Holiday', date: DateTime(2026, 11, 3));

// Several days, whole-day or with times.
CalendarEventData<Meeting>.multiDay(
  title: 'Conference',
  date: DateTime(2026, 11, 10),
  endDate: DateTime(2026, 11, 12),
);
```

- `CalendarEventData(...)` (the default constructor) accepts the same
  `date`/`endDate`; the factories only make the intent clear.
- `startTime` and `endTime` are **read-only** `TimeOfDay?` fields derived from
  `date` and `endDate`. The stored `date` and `endDate` have no time.
- **Full-day:** an event is full-day when `endDate` is omitted, or when
  `startTime` and `endTime` are both `00:00`. Full-day events render in the
  all-day header of Day, Week and MultiDay views.
- **Overnight (22:00 to 06:00):** pass the **next** day as `endDate` with the
  end time: `date: DateTime(y, m, d, 22)`, `endDate: DateTime(y, m, d + 1, 6)`.
- **Midnight end:** a timed multi-day event whose `endDate` time is `00:00`
  ends at the start of `endDate`, so it does not appear on `endDate`.
- **`copyWith` replaces the time:** passing a date-only `date` or `endDate`
  resets the time to `00:00`. To move an event to another day, carry the time:
  `copyWith(date: DateTime(y, m, d, e.startTime!.hour, e.startTime!.minute))`.
- **`copyWith` cannot clear a field** (`null` means "keep"). To drop
  `endDate` or `recurrenceSettings`, build a new `CalendarEventData` and call
  `update(stored, fresh)`.

## Filtering and sorting

```dart
final controller = EventController<Meeting>(
  eventFilter: (date, all) => all.where((e) => e.event?.id != 'hidden').toList(),
  eventSorter: (a, b) => a.title.compareTo(b.title),
);
controller.updateFilter(newFilter: (date, all) => all); // change it later
```

- `eventFilter` **replaces** `getEventsOnDay` only. It receives `date` as
  passed (it may contain a time) and all events with recurrences **not**
  expanded. `getFullDayEvent` is unaffected, so the all-day header still shows
  unfiltered full-day events.
- `eventSorter` orders events within a day. When it returns `0`, events fall
  back to start-time order. The event arrangers re-sort by start time
  internally, so a custom order never breaks the layout.

## Recurring events

```dart
final start = DateTime(2026, 11, 2, 18);

CalendarEventData<Meeting>.timeRanged(
  title: 'Gym',
  date: start,
  endDate: start.add(const Duration(hours: 1)),
  recurrenceSettings: RecurrenceSettings(
    startDate: start, // keep equal to the event's date
    frequency: RepeatFrequency.weekly, // doNotRepeat/daily/weekly/monthly/yearly
    weekdays: [WeekDays.monday, WeekDays.wednesday],
    endDate: DateTime(2027, 6, 30), // omit to repeat forever
    excludeDates: [DateTime(2026, 11, 16)], // date only, growable (not const)
  ),
);

// "After 10 times": only this constructor computes endDate from occurrences.
RecurrenceSettings.withCalculatedEndDate(
  startDate: start,
  frequency: RepeatFrequency.weekly,
  weekdays: [WeekDays.monday],
  recurrenceEndOn: RecurrenceEnd.after,
  occurrences: 10,
);

// Delete one occurrence, the following ones, or the whole series.
void deleteOne(CalendarEventData<Meeting> stored, DateTime tapped) {
  eventController.deleteRecurrenceEvent(
    date: tapped.withoutTime, // date only, or nothing is deleted
    event: stored,
    deleteEventType: DeleteEvent.current, // .following / .all
  );
}
```

- `weekdays` is a `List<WeekDays>` (`WeekDays.monday` ... `WeekDays.sunday`).
  Without it, the series repeats on the weekday of `startDate`.
- **Only `endDate` ends a series.** The plain `RecurrenceSettings(...)`
  constructor ignores `recurrenceEndOn` and `occurrences`, so
  `RecurrenceEnd.after, occurrences: 3` repeats forever. Use
  `withCalculatedEndDate` to turn `occurrences` into an `endDate`. With
  `RecurrenceEnd.never` it leaves `endDate` null.
- `DeleteEvent.current` adds `date` to `excludeDates` (exact match, so pass
  `withoutTime`; a `const` list throws `Cannot add to an unmodifiable list`).
  `.following` sets `endDate` to the day before, or removes the series when
  `date` equals the event's date. `.all` removes the series.
- `monthly` repeats the same day number. A start on the 29th to 31st skips
  months that are too short.

## Limitations and workarounds

| Need | What happens | Workaround |
| --- | --- | --- |
| Recurring overnight or multi-day event | Silently dropped: `getEventsOnDay` returns nothing, even on the first day | Two series that each stay within one day: see below |
| Every N weeks or N days | No interval field: it repeats every week or day | Subclass the controller: `references/every-n-weeks.md` |
| "2nd Tuesday", last day of month | `monthly` matches the day number only | Generate individual events |
| Persistence | Not provided | Keep your own store and feed the controller |
| Google/Outlook/device sync, iCal/RRULE | Not provided | Use another package and map to `CalendarEventData` |
| Time zones | Not handled | Convert to local `DateTime` first |
| Drag or resize an event | Not provided | Build it with `eventTileBuilder` (see `calendar-view-views`), gestures and `update` |

**Recurring overnight shift (Mon to Fri, 22:00 to 06:00):** create two series
that share the same `event` payload and stay inside one day: the evening
(`date` 22:00, `endDate` 23:59 on the same day, Monday to Friday) and the
morning (`date` 00:00, `endDate` 06:00, Tuesday to Saturday). Cancel a night
in both series. A series that ends at `24:00` or crosses midnight is dropped.

## Symptom to fix

| Symptom | Fix |
| --- | --- |
| `No CalendarControllerProvider<X> found` | One `T` everywhere; see `calendar-view-views`. |
| `The named parameter 'startTime' isn't defined` | Put the time in `date`/`endDate`; see `calendar-view-migration`. |
| Events vanish after a rebuild | Move the controller out of `build()`. |
| `update` or `remove` does nothing | Pass the stored instance, or give the `event` payload `==` and `hashCode`. |
| Same event added twice | The `event` payload has no `==`; add `==` and `hashCode`. |
| Recurring overnight event never shows | Split it into two series (see above). |
| Recurring event survives `removeWhere` | Use `remove`, `removeAll` or `DeleteEvent.all`. |
| Weekly event on the wrong day | Check `weekdays` and that `startDate` equals the event `date`. |
| Series never ends | Set `endDate`, or use `withCalculatedEndDate` for `occurrences`. |
| Deleted occurrence still shows | Pass `date: tapped.withoutTime`. |
| `Cannot add to an unmodifiable list` | Don't pass `const` lists as `excludeDates` or `weekdays`. |
| Timed event shows in the all-day header | Give it a real start and end time (not both `00:00`). |
| Overnight event is cut off | Set `endDate` to the next day. |
| Moved event lost its time | `copyWith(date:)` replaced it; carry the time over. |
