![Plugin Banner](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/plugin_banner.png)

# calendar_view

[![Build](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/workflows/Build/badge.svg?branch=master)](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/actions) [![calendar_view](https://img.shields.io/pub/v/calendar_view?label=calendar_view)](https://pub.dev/packages/calendar_view)

A Flutter package allows you to easily implement all calendar UI and calendar
event functionality.

For web demo
visit [Calendar View Example](https://simformsolutionspvtltd.github.io/flutter_calendar_view/).

## Preview

![Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/demo.gif)

## Installing

1. Add dependencies to `pubspec.yaml`

   Get the latest version in the 'Installing' tab
   on [pub.dev](https://pub.dev/packages/calendar_view/install)

    ```yaml
    dependencies:
        calendar_view: <latest-version>
    ```

2. Run pub get.

   ```shell
   flutter pub get
   ```

3. Import package.

    ```dart
    import 'package:calendar_view/calendar_view.dart';
    ```

## Implementation

1. Wrap `MaterialApp` with `CalendarControllerProvider` and
   assign `EventController` to it.

    ```dart
    CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
            // Your initialization for material app.
        ),
    )
    ```

2. Add calendar views.

   For Month View

    ```dart
    Scaffold(
        body: MonthView(),
    );
    ```

   For Day View

    ```dart
    Scaffold(
        body: DayView(),
    );
    ```

   For Week view

    ```dart
    Scaffold(
        body: WeekView(),
    );
    ```

   For more info on properties
   visit [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/calendar_view-library.html)
   .

3. Use `controller` to add or remove events.

   To Add event:

    ```dart
    final event = CalendarEventData(
        date: DateTime(2021, 8, 10),
        event: "Event 1",
    );

    CalendarControllerProvider.of(context).controller.add(event);
    ```

   To Add events in range of dates:

   ```dart
   final event = CalendarEventData(
           date: DateTime(2021, 8, 10),
           endDate: DateTime(2021,8,15),
           event: "Event 1",
       );

       CalendarControllerProvider.of(context).controller.add(event);
   ```

   To Remove event:

    ```dart
    CalendarControllerProvider.of(context).controller.remove(event);
    ```

   As soon as you add or remove events from the controller, it will
   automatically update the
   calendar view assigned to that controller.
   See, [Use of EventController](#use-of-eventcontroller)
   for more info

4. Use `GlobalKey` to change the page or jump to a specific page or date.
   See, [Use of GlobalKey](#use-of-globalkey) for more info.

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

## Main Contributors

<table>
  <tr>
    <td align="center"><a href="https://github.com/vatsaltanna"><img src="https://avatars.githubusercontent.com/u/25323183?s=100" width="100px;" alt=""/><br /><sub><b>Vatsal Tanna</b></sub></a></td>
    <td align="center"><a href="https://github.com/sanket-simform"><img src="https://avatars.githubusercontent.com/u/65167856?v=4" width="100px;" alt=""/><br /><sub><b>Sanket Kachhela</b></sub></a></td>
    <td align="center"><a href="https://github.com/ParthBaraiya"><img src="https://avatars.githubusercontent.com/u/36261739?v=4" width="100px;" alt=""/><br /><sub><b>Parth Baraiya</b></sub></a></td>
    <td align="center"><a href="https://github.com/ujas-m-simformsolutions"><img src="https://avatars.githubusercontent.com/u/76939001?v=4" width="100px;" alt=""/><br /><sub><b>Ujas Majithiya</b></sub></a></td>
    <td align="center"><a href="https://github.com/AnkitPanchal10"><img src="https://avatars.githubusercontent.com/u/38405884?s=100" width="100px;" alt=""/><br /><sub><b>Ankit Panchal</b></sub></a></td>
    <td align="center"><a href="https://github.com/MehulKK"><img src="https://avatars.githubusercontent.com/u/60209725?s=100" width="100px;" alt=""/><br /><sub><b>Mehul Kabaria</b></sub></a></td>
    <td align="center"><a href="https://github.com/faiyaz-shaikh"><img src="https://avatars.githubusercontent.com/u/89002539?v=4" width="100px;" alt=""/><br /><sub><b>Faiyaz Shaikh</b></sub></a></td>
    <td align="center"><a href="https://github.com/DhavalRKansara"><img 
    src="https://avatars.githubusercontent.com/u/44993081?v=4" width="100px;" 
    alt=""/><br /><sub><b>Dhaval Kansara</b></sub></a></td>
    <td align="center"><a href="https://github.com/apurva780"><img src="https://avatars.githubusercontent.com/u/65003381?v=4" width="100px;" alt=""/><br /><sub><b>Apurva Kanthraviya</b></sub></a></td>
</tr>
</table>
<br/>

## Awesome Mobile Libraries

- Check out our other
  available [awesome mobile libraries](https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries)

## License

```text
MIT License

Copyright (c) 2021 Simform Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```