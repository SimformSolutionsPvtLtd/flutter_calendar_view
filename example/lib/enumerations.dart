/// Defines the type of calendar view.
enum CalendarView { month, day, week, multiday, schedule }

/// Defines the months of the year.
enum Months {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

/// A fixed, Google-Calendar-style set of predefined event types the user can
/// pick from on the create-event page.
///
/// [EventType.event] is the neutral default: picking it preconfigures nothing
/// and leaves the form at its plain defaults. Every other type carries a
/// preset (see [kEventTypeConfigs]) that seeds the color, the whole-day /
/// duration behaviour, and the default recurrence — all of which the user can
/// still override before saving.
enum EventType { event, birthday, task, outOfOffice, meeting, reminder }
