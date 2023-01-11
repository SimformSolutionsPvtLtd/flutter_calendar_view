# EventController

Calendar controller to control all the events related operations like, adding event, removing event, etc.

## Constructor

```dart
EventController(
  {EventFilter? filter}
);
```

## Properties

### events -> [List<CalendarEventData>](calendar_event_data.md)

Returns list of events stored in controller.

### eventFilter -> [EventFilter?](typedefs.md)

This property will provide list of events on given date. This method is useful when you have recurring events. As of now **Calendar View** library does not support recurring events by default. You can implement same behaviour in this function. This function will overwrite default behaviour of `getEventsOnDay` function which will be used to display events on given day in [MonthView](month_view.md), [DayView](day_view.md) and [WeekView](week_view.md).

## Methods

### add

Syntax:

```dart
void add(CalendarEventData event);
```

Adds a single event in controller if event does not exist in controller. If event is successfully added in controller it will rebuild calendar view UI.

### addAll

```dart
void addAll(List<CalendarEventData> events);
```

Adds multiple events in controller. It will add only those events that are not in controller.

### remove

```dart
void remove(CalendarEventData event);
```

Removes event from controller.

### getEventOnDay

```dart
List<CalendarEventData> getEventsOnDay(DateTime date);
```

Returns list of events on given date. Default behaviour of this method is to compare [CalendarEventData.date](calendar_event_data.md) with date and return list of events having matching date. If `eventFilter` argument is provided, it will override default behaviour this method and will have same behaviour as `eventFilter`. This method is called internally by [MonthView](month_view.md), [DayView](day_view.md) and [WeekView](week_view.md) to display events on given date.
