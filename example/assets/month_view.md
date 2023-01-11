# MonthView

`MonthView` is a simple widget to display month view calendar. You can display basic month view UI by using `MonthView()` constructor.

ex,

```dart
MonthView();
```

## Properties in MonthView

### key -> GlobalKey

Defines key for MonthView. Provide GlobalKey<[MonthViewState](month_view_state.md)> to access functionalities provided by [MonthViewState](month_view_state.md).

### controller -> [EventController](event_controller.md)

[EventController](event_controller.md) manages all the events in month view. It rebuilds month view whenever there is any change in event list stored in controller.

### showBorder  ->  bool

hide or show cell border.

### borderColor  ->  Color

Color of cell border. This will only affect if `showBorder` is true.

### borderSize -> double

Size of cell border. This will only affect if `showBorder` is true.

### cellBuilder -> [CellBuilder](typedefs.md)

A callback function used to build month cell. This function returns `Widget` that will be displayed as month cell.

### width -> double

Defines width of month view. If width is not provided then MonthView will take width of nearest MediaQuery data.

### minMonth -> DateTime

Determines the lower boundary user can scroll. If not provided [CalendarConstants.epochDate](calendar_constants.md) is default.

### maxMonth -> DateTime

Determines the upper boundary user can scroll. If not provided [CalendarConstants.maxDate](calendar_constants.md) is default.

### initialMonth -> DateTime

Defines initial month to display. If not provided current date is default.

### cellAspectRatio -> double

Used to calculate height of one cell. Height of one cell will be calculated as: `width` / (7 * `cellAspectRatio`).

### headerBuilder -> [DateWidgetBuilder?](typedefs.md)

Builds month page title/header. If null default title builder will be used.

### weekDayBuilder -> [WeekDayBuilder?](typedefs.md)

Builds the name of the weeks. Used default week builder if null. Here day will range from 0 to 6 starting from Monday to Sunday.

### pageTransitionDuration -> Duration

Page transition duration used when user try to change page using [MonthViewState.nextPage](month_view_state.md) or [MonthViewState.previousPage](month_view_state.md)

### pageTransitionCurve -> Curve

Page transition curve used when user try to change page using[MonthViewState.nextPage](month_view_state.md) or [MonthViewState.previousPage](month_view_state.md)

### onPageChange -> [CalendarPageChangeCallBack?](typedefs.md)

Called when user changes month.

### onCellTap -> [CellTapCallback?](typedefs.md)

This function will be called when user taps on month view cell.

### onEventTap -> [TileTapCallback?](typedefs.md)

This function will be called when user will tap on a single event tile inside a cell. This function will only work if `cellBuilder` is null.
