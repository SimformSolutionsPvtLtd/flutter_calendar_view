// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_constants.dart';
import '../calendar_controller_provider.dart';
import '../calendar_event_data.dart';
import '../components/common_components.dart';
import '../components/components.dart';
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
import '_internal_week_view_page.dart';

/// [Widget] to display week view.
class WeekView<T extends Object?> extends StatefulWidget {
  /// Builder to build tile for events.
  final EventTileBuilder<T>? eventTileBuilder;

  /// Builder for timeline.
  final DateWidgetBuilder? timeLineBuilder;

  /// Header builder for week page header.
  final WeekPageHeaderBuilder? weekPageHeaderBuilder;

  /// Builds custom PressDetector widget
  ///
  /// If null, internal PressDetector will be used to handle onDateLongPress()
  ///
  final DetectorBuilder? weekDetectorBuilder;

  /// This function will generate dateString int the calendar header.
  /// Useful for I18n
  final StringProvider? headerStringBuilder;

  /// This function will generate the TimeString in the timeline.
  /// Useful for I18n
  final StringProvider? timeLineStringBuilder;

  /// This function will generate WeekDayString in the weekday.
  /// Useful for I18n
  final String Function(int)? weekDayStringBuilder;

  /// This function will generate WeekDayDateString in the weekday.
  /// Useful for I18n
  final String Function(int)? weekDayDateStringBuilder;

  /// Arrange events.
  final EventArranger<T>? eventArranger;

  /// Called whenever user changes week.
  final CalendarPageChangeCallBack? onPageChange;

  /// Minimum day to display in week view.
  ///
  /// In calendar first date of the week that contains this data will be
  /// minimum date.
  ///
  /// ex, If minDay is 16th March, 2022 then week containing this date will have
  /// dates from 14th to 20th (Monday to Sunday). adn 14th date will
  /// be the actual minimum date.
  final DateTime? minDay;

  /// Maximum day to display in week view.
  ///
  /// In calendar last date of the week that contains this data will be
  /// maximum date.
  ///
  /// ex, If maxDay is 16th March, 2022 then week containing this date will have
  /// dates from 14th to 20th (Monday to Sunday). adn 20th date will
  /// be the actual maximum date.
  final DateTime? maxDay;

  /// Initial week to display in week view.
  final DateTime? initialDay;

  /// Settings for hour indicator settings.
  final HourIndicatorSettings? hourIndicatorSettings;

  /// A funtion that returns a [CustomPainter].
  ///
  /// Use this if you want to paint custom hour lines.
  final CustomHourLinePainter? hourLinePainter;

  /// Settings for half hour indicator settings.
  final HourIndicatorSettings? halfHourIndicatorSettings;

  /// Settings for quarter hour indicator settings.
  final HourIndicatorSettings? quarterHourIndicatorSettings;

  /// Settings for live time indicator settings.
  final LiveTimeIndicatorSettings? liveTimeIndicatorSettings;

  /// duration for page transition while changing the week.
  final Duration pageTransitionDuration;

  /// Transition curve for transition.
  final Curve pageTransitionCurve;

  /// Controller for Week view thia will refresh view when user adds or removes
  /// event from controller.
  final EventController<T>? controller;

  /// Defines height occupied by one minute of time span. This parameter will
  /// be used to calculate total height of Week view.
  final double heightPerMinute;

  /// Width of time line.
  final double? timeLineWidth;

  /// Flag to show live time indicator in all day or only [initialDay]
  final bool showLiveTimeLineInAllDays;

  /// Offset of time line
  final double timeLineOffset;

  /// Width of week view. If null provided device width will be considered.
  final double? width;

  /// If true this will display vertical lines between each day.
  final bool showVerticalLines;

  /// Height of week day title,
  final double weekTitleHeight;

  /// Builder to build week day.
  final DateWidgetBuilder? weekDayBuilder;

  /// Builder to build week number.
  final WeekNumberBuilder? weekNumberBuilder;

  /// Background color of week view page.
  final Color backgroundColor;

  /// Scroll offset of week view page.
  final double scrollOffset;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onEventTap;

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onEventLongTap;

  /// Called when user double taps on any event tile.
  final CellTapCallback<T>? onEventDoubleTap;

  /// Show weekends or not
  ///
  /// Default value is true.
  ///
  /// If it is false week view will remove weekends from week
  /// even if weekends are added in [weekDays].
  ///
  /// ex, if [showWeekends] is false and [weekDays] are monday, tuesday,
  /// saturday and sunday, only monday and tuesday will be visible in week view.
  final bool showWeekends;

  /// Defines which days should be displayed in one week.
  ///
  /// By default all the days will be visible.
  /// Sequence will be monday to sunday.
  ///
  /// Duplicate values will be removed from list.
  ///
  /// ex, if there are two mondays in list it will display only one.
  final List<WeekDays> weekDays;

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

  /// Defines the day from which the week starts.
  ///
  /// Default value is [WeekDays.monday].
  final WeekDays startDay;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  final MinuteSlotSize minuteSlotSize;

  /// Style for WeekView header.
  final HeaderStyle headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Display full day event builder.
  final FullDayEventBuilder<T>? fullDayEventBuilder;

  /// First hour displayed in the layout, goes from 0 to 24
  final int startHour;

  /// This field will be used to set end hour for week view
  final int endHour;

  ///Show half hour indicator
  final bool showHalfHours;

  ///Show quarter hour indicator
  final bool showQuarterHours;

  ///Emulates offset of vertical line from hour line starts.
  final double emulateVerticalOffsetBy;

  /// Callback for the Header title
  final HeaderTitleCallback? onHeaderTitleTap;

  /// If true this will show week day at bottom position.
  final bool showWeekDayAtBottom;

  /// Defines scroll physics for a page of a week view.
  ///
  /// This can be used to disable the horizontal scroll of a page.
  final ScrollPhysics? pageViewPhysics;

  /// Title of the full day events row
  final String fullDayHeaderTitle;

  /// Defines full day events header text config
  final FullDayHeaderTextConfig? fullDayHeaderTextConfig;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

  /// Main widget for week view.
  const WeekView({
    Key? key,
    this.controller,
    this.eventTileBuilder,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.heightPerMinute = 1,
    this.timeLineOffset = 0,
    this.showLiveTimeLineInAllDays = false,
    this.showVerticalLines = true,
    this.width,
    this.minDay,
    this.maxDay,
    this.initialDay,
    this.hourIndicatorSettings,
    this.hourLinePainter,
    this.halfHourIndicatorSettings,
    this.quarterHourIndicatorSettings,
    this.timeLineBuilder,
    this.timeLineWidth,
    this.liveTimeIndicatorSettings,
    this.onPageChange,
    this.weekPageHeaderBuilder,
    this.eventArranger,
    this.weekTitleHeight = 50,
    this.weekDayBuilder,
    this.weekNumberBuilder,
    this.backgroundColor = Colors.white,
    this.scrollOffset = 0.0,
    this.onEventTap,
    this.onEventLongTap,
    this.onDateLongPress,
    this.onDateTap,
    this.weekDays = WeekDays.values,
    this.showWeekends = true,
    this.startDay = WeekDays.monday,
    this.minuteSlotSize = MinuteSlotSize.minutes60,
    this.weekDetectorBuilder,
    this.headerStringBuilder,
    this.timeLineStringBuilder,
    this.weekDayStringBuilder,
    this.weekDayDateStringBuilder,
    this.headerStyle = const HeaderStyle(),
    this.safeAreaOption = const SafeAreaOption(),
    this.fullDayEventBuilder,
    this.startHour = 0,
    this.onHeaderTitleTap,
    this.showHalfHours = false,
    this.showQuarterHours = false,
    this.emulateVerticalOffsetBy = 0,
    this.showWeekDayAtBottom = false,
    this.pageViewPhysics,
    this.onEventDoubleTap,
    this.endHour = Constants.hoursADay,
    this.fullDayHeaderTitle = '',
    this.fullDayHeaderTextConfig,
    this.keepScrollOffset = false,
  })  : assert(!(onHeaderTitleTap != null && weekPageHeaderBuilder != null),
            "can't use [onHeaderTitleTap] & [weekPageHeaderBuilder] simultaneously"),
        assert((timeLineOffset) >= 0,
            "timeLineOffset must be greater than or equal to 0"),
        assert(width == null || width > 0,
            "Calendar width must be greater than 0."),
        assert(timeLineWidth == null || timeLineWidth > 0,
            "Time line width must be greater than 0."),
        assert(
            heightPerMinute > 0, "Height per minute must be greater than 0."),
        assert(
          weekDetectorBuilder == null || onDateLongPress == null,
          """If you use [weekPressDetectorBuilder] 
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
  WeekViewState<T> createState() => WeekViewState<T>();
}

class WeekViewState<T extends Object?> extends State<WeekView<T>> {
  late double _width;
  late double _height;
  late double _timeLineWidth;
  late double _hourHeight;
  late double _lastScrollOffset;
  late DateTime _currentStartDate;
  late DateTime _currentEndDate;
  late DateTime _maxDate;
  late DateTime _minDate;
  late DateTime _currentWeek;
  late int _totalWeeks;
  late int _currentIndex;
  late String _fullDayHeaderTitle;

  late EventArranger<T> _eventArranger;

  late HourIndicatorSettings _hourIndicatorSettings;
  late CustomHourLinePainter _hourLinePainter;

  late HourIndicatorSettings _halfHourIndicatorSettings;
  late LiveTimeIndicatorSettings _liveTimeIndicatorSettings;
  late HourIndicatorSettings _quarterHourIndicatorSettings;

  late PageController _pageController;

  late DateWidgetBuilder _timeLineBuilder;
  late EventTileBuilder<T> _eventTileBuilder;
  late WeekPageHeaderBuilder _weekHeaderBuilder;
  late DateWidgetBuilder _weekDayBuilder;
  late WeekNumberBuilder _weekNumberBuilder;
  late FullDayEventBuilder<T> _fullDayEventBuilder;
  late DetectorBuilder _weekDetectorBuilder;
  late FullDayHeaderTextConfig _fullDayHeaderTextConfig;

  late double _weekTitleWidth;
  late int _totalDaysInWeek;

  late VoidCallback _reloadCallback;

  EventController<T>? _controller;

  late ScrollController _scrollController;

  ScrollController get scrollController => _scrollController;

  late List<WeekDays> _weekDays;

  late int _startHour;
  late int _endHour;

  final _scrollConfiguration = EventScrollConfiguration();

  @override
  void initState() {
    super.initState();
    _lastScrollOffset = widget.scrollOffset;

    _scrollController =
        ScrollController(initialScrollOffset: widget.scrollOffset);

    _startHour = widget.startHour;
    _endHour = widget.endHour;

    _reloadCallback = _reload;

    _setWeekDays();
    _setDateRange();

    _currentWeek = (widget.initialDay ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();

    _calculateHeights();

    _pageController = PageController(initialPage: _currentIndex);
    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();

    _assignBuilders();
    _fullDayHeaderTitle = widget.fullDayHeaderTitle;
    _fullDayHeaderTextConfig =
        widget.fullDayHeaderTextConfig ?? FullDayHeaderTextConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (_controller != newController) {
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
  void didUpdateWidget(WeekView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller.
    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    _setWeekDays();

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
              _weekHeaderBuilder(
                _currentStartDate,
                _currentEndDate,
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: widget.backgroundColor),
                  child: SizedBox(
                    height: _height,
                    width: _width,
                    child: PageView.builder(
                      itemCount: _totalWeeks,
                      controller: _pageController,
                      physics: widget.pageViewPhysics,
                      onPageChanged: _onPageChange,
                      itemBuilder: (_, index) {
                        final dates = DateTime(_minDate.year, _minDate.month,
                                _minDate.day + (index * DateTime.daysPerWeek))
                            .datesOfWeek(start: widget.startDay);

                        return ValueListenableBuilder(
                          valueListenable: _scrollConfiguration,
                          builder: (_, __, ___) => InternalWeekViewPage<T>(
                            key: ValueKey(
                                _hourHeight.toString() + dates[0].toString()),
                            height: _height,
                            width: _width,
                            weekTitleWidth: _weekTitleWidth,
                            weekTitleHeight: widget.weekTitleHeight,
                            weekDayBuilder: _weekDayBuilder,
                            weekNumberBuilder: _weekNumberBuilder,
                            weekDetectorBuilder: _weekDetectorBuilder,
                            liveTimeIndicatorSettings:
                                _liveTimeIndicatorSettings,
                            timeLineBuilder: _timeLineBuilder,
                            onTileTap: widget.onEventTap,
                            onTileLongTap: widget.onEventLongTap,
                            onDateLongPress: widget.onDateLongPress,
                            onDateTap: widget.onDateTap,
                            onTileDoubleTap: widget.onEventDoubleTap,
                            eventTileBuilder: _eventTileBuilder,
                            heightPerMinute: widget.heightPerMinute,
                            hourIndicatorSettings: _hourIndicatorSettings,
                            hourLinePainter: _hourLinePainter,
                            halfHourIndicatorSettings:
                                _halfHourIndicatorSettings,
                            quarterHourIndicatorSettings:
                                _quarterHourIndicatorSettings,
                            dates: dates,
                            showLiveLine: widget.showLiveTimeLineInAllDays ||
                                _showLiveTimeIndicator(dates),
                            timeLineOffset: widget.timeLineOffset,
                            timeLineWidth: _timeLineWidth,
                            verticalLineOffset: 0,
                            showVerticalLine: widget.showVerticalLines,
                            controller: controller,
                            hourHeight: _hourHeight,
                            weekViewScrollController: _scrollController,
                            eventArranger: _eventArranger,
                            weekDays: _weekDays,
                            minuteSlotSize: widget.minuteSlotSize,
                            scrollConfiguration: _scrollConfiguration,
                            fullDayEventBuilder: _fullDayEventBuilder,
                            startHour: _startHour,
                            showHalfHours: widget.showHalfHours,
                            showQuarterHours: widget.showQuarterHours,
                            emulateVerticalOffsetBy:
                                widget.emulateVerticalOffsetBy,
                            showWeekDayAtBottom: widget.showWeekDayAtBottom,
                            endHour: _endHour,
                            fullDayHeaderTitle: _fullDayHeaderTitle,
                            fullDayHeaderTextConfig: _fullDayHeaderTextConfig,
                            lastScrollOffset: _lastScrollOffset,
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
  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  void _setWeekDays() {
    _weekDays = widget.weekDays.toSet().toList();

    if (!widget.showWeekends) {
      _weekDays
        ..remove(WeekDays.saturday)
        ..remove(WeekDays.sunday);
    }

    assert(
        _weekDays.isNotEmpty,
        "weekDays can not be empty.\n"
        "Make sure you are providing weekdays in initialization of "
        "WeekView. or showWeekends is true if you are providing only "
        "saturday or sunday in weekDays.");
    _totalDaysInWeek = _weekDays.length;
  }

  void _updateViewDimensions() {
    _timeLineWidth = widget.timeLineWidth ?? _width * 0.13;

    _liveTimeIndicatorSettings = widget.liveTimeIndicatorSettings ??
        LiveTimeIndicatorSettings(
          color: Constants.defaultLiveTimeIndicatorColor,
          height: widget.heightPerMinute,
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

    _weekTitleWidth =
        (_width - _timeLineWidth - _hourIndicatorSettings.offset) /
            _totalDaysInWeek;

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
          color: Constants.defaultBorderColor,
        );

    assert(_quarterHourIndicatorSettings.height < _hourHeight,
        "quarterHourIndicator height must be less than minuteHeight * 60");
  }

  void _calculateHeights() {
    _hourHeight = widget.heightPerMinute * 60;
    _height = _hourHeight * (_endHour - _startHour);
  }

  void _assignBuilders() {
    _timeLineBuilder = widget.timeLineBuilder ?? _defaultTimeLineBuilder;
    _eventTileBuilder = widget.eventTileBuilder ?? _defaultEventTileBuilder;
    _weekHeaderBuilder =
        widget.weekPageHeaderBuilder ?? _defaultWeekPageHeaderBuilder;
    _weekDayBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;
    _weekDetectorBuilder =
        widget.weekDetectorBuilder ?? _defaultPressDetectorBuilder;
    _weekNumberBuilder = widget.weekNumberBuilder ?? _defaultWeekNumberBuilder;
    _fullDayEventBuilder =
        widget.fullDayEventBuilder ?? _defaultFullDayEventBuilder;
    _hourLinePainter = widget.hourLinePainter ?? _defaultHourLinePainter;
  }

  Widget _defaultFullDayEventBuilder(
      List<CalendarEventData<T>> events, DateTime dateTime) {
    return FullDayEventView(
      events: events,
      boxConstraints: BoxConstraints(maxHeight: 65),
      date: dateTime,
      onEventTap: widget.onEventTap,
      onEventDoubleTap: widget.onEventDoubleTap,
      onEventLongPress: widget.onEventLongTap,
    );
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
    if (_currentWeek.isBefore(_minDate)) {
      _currentWeek = _minDate;
    } else if (_currentWeek.isAfter(_maxDate)) {
      _currentWeek = _maxDate;
    }

    _currentStartDate = _currentWeek.firstDayOfWeek(start: widget.startDay);
    _currentEndDate = _currentWeek.lastDayOfWeek(start: widget.startDay);
    _currentIndex =
        _minDate.getWeekDifference(_currentEndDate, start: widget.startDay);
  }

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    _minDate = (widget.minDay ?? CalendarConstants.epochDate)
        .firstDayOfWeek(start: widget.startDay)
        .withoutTime;

    _maxDate = (widget.maxDay ?? CalendarConstants.maxDate)
        .lastDayOfWeek(start: widget.startDay)
        .withoutTime;

    assert(
      _minDate.isBefore(_maxDate),
      "Minimum date must be less than maximum date.\n"
      "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    _totalWeeks =
        _minDate.getWeekDifference(_maxDate, start: widget.startDay) + 1;
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
        startHour: _startHour,
      );

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(DateTime date) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.weekDayStringBuilder?.call(date.weekday - 1) ??
              Constants.weekTitles[date.weekday - 1]),
          Text(widget.weekDayDateStringBuilder?.call(date.day) ??
              date.day.toString()),
        ],
      ),
    );
  }

  /// Default builder for week number.
  Widget _defaultWeekNumberBuilder(DateTime date) {
    final daysToAdd = DateTime.thursday - date.weekday;
    final thursday = daysToAdd > 0
        ? date.add(Duration(days: daysToAdd))
        : date.subtract(Duration(days: daysToAdd.abs()));
    final weekNumber =
        (date.difference(DateTime(thursday.year)).inDays / 7).floor() + 1;
    return Center(
      child: Text("$weekNumber"),
    );
  }

  /// Default timeline builder this builder will be used if
  /// [widget.eventTileBuilder] is null
  ///
  Widget _defaultTimeLineBuilder(DateTime date) => DefaultTimeLineMark(
        date: date,
        timeStringBuilder: widget.timeLineStringBuilder,
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
  Widget _defaultWeekPageHeaderBuilder(
    DateTime startDate,
    DateTime endDate,
  ) {
    return WeekPageHeader(
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      onNextDay: nextPage,
      onPreviousDay: previousPage,
      onTitleTapped: () async {
        if (widget.onHeaderTitleTap != null) {
          widget.onHeaderTitleTap!(startDate);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: _minDate,
            lastDate: _maxDate,
          );

          if (selectedDate == null) return;
          jumpToWeek(selectedDate);
        }
      },
      headerStringBuilder: widget.headerStringBuilder,
      headerStyle: widget.headerStyle,
    );
  }

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
  void _onPageChange(int index) {
    if (mounted) {
      setState(() {
        _currentStartDate = DateTime(
          _currentStartDate.year,
          _currentStartDate.month,
          _currentStartDate.day + (index - _currentIndex) * 7,
        );
        _currentEndDate = _currentStartDate.add(Duration(days: 6));
        _currentIndex = index;
      });
    }
    widget.onPageChange?.call(_currentStartDate, _currentIndex);
  }

  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Jumps to page number [page]
  ///
  ///
  void jumpToPage(int page) => _pageController.jumpToPage(page);

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve);
  }

  /// Returns current page number.
  int get currentPage => _currentIndex;

  /// Jumps to page which gives day calendar for [week]
  void jumpToWeek(DateTime week) {
    if (week.isBefore(_minDate) || week.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController
        .jumpToPage(_minDate.getWeekDifference(week, start: widget.startDay));
  }

  /// Animate to page which gives day calendar for [week].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [WeekView.pageTransitionDuration] and [WeekView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToWeek(DateTime week,
      {Duration? duration, Curve? curve}) async {
    if (week.isBefore(_minDate) || week.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getWeekDifference(week, start: widget.startDay),
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible week's first date.
  DateTime get currentDate => DateTime(
      _currentStartDate.year, _currentStartDate.month, _currentStartDate.day);

  /// Jumps to page which contains given events and make event
  /// tile visible to user.
  ///
  Future<void> jumpToEvent(CalendarEventData<T> event) async {
    jumpToWeek(event.date);

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
    await animateToWeek(event.date, duration: duration, curve: curve);
    await _scrollConfiguration.setScrollEvent(
      event: event,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
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

  /// check if any dates contains current date or not.
  /// Returns true if it does else false.
  bool _showLiveTimeIndicator(List<DateTime> dates) =>
      dates.any((date) => date.compareWithoutTime(DateTime.now()));

  /// Listener for every week page ScrollController
  void _scrollPageListener(ScrollController controller) {
    _lastScrollOffset = controller.offset;
  }
}

class WeekHeader {
  /// Hide Header Widget
  static Widget hidden(DateTime date, DateTime date1) => SizedBox.shrink();
}
