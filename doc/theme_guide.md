## **Customise theme**
The default theme supports dark mode. Refer this colors to override it.

| Name                                          | Parameter              | Default color                       |
|-----------------------------------------------|------------------------|-------------------------------------|
| `MonthView` Border color                      | Color? borderColor     | colorScheme.surfaceContainerHigh    |
| `WeekView` Background color of week view page | Color? backgroundColor | colorScheme.surfaceContainerLowest  |
| `DayView` Default background color            | Color? backgroundColor | colorScheme.surfaceContainerLow     |
| `FilledCell` Dates in month cell color        | Color? backgroundColor | colorScheme.surfaceContainerLowest  |
| `FilledCell` Dates not in month cell color    | Color? backgroundColor | colorScheme.surfaceContainerLow     |
| `WeekDayTile` Border color                    | Color? borderColor     | colorScheme.secondaryContainer      |
| `WeekDayTile` Background color                | Color? backgroundColor | colorScheme.surfaceContainerHigh    |
| `WeekDayTile` Text style color                | TextStyle? textStyle   | colorScheme.onSecondaryContainer    |

To customise `MonthView`, `DayView` & `WeekView` page header use `HeaderStyle`.

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

1. **Using ThemeData extensions**:
   ```dart
   // Create custom theme
   final myMonthViewTheme = MonthViewTheme.light().copyWith(
     cellInMonthColor: Colors.blue.shade50,
     cellBorderColor: Colors.blue.shade300,
   );
   
   // Apply to your app theme
   final theme = ThemeData.light().copyWith(
     extensions: [
       myMonthViewTheme,
       DayViewTheme.light(),
       WeekViewTheme.light(),
     ],
   );
   ```

2. **Using CalendarThemeProvider**:
   ```dart
   CalendarThemeProvider(
     calendarTheme: CalendarTheme(
       monthViewTheme: MonthViewTheme.light().copyWith(
         cellInMonthColor: Colors.blue.shade50,
       ),
       dayViewTheme: DayViewTheme.light(),
       weekViewTheme: WeekViewTheme.light(),
     ),
     child: YourApp(),
   )
   ```

### Day view
* Default timeline text color is `colorScheme.onSurface`. 
  * Use `markingStyle` in `DefaultTimeLineMark` to give text style.
* Default `LiveTimeIndicatorSettings` color `colorScheme.primaryColorLight`.
    * Use `liveTimeIndicatorSettings` to customise it.
* Default hour, half hour & quarter color is `colorScheme.surfaceContainerHighest`.
  * Use `hourIndicatorSettings` to customise it.

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
* Default week tile background color is `colorScheme.surfaceContainerHigh`.
  * Use `weekTitleBackgroundColor` to change background color.
* Default page background color is `colorScheme.surfaceContainerLowest`.
  * Use `backgroundColor` to change background color.
* Default timeline text color is `colorScheme.onSurface`. Use `markingStyle` in `DefaultTimeLineMark` to give text style.
  * To customise timeline use `timeLineBuilder`.
* To change Hour lines color use `HourIndicatorSettings`.
* To style hours, half hours & quarter hours use `HourIndicatorSettings`. Default color used is `surfaceContainerHighest`

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
```

### Month view

* Default date cell color in month is `colorScheme.surfaceContainerLowest` and `colorScheme.surfaceContainerLow` for days not in month.
* Use `cellBuilder` to completely customize the cell appearance:

  ```dart
  cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
    return Container(
      decoration: BoxDecoration(
        color: isInMonth ? Colors.white : Colors.grey[200],
        border: Border.all(color: Colors.blue),
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(
            color: isToday ? Colors.red : Colors.black,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  ```
* Use `showWeekTileBorder` to control week day title border visibility
* Use `headerBuilder` to customize or completely replace the month header
