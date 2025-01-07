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
