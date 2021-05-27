import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/src/calendar_controller.dart';
import 'package:flutter_calendar_page/src/components/components.dart';
import 'package:flutter_calendar_page/src/constants.dart';
import 'package:flutter_calendar_page/src/extensions.dart';
import 'package:flutter_calendar_page/src/modals.dart';

import '../event_arrangers/event_arrangers.dart';
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

  /// Controller for Week view thia will refresh view when user adds or removes event from controller.
  final CalendarController<T> controller;

  /// Defines height occupied by one minute of time span. This parameter will be used to calculate total height of Week view.
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

  /// Main widget for week view.
  const WeekView({
    Key? key,
    required this.controller,
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
  late WeekPageHeaderBuilder _dayTitleBuilder;
  late DateWidgetBuilder _weekDayBuilder;

  late double _weekTitleWidth;
  int _weekDays = 7;

  @override
  void initState() {
    super.initState();

    _minDate = widget.minDay ?? Constants.epochDate;
    _maxDate = widget.maxDay ?? Constants.maxDate;

    _initialDay = widget.initialDay ?? DateTime.now();

    if (_initialDay.isBefore(_minDate)) {
      _initialDay = _minDate;
    } else if (_initialDay.isAfter(_maxDate)) {
      _initialDay = _maxDate;
    }

    List<DateTime> dates = _initialDay.datesOfWeek;
    _currentStartDate = dates.first;
    _currentEndDate = dates.last;

    _totalWeeks = _maxDate.getWeekDifference(_minDate) + 1;
    widget.controller.addListener(_reload);
    _currentIndex = _currentStartDate.getWeekDifference(_minDate) + 1;
    _hourHeight = widget.heightPerMinute * 60;
    _height = _hourHeight * Constants.hoursADay;
    _timeLineOffset = widget.timeLineOffset;
    _pageController = PageController(initialPage: _currentIndex);
    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();
    _timeLineBuilder = widget.timeLineBuilder ?? _defaultTimeLineBuilder;
    _eventTileBuilder = widget.eventTileBuilder ?? _defaultEventTileBuilder;
    _dayTitleBuilder =
        widget.weekPageHeaderBuilder ?? _defaultWeekPageHeaderBuilder;
    _weekDayBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
    widget.controller.removeListener(_reload);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _dayTitleBuilder(_currentStartDate, _currentEndDate),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: _height + widget.weekTitleHeight,
                width: _width,
                child: PageView.builder(
                  itemCount: _totalWeeks,
                  controller: _pageController,
                  onPageChanged: _onPageChange,
                  itemBuilder: (_, index) {
                    List<DateTime> dates = _minDate
                        .add(Duration(days: (index - 1) * _weekDays))
                        .datesOfWeek;

                    bool showLiveTimeIndicator = false;

                    dates.forEach(
                      (date) => showLiveTimeIndicator = showLiveTimeIndicator ||
                          date.compareWithoutTime(
                            DateTime.now(),
                          ),
                    );

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
                      eventTileBuilder: _eventTileBuilder,
                      heightPerMinute: widget.heightPerMinute,
                      hourIndicatorSettings: _hourIndicatorSettings,
                      dates: dates,
                      showLiveLine: widget.showLiveTimeLineInAllDays ||
                          showLiveTimeIndicator,
                      timeLineOffset: _timeLineOffset,
                      timeLineWidth: _timeLineWidth,
                      verticalLineOffset: 0,
                      showVerticalLine: true,
                      controller: widget.controller,
                      hourHeight: _hourHeight,
                      eventArranger: _eventArranger,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reloads page.
  ///
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Constants.weekTitles[date.weekday - 1]),
          Text(date.day.toString()),
        ],
      ),
    );
  }

  /// Default timeline builder this builder will be used if [widget.eventTileBuilder] is null
  ///
  Widget _defaultTimeLineBuilder(date) {
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

  /// Default timeline builder. This builder will be used if [widget.eventTileBuilder] is null
  ///
  Widget _defaultEventTileBuilder(
      date, events, boundary, startDuration, endDuration) {
    if (events.isNotEmpty)
      return RoundedEventTile(
        borderRadius: BorderRadius.circular(10.0),
        title: events[0]?.title ?? "",
        extraEvents: events.length - 1,
        description: events[0]?.description ?? "",
        padding: EdgeInsets.all(10.0),
        backgroundColor: events[0]?.eventColor ?? Colors.blue,
        margin: EdgeInsets.all(2.0),
      );
    else
      return Container();
  }

  /// Default view header builder. This builder will be used if [widget.dayTitleBuilder] is null.
  ///
  Widget _defaultWeekPageHeaderBuilder(DateTime startDate, DateTime endDate) {
    return WeekPageHeader(
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      onNextDay: nextPage,
      onPreviousDay: previousPage,
      onTitleTapped: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: Constants.minDate,
          lastDate: Constants.maxDate,
        );

        if (selectedDate == null) return;
        this.jumpToWeek(selectedDate);
      },
    );
  }

  /// Called when user change page using any gesture or inbuilt functions.
  ///
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
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve] respectively.
  ///
  ///
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve] respectively.
  ///
  ///
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
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve] respectively.
  ///
  ///
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve);
  }

  /// Returns current page number.
  ///
  ///
  int get currentPage => _currentIndex;

  /// Jumps to page which gives day calendar for [date]
  ///
  ///
  void jumpToWeek(DateTime date) {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getWeekDifference(date) + 1);
  }

  /// Animate to page which gives day calendar for [date].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [WeekView.pageTransitionDuration] and [WeekView.pageTransitionCurve] respectively.
  ///
  ///
  Future<void> animateToWeek(DateTime date,
      {Duration? duration, Curve? curve}) async {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getWeekDifference(date) + 1,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible date in day view.
  DateTime get currentDate => DateTime(
      _currentStartDate.year, _currentStartDate.month, _currentStartDate.day);
}
