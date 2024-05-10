// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import '../calendar_constants.dart';
import '../calendar_controller_provider.dart';
import '../calendar_event_data.dart';
import '../components/common_components.dart';
import '../components/day_view_components.dart';
import '../components/event_scroll_notifier.dart';
import '../components/safe_area_wrapper.dart';
import '../constants.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../extensions.dart';
import '../modals.dart';
import '../painters.dart';
import '../style/header_style.dart';
import '../typedefs.dart';
import '_internal_day_view_page.dart';

class DayView<T extends Object?> extends StatefulWidget {
  /// A function that returns a [Widget] that determines appearance of each
  /// cell in day calendar.
  final EventTileBuilder<T>? eventTileBuilder;

  /// A function to generate the DateString in the calendar title.
  /// Useful for I18n
  final StringProvider? dateStringBuilder;

  /// A function to generate the TimeString in the timeline.
  /// Useful for I18n
  final StringProvider? timeStringBuilder;

  /// A function that returns a [Widget] that will be displayed left side of
  /// day view.
  ///
  /// If null is provided then no time line will be visible.
  ///
  final DateWidgetBuilder? timeLineBuilder;

  /// Builds day title bar.
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

  /// Determines the lower boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.epochDate] is default.
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
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  final Curve pageTransitionCurve;

  /// A required parameters that controls events for day view.
  ///
  /// This will auto update day view when user adds events in controller.
  /// This controller will store all the events. And returns events
  /// for particular day.
  final EventController<T>? controller;

  /// Defines height occupied by one minute of interval.
  /// This will be used to calculate total height of day view.
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
  /// If [scrollOffset] is null then [startDuration] will be considered for
  /// initial offset.
  final double? scrollOffset;

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
  final MinuteSlotSize minuteSlotSize;

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

  /// Use this field to disable the page view scrolling behavior
  final ScrollPhysics? pageViewPhysics;

  /// Style for DayView header.
  final HeaderStyle headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Display full day event builder.
  final FullDayEventBuilder<T>? fullDayEventBuilder;

  /// First hour displayed in the layout, goes from 0 to 24
  final int startHour;

  /// Show half hour indicator
  final bool showHalfHours;

  /// Show quarter hour indicator(15min & 45min).
  final bool showQuarterHours;

  /// It define the starting duration from where day view page will be visible
  /// By default it will be Duration(hours:0)
  final Duration startDuration;

  /// Callback for the Header title
  final HeaderTitleCallback? onHeaderTitleTap;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for day view
  final int endHour;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

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
    this.backgroundColor = Colors.white,
    this.scrollOffset,
    this.onEventTap,
    this.onEventLongTap,
    this.onDateLongPress,
    this.onDateTap,
    this.minuteSlotSize = MinuteSlotSize.minutes60,
    this.headerStyle = const HeaderStyle(),
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
  late double _width;
  late double _height;
  late double _timeLineWidth;
  late double _hourHeight;
  late double _lastScrollOffset;
  late DateTime _currentDate;
  late DateTime _maxDate;
  late DateTime _minDate;
  late int _totalDays;
  late int _currentIndex;

  late EventArranger<T> _eventArranger;

  late HourIndicatorSettings _hourIndicatorSettings;
  late HourIndicatorSettings _halfHourIndicatorSettings;
  late HourIndicatorSettings _quarterHourIndicatorSettings;
  late CustomHourLinePainter _hourLinePainter;

  late LiveTimeIndicatorSettings _liveTimeIndicatorSettings;

  late PageController _pageController;

  late DateWidgetBuilder _timeLineBuilder;

  late EventTileBuilder<T> _eventTileBuilder;

  late DateWidgetBuilder _dayTitleBuilder;

  late FullDayEventBuilder<T> _fullDayEventBuilder;

  late DetectorBuilder _dayDetectorBuilder;

  EventController<T>? _controller;

  late ScrollController _scrollController;

  ScrollController get scrollController => _scrollController;

  late VoidCallback _reloadCallback;

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
                  decoration: BoxDecoration(color: widget.backgroundColor),
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
                            scrollListener: _scrollPageListener,
                            keepScrollOffset: widget.keepScrollOffset,
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
  ///
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
          color: Constants.defaultLiveTimeIndicatorColor,
          height: widget.heightPerMinute,
          offset: 5 + widget.verticalLineOffset,
        );

    assert(_liveTimeIndicatorSettings.height < _hourHeight,
        "liveTimeIndicator height must be less than minuteHeight * 60");

    _hourIndicatorSettings = widget.hourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: Constants.defaultBorderColor,
          offset: 5,
        );

    assert(_hourIndicatorSettings.height < _hourHeight,
        "hourIndicator height must be less than minuteHeight * 60");

    _halfHourIndicatorSettings = widget.halfHourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: Constants.defaultBorderColor,
          offset: 5,
        );

    assert(_halfHourIndicatorSettings.height < _hourHeight,
        "halfHourIndicator height must be less than minuteHeight * 60");

    _quarterHourIndicatorSettings = widget.quarterHourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: Constants.defaultBorderColor,
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
  }

  /// Sets the current date of this month.
  ///
  /// This method is used in initState and onUpdateWidget methods to
  /// regulate current date in Month view.
  ///
  /// If maximum and minimum dates are change then first call _setDateRange
  /// and then _regulateCurrentDate method.
  ///
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
  ///
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
  ///
  Widget _defaultTimeLineBuilder(date) => DefaultTimeLineMark(
      date: date, timeStringBuilder: widget.timeStringBuilder);

  /// Default timeline builder. This builder will be used if
  /// [widget.eventTileBuilder] is null
  ///
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
      onPreviousDay: previousPage,
      onTitleTapped: () async {
        if (widget.onHeaderTitleTap != null) {
          widget.onHeaderTitleTap!(date);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: _minDate,
            lastDate: _maxDate,
          );

          if (selectedDate == null) return;
          jumpToDate(selectedDate);
        }
      },
      headerStyle: widget.headerStyle,
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

  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  ///
  void nextPage({Duration? duration, Curve? curve}) => _pageController.nextPage(
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve,
      );

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  ///
  void previousPage({Duration? duration, Curve? curve}) =>
      _pageController.previousPage(
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve,
      );

  /// Jumps to page number [page]
  ///
  ///
  void jumpToPage(int page) => _pageController.jumpToPage(page);

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  ///
  Future<void> animateToPage(int page, {Duration? duration, Curve? curve}) =>
      _pageController.animateToPage(page,
          duration: duration ?? widget.pageTransitionDuration,
          curve: curve ?? widget.pageTransitionCurve);

  /// Returns current page number.
  ///
  ///
  int get currentPage => _currentIndex;

  /// Jumps to page which gives day calendar for [date]
  ///
  ///
  void jumpToDate(DateTime date) {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getDayDifference(date));
  }

  /// Animate to page which gives day calendar for [date].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  ///
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
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  /// Actual duration will be 2 times the given duration.
  ///
  /// Ex, If provided duration is 200 milliseconds then this function will take
  /// 200 milliseconds for animate to page then 200 milliseconds for
  /// scroll to event tile.
  ///
  ///
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
