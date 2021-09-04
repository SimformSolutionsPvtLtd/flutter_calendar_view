// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../calendar_constants.dart';
import '../calendar_controller_provider.dart';
import '../calendar_event_data.dart';
import '../components/components.dart';
import '../constants.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../extensions.dart';
import '../modals.dart';
import '../typedefs.dart';
import '_internal_week_view_page.dart';

/// [Widget] to display week view.
class WeekView<T> extends StatefulWidget {
  /// Builder to build tile for events.
  final EventTileBuilder<T>? eventTileBuilder;

  /// Builder for timeline.
  final DateWidgetBuilder? timeLineBuilder;

  /// Header builder for week page header.
  final WeekPageHeaderBuilder? weekPageHeaderBuilder;

  /// Arrange events.
  final EventArranger<T>? eventArranger;

  /// Called whenever user changes week.
  final CalendarPageChangeCallBack? onPageChange;

  /// Minimum day to display in week view.
  final DateTime? minDay;

  /// Maximum day to display in week view.
  final DateTime? maxDay;

  /// Initial week to display in week view.
  final DateTime? initialDay;

  /// Settings for hour indicator settings.
  final HourIndicatorSettings? hourIndicatorSettings;

  /// Settings for live time indicator settings.
  final HourIndicatorSettings? liveTimeIndicatorSettings;

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

  /// Height of week day title,
  final double weekTitleHeight;

  /// Builder to build week day.
  final DateWidgetBuilder? weekDayBuilder;

  /// Background color of week view page.
  final Color backgroundColor;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onEventTap;

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
    this.width,
    this.minDay,
    this.maxDay,
    this.initialDay,
    this.hourIndicatorSettings,
    this.timeLineBuilder,
    this.timeLineWidth,
    this.liveTimeIndicatorSettings,
    this.onPageChange,
    this.weekPageHeaderBuilder,
    this.eventArranger,
    this.weekTitleHeight = 50,
    this.weekDayBuilder,
    this.backgroundColor = Colors.white,
    this.onEventTap,
  }) : super(key: key);

  @override
  WeekViewState<T> createState() => WeekViewState<T>();
}

class WeekViewState<T> extends State<WeekView<T>> {
  late double _width;
  late double _height;
  late double _timeLineWidth;
  late double _hourHeight;
  late double _timeLineOffset;
  late DateTime _currentStartDate;
  late DateTime _currentEndDate;
  late DateTime _maxDate;
  late DateTime _minDate;
  late DateTime _initialDay;
  late int _totalWeeks;
  late int _currentIndex;

  late EventArranger<T> _eventArranger;

  late HourIndicatorSettings _hourIndicatorSettings;
  late HourIndicatorSettings _liveTimeIndicatorSettings;

  late PageController _pageController;

  late DateWidgetBuilder _timeLineBuilder;
  late EventTileBuilder<T> _eventTileBuilder;
  late WeekPageHeaderBuilder _weekHeaderBuilder;
  late DateWidgetBuilder _weekDayBuilder;

  late double _weekTitleWidth;
  final _weekDays = 7;

  bool _controllerAdded = false;

  late VoidCallback _reloadCallback;

  late EventController<T> _controller;

  @override
  void initState() {
    super.initState();

    _reloadCallback = _reload;

    _minDate = widget.minDay ?? CalendarConstants.epochDate;
    _maxDate = widget.maxDay ?? CalendarConstants.maxDate;

    _initialDay = widget.initialDay ?? DateTime.now();

    if (_initialDay.isBefore(_minDate)) {
      _initialDay = _minDate;
    } else if (_initialDay.isAfter(_maxDate)) {
      _initialDay = _maxDate;
    }

    final dates = _initialDay.datesOfWeek();
    _currentStartDate = dates.first;
    _currentEndDate = dates.last;

    _totalWeeks = _maxDate.getWeekDifference(_minDate) + 1;
    _currentIndex = _currentStartDate.getWeekDifference(_minDate) + 1;
    _hourHeight = widget.heightPerMinute * 60;
    _height = _hourHeight * Constants.hoursADay;
    _timeLineOffset = widget.timeLineOffset;
    _pageController = PageController(initialPage: _currentIndex);
    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();
    _timeLineBuilder = widget.timeLineBuilder ?? _defaultTimeLineBuilder;
    _eventTileBuilder = widget.eventTileBuilder ?? _defaultEventTileBuilder;
    _weekHeaderBuilder =
        widget.weekPageHeaderBuilder ?? _defaultWeekPageHeaderBuilder;
    _weekDayBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_controllerAdded) {
      _controller = widget.controller ??
          CalendarControllerProvider.of<T>(context).controller;
      _controllerAdded = true;

      // Reloads the view if there is any change in controller or user
      // adds new events.
      _controller.addListener(_reloadCallback);
    }

    _width = widget.width ?? MediaQuery.of(context).size.width;

    assert(_width != 0, "Calendar width can not be 0.");

    _timeLineWidth = widget.timeLineWidth ?? _width * 0.13;
    assert(_timeLineWidth != 0, "Time line width can not be 0.");

    _liveTimeIndicatorSettings = widget.liveTimeIndicatorSettings ??
        HourIndicatorSettings(
          color: Constants.defaultLiveTimeIndicatorColor,
          height: widget.heightPerMinute,
          offset: 5,
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
        (_width - _timeLineWidth - _hourIndicatorSettings.offset) / _weekDays;
  }

  @override
  void dispose() {
    _controller.removeListener(_reloadCallback);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: _width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _weekHeaderBuilder(_currentStartDate, _currentEndDate),
              Expanded(
                child: SizedBox(
                  height: _height,
                  width: _width,
                  child: PageView.builder(
                    itemCount: _totalWeeks,
                    controller: _pageController,
                    onPageChanged: _onPageChange,
                    itemBuilder: (_, index) {
                      final dates = _minDate
                          .add(Duration(days: (index - 1) * _weekDays))
                          .datesOfWeek();

                      return InternalWeekViewPage<T>(
                        key: ValueKey(
                            _hourHeight.toString() + dates[0].toString()),
                        height: _height,
                        width: _width,
                        weekTitleWidth: _weekTitleWidth,
                        weekTitleHeight: widget.weekTitleHeight,
                        weekDayBuilder: _weekDayBuilder,
                        liveTimeIndicatorSettings: _liveTimeIndicatorSettings,
                        timeLineBuilder: _timeLineBuilder,
                        onTileTap: widget.onEventTap,
                        eventTileBuilder: _eventTileBuilder,
                        heightPerMinute: widget.heightPerMinute,
                        hourIndicatorSettings: _hourIndicatorSettings,
                        dates: dates,
                        showLiveLine: widget.showLiveTimeLineInAllDays ||
                            _showLiveTimeIndicator(dates),
                        timeLineOffset: _timeLineOffset,
                        timeLineWidth: _timeLineWidth,
                        verticalLineOffset: 0,
                        showVerticalLine: true,
                        controller: _controller,
                        hourHeight: _hourHeight,
                        eventArranger: _eventArranger,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  EventController<T> get controller {
    assert(_controllerAdded, "EventController is not initialized yet.");

    return _controller;
  }

  /// Reloads page.
  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(DateTime date) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Constants.weekTitles[date.weekday - 1]),
          Text(date.day.toString()),
        ],
      ),
    );
  }

  /// Default timeline builder this builder will be used if
  /// [widget.eventTileBuilder] is null
  ///
  Widget _defaultTimeLineBuilder(DateTime date) {
    return Transform.translate(
      offset: Offset(0, -7.5),
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0),
        child: Text(
          "${((date.hour - 1) % 12) + 1} ${date.hour ~/ 12 == 0 ? "am" : "pm"}",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  /// Default timeline builder. This builder will be used if
  /// [widget.eventTileBuilder] is null
  Widget _defaultEventTileBuilder<T>(
      DateTime date,
      List<CalendarEventData<T>> events,
      Rect boundary,
      DateTime startDuration,
      DateTime endDuration) {
    if (events.isNotEmpty)
      return RoundedEventTile(
        borderRadius: BorderRadius.circular(6.0),
        title: events[0].title,
        titleStyle: TextStyle(
          fontSize: 12,
          color: events[0].color.accent,
        ),
        totalEvents: events.length,
        padding: EdgeInsets.all(7.0),
        backgroundColor: events[0].color,
      );
    else
      return Container();
  }

  /// Default view header builder. This builder will be used if
  /// [widget.dayTitleBuilder] is null.
  Widget _defaultWeekPageHeaderBuilder(DateTime startDate, DateTime endDate) {
    return WeekPageHeader(
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      onNextDay: nextPage,
      onPreviousDay: previousPage,
      onTitleTapped: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: CalendarConstants.minDate,
          lastDate: CalendarConstants.maxDate,
        );

        if (selectedDate == null) return;
        jumpToWeek(selectedDate);
      },
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
    _pageController.jumpToPage(_minDate.getWeekDifference(week) + 1);
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
      _minDate.getWeekDifference(week) + 1,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible date in week view.
  DateTime get currentDate => DateTime(
      _currentStartDate.year, _currentStartDate.month, _currentStartDate.day);

  /// check if any dates contains current date or not.
  /// Returns true if it does else false.
  bool _showLiveTimeIndicator(List<DateTime> dates) =>
      dates.any((date) => date.compareWithoutTime(DateTime.now()));
}
