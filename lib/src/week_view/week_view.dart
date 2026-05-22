// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';
import '../extensions.dart';
import '../painters.dart';
import '../zoom_scroll_controller.dart';
import '_internal_week_view_page.dart';

/// [Widget] to display week view.
class WeekView<T extends Object?> extends StatefulWidget {
  /// Builder to build tile for events.
  final EventTileBuilder<T>? eventTileBuilder;

  /// Builder for timeline.
  final DateWidgetBuilder? timeLineBuilder;

  /// Header builder for week page header.
  ///
  /// If there are some configurations that is not directly available
  /// in [WeekView], override this to create your custom header or reuse,
  /// [CalendarPageHeader] | [DayPageHeader] | [MonthPageHeader] |
  /// [WeekPageHeader] widgets provided by this package with your custom
  /// configurations.
  final WeekPageHeaderBuilder? weekPageHeaderBuilder;

  /// Builds custom PressDetector widget.
  /// If null, internal PressDetector handles [onDateLongPress].
  final DetectorBuilder? weekDetectorBuilder;

  /// Generates date string in the calendar header. Useful for I18n.
  final StringProvider? headerStringBuilder;

  /// Generates time string in the timeline. Useful for I18n.
  final StringProvider? timeLineStringBuilder;

  /// Generates week day string. Useful for I18n.
  final String Function(int)? weekDayStringBuilder;

  /// Generates week day date string. Useful for I18n.
  final String Function(int)? weekDayDateStringBuilder;

  /// Arrange events.
  final EventArranger<T>? eventArranger;

  /// Called whenever user changes week.
  final CalendarPageChangeCallBack? onPageChange;

  /// Minimum day to display (base date for page indexing).
  ///
  /// The week containing this date will be the minimum week displayed.
  /// If not provided, [CalendarConstants.epochDate] (1900-01-01) is used.
  /// Use same [minDay] across all views when switching between them.
  final DateTime? minDay;

  /// Maximum day to display in week view.
  ///
  /// The last date of the week containing this date will be the maximum displayed.
  /// If not provided, [CalendarConstants.maxDate] is used.
  final DateTime? maxDay;

  /// Initial week to display in week view.
  final DateTime? initialDay;

  /// Settings for hour indicator settings.
  final HourIndicatorSettings? hourIndicatorSettings;

  /// A function that returns a [CustomPainter].
  ///
  /// Use this if you want to paint custom hour lines.
  final CustomHourLinePainter? hourLinePainter;

  /// Settings for half hour indicator settings.
  final HourIndicatorSettings? halfHourIndicatorSettings;

  /// Settings for quarter hour indicator settings.
  final HourIndicatorSettings? quarterHourIndicatorSettings;

  /// Settings for divider between FullDay events and weekdays header.
  final DividerSettings? dividerSettings;

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

  /// Background color of week title
  final Color? weekTitleBackgroundColor;

  /// Builder to build week day.
  final DateWidgetBuilder? weekDayBuilder;

  /// Builder to build week number.
  final WeekNumberBuilder? weekNumberBuilder;

  /// Background color of week view page.
  final Color? backgroundColor;

  /// Scroll offset of week view page.
  final double scrollOffset;

  /// This method will be called when user taps on timestamp in timeline.
  final TimestampCallback? onTimestampTap;

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
  final HeaderStyle? headerStyle;

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

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

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

  /// A callback that resolves slot background color for each visible time slot.
  /// Useful for highlighting unavailable hours, business hours, or blocked time.
  final TimeSlotColorBuilder? timeSlotColorBuilder;

  /// Flag to display the 00:00 (midnight) hour in the timeline.
  final bool showMidnightHour;

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
    this.dividerSettings,
    this.timeLineBuilder,
    this.timeLineWidth,
    this.liveTimeIndicatorSettings,
    this.onPageChange,
    this.weekPageHeaderBuilder,
    this.eventArranger,
    this.weekTitleHeight = 50,
    this.weekTitleBackgroundColor,
    this.weekDayBuilder,
    this.weekNumberBuilder,
    this.backgroundColor,
    this.scrollPhysics,
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
    this.headerStyle,
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
    this.onTimestampTap,
    this.timeSlotColorBuilder,
    this.showMidnightHour = false,
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
  /// Width of the Week View widget in pixels.
  late double _width;

  /// Total height of the visible week view.
  /// Calculated as: hourHeight * (endHour - startHour)
  late double _height;

  /// Width allocated for the timeline/hour labels on the left side.
  late double _timeLineWidth;

  /// Height occupied by a single hour in pixels.
  /// Calculated as: heightPerMinute * 60
  late double _hourHeight;

  /// Last recorded scroll offset position.
  late double _lastScrollOffset;

  /// Start date of the currently displayed week.
  late DateTime _currentStartDate;

  /// End date of the currently displayed week.
  late DateTime _currentEndDate;

  /// Maximum date user can scroll to (aligned to week end).
  late DateTime _maxDate;

  /// Minimum date user can scroll to (reference for page indexing).
  /// Calculated as: weekIndex = (weekStartDate - minWeekStartDate) / 7
  late DateTime _minDate;

  /// Reference week for page index calculations.
  late DateTime _currentWeek;

  /// Total number of weeks available in the calendar range.
  late int _totalWeeks;

  /// Current page index in the PageView controller.
  late int _currentIndex;

  /// Title text for the full-day events section.
  late String _fullDayHeaderTitle;

  /// Event arrangement strategy for positioning events.
  late EventArranger<T> _eventArranger;

  /// Settings for full hour indicator lines.
  late HourIndicatorSettings _hourIndicatorSettings;

  /// Custom painter for drawing hour lines.
  late CustomHourLinePainter _hourLinePainter;

  /// Settings for half-hour indicator lines.
  late HourIndicatorSettings _halfHourIndicatorSettings;

  /// Settings for the live time indicator.
  late LiveTimeIndicatorSettings _liveTimeIndicatorSettings;

  /// Settings for quarter-hour indicator lines.
  late HourIndicatorSettings _quarterHourIndicatorSettings;

  /// Settings for divider between FullDay events and weekdays header.
  late DividerSettings _dividerSettings;

  /// Builder for adding custom colors to time slots in the day view.
  late TimeSlotColorBuilder? _timeSlotColorBuilder;

  /// Controller for managing page transitions between weeks.
  /// Used for navigating to different weeks.
  late PageController _pageController;

  /// Builder function for creating timeline/hour labels.
  late DateWidgetBuilder _timeLineBuilder;

  /// Builder function for creating event tiles.
  late EventTileBuilder<T> _eventTileBuilder;

  /// Builder function for creating the week header.
  late WeekPageHeaderBuilder _weekHeaderBuilder;

  /// Builder function for creating week day headers.
  late DateWidgetBuilder _weekDayBuilder;

  /// Builder function for creating week number display.
  late WeekNumberBuilder _weekNumberBuilder;

  /// Builder function for creating full-day event displays.
  late FullDayEventBuilder<T> _fullDayEventBuilder;

  /// Builder function for creating the press detector overlay.
  late DetectorBuilder _weekDetectorBuilder;

  /// Configuration for styling the full-day event header text.
  late FullDayHeaderTextConfig _fullDayHeaderTextConfig;

  /// Width allocated for each day column.
  /// Calculated as: (totalWidth - timelineWidth) / totalDaysInWeek
  late double _weekTitleWidth;

  /// Number of days in a week (typically 7).
  /// Used for layout calculations and iteration.
  late int _totalDaysInWeek;

  /// Callback function triggered when events change or rebuild is needed.
  late VoidCallback _reloadCallback;

  /// Event controller for managing calendar events.
  /// Provides data for rendering events for the week.
  EventController<T>? _controller;

  /// Scroll controller for managing vertical scrolling.
  late ZoomScrollController _scrollController;

  /// Public getter for accessing the scroll controller.
  ScrollController get scrollController => _scrollController;

  /// List of days in a week with their properties (name, order, etc.).
  /// Used for rendering day headers and determining week layout.
  late List<WeekDays> _weekDays;

  /// First hour to display in the week view (0-23).
  /// Controls the starting hour of the visible time range.
  late int _startHour;

  /// Last hour to display in the week view (1-24).
  /// Controls the ending hour of the visible time range.
  late int _endHour;

  /// Configuration for handling scroll events when jumping/animating to specific events.
  final _scrollConfiguration = EventScrollConfiguration();

  @override
  void initState() {
    super.initState();
    _lastScrollOffset = widget.scrollOffset;

    _scrollController =
        ZoomScrollController(initialScrollOffset: widget.scrollOffset);

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
    _startHour = widget.startHour;
    _endHour = widget.endHour;

    // Update heights.
    _calculateHeights();

    // Update builders and callbacks
    _assignBuilders();

    if (widget.heightPerMinute != oldWidget.heightPerMinute) {
      // Read the ACTUAL current scroll position from the shared controller
      // (not _lastScrollOffset, which is only updated when keepScrollOffset=true).
      // Scale it proportionally so the same time slot stays visible after zoom.
      final currentOffset = _scrollController.hasClients
          ? _scrollController.offset
          : _lastScrollOffset;
      final scaledOffset = currentOffset *
          widget.heightPerMinute /
          (oldWidget.heightPerMinute > 0 ? oldWidget.heightPerMinute : 1.0);
      _lastScrollOffset = scaledOffset;
      // prepareZoomJump stores the target offset so ZoomScrollController can
      // apply it inside applyContentDimensions (during layout, before paint),
      // eliminating the one-frame flicker that addPostFrameCallback caused.
      _scrollController.prepareZoomJump(scaledOffset);
    }

    if (widget.scrollOffset != oldWidget.scrollOffset) {
      _lastScrollOffset = widget.scrollOffset;
      _jumpToOffsetAfterPageTransition(widget.scrollOffset);
    }
  }

  void _runAfterPageTransition(VoidCallback action) {
    if (!_pageController.hasClients) {
      action();
      return;
    }

    final pagePosition = _pageController.position;

    if (!pagePosition.isScrollingNotifier.value) {
      action();
      return;
    }

    late VoidCallback listener;
    listener = () {
      if (!mounted) {
        pagePosition.isScrollingNotifier.removeListener(listener);
        return;
      }

      if (!pagePosition.isScrollingNotifier.value) {
        pagePosition.isScrollingNotifier.removeListener(listener);
        action();
      }
    };

    pagePosition.isScrollingNotifier.addListener(listener);
  }

  void _jumpToOffsetAfterPageTransition(double offset) {
    _runAfterPageTransition(() {
      if (!_scrollController.hasClients) return;

      final clampedOffset = offset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );

      _lastScrollOffset = clampedOffset.toDouble();
      _scrollController.jumpTo(clampedOffset.toDouble());
    });
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
                          .datesOfWeek(
                        start: widget.startDay,
                        showWeekEnds: widget.showWeekends,
                      );
                      return ValueListenableBuilder(
                        valueListenable: _scrollConfiguration,
                        builder: (_, __, ___) => InternalWeekViewPage<T>(
                          key: ValueKey(dates[0].toString()),
                          height: _height,
                          width: _width,
                          weekTitleWidth: _weekTitleWidth,
                          weekTitleHeight: widget.weekTitleHeight,
                          weekTitleBackgroundColor:
                              widget.weekTitleBackgroundColor,
                          weekDayBuilder: _weekDayBuilder,
                          weekNumberBuilder: _weekNumberBuilder,
                          weekDetectorBuilder: _weekDetectorBuilder,
                          liveTimeIndicatorSettings: _liveTimeIndicatorSettings,
                          timeLineBuilder: _timeLineBuilder,
                          onTimestampTap: widget.onTimestampTap,
                          onTileTap: widget.onEventTap,
                          onTileLongTap: widget.onEventLongTap,
                          onDateLongPress: widget.onDateLongPress,
                          onDateTap: widget.onDateTap,
                          onTileDoubleTap: widget.onEventDoubleTap,
                          eventTileBuilder: _eventTileBuilder,
                          heightPerMinute: widget.heightPerMinute,
                          backgroundColor: widget.backgroundColor,
                          hourIndicatorSettings: _hourIndicatorSettings,
                          hourLinePainter: _hourLinePainter,
                          halfHourIndicatorSettings: _halfHourIndicatorSettings,
                          quarterHourIndicatorSettings:
                              _quarterHourIndicatorSettings,
                          dividerSettings: _dividerSettings,
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
          color: context.weekViewColors.liveIndicatorColor,
          height: widget.heightPerMinute,
        );

    assert(_liveTimeIndicatorSettings.height < _hourHeight,
        "liveTimeIndicator height must be less than minuteHeight * 60");

    _hourIndicatorSettings = widget.hourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: context.weekViewColors.hourLineColor,
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
          color: context.weekViewColors.halfHourLineColor,
          offset: 5,
        );

    assert(_halfHourIndicatorSettings.height < _hourHeight,
        "halfHourIndicator height must be less than minuteHeight * 60");

    _quarterHourIndicatorSettings = widget.quarterHourIndicatorSettings ??
        HourIndicatorSettings(
          color: context.weekViewColors.quarterHourLineColor,
        );

    assert(_quarterHourIndicatorSettings.height < _hourHeight,
        "quarterHourIndicator height must be less than minuteHeight * 60");

    _dividerSettings = widget.dividerSettings ??
        DividerSettings(
          color: context.weekViewColors.borderColor,
        );
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
    _timeSlotColorBuilder = widget.timeSlotColorBuilder;
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

  /// Default press detector builder (used if [widget.weekDetectorBuilder] is null).
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

  /// Default builder for the week day header displaying day name and date.
  Widget _defaultWeekDayBuilder(DateTime date) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.weekDayStringBuilder?.call(date.weekday - 1) ??
                PackageStrings.currentLocale.weekdays[date.weekday - 1],
            style: TextStyle(
              color: context.weekViewColors.weekDayTextColor,
            ),
          ),
          Text(
            widget.weekDayDateStringBuilder?.call(date.day) ??
                PackageStrings.localizeNumber(date.day),
            style: TextStyle(
              color: context.weekViewColors.weekDayTextColor,
            ),
          ),
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
      child: Text(
        PackageStrings.localizeNumber(weekNumber),
        style: TextStyle(
          color: context.weekViewColors.weekDayTextColor,
        ),
      ),
    );
  }

  /// Default timeline builder (used if [widget.eventTileBuilder] is null).
  Widget _defaultTimeLineBuilder(DateTime date) => DefaultTimeLineMark(
        date: date,
        timeStringBuilder: widget.timeLineStringBuilder,
        markingStyle: TextStyle(
          color: context.weekViewColors.timelineTextColor,
          fontSize: 15.0,
        ),
      );

  /// Default event tile builder (used if [widget.eventTileBuilder] is null).
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

  /// Default week page header builder (used if [widget.dayTitleBuilder] is null).
  Widget _defaultWeekPageHeaderBuilder(
    DateTime startDate,
    DateTime endDate,
  ) {
    return WeekPageHeader(
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      onNextDay: nextPage,
      showNextIcon: endDate != _maxDate,
      onPreviousDay: previousPage,
      showPreviousIcon: startDate != _minDate,
      onTitleTapped: () async {
        if (widget.onHeaderTitleTap != null) {
          widget.onHeaderTitleTap!(startDate);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: _minDate,
            lastDate: _maxDate,
            locale: Locale(PackageStrings.selectedLocale),
          );

          if (selectedDate == null) return;
          jumpToWeek(selectedDate);
        }
      },
      headerStringBuilder: widget.headerStringBuilder,
      headerStyle: widget.headerStyle ??
          HeaderStyle(
            decoration: BoxDecoration(
              color: context.weekViewColors.headerBackgroundColor,
            ),
            leftIconConfig: IconDataConfig(
              color: context.weekViewColors.headerIconColor,
            ),
            rightIconConfig: IconDataConfig(
              color: context.weekViewColors.headerIconColor,
            ),
            headerTextStyle: TextStyle(
              color: context.weekViewColors.headerTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
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
      timelineWidth: widget.timeLineWidth,
      textDirection: Directionality.of(context),
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

  /// Jumps to page index without animation.
  /// Page Index Calculation: weekIndex = (weekStartDate - minWeekStartDate) / 7
  /// Prefer [jumpToWeek] instead for date-based navigation.
  void jumpToPage(int page) => _pageController.jumpToPage(page);

  /// Animates to page index with animation.
  /// Page Index Calculation: weekIndex = (weekStartDate - minWeekStartDate) / 7
  /// Prefer [animateToWeek] instead for date-based navigation.
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve);
  }

  /// Returns current page index (number of weeks since [minDay]).
  ///
  /// Use [currentDate] to get the week's first date.
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

  /// Jumps to page which contains given event and makes tile visible.
  Future<void> jumpToEvent(CalendarEventData<T> event) async {
    jumpToWeek(event.date);

    await _scrollConfiguration.setScrollEvent(
      event: event,
      duration: Duration.zero,
      curve: Curves.ease,
    );
  }

  /// Animate to page which contains given events and make event tile visible.
  /// Actual duration will be 2 times the given duration (animate + scroll).
  ///
  /// Ex, If provided duration is 200 milliseconds then this function will take
  /// 200 milliseconds for animate to page then 200 milliseconds for
  /// scroll to event tile.
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

  /// Check if any dates contain current date. Returns true if found.
  bool _showLiveTimeIndicator(List<DateTime> dates) {
    final now = _liveTimeIndicatorSettings.currentTimeProvider?.call() ??
        DateTime.now();
    return dates.any((date) => date.compareWithoutTime(now));
  }

  /// Listener for every week page ScrollController
  void _scrollPageListener(ScrollController controller) {
    _lastScrollOffset = controller.offset;
  }
}

class WeekHeader {
  /// Hide Header Widget
  static Widget hidden(DateTime date, DateTime date1) => SizedBox.shrink();
}
