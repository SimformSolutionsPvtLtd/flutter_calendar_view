# Event Arranger

An interface to define how events will be arranged in week and day view.

Calendar View provide two implementation of this class:

- `MergeEventArranger`: This arranger merges overlapping events and make it one.

- `SideEventArranger`: This event arranger arranges overlapping events side by side.

## Methods

### arrange -> [List<OrganizedCalendarEventData>](organized_calendar_event_data.md)

Syntax:

```dart
List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
});

```

Override this method to define how events will be arranged.
