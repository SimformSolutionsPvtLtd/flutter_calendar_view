# Every N weeks (workaround, not package API)

`RecurrenceSettings` has no interval. Define the series as weekly, then filter
by week parity in a controller subclass. The views read through `getEventsOnDay`,
and the all-day header reads through `getFullDayEvent`, so override both.

This overrides controller internals; if a later release adds an interval to
`RecurrenceSettings`, use that instead.

```dart
import 'package:calendar_view/calendar_view.dart';

class IntervalEventController<T> extends EventController<T> {
  IntervalEventController(this.weeksBetween);

  /// Weeks between occurrences of [e]; 1 means every week.
  final int Function(CalendarEventData<T> e) weeksBetween;

  bool _keep(CalendarEventData<T> e, DateTime day) {
    final n = weeksBetween(e);
    if (n <= 1 || e.recurrenceSettings == null) return true;
    final days = DateTime.utc(day.year, day.month, day.day)
        .difference(DateTime.utc(e.date.year, e.date.month, e.date.day))
        .inDays; // UTC so DST can't shift the count
    return (days ~/ 7) % n == 0;
  }

  @override
  List<CalendarEventData<T>> getEventsOnDay(
    DateTime date, {
    bool includeFullDayEvents = true,
  }) =>
      super
          .getEventsOnDay(date, includeFullDayEvents: includeFullDayEvents)
          .where((e) => _keep(e, date))
          .toList();

  @override
  List<CalendarEventData<T>> getFullDayEvent(DateTime date) =>
      super.getFullDayEvent(date).where((e) => _keep(e, date)).toList();
}
```

- Parity counts in 7-day blocks from the event's `date`. Keep `date` unchanged
  in `copyWith` and `update`, and start the series on its first weekday.
- Direct calls to `getRecurringEventsOnDay` still return every week.
