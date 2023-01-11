# WeekView

`WeekView` is a simple widget to display week view calendar. You can display basic week view UI by using `WeekView()` constructor.

ex,

```dart
WeekVieW();
```

## Properties

### key -> GlobalKey<[WeekViewState](week_view_state.md)>

Defines key for `DayView`. Provide GlobalKey<[WeekViewState](week_view_state.md)> to access functionalities provided by [WeekViewState](week_view_state.md).

### eventTileBuilder -> [EventTileBuilder?](typedefs.md)

Builder to build tile for events.

### timeLineBuilder -> [DateWidgetBuilder?](typedefs.md)

Builder for timeline.

### weekPageHeaderBuilder -> [WeekPageHeaderBuilder?](typedefs.md)

Header builder for week page header.

### eventArranger -> [EventArranger?](event_arranger.md)

Defines how events should be arranged.

### onPageChange -> [CalendarPageChangeCallBack?](typedefs.md)

Called whenever user changes week.

### minDay -> DateTime?

Minimum day to display in week view.

### maxDay -> DateTime?

Maximum day to display in week view.

### initialDay -> DateTime?

Initial week to display in week view.

### hourIndicatorSettings -> [HourIndicatorSettings?](hour_indicator_settings.md)

Settings for hour indicator settings.

### liveTimeIndicatorSettings -> [HourIndicatorSettings?](hour_indicator_settings.md)

Settings for live time indicator settings.

### pageTransitionDuration -> Duration

Duration for page transition while changing the week.

### pageTransitionCurve -> Curve

Transition curve for transition.

### controller -> [EventController?](event_controller.md)

Controller for Week view thia will refresh view when user adds or removes event from controller.

### heightPerMinute -> double

Defines height occupied by one minute of time span. This parameter will be used to calculate total height of Week view.

### timeLineWidth -> double?

Width of time line.

### showLiveTimeLineInAllDays -> bool

Flag to show live time indicator in all day or only `initialDay`

### timeLineOffset -> double

Offset of time line

### width -> double?

Width of week view. If null provided device width will be considered.

### weekTitleHeight -> double

Height of week day title,

### weekDayBuilder -> [DateWidgetBuilder?](typedefs.md)

Builder to build week day.

### backgroundColor -> Color?

Background color of week view page.

### onEventTap -> [CellTapCallback?](typedefs.md)

Called when user taps on event tile.
