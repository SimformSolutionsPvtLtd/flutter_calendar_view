// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';

class MonthView<T extends Object?> extends StatefulWidget {
  /// A required parameters that controls events for month view.
  ///
  /// This will auto update month view when user adds events in controller.
  /// This controller will store all the events. And returns events
  /// for particular day.
  ///
  /// If [controller] is null it will take controller from
  /// [CalendarControllerProvider.controller].
  final EventController<T>? controller;

  /// Style of month view.
  final MonthViewStyle monthViewStyle;

  /// Builders for month view.
  final MonthViewBuilders monthViewBuilders;

  /// Theme settings for month view.
  final MonthViewThemeSettings monthViewThemeSettings;

  /// Width of month view.
  ///
  /// If null is provided then It will take width of closest [MediaQuery].
  final double? width;

  /// Main [Widget] to display month view.
  const MonthView({
    Key? key,
    this.monthViewStyle = const MonthViewStyle(),
    this.monthViewBuilders = const MonthViewBuilders(),
    this.monthViewThemeSettings = const MonthViewThemeSettings(),
    this.controller,
    this.width,
  }) : super(key: key);

  @override
  MonthViewState<T> createState() => MonthViewState<T>();
}

/// State of month view.
class MonthViewState<T extends Object?> extends State<MonthView<T>> {
  late DateTime _minDate;
  late DateTime _maxDate;

  late DateTime _currentDate;

  late int _currentIndex;

  int _totalMonths = 0;

  late PageController _pageController;

  late double _width;
  late double _height;

  late double _cellWidth;
  late double _cellHeight;

  late CellBuilder<T> _cellBuilder;

  late WeekDayBuilder _weekBuilder;

  late DateWidgetBuilder _headerBuilder;

  EventController<T>? _controller;

  late VoidCallback _reloadCallback;

  late MonthViewStyle _monthViewStyle = widget.monthViewStyle;
  late MonthViewBuilders _monthViewBuilders = widget.monthViewBuilders;
  late MonthViewThemeSettings _monthViewThemeSettings =
      widget.monthViewThemeSettings;

  @override
  void initState() {
    super.initState();
    _reloadCallback = _reload;

    _setDateRange();

    // Initialize current date.
    _currentDate = (_monthViewStyle.initialMonth ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();

    // Initialize page controller to control page actions.
    _pageController = PageController(initialPage: _currentIndex);

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

    updateViewDimensions();
  }

  @override
  void didUpdateWidget(MonthView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller.
    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;
    _monthViewStyle = widget.monthViewStyle;
    _monthViewBuilders = widget.monthViewBuilders;
    _monthViewThemeSettings = widget.monthViewThemeSettings;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    // Update date range.
    if (_monthViewStyle.minMonth != oldWidget.monthViewStyle.minMonth ||
        _monthViewStyle.maxMonth != oldWidget.monthViewStyle.maxMonth) {
      _setDateRange();
      _regulateCurrentDate();

      _pageController.jumpToPage(_currentIndex);
    }

    // Update builders and callbacks
    _assignBuilders();

    updateViewDimensions();
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
      option: _monthViewStyle.safeAreaOption,
      child: SizedBox(
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: _width,
              child: _headerBuilder(_currentDate),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: _monthViewStyle.pageViewPhysics,
                onPageChanged: _onPageChange,
                itemBuilder: (_, index) {
                  final date = DateTime(_minDate.year, _minDate.month + index);
                  final weekDays = date.datesOfWeek(
                    start: _monthViewStyle.startDay,
                    showWeekEnds: _monthViewStyle.showWeekends,
                  );

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: _width,
                        child: Row(
                          children: List.generate(
                            _monthViewStyle.showWeekends ? 7 : 5,
                            (index) => Expanded(
                              child: SizedBox(
                                width: _cellWidth,
                                child:
                                    _weekBuilder(weekDays[index].weekday - 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final dates = date.datesOfMonths(
                              startDay: _monthViewStyle.startDay,
                              hideDaysNotInMonth:
                                  _monthViewStyle.hideDaysNotInMonth,
                              showWeekends: _monthViewStyle.showWeekends,
                            );
                            final _cellAspectRatio =
                                _monthViewStyle.useAvailableVerticalSpace
                                    ? calculateCellAspectRatio(
                                        height: constraints.maxHeight,
                                        daysInMonth: dates.length,
                                      )
                                    : _monthViewStyle.cellAspectRatio;

                            return SizedBox(
                              height: _height,
                              width: _width,
                              child: _MonthPageBuilder<T>(
                                key: ValueKey(date.toIso8601String()),
                                onCellTap: _monthViewBuilders.onCellTap,
                                onDateLongPress:
                                    _monthViewBuilders.onDateLongPress,
                                width: _width,
                                height: _height,
                                controller: controller,
                                borderColor: _monthViewStyle.borderColor,
                                borderSize: _monthViewStyle.borderSize,
                                cellBuilder: _cellBuilder,
                                cellRatio: _cellAspectRatio,
                                date: date,
                                showBorder: _monthViewStyle.showBorder,
                                startDay: _monthViewStyle.startDay,
                                physics: _monthViewStyle.pagePhysics,
                                hideDaysNotInMonth:
                                    _monthViewStyle.hideDaysNotInMonth,
                                weekDays: _monthViewStyle.showWeekends ? 7 : 5,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                itemCount: _totalMonths,
              ),
            ),
          ],
        ),
      ),
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

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  void updateViewDimensions() {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    _cellWidth = _width / 7;
    _cellHeight = _cellWidth / _monthViewStyle.cellAspectRatio;
    _height = _cellHeight * 6;
  }

  double calculateCellAspectRatio({
    required double height,
    required int daysInMonth,
  }) {
    final rows = daysInMonth / 7;
    final _cellHeight = height / rows;
    return _cellWidth / _cellHeight;
  }

  void _assignBuilders() {
    // Initialize cell builder. Assign default if widget.cellBuilder is null.
    _cellBuilder = _monthViewBuilders.cellBuilder ?? _defaultCellBuilder;

    // Initialize week builder. Assign default if widget.weekBuilder is null.
    // This widget will come under header this will display week days.
    _weekBuilder = _monthViewBuilders.weekDayBuilder ?? _defaultWeekDayBuilder;

    // Initialize header builder. Assign default if widget.headerBuilder
    // is null.
    //
    // This widget will be displayed on top of the page.
    // from where user can see month and change month.
    _headerBuilder = _monthViewBuilders.headerBuilder ?? _defaultHeaderBuilder;
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
    // make sure that _currentDate is between _minDate and _maxDate.
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    // Calculate the current index of page view.
    _currentIndex = _minDate.getMonthDifference(_currentDate) - 1;
  }

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    // Initialize minimum date.
    _minDate =
        (_monthViewStyle.minMonth ?? CalendarConstants.epochDate).withoutTime;

    // Initialize maximum date.
    _maxDate =
        (_monthViewStyle.maxMonth ?? CalendarConstants.maxDate).withoutTime;

    assert(
      _minDate.isBefore(_maxDate),
      "Minimum date should be less than maximum date.\n"
      "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    // Get number of months between _minDate and _maxDate.
    // This number will be number of page in page view.
    _totalMonths = _maxDate.getMonthDifference(_minDate);
  }

  /// Calls when user changes page using gesture or inbuilt methods.
  void _onPageChange(int value) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + (value - _currentIndex),
        );
        _currentIndex = value;
      });
    }
    _monthViewBuilders.onPageChange?.call(_currentDate, _currentIndex);
  }

  /// Default month view header builder
  Widget _defaultHeaderBuilder(DateTime date) {
    return MonthPageHeader(
      showPreviousIcon: date != _minDate,
      showNextIcon: date != _maxDate,
      onTitleTapped: () async {
        if (_monthViewBuilders.onHeaderTitleTap != null) {
          _monthViewBuilders.onHeaderTitleTap!(date);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: _minDate,
            lastDate: _maxDate,
            locale: Locale(PackageStrings.selectedLocale),
          );

          if (selectedDate == null) return;
          jumpToMonth(selectedDate);
        }
      },
      onPreviousMonth: previousPage,
      date: date,
      dateStringBuilder: _monthViewBuilders.headerStringBuilder,
      onNextMonth: nextPage,
      headerStyle: _monthViewThemeSettings.headerStyle ??
          HeaderStyle(
            decoration: BoxDecoration(
              color: context.monthViewColors.headerBackgroundColor,
            ),
            leftIconConfig: IconDataConfig(
              color: context.monthViewColors.headerIconColor,
            ),
            rightIconConfig: IconDataConfig(
              color: context.monthViewColors.headerIconColor,
            ),
            headerTextStyle: TextStyle(
              color: context.monthViewColors.headerTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(int index) {
    final themeColors = context.monthViewColors;
    return WeekDayTile(
      dayIndex: index,
      weekDayStringBuilder: _monthViewBuilders.weekDayStringBuilder,
      displayBorder: _monthViewStyle.showWeekTileBorder,
      borderColor: themeColors.weekDayBorderColor,
      backgroundColor: themeColors.weekDayTileColor,
      textStyle: _monthViewThemeSettings.weekDayTextStyle,
    );
  }

  /// Default cell builder. Used when [widget.cellBuilder] is null
  Widget _defaultCellBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
    bool isInMonth,
    bool hideDaysNotInMonth,
  ) {
    final themeColor = context.monthViewColors;

    if (hideDaysNotInMonth) {
      return FilledCell<T>(
        date: date,
        shouldHighlight: isToday,
        backgroundColor: isInMonth
            ? themeColor.cellInMonthColor
            : themeColor.cellNotInMonthColor,
        events: events,
        isInMonth: isInMonth,
        onTileTap: _monthViewBuilders.onEventTap,
        onTileDoubleTap: _monthViewBuilders.onEventDoubleTap,
        onTileLongTap: _monthViewBuilders.onEventLongTap,
        onTileTapDetails: _monthViewBuilders.onEventTapDetails,
        onTileDoubleTapDetails: _monthViewBuilders.onEventDoubleTapDetails,
        onTileLongTapDetails: _monthViewBuilders.onEventLongTapDetails,
        dateStringBuilder: _monthViewBuilders.dateStringBuilder,
        hideDaysNotInMonth: hideDaysNotInMonth,
        titleColor: themeColor.cellTextColor,
        highlightColor: themeColor.cellHighlightColor,
        tileColor: themeColor.weekDayTileColor,
        highlightRadius: _monthViewThemeSettings.cellsNotInMonthHighlightRadius,
        highlightedTitleColor:
            _monthViewThemeSettings.cellsNotInMonthHighlightedTitleColor,
      );
    }
    return FilledCell<T>(
      date: date,
      shouldHighlight: isToday,
      backgroundColor: isInMonth
          ? themeColor.cellInMonthColor
          : themeColor.cellNotInMonthColor,
      events: events,
      onTileTap: _monthViewBuilders.onEventTap,
      onTileLongTap: _monthViewBuilders.onEventLongTap,
      onTileTapDetails: _monthViewBuilders.onEventTapDetails,
      onTileDoubleTapDetails: _monthViewBuilders.onEventDoubleTapDetails,
      onTileLongTapDetails: _monthViewBuilders.onEventLongTapDetails,
      dateStringBuilder: _monthViewBuilders.dateStringBuilder,
      onTileDoubleTap: _monthViewBuilders.onEventDoubleTap,
      hideDaysNotInMonth: hideDaysNotInMonth,
      titleColor: isInMonth
          ? themeColor.cellTextColor
          : themeColor.cellTextColor.withAlpha(150),
      highlightedTitleColor:
          _monthViewThemeSettings.cellsInMonthHighlightedTitleColor,
      highlightRadius: _monthViewThemeSettings.cellsInMonthHighlightRadius,
      tileColor: _monthViewThemeSettings.cellsInMonthTileColor,
      highlightColor: _monthViewThemeSettings.cellsInMonthHighlightColor,
    );
  }

  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? _monthViewStyle.pageTransitionDuration,
      curve: curve ?? _monthViewStyle.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? _monthViewStyle.pageTransitionDuration,
      curve: curve ?? _monthViewStyle.pageTransitionCurve,
    );
  }

  /// Jumps to page number [page]
  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? _monthViewStyle.pageTransitionDuration,
        curve: curve ?? _monthViewStyle.pageTransitionCurve);
  }

  /// Returns current page number.
  int get currentPage => _currentIndex;

  /// Jumps to page which gives month calendar for [month]
  void jumpToMonth(DateTime month) {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getMonthDifference(month) - 1);
  }

  /// Animate to page which gives month calendar for [month].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToMonth(DateTime month,
      {Duration? duration, Curve? curve}) async {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getMonthDifference(month) - 1,
      duration: duration ?? _monthViewStyle.pageTransitionDuration,
      curve: curve ?? _monthViewStyle.pageTransitionCurve,
    );
  }

  /// Returns the current visible date in month view.
  DateTime get currentDate => DateTime(_currentDate.year, _currentDate.month);
}

/// A single month page.
class _MonthPageBuilder<T> extends StatelessWidget {
  final double cellRatio;
  final bool showBorder;
  final double borderSize;
  final Color? borderColor;
  final CellBuilder<T> cellBuilder;
  final DateTime date;
  final EventController<T> controller;
  final double width;
  final double height;
  final CellTapCallback<T>? onCellTap;
  final DatePressCallback? onDateLongPress;
  final WeekDays startDay;
  final ScrollPhysics physics;
  final bool hideDaysNotInMonth;
  final int weekDays;

  const _MonthPageBuilder({
    Key? key,
    required this.cellRatio,
    required this.showBorder,
    required this.borderSize,
    required this.cellBuilder,
    required this.date,
    required this.controller,
    required this.width,
    required this.height,
    required this.onCellTap,
    required this.onDateLongPress,
    required this.startDay,
    required this.physics,
    required this.hideDaysNotInMonth,
    required this.weekDays,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthDays = date.datesOfMonths(
      startDay: startDay,
      hideDaysNotInMonth: hideDaysNotInMonth,
      showWeekends: weekDays == 7,
    );

    // Highlight tiles which is not in current month
    return SizedBox(
      width: width,
      height: height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: physics,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: weekDays,
          childAspectRatio: cellRatio,
        ),
        itemCount: monthDays.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // Hide events if `hideDaysNotInMonth` true
          final events =
              hideDaysNotInMonth && (monthDays[index].month != date.month)
                  ? <CalendarEventData<T>>[]
                  : controller.getEventsOnDay(monthDays[index]);
          return GestureDetector(
            onTap: () => onCellTap?.call(events, monthDays[index]),
            onLongPress: () => onDateLongPress?.call(monthDays[index]),
            child: Container(
              decoration: BoxDecoration(
                border: showBorder
                    ? Border.all(
                        color: borderColor ??
                            context.monthViewColors.cellBorderColor,
                        width: borderSize,
                      )
                    : null,
              ),
              child: cellBuilder(
                monthDays[index],
                events,
                monthDays[index].compareWithoutTime(DateTime.now()),
                monthDays[index].month == date.month,
                hideDaysNotInMonth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MonthHeader {
  /// Hide Header Widget
  static Widget hidden(DateTime date) => SizedBox.shrink();
}
