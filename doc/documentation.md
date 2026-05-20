# Overview

This package is a comprehensive Flutter solution that enables you to easily implement calendar UI and calendar event functionality in your applications.

## Preview

![Preview](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_calendar_view/master/readme_assets/demo.gif)


## Key Features

- Multiple calendar view options:
  - Month View
  - Day View
  - Week View
  - MultiDay View
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

### MultiDay View

```dart
Scaffold(
    body: MultiDayView(),
);
```

## Managing Events

### Adding an event

To add an event, create a `CalendarEventData` object and call the `add` method of your `EventController`.

```dart
final event = CalendarEventData(
    date: DateTime(2021, 8, 10),
    title: "Project Meeting",
    description: "Discussing project progress",
    startTime: DateTime(2021, 8, 10, 10, 0),
    endTime: DateTime(2021, 8, 10, 11, 0),
    color: Colors.blue,
);

CalendarControllerProvider.of(context).controller.add(event);
```

### Adding events in a date range

You can add events that span multiple days by providing an `endDate`.

```dart
final event = CalendarEventData(
    date: DateTime(2021, 8, 10),
    endDate: DateTime(2021, 8, 15),
    title: "Vacation",
);

CalendarControllerProvider.of(context).controller.add(event);
```

### Updating an event

To update an existing event, use the `update` method. You can use `copyWith` to create a new event object with updated values.

```dart
final updatedEvent = event.copyWith(
    title: "Updated Project Meeting",
);

CalendarControllerProvider.of(context).controller.update(event, updatedEvent);
```

### Removing an event

```dart
CalendarControllerProvider.of(context).controller.remove(event);
```

As soon as you add, update, or remove events from the controller, it will automatically update the calendar view assigned to that controller.

# Advanced Usage

This guide covers more advanced features and customization options for the calendar_view package.

## Month View Customization

```dart
MonthView(
    controller: EventController(),
    width: 400, // Width of month view (if null, uses MediaQuery width)
    selectedDate: DateTime(2021, 8, 10), // Controls selected date in month grid
    // Set of dates that are selected via long press and drag
    multiDateSelectionRange: {DateTime(2021, 8, 12), DateTime(2021, 8, 13)},
    multiDateSelectionColor: Colors.blue.withOpacity(0.3), // Color of selected date cells
    monthViewBuilders: MonthViewBuilders(
      // Custom UI for month cells
      cellBuilder: (date, events, isToday, isInMonth, isSelected, hideDaysNotInMonth) {
        // Return your widget to display as month cell.
        return Container();
      },
      onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
      onCellTap: (events, date) {
        // Implement callback when user taps on a cell.
        // Update selectedDate here if you want controlled selection.
        print(events);
      },
      // Event callbacks
      onEventTap: (event, date) => print('on tap'),
      onEventTapDetails: (event, date, details) => print('on tap details'),
      onEventDoubleTap: (event, date) => print('on double tap'),
      onEventDoubleTapDetails: (event, date, details) =>
        print('on double details'),
      onEventLongTap: (event, data) => print('on long tap'),
      onEventLongTapDetails: (event, data, details) =>
        print('on long tap details'),
      onDateLongPress: (date) => print(date),
      headerBuilder: MonthHeader.hidden, // To hide month header
    ),
    monthViewStyle: MonthViewStyle(
      minMonth: DateTime(1990),
      maxMonth: DateTime(2050),
      initialMonth: DateTime(2021),
      cellAspectRatio: 1,
      startDay: WeekDays.sunday, // To change the first day of the week.
      showWeekTileBorder: false, // To show or hide header border
      hideDaysNotInMonth: true, // To hide days or cell that are not in current month
      showWeekends: false, // To hide weekends default value is true
      useAvailableVerticalSpace: true, // To fill the available vertical space
    ),
    monthViewThemeSettings: MonthViewThemeSettings(
      selectedHighlightColor: Colors.blue,
      selectedTitleColor: Colors.white,
      cellsInMonthHighlightColor: Colors.blue.shade100,
      weekDayTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
);
```

## Day View Customization

```dart
DayView(
    controller: EventController(),
    // Custom date string formatter for I18n
    dateStringBuilder: (date) => '${date.day}/${date.month}/${date.year}',
    // Custom time string formatter for I18n
    timeStringBuilder: (date) => '${date.hour}:${date.minute}',
    // Custom timeline widget builder
    timeLineBuilder: (date) => Text(date.toString()),
    // Custom day header builder
    dayTitleBuilder: DayHeader.hidden,
    // Custom press detector widget
    dayDetectorBuilder: ({date, height, width, heightPerMinute, minuteSlotSize}) => Container(),
    eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return Container();
    },
    fullDayEventBuilder: (events, date) {
        // Return your widget to display full day event view.
        return Container();
    },
    // Time and date boundaries
    minDay: DateTime(1990),
    maxDay: DateTime(2050),
    initialDay: DateTime(2021),
    heightPerMinute: 1, // Height occupied by 1 minute time span.
    timeLineWidth: 60, // Width of the timeline
    showVerticalLine: true, // Display vertical line in day view.
    verticalLineOffset: 5, // Offset of vertical line from hour line
    backgroundColor: Colors.white, // Background color of day view
    showLiveTimeLineInAllDays: true, // Display live time line in all pages
    scrollOffset: 0, // Initial scroll position
    width: 400, // Width of day view page
    timeLineOffset: 0, // Offset for timeline
    // Event handling
    eventArranger: SideEventArranger(), // Define how simultaneous events are arranged
    onEventTap: (events, date) => print(events),
    onEventDoubleTap: (events, date) => print(events),
    onEventLongTap: (events, date) => print(events),
    onDateLongPress: (date) => print(date),
    onDateTap: (date) => print('Tapped: $date'),
    onTimestampTap: (date) => print('Timestamp tapped: $date'),
    // Hour settings
    startHour: 5, // To set the first hour displayed (ex: 05:00)
    endHour: 20, // To set the end hour displayed
    // Custom hour line painter
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset, lineStyle, dashWidth, dashSpaceWidth, emulateVerticalOffsetBy, startHour, endHour) {
        return // Your custom painter.
    },
    // Hour indicator settings
    hourIndicatorSettings: HourIndicatorSettings(
      color: Colors.grey,
      lineStyle: LineStyle.solid,
    ),
    halfHourIndicatorSettings: HourIndicatorSettings(
      color: Colors.grey.shade300,
      lineStyle: LineStyle.solid,
    ),
    quarterHourIndicatorSettings: HourIndicatorSettings(
      color: Colors.grey.shade200,
      lineStyle: LineStyle.solid,
    ),
    // Live time indicator
    liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
      color: Colors.red,
      showTime: true,
      // Support for different timezones - provide custom DateTime function
      currentTimeProvider: () => DateTime.now(),
    ),
    // Page transition settings
    pageTransitionDuration: Duration(milliseconds: 300),
    pageTransitionCurve: Curves.ease,
    // Minute slot size for long press callbacks
    minuteSlotSize: MinuteSlotSize.minutes60,
    // Scroll physics
    scrollPhysics: ScrollPhysics(), // ScrollPhysics for vertical scrolling
    pageViewPhysics: ScrollPhysics(), // ScrollPhysics for horizontal page transitions
    // Header and safe area
    headerStyle: HeaderStyle(
      headerTextStyle: TextStyle(fontSize: 18),
      decoration: BoxDecoration(color: Colors.blue),
    ),
    safeAreaOption: SafeAreaOption.all(),
    // Miscellaneous
    keepScrollOffset: true, // Maintain scroll offset when the page changes
);
```

## Week View Customization

```dart
WeekView(
    controller: EventController(),
    // Custom builders
    eventTileBuilder: (date, events, boundry, start, end) {
      // Return your widget to display as event tile.
      return Container();
    },
    timeLineBuilder: (date) => Text(date.toString()),
    weekPageHeaderBuilder: WeekHeader.hidden, // To hide week header
    weekDetectorBuilder: ({date, height, width, heightPerMinute, minuteSlotSize}) => Container(),    weekDayBuilder: (date) => Text(date.day.toString()),
    weekNumberBuilder: (weekNumber) => Text('W$weekNumber'),
    // Custom string builders for I18n
    headerStringBuilder: (date, {secondaryDate}) => '${date.month}/${date.year}',
    timeLineStringBuilder: (date) => '${date.hour}:${date.minute}',
    weekDayStringBuilder: (weekDay) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekDay],
    weekDayDateStringBuilder: (date) => '${date.day}',
    fullDayEventBuilder: (events, date) {
      // Return your widget to display full day event view.
      return Container();
    },
    // Time and date boundaries
    minDay: DateTime(1990),
    maxDay: DateTime(2050),
    initialDay: DateTime(2021),
    heightPerMinute: 1, // Height occupied by 1 minute time span.
    timeLineWidth: 60, // Width of time line
    timeLineOffset: 0, // Offset of time line
    width: 400, // Width of week view
    // Week configuration
    weekTitleHeight: 50, // Height of week day title
    weekTitleBackgroundColor: Colors.grey.shade200, // Background color of week title
    showVerticalLines: false, // Show the vertical line between days
    showWeekends: true, // Show weekends or not
    showWeekDayAtBottom: false, // Show week day at bottom position
    showLiveTimeLineInAllDays: true, // Display live time line in all pages
    showHalfHours: false, // Show half hour indicator
    showQuarterHours: false, // Show quarter hour indicator
    showMidnightHour: false, // Show 00:00 (midnight) hour in timeline
    // Week days configuration
    weekDays: [
      WeekDays.monday,
      WeekDays.tuesday,
      WeekDays.wednesday,
      WeekDays.thursday,
      WeekDays.friday,
    ],
    startDay: WeekDays.sunday, // Change the first day of the week
    // Event handling
    eventArranger: SideEventArranger(), // Define how simultaneous events will be arranged
    onEventTap: (events, date) => print(events),
    onEventDoubleTap: (events, date) => print(events),
    onEventLongTap: (events, date) => print(events),
    onDateLongPress: (date) => print(date),
    onDateTap: (date) => print('Tapped: $date'),
    onTimestampTap: (date) => print('Timestamp tapped: $date'),
    onHeaderTitleTap: () => print('Header tapped'),
    // Hour settings
    startHour: 5, // Set the first hour displayed
    endHour: 20, // Set the end hour displayed
    emulateVerticalOffsetBy: 0, // Emulates offset of vertical line from hour line
    // Hour indicator settings
    hourIndicatorSettings: HourIndicatorSettings(
      color: Colors.greenAccent,
      lineStyle: LineStyle.dashed,
    ),
    halfHourIndicatorSettings: HourIndicatorSettings(
      color: Colors.redAccent,
      lineStyle: LineStyle.dashed,
    ),
    quarterHourIndicatorSettings: HourIndicatorSettings(
      color: Colors.blueAccent,
      lineStyle: LineStyle.dashed,
    ),
    // Custom hour line painter
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset, lineStyle, dashWidth, dashSpaceWidth, emulateVerticalOffsetBy, startHour, endHour) {
      return // Your custom painter.
    },
    // Live time indicator
    liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
      color: Colors.red,
      showTime: true,
      // Support for different timezones - provide custom DateTime function
      currentTimeProvider: () {
        final utcNow = DateTime.now().toUtc();
        return utcNow.subtract(Duration(hours: 4));
      },
    ),
    // Divider settings
    dividerSettings: DividerSettings(
      thickness: 2,
      height: 2,
      color: Colors.blueAccent,
      indent: 10,
      endIndent: 10,
    ),
    // Page transition settings
    pageTransitionDuration: Duration(milliseconds: 300),
    pageTransitionCurve: Curves.ease,
    // Minute slot size for long press callbacks
    minuteSlotSize: MinuteSlotSize.minutes60,
    // Background color
    backgroundColor: Colors.white,
    // Full day header configuration
    fullDayHeaderTitle: 'All day',
    fullDayHeaderTextConfig: FullDayHeaderTextConfig(
      textAlign: TextAlign.center,
      textOverflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
    // Scroll configuration  
    scrollOffset: 0.0,
    scrollPhysics: ScrollPhysics(), // ScrollPhysics for vertical scrolling
    pageViewPhysics: ScrollPhysics(), // ScrollPhysics for page view
    keepScrollOffset: true, // Maintain scroll offset when the page changes
    // Header and safe area
    headerStyle: HeaderStyle(
      headerTextStyle: TextStyle(fontSize: 18),
      decoration: BoxDecoration(color: Colors.blue),
    ),
    safeAreaOption: SafeAreaOption.all(),
    // Time slot color builder for highlighting unavailable hours
    timeSlotColorBuilder: (date, slotStartTime, slotEndTime, index) => 
        slotStartTime.hour >= 9 && slotStartTime.hour < 17 
            ? Colors.transparent 
            : Colors.grey.shade200,
    onPageChange: (date, pageIndex) => print("$date, Page: $pageIndex"),
);
```

## MultiDay View Customization

```dart
MultiDayView(
    controller: EventController(),
    // Custom builders
    eventTileBuilder: (date, events, boundry, start, end) {
      // Return your widget to display as event tile.
      return Container();
    },
    timeLineBuilder: (date) => Text(date.toString()),
    weekPageHeaderBuilder: WeekHeader.hidden, // To hide week header
    weekDetectorBuilder: ({date, height, width, heightPerMinute, minuteSlotSize}) => Container(),    weekDayBuilder: (date) => Text(date.day.toString()),
    weekNumberBuilder: (weekNumber) => Text('W$weekNumber'),
    // Custom string builders for I18n
    headerStringBuilder: (date, {secondaryDate}) => '${date.month}/${date.year}',
    timeLineStringBuilder: (date) => '${date.hour}:${date.minute}',
    weekDayStringBuilder: (weekDay) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekDay],
    weekDayDateStringBuilder: (date) => '${date.day}',
    fullDayEventBuilder: (events, date) {
      // Return your widget to display full day event view.
      return Container();
    },
    // Time and date boundaries
    minDay: DateTime(1990),
    maxDay: DateTime(2050),
    initialDay: DateTime(2021),
    heightPerMinute: 1, // Height occupied by 1 minute time span.
    timeLineWidth: 60, // Width of time line
    timeLineOffset: 0, // Offset of time line
    width: 400, // Width of multi-day view
    // Multi-day configuration
    daysInView: 3, // Number of days to display (default is 3)
    weekTitleHeight: 50, // Height of week day title
    showVerticalLines: true, // Show the vertical line between days
    showWeekDayAtBottom: false, // Show week day at bottom position
    showLiveTimeLineInAllDays: true, // Display live time line in all pages
    showHalfHours: false, // Show half hour indicator
    showQuarterHours: false, // Show quarter hour indicator
    showWeekDayBottomLine: true, // Display workday bottom line
    // Event handling
    eventArranger: SideEventArranger(), // Define how simultaneous events will be arranged
    onEventTap: (events, date) => print(events),
    onEventDoubleTap: (events, date) => print(events),
    onEventLongTap: (events, date) => print(events),
    onDateLongPress: (date) => print(date),
    onDateTap: (date) => print('Tapped: $date'),
    onTimestampTap: (date) => print('Timestamp tapped: $date'),
    onHeaderTitleTap: () => print('Header tapped'),
    // Hour settings
    startHour: 5, // Set the first hour displayed
    endHour: 20, // Set the end hour displayed
    emulateVerticalOffsetBy: 0, // Emulates offset of vertical line from hour line
    // Hour indicator settings
    hourIndicatorSettings: HourIndicatorSettings(
      color: Colors.greenAccent,
      lineStyle: LineStyle.dashed,
    ),
    halfHourIndicatorSettings: HourIndicatorSettings(
      color: Colors.redAccent,
      lineStyle: LineStyle.dashed,
    ),
    quarterHourIndicatorSettings: HourIndicatorSettings(
      color: Colors.blueAccent,
      lineStyle: LineStyle.dashed,
    ),
    // Custom hour line painter
    hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset, lineStyle, dashWidth, dashSpaceWidth, emulateVerticalOffsetBy, startHour, endHour) {
      return // Your custom painter.
    },
    // Live time indicator
    liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
      color: Colors.red,
      showTime: true,
      // Support for different timezones - provide custom DateTime function
      currentTimeProvider: () => DateTime.now(),
    ),
    // Divider settings
    dividerSettings: DividerSettings(
      thickness: 2,
      height: 2,
      color: Colors.blueAccent,
      indent: 10,
      endIndent: 10,
    ),
    // Page transition settings
    pageTransitionDuration: Duration(milliseconds: 300),
    pageTransitionCurve: Curves.ease,
    // Minute slot size for long press callbacks
    minuteSlotSize: MinuteSlotSize.minutes60,
    // Background color
    backgroundColor: Colors.white,
    // Full day header configuration
    fullDayHeaderTitle: 'All day',
    fullDayHeaderTextConfig: FullDayHeaderTextConfig(
      textAlign: TextAlign.center,
      textOverflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
    // Scroll configuration  
    scrollOffset: 0.0,
    scrollPhysics: ScrollPhysics(), // ScrollPhysics for vertical scrolling
    pageViewPhysics: ScrollPhysics(), // ScrollPhysics for page view
    keepScrollOffset: true, // Maintain scroll offset when the page changes
    // Header and safe area
    headerStyle: HeaderStyle(
      headerTextStyle: TextStyle(fontSize: 18),
      decoration: BoxDecoration(color: Colors.blue),
    ),
    safeAreaOption: SafeAreaOption.all(),
    onPageChange: (date, pageIndex) => print("$date, Page: $pageIndex"),
);
```

## Show Only Working Days in `WeekView`

You can control visible weekdays using the `weekDays` parameter:

```dart
WeekView(
  weekDays: const [
    WeekDays.monday,
    WeekDays.tuesday,
    WeekDays.wednesday,
    WeekDays.thursday,
    WeekDays.friday,
  ],
  showWeekends: false,
);
```

This renders Monday-Friday only. Duplicate entries are ignored, and `showWeekends: false` removes weekend days even if they are included in `weekDays`.

## Synchronizing Events Between Calendar Views

To keep `DayView`, `WeekView`, `MonthView`, and `MultiDayView` in sync, use a single shared `EventController<T>`.

### Option 1: Pass the same controller directly

```dart
final controller = EventController();

MonthView(controller: controller);
WeekView(controller: controller);
DayView(controller: controller);
MultiDayView(controller: controller);
```

### Option 2: Use `CalendarControllerProvider`

```dart
CalendarControllerProvider(
  controller: EventController(),
  child: MaterialApp(
    home: const CalendarScreen(),
  ),
);
```

When a view does not receive `controller` directly, it reads the controller from `CalendarControllerProvider`.

# Localization Guide

This guide covers localization support in `calendar_view` and how to keep localized strings aligned with the package API.

## Overview

`calendar_view` localization supports:

- AM/PM labels and the "more" text
- Weekday abbreviations
- Optional localized number mapping
- RTL layout support (`isRTL`)
- Runtime locale switching

## Built-in Language Support

The package includes **8 pre-configured languages** out of the box:

| Language | Code | RTL | Localized Numbers |
|----------|------|-----|-------------------|
| English | `en` | No | No |
| Spanish (Español) | `es` | No | No |
| Arabic (العربية) | `ar` | Yes | Yes (٠-٩) |
| French (Français) | `fr` | No | No |
| German (Deutsch) | `de` | No | No |
| Hindi (हिन्दी) | `hi` | No | Yes (०-९) |
| Chinese (简体中文) | `zh` | No | No |
| Japanese (日本語) | `ja` | No | No |

You can use these built-in languages directly without any configuration!

## Quick Start

### Using Built-in Languages

```dart
import 'package:calendar_view/calendar_view.dart';

void main() {
  // Switch to Spanish
  PackageStrings.setLocale('es');

  // Switch to Arabic (includes RTL and Arabic numerals)
  PackageStrings.setLocale('ar');

  // Switch to Hindi (includes Devanagari numerals)
  PackageStrings.setLocale('hi');

  runApp(MyApp());
}
```

### Add or override locales

```dart
PackageStrings.addLocaleObject(
  'pt',
  const CalendarLocalizations(
    am: 'AM',
    pm: 'PM',
    more: 'Mais',
    weekdays: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'],
  ),
);

PackageStrings.setLocale('pt');
```

`addLocaleObject` also overrides an existing locale when the same key is reused.

### Access built-in localization objects

```dart
final spanish = PackageStrings.spanish;
final arabic = PackageStrings.arabic;
final french = PackageStrings.french;
final german = PackageStrings.german;
final hindi = PackageStrings.hindi;
final chinese = PackageStrings.chinese;
final japanese = PackageStrings.japanese;
```
To set the current locale, use `PackageStrings.setLocale`.

## API Reference

### `CalendarLocalizations`

A class that holds all localizable strings for the calendar.

```dart
const CalendarLocalizations({
  required String am,             // AM suffix (e.g., 'am', 'a. m.')
  required String pm,             // PM suffix (e.g., 'pm', 'p. m.')
  required String more,           // "More" text for additional events
  required List<String> weekdays, // Weekday abbreviations [Mon-Sun]
  List<String>? numbers,          // Localized numbers 0-60 (61 elements)
  bool isRTL = false,             // Right-to-left layout
});
```

- `numbers` defaults to `['0'...'9']` when omitted.
- For full numeric localization via `PackageStrings.localizeNumber`, provide values for `0..60`.

Factory constructor:

```dart
factory CalendarLocalizations.fromMap(Map<String, dynamic> map)
```

Built-in English object:

```dart
CalendarLocalizations.en // English (default)
```

### `PackageStrings`

A static class for managing calendar localizations at runtime.

#### Methods

| Method | Description |
|--------|-------------|
| `addLocaleObject(String locale, CalendarLocalizations localeObj)` | Register a new locale |
| `setLocale(String locale)` | Set the active locale |
| `localizeNumber(int number)` | Convert a number to localized string |

#### Properties

| Property | Description |
|----------|-------------|
| `currentLocale` | Get the current `CalendarLocalizations` object |
| `selectedLocale` | Get the current locale code (e.g., 'en', 'es') |

## Complete Integration Example

```dart
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLocale = 'en';

  @override
  void initState() {
    super.initState();
    _registerCustomLocales();
  }

  void _registerCustomLocales() {
    PackageStrings.addLocaleObject(
      'es',
      const CalendarLocalizations(
        am: 'a. m.',
        pm: 'p. m.',
        more: 'Más',
        weekdays: ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
      ),
    );
  }

  void _changeLocale(String locale) {
    setState(() {
      _currentLocale = locale;
      PackageStrings.setLocale(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        locale: Locale(_currentLocale),
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('ar'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Calendar Localization Demo'),
            actions: [
              PopupMenuButton<String>(
                onSelected: _changeLocale,
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'en', child: Text('English')),
                  PopupMenuItem(value: 'es', child: Text('Español')),
                  PopupMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
            ],
          ),
          body: const MonthView(),
        ),
      ),
    );
  }
}
```

# Customise theme
The package supports dark mode out of the box. Each calendar view has a dedicated theme data class with `.light()` and `.dark()` named constructors for quick setup.

## Theme data classes

| Class | View |
|-------|------|
| `MonthViewThemeData` | `MonthView` |
| `DayViewThemeData` | `DayView` |
| `WeekViewThemeData` | `WeekView` |
| `MultiDayViewThemeData` | `MultiDayView` |

## Default colours

### MonthViewThemeData

| Property | Default (light) |
|----------|----------------|
| `cellInMonthColor` | `surfaceContainerLowest` |
| `cellNotInMonthColor` | `surfaceContainerLow` |
| `cellTextColor` | `onSurface` |
| `cellBorderColor` | `surfaceContainerHigh` |
| `cellHighlightColor` | `primary` |
| `weekDayTileColor` | `surfaceContainerHigh` |
| `weekDayTextColor` | `onSurface` |
| `weekDayBorderColor` | `outlineVariant` |
| `headerIconColor` | `onPrimary` |
| `headerTextColor` | `onPrimary` |
| `headerBackgroundColor` | `primary` |

### DayViewThemeData

| Property | Default (light) |
|----------|----------------|
| `hourLineColor` | `surfaceContainerHighest` |
| `halfHourLineColor` | `surfaceContainerHighest` |
| `quarterHourLineColor` | `surfaceContainerHighest` |
| `pageBackgroundColor` | `surfaceContainerLowest` |
| `liveIndicatorColor` | `primary` |
| `timelineTextColor` | `onSurface` |
| `headerIconColor` | `onPrimary` |
| `headerTextColor` | `onPrimary` |
| `headerBackgroundColor` | `primary` |

### WeekViewThemeData

| Property | Default (light) |
|----------|----------------|
| `weekDayTileColor` | `surfaceContainerHigh` |
| `weekDayTextColor` | `onSurface` |
| `hourLineColor` | `surfaceContainerHighest` |
| `halfHourLineColor` | `surfaceContainerHighest` |
| `quarterHourLineColor` | `surfaceContainerHighest` |
| `liveIndicatorColor` | `primary` |
| `pageBackgroundColor` | `surfaceContainerLowest` |
| `timelineTextColor` | `onSurface` |
| `borderColor` | `surfaceContainerHighest` |
| `verticalLinesColor` | `surfaceContainerHighest` |
| `headerIconColor` | `onPrimary` |
| `headerTextColor` | `onPrimary` |
| `headerBackgroundColor` | `primary` |

### MultiDayViewThemeData

| Property | Default (light) |
|----------|----------------|
| `multiDayTileColor` | `surfaceContainerHigh` |
| `multiDayTextColor` | `onSurface` |
| `hourLineColor` | `surfaceContainerHighest` |
| `halfHourLineColor` | `surfaceContainerHighest` |
| `quarterHourLineColor` | `surfaceContainerHighest` |
| `liveIndicatorColor` | `primary` |
| `pageBackgroundColor` | `surfaceContainerLowest` |
| `timelineTextColor` | `onSurface` |
| `borderColor` | `surfaceContainerHighest` |
| `verticalLinesColor` | `surfaceContainerHighest` |
| `headerIconColor` | `onPrimary` |
| `headerTextColor` | `onPrimary` |
| `headerBackgroundColor` | `primary` |

To customise `MonthView`, `DayView`, `WeekView` & `MultiDayView` page header use `HeaderStyle`.

```dart
  headerStyle: HeaderStyle(
        leftIconConfig: IconDataConfig(color: Colors.red),
        rightIconConfig: IconDataConfig(color: Colors.red),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
        ),
      ),
```

### Theme implementation approaches

There are two main ways to customize the theme for calendar views:

1. **Using `CalendarThemeProvider`** (recommended):
   ```dart
   CalendarThemeProvider(
     calendarTheme: CalendarThemeData(
       monthViewTheme: MonthViewThemeData.light().copyWith(
         cellInMonthColor: Colors.blue.shade50,
         cellBorderColor: Colors.blue.shade300,
       ),
       dayViewTheme: DayViewThemeData.light(),
       weekViewTheme: WeekViewThemeData.light(),
       multiDayViewTheme: MultiDayViewThemeData.light(),
     ),
     child: YourApp(),
   )
   ```

2. **Using ThemeData extensions** (since all theme data classes extend `ThemeExtension`):
   ```dart
   // Create custom theme
   final myMonthViewTheme = MonthViewThemeData.light().copyWith(
     cellInMonthColor: Colors.blue.shade50,
     cellBorderColor: Colors.blue.shade300,
   );

   // Apply to your app theme
   final theme = ThemeData.light().copyWith(
     extensions: [
       myMonthViewTheme,
       DayViewThemeData.light(),
       WeekViewThemeData.light(),
       MultiDayViewThemeData.light(),
     ],
   );
   ```

### Day view
* Default timeline text color is `timelineTextColor` in `DayViewThemeData` (defaults to `onSurface`).
    * Use `markingStyle` in `DefaultTimeLineMark` to give text style.
* Default live time indicator color is `liveIndicatorColor` in `DayViewThemeData` (defaults to `primary`).
    * Use `liveTimeIndicatorSettings` to customise it per-widget.
* Default hour, half hour & quarter line color is `hourLineColor` / `halfHourLineColor` / `quarterHourLineColor` in `DayViewThemeData` (all default to `surfaceContainerHighest`).
    * Use `hourIndicatorSettings` to customise it per-widget.

Default hour indicator settings.
```dart
 HourIndicatorSettings(
          height: widget.heightPerMinute,
          // Color of horizontal and vertical lines
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          offset: 5,
        );
```

### Week view
* To customise week number & weekdays use `weekNumberBuilder` & `weekDayBuilder`.
* Default week day tile color is `weekDayTileColor` in `WeekViewThemeData` (defaults to `surfaceContainerHigh`).
    * Use `weekTitleBackgroundColor` to override it per-widget.
* Default page background color is `pageBackgroundColor` in `WeekViewThemeData` (defaults to `surfaceContainerLowest`).
    * Use `backgroundColor` to override it per-widget.
* Default timeline text color is `timelineTextColor` in `WeekViewThemeData` (defaults to `onSurface`).
    * Use `markingStyle` in `DefaultTimeLineMark` to give text style, or `timeLineBuilder` to fully replace the timeline.
* Default hour/half hour/quarter hour line color is `hourLineColor` / `halfHourLineColor` / `quarterHourLineColor` in `WeekViewThemeData` (all default to `surfaceContainerHighest`).
    * Use `hourIndicatorSettings`, `halfHourIndicatorSettings`, and `quarterHourIndicatorSettings` to customise per-widget.
* Default vertical line color between days is `verticalLinesColor` in `WeekViewThemeData`.
* To customise the divider between weekdays and full-day events use `dividerSettings`.

```dart
  hourIndicatorSettings: HourIndicatorSettings(
        color: Colors.greenAccent,
        lineStyle: LineStyle.dashed,
      ),
      showHalfHours: true,
  halfHourIndicatorSettings: HourIndicatorSettings(
        color: Colors.redAccent,
        lineStyle: LineStyle.dashed,
      ),
  dividerSettings: DividerSettings(
        thickness: 2,
        height: 2,
        color: Colors.blueAccent,
        indent: 10,
        endIndent: 10,
      ),
```

Hide divider in week view.
```dart
  dividerSettings: DividerSettings.none(),
```

### Month view

* Default date cell colors come from `MonthViewThemeData`: `cellInMonthColor` (`surfaceContainerLowest`) for days in the current month and `cellNotInMonthColor` (`surfaceContainerLow`) for days outside it.
* Use `monthViewThemeSettings` to fine-tune highlight colors and text styles without a full theme override:

```dart
MonthView(
  monthViewThemeSettings: MonthViewThemeSettings(
    selectedHighlightColor: Colors.blue,
    selectedTitleColor: Colors.white,
    cellsInMonthHighlightColor: Colors.blue,
    weekDayTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
)
```

* Use `monthViewBuilders.cellBuilder` to completely customize the cell appearance:

  ```dart
  MonthView(
    monthViewBuilders: MonthViewBuilders(
      cellBuilder: (date, events, isToday, isInMonth, isSelected, hideDaysNotInMonth) {
        return Container(
          decoration: BoxDecoration(
            color: isInMonth ? Colors.white : Colors.grey[200],
            border: Border.all(color: Colors.blue),
          ),
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : (isToday ? Colors.red : Colors.black),
                fontWeight: (isToday || isSelected) ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    ),
  )
  ```
* Use `monthViewStyle.showWeekTileBorder` to control week day title border visibility
* Use `monthViewBuilders.headerBuilder` to customize or completely replace the month header

# Migration Guides

## Migrate from `1.x.x` to latest
### ⚠ Note

All 2.x.x releases may include breaking changes. To avoid unexpected issues, do not use the
caret (^) when depending on any versions of 2.x.x Instead, pin the exact version.

Example:

```yaml
dependencies:
  calendar_view: 2.0.0
```

### 1. Migrate `HeaderStyle`.
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
### 2. Migrate `CalendarPageHeader` | `DayPageHeader` | `MonthPageHeader` | `WeekPageHeader`:
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
### 3. Migrate `CellBuilder`

   ```dart
  //  **Previous Signature (2.0.0):**
   typedef CellBuilder<T extends Object?> = Widget Function(
     DateTime date,
     List<CalendarEventData<T>> event,
     bool isToday,
     bool isInMonth,
     bool hideDaysNotInMonth,
   );
   ```
   ```dart
   // **New Signature (Latest):**
   typedef CellBuilder<T extends Object?> = Widget Function(
     DateTime date,
     List<CalendarEventData<T>> event,
     bool isToday,
     bool isInMonth,
     bool isSelected,        // New parameter added
     bool hideDaysNotInMonth,
   );
   ```

# Contributors

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/25323183?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65167856?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/36261739?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/56400956?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/69202025?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
|           [Vatsal Tanna](https://github.com/vatsaltanna)           |        [Sanket Kachhela](https://github.com/sanket-simform)        |          [Parth Baraiya](https://github.com/ParthBaraiya)          |        [Ujas Majithiya](https://github.com/Ujas-Majithiya)         |            [Rashi Shah](https://github.com/rashi-shah)             |

| ![img](https://avatars.githubusercontent.com/u/89002539?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/44993081?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/65003381?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/72137369?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/81063988?v=4&s=200) |
|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|:------------------------------------------------------------------:|
|         [Faiyaz Shaikh](https://github.com/faiyaz-shaikh)          |        [Dhaval Kansara](https://github.com/DhavalRKansara)         |         [Apurva Kanthraviya](https://github.com/apurva780)         |         [Shubham Jitiya](https://github.com/ShubhamJitiya)         |           [Sahil Totala](https://github.com/Flamingloon)           |

| ![img](https://avatars.githubusercontent.com/u/97207242?v=4&s=200) | ![img](https://avatars.githubusercontent.com/u/201776786?v=4&size=64?v=4&s=200) |
|:------------------------------------------------------------------:|:----------------------------------------------------------------------------:|
|        [Kavan Trivedi](https://github.com/kavantrivedi)            |              [Lavi Garg](https://github.com/lavigarg-dev)                    |

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
