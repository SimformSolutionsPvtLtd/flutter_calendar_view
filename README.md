![Plugin Banner](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/plugin_banner.png)

# calendar_view

[![Build](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/workflows/Build/badge.svg?branch=master)](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/actions) [![calendar_view](https://img.shields.io/pub/v/calendar_view?label=calendar_view)](https://pub.dev/packages/calendar_view)

A Flutter package allows you to easily implement all calendar UI and calendar event functionality.

For web demo visit [Calendar View Example](https://simformsolutionspvtltd.github.io/flutter_calendar_view/).

## Preview

![Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/demo.gif)

## Installing

1. Add dependencies to `pubspec.yaml`

   Get the latest version in the 'Installing' tab on [pub.dev](https://pub.dev/packages/calendar_view/install)

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

1. Wrap `MaterialApp` with `CalendarControllerProvider` and assign `EventController` to it.

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

   For more info on properties visit [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/calendar_view-library.html).

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

   As soon as you add or remove events from the controller, it will automatically update the calendar view assigned to that controller. See, [Use of EventController](#use-of-eventcontroller) for more info

4. Use `GlobalKey` to change the page or jump to a specific page or date. See, [Use of GlobalKey](#use-of-globalkey) for more info.

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
    }
    // This callback will only work if cellBuilder is null.
    onEventTap: (event, date) => print(event);
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
    showVerticalLine: true, // To display live time line in day view.
    showLiveTimeLineInAllDays: true, // To display live time line in all pages in day view.
    minMonth: DateTime(1990),
    maxMonth: DateTime(2050),
    initialMonth: DateTime(2021),
    heightPerMinute: 1, // height occupied by 1 minute time span.
    eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
    onEventTap: (events, date) => print(events),
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
    showLiveTimeLineInAllDays: true, // To display live time line in all pages in week view.
    width: 400, // width of week view.
    minMonth: DateTime(1990),
    maxMonth: DateTime(2050),
    initialMonth: DateTime(2021),
    heightPerMinute: 1, // height occupied by 1 minute time span.
    eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
    onEventTap: (events, date) => print(events),
);
```

To see the list of all parameters and detailed description of parameters visit [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/calendar_view-library.html).

### Use of `EventController`

`EventController` is used to add or remove events from the calendar view. When we add or remove events from the controller, it will automatically update all the views to which this controller is assigned.

Methods provided by `EventController`

| Name           | Parameters | Description |
|----------------|-----------|--------------|
| add            |CalendarEventData\<T\> event | Adds one event in controller and rebuilds view. |
| addAll         | List\<CalendarEventData\<T\>\> events | Adds list of events in controller and rebuilds view. |
| remove         | CalendarEventData\<T\> event | Removes an event from controller and rebuilds view. |
| getEventsOnDay | DateTime date | Returns list of events on `date` |

### Use of `GlobalKey`

User needs to define global keys to access functionalities like changing a page or jump to a specific page or date. Users can also access the `controller` assigned to respected view using the global key.

By assigning global keys to calendar views you can access methods and fields defined by state class of respected views.

Methods defined by `MonthViewState` class:

| Name | Parameters | Description |
|------|------------|-------------|
| nextPage | none | Jumps to next page. |
| previousPage | none | Jumps to the previous page. |
| jumpToPage | int page | Jumps to page index defined by `page`. |
| animateToPage | int page | Animate to page index defined by `page`. |
| jumpToMonth | DateTime month | Jumps to the page that has a calendar for month defined by `month` |
| animateToMonth | DateTime month | Animate to the page that has a calendar for month defined by `month` |

Methods defined by `DayViewState` class.

| Name | Parameters | Description |
|------|------------|-------------|
| nextPage | none | Jumps to next page. |
| previousPage | none | Jumps to the previous page. |
| jumpToPage | int page | Jumps to page index defined by `page`. |
| animateToPage | int page | Animate to page index defined by `page`. |
| jumpToDate | DateTime date | Jumps to the page that has a calendar for month defined by `date` |
| animateToDate | DateTime date | Animate to the page that has a calendar for month defined by `date` |

Methods defined by `WeekViewState` class.

| Name | Parameters | Description |
|------|------------|-------------|
| nextPage | none | Jumps to next page. |
| previousPage | none | Jumps to the previous page. |
| jumpToPage | int page | Jumps to page index defined by `page`. |
| animateToPage | int page | Animate to page index defined by `page`. |
| jumpToWeek | DateTime week | Jumps to the page that has a calendar for month defined by `week` |
| animateToWeek | DateTime week | Animate to the page that has a calendar for month defined by `week` |

### Synchronize events between calendar views

There are two ways to synchronize events between calendar views.

1. Provide the same `controller` object to all calendar views used in the project.
2. Wrap MaterialApp with `CalendarControllerProvider` and provide controller as argument as defined in [Implementation](#implementation).

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
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```