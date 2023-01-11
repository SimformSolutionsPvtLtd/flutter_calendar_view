# CalendarEventData

Model class that defines event for calendar view.

## Properties

## date -> DateTime

Specifies date on which all these events are.

### startTime -> DateTime

Defines the start time of the event. [endTime] and [startTime] will defines time on same day.This is required when you are using [CalendarEventData] for [DayView]

### endTime -> DateTime?

Defines the end time of the event. [endTime] and [startTime] defines time on same day.This is required when you are using [CalendarEventData] for [DayView]

### title -> String

Title of the event.

### description -> String

Description of the event.

### color -> Color

Defines color of event.This color will be used in default widgets provided by plugin.

### event -> dynamic?

Event on [date]. This stores extra data about your event.
