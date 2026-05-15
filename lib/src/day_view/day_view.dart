// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';
import '../extensions.dart';
import '../painters.dart';
import '_internal_day_view_page.dart';

/// Displays a single-day calendar view and renders events for that day.
class DayView<T extends Object?> extends StatefulWidget {
  /// A function that returns a [Widget] that determines appearance of each
  /// cell in day calendar.
  final EventTileBuilder<T>? eventTileBuilder;

  /// A function to generate the DateString in the calendar title.
  /// Useful for I18n
  ///
  /// If not provided, a default date format will be used.
  final StringProvider? dateStringBuilder;

  /// A function to generate the TimeString in the timeline.
  /// Useful for I18n
  ///
  /// If not provided, a default time format will be used.
  final StringProvider? timeStringBuilder;

  /// A function that returns a [Widget] that will be displayed left side of
  /// day view.
  ///
  /// If null is provided then no time line will be visible.
  ///
  final DateWidgetBuilder? timeLineBuilder;

  /// Builds day title bar.
  ///
  /// If there are some configurations that is not directly available
  /// in [DayView], override this to create your custom header or reuse,
  /// [CalendarPageHeader] | [DayPageHeader] | [MonthPageHeader] |
  /// [WeekPageHeader] widgets provided by this package with your custom
  /// configurations.
  ///
  final DateWidgetBuilder? dayTitleBuilder;

  /// Builds custom PressDetector widget
  ///
  /// If null, internal PressDetector will be used to handle onDateLongPress()
  ///
  final DetectorBuilder? dayDetectorBuilder;

  /// Defines how events are arranged in day view.
  /// User can define custom event arranger by implementing [EventArranger]
  /// class and pass object of that class as argument.
  final EventArranger<T>? eventArranger;

  /// This callback will run whenever page will change.
  final CalendarPageChangeCallBack? onPageChange;

  /// Determines the lower boundary user can scroll (base date for page indexing).
  ///
  /// **Important:** Use same [minDay] across all views (day/week/month) when
  /// switching between them to ensure consistent date-to-page mapping.
  final DateTime? minDay;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.maxDate] is default.
  final DateTime? maxDay;

  /// Defines initial display day.
  ///
  /// If not provided [DateTime.now] is default date.
  final DateTime? initialDay;

  /// Defines settings for hour indication lines.
  ///
  /// Pass [HourIndicatorSettings.none] to remove Hour lines.
  final HourIndicatorSettings? hourIndicatorSettings;

  /// A funtion that returns a [CustomPainter].
  ///
  /// Use this if you want to paint custom hour lines.
  final CustomHourLinePainter? hourLinePainter;

  /// Defines settings for live time indicator.
  ///
  /// Pass [LiveTimeIndicatorSettings.none] to remove live time indicator.
  final LiveTimeIndicatorSettings? liveTimeIndicatorSettings;

  /// Defines settings for half hour indication lines.
  ///
  /// Pass [HourIndicatorSettings.none] to remove half hour lines.
  final HourIndicatorSettings? halfHourIndicatorSettings;

  /// Defines settings for quarter hour indication lines.
  ///
  /// Pass [HourIndicatorSettings.none] to remove quarter hour lines.
  final HourIndicatorSettings? quarterHourIndicatorSettings;

  /// Page transition duration used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  ///
  /// Default value is 300 milliseconds.
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  ///
  /// Default value is [Curves.ease].
  final Curve pageTransitionCurve;

  /// A required parameters that controls events for day view.
  ///
  /// This will auto update day view when user adds events in controller.
  /// This controller will store all the events. And returns events
  /// for particular day.
  final EventController<T>? controller;

  /// Defines height occupied by one minute of interval.
  /// This will be used to calculate total height of day view.
  ///
  /// For example, if [heightPerMinute] is 0.7, then one hour (60 minutes)
  /// will occupy 42 pixels of height (0.7 * 60).
  ///
  /// Default value is 0.7.
  /// Must be greater than 0.
  final double heightPerMinute;

  /// Defines the width of timeline. If null then it will
  /// occupies 13% of [width].
  final double? timeLineWidth;

  /// if parsed true then live time line will be displayed in all days.
  /// else it will be displayed in [DateTime.now] only.
  ///
  /// Parse [HourIndicatorSettings.none] as argument in
  /// [DayView.liveTimeIndicatorSettings]
  /// to remove time line completely.
  final bool showLiveTimeLineInAllDays;

  /// Defines offset for timeline.
  ///
  /// This will translate all the widgets returned by
  /// [DayView.timeLineBuilder] by provided offset.
  ///
  /// If offset is positive all the widgets will be translated up.
  ///
  /// If offset is negative all the widgets will be translated down.
  /// Default value is 0.
  final double timeLineOffset;

  /// Width of day page.
  ///
  /// if null provided then device width will be considered.
  final double? width;

  /// If true this will display vertical line in day view.
  final bool showVerticalLine;

  /// Defines offset of vertical line from hour line starts.
  final double verticalLineOffset;

  /// Background colour of day view page.
  final Color? backgroundColor;

  /// Defines initial offset of first page that will be displayed when
  /// [DayView] is initialized.
  ///
  /// This controls the scroll position within the day view. If [scrollOffset]
  /// is null, then [startDuration] will be considered for initial offset.
  ///
  /// Use this when you want to start the view at a specific scroll position
  /// rather than relying on the [startDuration] parameter.
  final double? scrollOffset;

  /// This method will be called when user taps on timestamp in timeline.
  ///
  /// Called when user taps on a time value in the timeline (left side of view).
  final TimestampCallback? onTimestampTap;

  /// This method will be called when user taps on event tile.
  final CellTapCallback<T>? onEventTap;

  /// This method will be called when user long press on event tile.
  final CellTapCallback<T>? onEventLongTap;

  /// This method will be called when user double taps on event tile.
  final CellTapCallback<T>? onEventDoubleTap;

  /// This method will be called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Called when user taps on day view page.
  ///
  /// This callback will have a date parameter which
  /// will provide the time span on which user has tapped.
  ///
  /// Ex, User Taps on Date page with date 11/01/2022 and time span is 1PM to 2PM.
  /// then DateTime object will be  DateTime(2022,01,11,1,0)
  final DateTapCallback? onDateTap;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  ///
  /// This determines the granularity of time selections. For example,
  /// [MinuteSlotSize.minutes60] means each slot represents 60 minutes (1 hour).
  ///
  /// Default value is [MinuteSlotSize.minutes60].
  final MinuteSlotSize minuteSlotSize;

  /// Use this field to disable the calendar scrolling
  ///
  /// If specified, this [ScrollPhysics] will be applied to the time axis scrolling.
  /// Set to [NeverScrollableScrollPhysics] to disable scrolling within the day view.
  final ScrollPhysics? scrollPhysics;

  /// Use this field to disable the page view scrolling behavior
  ///
  /// If specified, this [ScrollPhysics] will be applied to the horizontal page transitions.
  /// Set to [NeverScrollableScrollPhysics] to disable day-to-day page swiping.
  final ScrollPhysics? pageViewPhysics;

  /// Style for DayView header.
  final HeaderStyle? headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Display full day event builder.
  ///
  /// A custom widget builder for displaying events that span the entire day.
  /// If not provided, [FullDayEventView] will be used as default.
  final FullDayEventBuilder<T>? fullDayEventBuilder;

  /// First hour displayed in the layout, goes from 0 to 24
  ///
  /// This determines the starting hour of the visible time range.
  /// For example, if [startHour] is 6, the timeline will start from 6:00 AM.
  ///
  /// Default value is 0 (starts from midnight).
  /// Must be less than or equal to [endHour].
  final int startHour;

  /// Show half hour indicator
  ///
  /// When true, displays horizontal lines at 30-minute intervals.
  /// Default value is false.
  final bool showHalfHours;

  /// Show quarter hour indicator(15min & 45min).
  ///
  /// When true, displays horizontal lines at 15-minute intervals (15min & 45min).
  /// Default value is false.
  final bool showQuarterHours;

  /// It define the starting duration from where day view page will be visible
  /// By default it will be Duration(hours:0)
  final Duration startDuration;

  /// Callback for the Header title
  ///
  /// Called when user taps on the header title/date. If not provided,
  /// a date picker dialog will be shown.
  final HeaderTitleCallback? onHeaderTitleTap;

  /// Emulate vertical line offset from hour line starts.
  ///
  /// This adjusts the vertical line position by the specified amount.
  /// Default value is 0.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for day view
  ///
  /// This determines the ending hour of the visible time range.
  /// For example, if [endHour] is 24, the timeline will end at midnight.
  ///
  /// Default value is 24.
  /// Must be greater than [startHour].
  final int endHour;

  /// Flag to keep scrollOffset of pages on page change
  ///
  /// When true, maintains the scroll position when navigating between days.
  /// When false, resets to [startDuration] on each page change.
  ///
  /// Default value is false.
  final bool keepScrollOffset;

  /// A callback that resolves slot background color for each visible time slot.
  /// Useful for highlighting unavailable hours, business hours, or blocked time.
  final TimeSlotColorBuilder? timeSlotColorBuilder;

  /// Flag to display the 00:00 (midnight) hour in the timeline.
  final bool showMidnightHour;

  /// Main widget for day view.
  const DayView({
    Key? key,
    this.eventTileBuilder,
    this.dateStringBuilder,
    this.timeStringBuilder,
    this.controller,
    this.showVerticalLine = true,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.width,
    this.minDay,
    this.maxDay,
    this.initialDay,
    this.hourIndicatorSettings,
    this.hourLinePainter,
    this.heightPerMinute = 0.7,
    this.timeLineBuilder,
    this.timeLineWidth,
    this.timeLineOffset = 0,
    this.showLiveTimeLineInAllDays = false,
    this.liveTimeIndicatorSettings,
    this.onPageChange,
    this.dayTitleBuilder,
    this.eventArranger,
    this.verticalLineOffset = 10,
    this.backgroundColor,
    this.scrollOffset,
    this.onEventTap,
    this.onEventLongTap,
    this.onDateLongPress,
    this.onDateTap,
    this.minuteSlotSize = MinuteSlotSize.minutes60,
    this.headerStyle,
    this.fullDayEventBuilder,
    this.safeAreaOption = const SafeAreaOption(),
    this.scrollPhysics,
    this.pageViewPhysics,
    this.dayDetectorBuilder,
    this.showHalfHours = false,
    this.showQuarterHours = false,
    this.halfHourIndicatorSettings,
    this.startHour = 0,
    this.quarterHourIndicatorSettings,
    this.startDuration = const Duration(hours: 0),
    this.onHeaderTitleTap,
    this.emulateVerticalOffsetBy = 0,
    this.onEventDoubleTap,
    this.endHour = Constants.hoursADay,
    this.keepScrollOffset = false,
    this.onTimestampTap,
    this.timeSlotColorBuilder,
    this.showMidnightHour = false,
  })  : assert(!(onHeaderTitleTap != null && dayTitleBuilder != null),
            "can't use [onHeaderTitleTap] & [dayTitleBuilder] simultaneously"),
        assert(timeLineOffset >= 0,
            "timeLineOffset must be greater than or equal to 0"),
        assert(width == null || width > 0,
            "Calendar width must be greater than 0."),
        assert(timeLineWidth == null || timeLineWidth > 0,
            "Time line width must be greater than 0."),
        assert(
            heightPerMinute > 0, "Height per minute must be greater than 0."),
        assert(
          dayDetectorBuilder == null || onDateLongPress == null,
          """If you use [dayPressDetectorBuilder]
          do not provide [onDateLongPress]""",
        ),
        assert(
          startHour <= 0 || startHour != endHour,
          "startHour must be greater than 0 or startHour should not equal to endHour",
        ),
        assert(
          endHour <= Constants.hoursADay || endHour < startHour,
          "End hour must be less than 24 or startHour must be less than endHour",
        ),
        super(key: key);

  @override
  DayViewState<T> createState() => DayViewState<T>();
}

class DayViewState<T extends Object?> extends State<DayView<T>> {
  /// Width of the Day View widget in pixels.
  /// Calculated from widget width or device constraint width.
  late double _width;

  /// Total height of the visible day view (calculated from hourHeight and hour range).
  /// Formula: _hourHeight * (endHour - startHour)
  late double _height;

  /// Width allocated for the timeline/hour labels on the left side.
  /// Defaults to 13% of _width if not explicitly specified.
  late double _timeLineWidth;

  /// Height occupied by a single hour in pixels.
  /// Formula: heightPerMinute * 60
  /// This is used to determine overall view height and scroll calculations.
  late double _hourHeight;

  /// Last recorded scroll offset position for maintaining scroll state.
  /// Used when navigating between pages if keepScrollOffset is enabled.
  late double _lastScrollOffset;

  /// Currently displayed day in the Day View.
  /// Updated when user navigates between days.
  /// Always stored without time component (time is 00:00:00).
  late DateTime _currentDate;

  /// Maximum date user can scroll to.
  /// Derived from widget.maxDay parameter (defaults to CalendarConstants.maxDate).
  /// Stored without time component.
  late DateTime _maxDate;

  /// Minimum date user can scroll to.
  /// This is the **reference date** for calculating page indices.
  /// Derived from widget.minDay parameter (defaults to CalendarConstants.epochDate).
  /// Stored without time component.
  late DateTime _minDate;

  /// Total number of days available in the calendar.
  /// Calculated as: (_maxDate - _minDate) + 1
  late int _totalDays;

  /// Current page index in the PageView controller.
  /// Represents the number of days since _minDate.
  /// Central to relating page indices with dates.
  /// Formula: currentDate.getDayDifference(_minDate)
  late int _currentIndex;

  /// Event arrangement strategy for positioning events in the day view.
  /// Determines how overlapping events are laid out (side-by-side, cascading, etc.).
  /// Defaults to SideEventArranger if not provided.
  late EventArranger<T> _eventArranger;

  /// Settings for full hour indicator lines (e.g., solid lines at each hour mark).
  /// Controls color, height, offset, and line style for 1-hour interval indicators.
  late HourIndicatorSettings _hourIndicatorSettings;

  /// Settings for half-hour indicator lines (at 30-minute marks).
  /// Controls color, height, offset, and line style for half-hour interval indicators.
  late HourIndicatorSettings _halfHourIndicatorSettings;

  /// Settings for quarter-hour indicator lines (at 15 and 45-minute marks).
  /// Controls color, height, offset, and line style for quarter-hour interval indicators.
  late HourIndicatorSettings _quarterHourIndicatorSettings;

  /// Custom painter for drawing hour lines in the day view.
  /// Allows fine-grained control over line rendering appearance.
  late CustomHourLinePainter _hourLinePainter;

  /// Settings for the live time indicator (current time line).
  /// Controls color, height, and offset of the indicator showing current time.
  late LiveTimeIndicatorSettings _liveTimeIndicatorSettings;

  /// Builder for adding custom colors to time slots in the day view.
  late TimeSlotColorBuilder? _timeSlotColorBuilder;

  /// Controller for managing page transitions between days.
  /// Used for jumpToPage(), animateToPage(), and nextPage/previousPage operations.
  late PageController _pageController;

  /// Builder function for creating timeline/hour labels on the left side.
  /// Receives the date and returns a Widget to display for that hour.
  late DateWidgetBuilder _timeLineBuilder;

  /// Builder function for creating event tiles within the day view.
  /// Customizes how individual events are rendered.
  late EventTileBuilder<T> _eventTileBuilder;

  /// Builder function for creating the day title/header section.
  /// Typically displays the current date and navigation controls.
  late DateWidgetBuilder _dayTitleBuilder;

  /// Builder function for creating full-day event displays.
  /// Handles rendering of events that span the entire day.
  late FullDayEventBuilder<T> _fullDayEventBuilder;

  /// Builder function for creating the press detector overlay.
  /// Handles tap, long-press detection for creating new events.
  late DetectorBuilder _dayDetectorBuilder;

  /// Event controller for managing calendar events.
  /// Can be null if event management is not needed.
  /// Provides data for rendering events and tracks event changes.
  EventController<T>? _controller;

  /// Scroll controller for managing vertical scrolling within the day view.
  /// Controls scroll position for time axis (top-to-bottom).
  late ScrollController _scrollController;

  /// Public getter for accessing the scroll controller.
  /// Allows external code to control or listen to scroll events.
  ScrollController get scrollController => _scrollController;

  /// Callback function triggered when the controller changes or events are modified.
  /// Used to rebuild the view when event data changes.
  late VoidCallback _reloadCallback;

  /// Configuration for handling scroll events when jumping/animating to specific events.
  /// Manages ValueNotifier for reactive scroll updates.
  final _scrollConfiguration = EventScrollConfiguration<T>();

  @override
  void initState() {
    super.initState();
    _lastScrollOffset = widget.scrollOffset ??
        widget.startDuration.inMinutes * widget.heightPerMinute;

    _reloadCallback = _reload;
    _setDateRange();

    _currentDate = (widget.initialDay ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();

    _calculateHeights();
    _scrollController = ScrollController(
      initialScrollOffset: _lastScrollOffset,
    );
    _pageController = PageController(initialPage: _currentIndex);
    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();
    _assignBuilders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller = newController;

      _controller!
        // Removes existing callback.
        ..removeListener(_reloadCallback)

        // Reloads the view if there is any change in controller or
        // user adds new events.
        ..addListener(_reloadCallback);
    }
  }

  @override
  void didUpdateWidget(DayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller.
    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    // Update date range.
    if (widget.minDay != oldWidget.minDay ||
        widget.maxDay != oldWidget.maxDay) {
      _setDateRange();
      _regulateCurrentDate();

      _pageController.jumpToPage(_currentIndex);
    }

    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();

    // Update heights.
    _calculateHeights();

    // Update builders and callbacks
    _assignBuilders();
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.dayViewColors;

    return SafeAreaWrapper(
      option: widget.safeAreaOption,
      child: LayoutBuilder(builder: (context, constraint) {
        _width = widget.width ?? constraint.maxWidth;
        _updateViewDimensions();
        return SizedBox(
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _dayTitleBuilder(_currentDate),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        themeColor.pageBackgroundColor,
                  ),
                  child: SizedBox(
                    height: _height,
                    child: PageView.builder(
                      physics: widget.pageViewPhysics,
                      itemCount: _totalDays,
                      controller: _pageController,
                      onPageChanged: _onPageChange,
                      itemBuilder: (_, index) {
                        final date = DateTime(_minDate.year, _minDate.month,
                            _minDate.day + index);
                        return ValueListenableBuilder(
                          valueListenable: _scrollConfiguration,
                          builder: (_, __, ___) => InternalDayViewPage<T>(
                            key: ValueKey(
                                _hourHeight.toString() + date.toString()),
                            width: _width,
                            liveTimeIndicatorSettings:
                                _liveTimeIndicatorSettings,
                            timeLineBuilder: _timeLineBuilder,
                            dayDetectorBuilder: _dayDetectorBuilder,
                            eventTileBuilder: _eventTileBuilder,
                            heightPerMinute: widget.heightPerMinute,
                            hourIndicatorSettings: _hourIndicatorSettings,
                            hourLinePainter: _hourLinePainter,
                            date: date,
                            onTimestampTap: widget.onTimestampTap,
                            onTileTap: widget.onEventTap,
                            onTileLongTap: widget.onEventLongTap,
                            onDateLongPress: widget.onDateLongPress,
                            onDateTap: widget.onDateTap,
                            onTileDoubleTap: widget.onEventDoubleTap,
                            showLiveLine: widget.showLiveTimeLineInAllDays ||
                                date.compareWithoutTime(DateTime.now()),
                            timeLineOffset: widget.timeLineOffset,
                            timeLineWidth: _timeLineWidth,
                            verticalLineOffset: widget.verticalLineOffset,
                            showVerticalLine: widget.showVerticalLine,
                            height: _height,
                            controller: controller,
                            hourHeight: _hourHeight,
                            eventArranger: _eventArranger,
                            minuteSlotSize: widget.minuteSlotSize,
                            scrollNotifier: _scrollConfiguration,
                            fullDayEventBuilder: _fullDayEventBuilder,
                            showHalfHours: widget.showHalfHours,
                            showQuarterHours: widget.showQuarterHours,
                            halfHourIndicatorSettings:
                                _halfHourIndicatorSettings,
                            startHour: widget.startHour,
                            endHour: widget.endHour,
                            quarterHourIndicatorSettings:
                                _quarterHourIndicatorSettings,
                            emulateVerticalOffsetBy:
                                widget.emulateVerticalOffsetBy,
                            lastScrollOffset: _lastScrollOffset,
                            dayViewScrollController: _scrollController,
                            scrollPhysics: widget.scrollPhysics,
                            scrollListener: _scrollPageListener,
                            keepScrollOffset: widget.keepScrollOffset,
                            timeSlotColorBuilder: _timeSlotColorBuilder,
                            showMidnightHour: widget.showMidnightHour,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Returns [EventController] associated with this Widget.
  ///
  /// This will throw [AssertionError] if controller is called before its
  /// initialization is complete.
  EventController<T> get controller {
    if (_controller == null) {
      throw "EventController is not initialized yet.";
    }

    return _controller!;
  }

  /// Reloads page.
  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Updates data related to size of this view.
  void _updateViewDimensions() {
    _timeLineWidth = widget.timeLineWidth ?? _width * 0.13;

    _liveTimeIndicatorSettings = widget.liveTimeIndicatorSettings ??
        LiveTimeIndicatorSettings(
          color: context.dayViewColors.liveIndicatorColor,
          height: widget.heightPerMinute,
          offset: 5 + widget.verticalLineOffset,
        );

    assert(_liveTimeIndicatorSettings.height < _hourHeight,
        "liveTimeIndicator height must be less than minuteHeight * 60");

    _hourIndicatorSettings = widget.hourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: context.dayViewColors.hourLineColor,
          offset: 5,
        );

    assert(_hourIndicatorSettings.height < _hourHeight,
        "hourIndicator height must be less than minuteHeight * 60");

    _halfHourIndicatorSettings = widget.halfHourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: context.dayViewColors.halfHourLineColor,
          offset: 5,
        );

    assert(_halfHourIndicatorSettings.height < _hourHeight,
        "halfHourIndicator height must be less than minuteHeight * 60");

    _quarterHourIndicatorSettings = widget.quarterHourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: context.dayViewColors.quarterHourLineColor,
          offset: 5,
        );

    assert(_quarterHourIndicatorSettings.height < _hourHeight,
        "quarterHourIndicator height must be less than minuteHeight * 60");
  }

  void _calculateHeights() {
    _hourHeight = widget.heightPerMinute * 60;
    _height = _hourHeight * (widget.endHour - widget.startHour);
  }

  void _assignBuilders() {
    _timeLineBuilder = widget.timeLineBuilder ?? _defaultTimeLineBuilder;
    _eventTileBuilder = widget.eventTileBuilder ?? _defaultEventTileBuilder;
    _dayTitleBuilder = widget.dayTitleBuilder ?? _defaultDayBuilder;
    _fullDayEventBuilder =
        widget.fullDayEventBuilder ?? _defaultFullDayEventBuilder;
    _dayDetectorBuilder =
        widget.dayDetectorBuilder ?? _defaultPressDetectorBuilder;
    _hourLinePainter = widget.hourLinePainter ?? _defaultHourLinePainter;
    _timeSlotColorBuilder = widget.timeSlotColorBuilder;
  }

  /// Sets the current date of this month.
  ///
  /// This method is used in initState and onUpdateWidget methods to
  /// regulate current date in Month view.
  ///
  /// If maximum and minimum dates are change then first call _setDateRange
  /// and then _regulateCurrentDate method.
  void _regulateCurrentDate() {
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    _currentIndex = _currentDate.getDayDifference(_minDate);
  }

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    _minDate = (widget.minDay ?? CalendarConstants.epochDate).withoutTime;
    _maxDate = (widget.maxDay ?? CalendarConstants.maxDate).withoutTime;

    assert(
      !_maxDate.isBefore(_minDate),
      "Minimum date should be less than maximum date.\n"
      "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    _totalDays = _maxDate.getDayDifference(_minDate) + 1;
  }

  /// Default press detector builder. This builder will be used if
  /// [widget.weekDetectorBuilder] is null.
  Widget _defaultPressDetectorBuilder({
    required DateTime date,
    required double height,
    required double width,
    required double heightPerMinute,
    required MinuteSlotSize minuteSlotSize,
  }) =>
      DefaultPressDetector(
        date: date,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        minuteSlotSize: minuteSlotSize,
        onDateTap: widget.onDateTap,
        onDateLongPress: widget.onDateLongPress,
        startHour: widget.startHour,
      );

  /// Default timeline builder this builder will be used if
  /// [widget.eventTileBuilder] is null
  Widget _defaultTimeLineBuilder(DateTime date) => DefaultTimeLineMark(
        date: date,
        timeStringBuilder: widget.timeStringBuilder,
        markingStyle: TextStyle(
          color: context.dayViewColors.timelineTextColor,
          fontSize: 15.0,
        ),
      );

  /// Default timeline builder. This builder will be used if
  /// [widget.eventTileBuilder] is null
  Widget _defaultEventTileBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
  ) =>
      DefaultEventTile(
        date: date,
        events: events,
        boundary: boundary,
        startDuration: startDuration,
        endDuration: endDuration,
      );

  /// Default view header builder. This builder will be used if
  /// [widget.dayTitleBuilder] is null.
  ///
  Widget _defaultDayBuilder(DateTime date) {
    return DayPageHeader(
      date: _currentDate,
      dateStringBuilder: widget.dateStringBuilder,
      onNextDay: nextPage,
      showNextIcon: date != _maxDate,
      onPreviousDay: previousPage,
      showPreviousIcon: date != _minDate,
      onTitleTapped: () async {
        if (widget.onHeaderTitleTap != null) {
          widget.onHeaderTitleTap!(date);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: _minDate,
            lastDate: _maxDate,
            locale: Locale(PackageStrings.selectedLocale),
          );

          if (selectedDate == null) return;
          jumpToDate(selectedDate);
        }
      },
      headerStyle: widget.headerStyle ??
          HeaderStyle(
            decoration: BoxDecoration(
              color: context.dayViewColors.headerBackgroundColor,
            ),
            leftIconConfig: IconDataConfig(
              color: context.dayViewColors.headerIconColor,
            ),
            rightIconConfig: IconDataConfig(
              color: context.dayViewColors.headerIconColor,
            ),
            headerTextStyle: TextStyle(
              color: context.dayViewColors.headerTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }

  Widget _defaultFullDayEventBuilder(
          List<CalendarEventData<T>> events, DateTime date) =>
      FullDayEventView(
        events: events,
        date: date,
        onEventTap: widget.onEventTap,
        onEventDoubleTap: widget.onEventDoubleTap,
        onEventLongPress: widget.onEventLongTap,
      );

  HourLinePainter _defaultHourLinePainter(
    Color lineColor,
    double lineHeight,
    double offset,
    double minuteHeight,
    bool showVerticalLine,
    double verticalLineOffset,
    LineStyle lineStyle,
    double dashWidth,
    double dashSpaceWidth,
    double emulateVerticalOffsetBy,
    int startHour,
    int endHour,
  ) {
    final directionality = Directionality.of(context);
    return HourLinePainter(
      lineColor: lineColor,
      lineHeight: lineHeight,
      offset: offset,
      minuteHeight: minuteHeight,
      verticalLineOffset: verticalLineOffset,
      showVerticalLine: showVerticalLine,
      lineStyle: lineStyle,
      dashWidth: dashWidth,
      dashSpaceWidth: dashSpaceWidth,
      emulateVerticalOffsetBy: emulateVerticalOffsetBy,
      startHour: startHour,
      endHour: endHour,
      timelineWidth: widget.timeLineWidth,
      textDirection: directionality,
    );
  }

  /// Called when user change page using any gesture or inbuilt functions.
  ///
  void _onPageChange(int index) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month,
          _currentDate.day + (index - _currentIndex),
        );
        _currentIndex = index;
      });
    }
    if (!widget.keepScrollOffset) {
      animateToDuration(widget.startDuration);
    }
    widget.onPageChange?.call(_currentDate, _currentIndex);
  }

  /// Animate to next page (next day).
  ///
  /// Transitions with animation using [pageTransitionDuration] and [pageTransitionCurve].
  ///
  /// See also: [previousPage], [jumpToDate], [animateToDate]
  void nextPage({Duration? duration, Curve? curve}) => _pageController.nextPage(
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve,
      );

  /// Animate to previous page (previous day).
  ///
  /// Transitions with animation using [pageTransitionDuration] and [pageTransitionCurve].
  ///
  /// See also: [nextPage], [jumpToDate], [animateToDate]
  void previousPage({Duration? duration, Curve? curve}) =>
      _pageController.previousPage(
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve,
      );

  /// Jumps to page index without animation.
  ///
  /// **Page Index Formula:** `pageIndex = date.getDayDifference(minDay)`
  ///
  /// **Prefer:** Use [jumpToDate] instead of this method for date-based navigation.
  ///
  /// **Throws:** Exception if page index is invalid.
  ///
  /// See also: [jumpToDate], [animateToPage]
  void jumpToPage(int page) => _pageController.jumpToPage(page);

  /// Animates to page index with animation.
  ///
  /// Arguments [duration] and [curve] override default transition values.
  ///
  /// **Page Index Formula:** `pageIndex = date.getDayDifference(minDay)`
  ///
  /// **Prefer:** Use [animateToDate] instead of this method for date-based navigation.
  ///
  /// See also: [animateToDate], [jumpToPage]
  Future<void> animateToPage(int page, {Duration? duration, Curve? curve}) =>
      _pageController.animateToPage(page,
          duration: duration ?? widget.pageTransitionDuration,
          curve: curve ?? widget.pageTransitionCurve);

  /// Returns current page index (number of days since [minDay]).
  int get currentPage => _currentIndex;

  /// Jumps to page which gives day calendar for [date]
  ///
  /// This is the preferred way to navigate to a specific date. It automatically
  /// calculates the correct page index based on the [minDay] parameter.
  ///
  /// **Example:**
  /// ```dart
  /// dayViewState.jumpToDate(DateTime(2024, 5, 15));
  /// ```
  ///
  /// **Note:** The [date] must be within the range [minDay] to [maxDay],
  /// otherwise an exception will be thrown.
  ///
  /// Throws an exception if [date] is outside the valid date range.
  void jumpToDate(DateTime date) {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getDayDifference(date));
  }

  /// Animate to page which gives day calendar for [date].
  ///
  /// Calculates the correct page index based on [minDay] and animates to it.
  /// Arguments [duration] and [curve] override default transition values.
  ///
  /// Throws an exception if [date] is outside the [minDay] to [maxDay] range.
  Future<void> animateToDate(DateTime date,
      {Duration? duration, Curve? curve}) async {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getDayDifference(date),
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Jumps to page which contains given events and make event
  /// tile visible to user.
  ///
  /// This method performs two operations:
  /// 1. Jumps to the page (day) containing the event
  /// 2. Scrolls to make the event tile visible
  ///
  /// **Example:**
  /// ```dart
  /// await dayViewState.jumpToEvent(myCalendarEvent);
  /// ```
  Future<void> jumpToEvent(CalendarEventData<T> event) async {
    jumpToDate(event.date);

    await _scrollConfiguration.setScrollEvent(
      event: event,
      duration: Duration.zero,
      curve: Curves.ease,
    );
  }

  /// Animate to page which contains given events and make event
  /// tile visible to user.
  ///
  /// This method performs two operations with animation:
  /// 1. Animates to the page (day) containing the event
  /// 2. Scrolls with animation to make the event tile visible
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  /// **Actual duration:** The total animation time will be 2 times the given duration:
  /// - First [duration]: animate to page
  /// - Second [duration]: scroll to event tile
  ///
  /// **Example:**
  /// If provided duration is 200 milliseconds, total animation time is 400 milliseconds.
  ///
  /// ```dart
  /// await dayViewState.animateToEvent(
  ///   myCalendarEvent,
  ///   duration: Duration(milliseconds: 300),
  /// );
  /// ```
  Future<void> animateToEvent(CalendarEventData<T> event,
      {Duration? duration, Curve? curve}) async {
    await animateToDate(event.date, duration: duration, curve: curve);
    await _scrollConfiguration.setScrollEvent(
      event: event,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to specific offset in a day view using the start duration
  ///
  /// This method scrolls to a specific time of day within the currently displayed page.
  ///
  /// **Parameters:**
  /// - [startDuration]: The time to scroll to (e.g., Duration(hours: 10) for 10:00 AM)
  /// - [duration]: Animation duration (default: 200ms)
  /// - [curve]: Animation curve (default: Curves.linear)
  ///
  /// **Example:**
  /// Scroll to 2:30 PM:
  /// ```dart
  /// await dayViewState.animateToDuration(
  ///   Duration(hours: 14, minutes: 30),
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  ///
  /// **Note:** If the duration exceeds 24 hours, it will be capped at 24 hours.
  Future<void> animateToDuration(
    Duration startDuration, {
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) async {
    final offSetForSingleMinute = _height / 24 / 60;
    final startDurationInMinutes = startDuration.inMinutes;

    // Added ternary condition below to take care if user passing duration
    // above 24 hrs then we take it max as 24 hours only
    final offset = offSetForSingleMinute *
        (startDurationInMinutes > 3600 ? 3600 : startDurationInMinutes);
    animateTo(
      offset.toDouble(),
      duration: duration,
      curve: curve,
    );
  }

  /// Animate to specific scroll controller offset
  ///
  /// This method scrolls to a specific pixel offset within the current page.
  ///
  /// **Parameters:**
  /// - [offset]: Target scroll offset in pixels
  /// - [duration]: Animation duration (default: 200ms)
  /// - [curve]: Animation curve (default: Curves.linear)
  ///
  /// **Example:**
  /// ```dart
  /// dayViewState.animateTo(500.0);
  /// ```
  void animateTo(
    double offset, {
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) {
    _scrollController.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// Returns the current visible date in day view.
  DateTime get currentDate =>
      DateTime(_currentDate.year, _currentDate.month, _currentDate.day);

  /// Listener for every day page ScrollController
  void _scrollPageListener(ScrollController controller) {
    _lastScrollOffset = controller.offset;
  }
}

class DayHeader {
  /// Hide Header Widget
  static Widget hidden(DateTime date) => SizedBox.shrink();
}
