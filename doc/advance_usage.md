## More on the calendar view

### Optional configurations/parameters in Calendar view

For month view

```dart
MonthView(
    controller: EventController(),
    // to provide custom UI for month cells.
    cellBuilder: (date, events, isToday, isInMonth) {
        // Return your widget to display as month cell.
        return Container();
    },
    minMonth: DateTime(1990),
    maxMonth: DateTime(2050),
    initialMonth: DateTime(2021),
    cellAspectRatio: 1,
    onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
    onCellTap: (events, date) {
      // Implement callback when user taps on a cell.
      print(events);
    },
    startDay: WeekDays.sunday, // To change the first day of the week.
    // This callback will only work if cellBuilder is null.
    onEventTap: (event, date) => print(event),
    onEventDoubleTap: (events, date) => print(events),
    onEventLongTap: (event, date) => print(event),
    onDateLongPress: (date) => print(date),
    headerBuilder: MonthHeader.hidden, // To hide month header
    showWeekTileBorder: false, // To show or hide header border
    hideDaysNotInMonth: true, // To hide days or cell that are not in current month
);
```

For day view

```dart
DayView(
    controller: EventController(),
    eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return Container();
    },
    fullDayEventBuilder: (events, date) {
        // Return your widget to display full day event view.
        return Container();
    },
    showVerticalLine: true, // To display live time line in day view.
    showLiveTimeLineInAllDays: true, // To display live time line in all pages in day view.
    minDay: DateTime(1990),
    maxDay: DateTime(2050),
    initialDay: DateTime(2021),
    heightPerMinute: 1, // height occupied by 1 minute time span.
    eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
    onEventTap: (events, date) => print(events),
    onEventDoubleTap: (events, date) => print(events),
    onEventLongTap: (events, date) => print(events),
    onDateLongPress: (date) => print(date),
    startHour: 5 // To set the first hour displayed (ex: 05:00)
    endHour:20, // To set the end hour displayed
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
        return //Your custom painter.
    },
    dayTitleBuilder: DayHeader.hidden, // To Hide day header
    keepScrollOffset: true, // To maintain scroll offset when the page changes
);
```

For week view

```dart
WeekView(
    controller: EventController(),
    eventTileBuilder: (date, events, boundry, start, end) {
      // Return your widget to display as event tile.
      return Container();
    },
    fullDayEventBuilder: (events, date) {
      // Return your widget to display full day event view.
      return Container();
    },
    showLiveTimeLineInAllDays: true, // To display live time line in all pages in week view.
    width: 400, // width of week view.
    minDay: DateTime(1990),
    maxDay: DateTime(2050),
    initialDay: DateTime(2021),
    heightPerMinute: 1, // height occupied by 1 minute time span.
    eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
    onEventTap: (events, date) => print(events),
    onEventDoubleTap: (events, date) => print(events),
    onDateLongPress: (date) => print(date),
    startDay: WeekDays.sunday, // To change the first day of the week.
    startHour: 5, // To set the first hour displayed (ex: 05:00)
    endHour:20, // To set the end hour displayed
    showVerticalLines: false, // Show the vertical line between days.
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
        return //Your custom painter.
    },
    weekPageHeaderBuilder: WeekHeader.hidden, // To hide week header
    fullDayHeaderTitle: 'All day', // To set full day events header title
    fullDayHeaderTextConfig: FullDayHeaderTextConfig(
      textAlign: TextAlign.center,
      textOverflow: TextOverflow.ellipsis,
      maxLines: 2,
    ), // To set full day events header text config
    keepScrollOffset: true, // To maintain scroll offset when the page changes
);
```



To see the list of all parameters and detailed description of parameters
visit [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/calendar_view-library.html)
.

### Use of `EventController`

`EventController` is used to add or remove events from the calendar view. When
we add or remove
events from the controller, it will automatically update all the views to which
this controller is
assigned.

Methods provided by `EventController`

| Name            | Parameters                                                   | Description                                               |
|-----------------|--------------------------------------------------------------|-----------------------------------------------------------|
| add             | CalendarEventData\<T\> event                                 | Adds one event in controller and rebuilds view.           |
| addAll          | List\<CalendarEventData\<T\>\> events                        | Adds list of events in controller and rebuilds view.      |
| remove          | CalendarEventData\<T\> event                                 | Removes an event from controller and rebuilds view.       |
| removeAll       | List\<CalendarEventData\<T\>\> events                        | Removes all event defined in the list                     |
| removeWhere     | TestPredicate\<CalendarEventData\<T\>\> test                 | Removes all events for which test returns true.           |
| update          | CalendarEventData\<T\> event, CalendarEventData\<T\> updated | Updates event with updated event.                         |
| getFullDayEvent | DateTime date                                                | Returns the list of full day events stored in controller  |
| updateFilter    | EventFilter\<T\> newFilter                                   | Updates the event filter of the controller.               |
| getEventsOnDay  | DateTime date                                                | Returns list of events on `date`                          |

Check [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/EventController-class.html) for more info.

### Use of `GlobalKey`

User needs to define global keys to access functionalities like changing a page
or jump to a
specific page or date. Users can also access the `controller` assigned to
respected view using the
global key.

By assigning global keys to calendar views you can access methods and fields
defined by state class
of respected views.

Methods defined by `MonthViewState` class:

| Name           | Parameters     | Description                                                          |
|----------------|----------------|----------------------------------------------------------------------|
| nextPage       | none           | Jumps to next page.                                                  |
| previousPage   | none           | Jumps to the previous page.                                          |
| jumpToPage     | int page       | Jumps to page index defined by `page`.                               |
| animateToPage  | int page       | Animate to page index defined by `page`.                             |
| jumpToMonth    | DateTime month | Jumps to the page that has a calendar for month defined by `month`   |
| animateToMonth | DateTime month | Animate to the page that has a calendar for month defined by `month` |

Check [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/MonthViewState-class.html) for more info.


Methods defined by `DayViewState` class.

| Name              | Parameters              | Description                                                                                                |
|-------------------|-------------------------|------------------------------------------------------------------------------------------------------------|
| nextPage          | none                    | Jumps to next page.                                                                                        |
| previousPage      | none                    | Jumps to the previous page.                                                                                |
| jumpToPage        | int page                | Jumps to page index defined by `page`.                                                                     |
| animateToPage     | int page                | Animate to page index defined by `page`.                                                                   |
| jumpToDate        | DateTime date           | Jumps to the page that has a calendar for month defined by `date`                                          |
| animateToDate     | DateTime date           | Animate to the page that has a calendar for month defined by `date`                                        |
| animateToDuration | Duration duration       | Animate to the `duration` <br/>from where we want start the day DayView                                    |
| animateToEvent    | CalendarEventData event | Animates to the page where a given `event` is and then scrolls to make that `event` visible on the screen. |
| jumpToEvent       | CalendarEventData event | Jumps to the page where a given `event` is and then scrolls to make that `event` visible on the screen.    |

Check [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/DayViewState-class.html) for more info.

Methods defined by `WeekViewState` class.

| Name           | Parameters              | Description                                                                                                |
|----------------|-------------------------|------------------------------------------------------------------------------------------------------------|
| nextPage       | none                    | Jumps to next page.                                                                                        |
| previousPage   | none                    | Jumps to the previous page.                                                                                |
| jumpToPage     | int page                | Jumps to page index defined by `page`.                                                                     |
| animateToPage  | int page                | Animate to page index defined by `page`.                                                                   |
| jumpToWeek     | DateTime week           | Jumps to the page that has a calendar for month defined by `week`                                          |
| animateToWeek  | DateTime week           | Animate to the page that has a calendar for month defined by `week`                                        |
| animateToEvent | CalendarEventData event | Animates to the page where a given `event` is and then scrolls to make that `event` visible on the screen. |
| jumpToEvent    | CalendarEventData event | Jumps to the page where a given `event` is and then scrolls to make that `event` visible on the screen.    |

Check [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/WeekViewState-class.html) for more info.

### Synchronize events between calendar views

There are two ways to synchronize events between calendar views.

1. Provide the same `controller` object to all calendar views used in the
   project.
2. Wrap MaterialApp with `CalendarControllerProvider` and provide controller as
   argument as defined
   in [Implementation](#implementation).

### Show only working days in WeekView.

You can configure week view such that it displays only specific days. ex,

```dart
WeekView(
weekDays: [
WeekDays.monday,
WeekDays.tuesday,
WeekDays.wednesday,
WeekDays.thursday,
WeekDays.friday,
],
);
```

Above code will create `WeekView` with only five days, from monday to friday.