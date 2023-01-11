# DayView

`DayView` is a simple widget to display day view calendar. You can display basic day view UI by using `DayView()` constructor.

ex,

```dart
DayView();
```

## Properties

### key -> GlobalKey<[DayViewState](day_view_state.md)>

Defines key for `DayView`. Provide GlobalKey<[DayViewState](day_view_state.md)> to access functionalities provided by [DayViewState](day_view_state.md).

### eventTileBuilder -> [EventTileBuilder?](typedefs.md)

A function that returns a `Widget` that determines appearance of each cell in day calendar.

### timeLineBuilder -> [DateWidgetBuilder?](typedefs.md)

A function that returns a `Widget` that will be displayed left side of day view.

If null is provided then no time line will be visible.

### dayTitleBuilder -> [DateWidgetBuilder?](typedefs.md)

Builds day title bar.

### eventArranger -> [EventArranger?](event_arranger.md)

Defines how events are arranged in day view. User can define custom event arranger by implementing [EventArranger](event_arranger.md) class and pass object of that class as argument.

### onPageChange -> [CalendarPageChangeCallBack?](typedefs.md)

This callback will run whenever page will change.

### minDay -> DateTime?

Determines the lower boundary user can scroll. If not provided [CalendarConstants.epochDate](calendar_constants.md) is default.

### maxDay -> DateTime?

Determines upper boundary user can scroll. If not provided [CalendarConstants.maxDate](calendar_constants.md) is default.

### initialDay -> DateTime?

Defines initial display day. If not provided `DateTime.now` is default date.

### hourIndicatorSettings -> [HourIndicatorSettings?](hour_indicator_settings.md)

Defines settings for hour indication lines. Pass [HourIndicatorSettings.none](hour_indicator_settings.md) to remove Hour lines.

### liveTimeIndicatorSettings -> [HourIndicatorSettings?](hour_indicator_settings.md)

Defines settings for live time indicator. Pass [HourIndicatorSettings.none](hour_indicator_settings.md) to remove live time indicator.

### pageTransitionDuration -> Duration

Page transition duration used when user try to change page using [DayViewState.nextPage](day_view_state.md) or [DayViewState.previousPage](day_view_state.md)

### pageTransitionCurve -> Curve

Page transition curve used when user try to change page using [DayViewState.nextPage](day_view_state.md) or [DayViewState.previousPage](day_view_state.md)

### controller -> [EventController?](event_controller.md)

A required parameters that controls events for day view. This will auto update day view when user adds events in controller. This controller will store all the events. And returns events for particular day.

### heightPerMinute -> double

Defines height occupied by one minute of interval. This will be used to calculate total height of day view.

### timeLineWidth -> double

Defines the width of timeline. If null then it will occupies 13% of `width`.

### showLiveTimeLineInAllDays -> bool

if parsed true then live time line will be displayed in all days. else it will be displayed in [DateTime.now] only.

Parse [HourIndicatorSettings.none](hour_indicator_settings.md) as argument in [DayView.liveTimeIndicatorSettings](hour_indicator_settings.md) to remove time line completely.

### timeLineOffset -> double

Defines offset for timeline.

This will translate all the widgets returned by [DayView.timeLineBuilder](day_view.md) by provided offset. If offset is positive all the widgets will be translated up. If offset is negative all the widgets will be translated down. Default value is 0.

### width -> double?

Width of day page. if null provided then device width will be considered.

### showVerticalLine -> bool

If true this will display vertical line in day view.

### verticalLineOffset -> double

Defines offset of vertical line from hour line starts.

### backgroundColor -> Color?

Background colour of day view page.

### onEventTap -> [CellTapCallback?](typedefs.md)

This method will be called when user taps on event tile.
