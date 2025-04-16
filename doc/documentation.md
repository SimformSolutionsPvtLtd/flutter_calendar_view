# Overview

This package is a comprehensive Flutter solution that enables you to easily implement calendar UI and calendar event functionality in your applications.

## Preview

![Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/demo.gif)


## Key Features

- Multiple calendar view options:
    - Month View
    - Day View
    - Week View
- Event management system
- Customizable UI components
- Support for event handling (add, remove, update)
- Navigation controls with page turning
- Date range selection
- Support for all-day events

This package provides a complete set of tools for implementing calendar functionality in your Flutter application, with extensive customization options to match your app's design and user experience requirements.

For a live web demo, visit [Calendar View Example](https://simformsolutionspvtltd.github.io/flutter_calendar_view/).

# Installation

Follow these steps to add the `calendar_view` package to your Flutter project:

## Step 1: Add dependency

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  calendar_view: <latest-version>
```

Get the latest version in the 'Installing' tab on [pub.dev](https://pub.dev/packages/calendar_view/install).

## Step 2: Install packages

Run the following command:

```bash
flutter pub get
```

## Step 3: Import the package

Add the following import to your Dart code:

```dart
import 'package:calendar_view/calendar_view.dart';
```

Now you're ready to use the calendar_view package in your Flutter application!

# Basic Usage

This guide covers the fundamental setup and implementation of the calendar_view package.

## Setup

First, wrap your `MaterialApp` with `CalendarControllerProvider` and assign an `EventController` to it:

```dart
CalendarControllerProvider(
    controller: EventController(),
    child: MaterialApp(
        // Your initialization for material app.
    ),
)
```

## Adding Calendar Views

### Month View

```dart
Scaffold(
    body: MonthView(),
);
```

### Day View

```dart
Scaffold(
    body: DayView(),
);
```

### Week View

```dart
Scaffold(
    body: WeekView(),
);
```

## Managing Events

### Adding an event

```dart
final event = CalendarEventData(
    date: DateTime(2021, 8, 10),
    event: "Event 1",
);

CalendarControllerProvider.of(context).controller.add(event);
```

### Adding events in a date range

```dart
final event = CalendarEventData(
    date: DateTime(2021, 8, 10),
    endDate: DateTime(2021, 8, 15),
    event: "Event 1",
);

CalendarControllerProvider.of(context).controller.add(event);
```

### Removing an event

```dart
CalendarControllerProvider.of(context).controller.remove(event);
```

As soon as you add or remove events from the controller, it will automatically update the calendar view assigned to that controller.

# Advanced Usage

This guide covers more advanced features and customization options for the calendar_view package.

## Month View Customization

```dart
MonthView(
    controller: EventController(),
    // Custom UI for month cells
    cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
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
    // Event callbacks
    onEventTap: (event, data) => print('on tap'),
    onEventDoubleTap: (event, data) => print('on double tap'),
    onEventLongTap: (event, data) => print('on long tap'),
    onDateLongPress: (date) => print(date),
    headerBuilder: MonthHeader.hidden, // To hide month header
    showWeekTileBorder: false, // To show or hide header border
    hideDaysNotInMonth: true, // To hide days not in current month
    showWeekends: false, // To hide weekends (default is true)
);
```

## Day View Customization

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
    startHour: 5, // To set the first hour displayed (ex: 05:00)
    endHour: 20, // To set the end hour displayed
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
        return // Your custom painter.
    },
    dayTitleBuilder: DayHeader.hidden, // To Hide day header
    keepScrollOffset: true, // To maintain scroll offset when the page changes
);
```

## Week View Customization

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
    startHour: 5, // To set the first hour displayed
    endHour: 20, // To set the end hour displayed
    showVerticalLines: false, // Show the vertical line between days.
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
        return // Your custom painter.
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

## Show Only Working Days in WeekView

You can configure the week view to display only specific days:

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

The above code will create a `WeekView` with only five days, from Monday to Friday.

## Synchronizing Events Between Calendar Views

There are two ways to synchronize events between calendar views:

1. Provide the same `controller` object to all calendar views used in the project.
2. Wrap MaterialApp with `CalendarControllerProvider` and provide controller as an argument.

# Migration Guides

This section provides guidance for migrating between different versions of the calendar_view package.

Currently, there are no specific migration guides available, as the package maintains backward compatibility between versions.

## Version Updates

When updating to a new version of calendar_view, check the [changelog](https://pub.dev/packages/calendar_view/changelog) for any breaking changes or new features that might require changes in your implementation.

## Best Practices for Updating

1. Always review the changelog before updating to a new version
2. Test your implementation thoroughly after updating
3. If you encounter issues, check the GitHub issues page for similar reports or solutions
4. If you're updating across multiple versions, consider updating incrementally to identify and address any breaking changes

## Getting Help

If you encounter difficulties during migration:

1. Check the [GitHub issues](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues) for similar problems
2. Ask for help in the Flutter community forums
3. Open a new issue on GitHub if you believe you've found a bug

# API References

## EventController

`EventController` is used to add or remove events from the calendar view. When we add or remove events from the controller, it will automatically update all the views to which this controller is assigned.

### Methods

| Name            | Parameters                                                   | Description                                                 |
|-----------------|--------------------------------------------------------------|-------------------------------------------------------------|
| add             | CalendarEventData\<T\> event                                 | Adds one event in controller and rebuilds view.             |
| addAll          | List\<CalendarEventData\<T\>\> events                        | Adds list of events in controller and rebuilds view.        |
| remove          | CalendarEventData\<T\> event                                 | Removes an event from controller and rebuilds view.         |
| removeAll       | List\<CalendarEventData\<T\>\> events                        | Removes all event defined in the list and rebuilds the view |
| clear           |                                                              | Removes events from the controller and rebuilds the view    |
| removeWhere     | TestPredicate\<CalendarEventData\<T\>\> test                 | Removes all events for which test returns true.             |
| update          | CalendarEventData\<T\> event, CalendarEventData\<T\> updated | Updates event with updated event.                           |
| getFullDayEvent | DateTime date                                                | Returns the list of full day events stored in controller    |
| updateFilter    | EventFilter\<T\> newFilter                                   | Updates the event filter of the controller.                 |
| getEventsOnDay  | DateTime date                                                | Returns list of events on `date`                            |

For more details, check the [EventController documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/EventController-class.html).

## Global Key Functionality

By assigning global keys to calendar views, you can access methods and fields defined by state classes of respected views.

### MonthViewState Methods

| Name           | Parameters     | Description                                                          |
|----------------|----------------|----------------------------------------------------------------------|
| nextPage       | none           | Jumps to next page.                                                  |
| previousPage   | none           | Jumps to the previous page.                                          |
| jumpToPage     | int page       | Jumps to page index defined by `page`.                               |
| animateToPage  | int page       | Animate to page index defined by `page`.                             |
| jumpToMonth    | DateTime month | Jumps to the page that has a calendar for month defined by `month`   |
| animateToMonth | DateTime month | Animate to the page that has a calendar for month defined by `month` |

For more details, check the [MonthViewState documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/MonthViewState-class.html).

### DayViewState Methods

| Name              | Parameters              | Description                                                                                                |
|-------------------|-------------------------|------------------------------------------------------------------------------------------------------------|
| nextPage          | none                    | Jumps to next page.                                                                                        |
| previousPage      | none                    | Jumps to the previous page.                                                                                |
| jumpToPage        | int page                | Jumps to page index defined by `page`.                                                                     |
| animateToPage     | int page                | Animate to page index defined by `page`.                                                                   |
| jumpToDate        | DateTime date           | Jumps to the page that has a calendar for month defined by `date`                                          |
| animateToDate     | DateTime date           | Animate to the page that has a calendar for month defined by `date`                                        |
| animateToDuration | Duration duration       | Animate to the `duration` from where we want start the day DayView                                    |
| animateToEvent    | CalendarEventData event | Animates to the page where a given `event` is and then scrolls to make that `event` visible on the screen. |
| jumpToEvent       | CalendarEventData event | Jumps to the page where a given `event` is and then scrolls to make that `event` visible on the screen.    |

For more details, check the [DayViewState documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/DayViewState-class.html).

### WeekViewState Methods

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

For more details, check the [WeekViewState documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/WeekViewState-class.html).

For complete API documentation, visit the [calendar_view documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/calendar_view-library.html).

# Contributors

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/25323183?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65167856?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/36261739?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/56400956?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
|           [Vatsal Tanna](https://github.com/vatsaltanna)           |        [Sanket Kachhela](https://github.com/sanket-simform)        |          [Parth Baraiya](https://github.com/ParthBaraiya)          |    [Ujas Majithiya](https://github.com/Ujas-Majithiya)    |

| ![img](https://avatars.githubusercontent.com/u/89002539?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/44993081?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65003381?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/72137369?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
|         [Faiyaz Shaikh](https://github.com/faiyaz-shaikh)          |        [Dhaval Kansara](https://github.com/DhavalRKansara)         |         [Apurva Kanthraviya](https://github.com/apurva780)         |         [Shubham Jitiya](https://github.com/ShubhamJitiya)         |

## Contributing

We welcome contributions to improve the calendar_view package. Please feel free to submit issues and
pull requests to the GitHub repository.

## More from Simform Solutions

Check out our other available [awesome mobile libraries](https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries).

# License

```
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
