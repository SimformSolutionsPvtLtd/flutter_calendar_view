# Overview

This package is a comprehensive Flutter solution that enables you to easily implement calendar UI and calendar event functionality in your applications.

## Preview

![Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/demo.gif)


## Key Features

- Multiple calendar view options:
  - Month View
  - Day View
  - Week View
- Highly customisable UI components
- Manage events (add, remove, update)
- Manage reminders (add, remove, update)
- Manage full-day events (add, remove, update)
- Show working days in week view and day views
- Sync event data between multiple views

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
    onEventTapDetails: (event, data, details) => print('on tap details'),
    onEventDoubleTap: (event, data) => print('on double tap'),
    onEventDoubleTapDetails: (event, data, details) =>
      print('on double details'),
    onEventLongTap: (event, data) => print('on long tap'),
    onEventLongTapDetails: (event, data, details) =>
      print('on long tap details'),
    onDateLongPress: (date) => print(date),
    headerBuilder: MonthHeader.hidden, // To hide month header
    showWeekTileBorder: false, // To show or hide header border
    hideDaysNotInMonth: true, // To hide days or cell that are not in current month
    showWeekends: false, // To hide weekends default value is true
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
    liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
      color: Colors.red,
      showTime: true,
      // Support for different timezones - provide custom DateTime function
      currentTimeProvider: () {
        final utcNow = DateTime.now().toUtc();
        return utcNow.subtract(Duration(hours: 4));
        },
    ),
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

## Migrate from `1.x.x` to latest

1. Migrate `HeaderStyle`.
   ```dart
    // Old
    final style = HeaderStyle(
      headerTextStyle : TextStyle(),
      headerMargin : EdgeInsets.zero,
      headerPadding : EdgeInsets.zero,
      titleAlign : TextAlign.center,
      decoration : BoxDecoration(),
      mainAxisAlignment : MainAxisAlignment.spaceBetween,
      leftIcon : Icon(Icons.left),
      rightIcon : Icon(Icons.right),
      leftIconVisible : true,
      rightIconVisible : true,
      leftIconPadding : EdgeInsets.zero,
      rightIconPadding : EdgeInsets.zero,
    );
   ```
   ```dart 
   // After Migration
   
   // NOTE: leftIconVisible and rightIconVisible is removed in
   // latest version. set leftIconConfig and rightIconConfig null to
   // hide the respective icon.
   final style = HeaderStyle(
      headerTextStyle : TextStyle(),
      headerMargin : EdgeInsets.zero,
      headerPadding : EdgeInsets.zero,
      titleAlign : TextAlign.center,
      decoration : BoxDecoration(),
      mainAxisAlignment : MainAxisAlignment.spaceBetween,
      
      // Set this null to hide the left icon.
      leftIconConfig : IconDataConfig(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.left),
      ),
   
      // Set this null to hide the right icon.
      rightIconConfig :  IconDataConfig(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.right),
      ),
    );
   ```
2. Migrate `CalendarPageHeader` | `DayPageHeader` | `MonthPageHeader` | `WeekPageHeader`:
   ```dart
      // Old
      final header = MonthPageBuilder({
        date = DateTime.now(),
        dateStringBuilder = (date, {secondaryDate}) => '$date',
        backgroundColor = Constants.headerBackground,
        iconColor = Constants.black,
      });
   ```
   ```dart
      // After Migration
      final header = MonthPageBuilder({
        date = DateTime.now(),
        dateStringBuilder = (date, {secondaryDate}) => '$date',
        headerStyle = HeaderStyle.withSameIcons(
          decoration: BoxDecoration(
            color: Constants.headerBackground,
          ),       
          iconConfig: IconDataConfig(
            color: Constants.black,
          ),
        ),
      });
   ```

# Contributors

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/25323183?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65167856?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/36261739?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/56400956?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/69202025?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
|           [Vatsal Tanna](https://github.com/vatsaltanna)           |        [Sanket Kachhela](https://github.com/sanket-simform)        |          [Parth Baraiya](https://github.com/ParthBaraiya)          |        [Ujas Majithiya](https://github.com/Ujas-Majithiya)         |            [Rashi Shah](https://github.com/rashi-shah)             |

| ![img](https://avatars.githubusercontent.com/u/89002539?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/44993081?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65003381?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/72137369?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/81063988?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
|         [Faiyaz Shaikh](https://github.com/faiyaz-shaikh)          |        [Dhaval Kansara](https://github.com/DhavalRKansara)         |         [Apurva Kanthraviya](https://github.com/apurva780)         |         [Shubham Jitiya](https://github.com/ShubhamJitiya)         |           [Sahil Totala](https://github.com/Flamingloon)           |

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
