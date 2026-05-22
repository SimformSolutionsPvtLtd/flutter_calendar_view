// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';

/// Controls how [MonthView] pages are scrolled.
enum MonthViewMode {
  /// Existing behavior: month pages scroll horizontally.
  standard,

  /// Month pages scroll vertically.
  verticalMonth,
}

class MonthView<T extends Object?> extends StatefulWidget {
  /// Main [Widget] to display month view.
  const MonthView({
    Key? key,
    this.monthViewStyle = const MonthViewStyle(),
    this.monthViewBuilders = const MonthViewBuilders(),
    this.monthViewThemeSettings = const MonthViewThemeSettings(),
    this.controller,
    this.width,
    this.selectedDate,
    this.multiDateSelectionRange = const {},
    this.multiDateSelectionColor,
    this.monthViewMode = MonthViewMode.standard,
  }) : super(key: key);

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
  final MonthViewBuilders<T> monthViewBuilders;

  /// Theme settings for month view.
  final MonthViewThemeSettings monthViewThemeSettings;

  /// Width of month view.
  ///
  /// If null is provided then It will take width of closest [MediaQuery].
  final double? width;

  /// Controls the selected date in the month grid.
  ///
  /// When null, the view manages selection internally and updates it when a
  /// visible cell is tapped. When non-null, selection is controlled by the
  /// caller and taps only trigger [MonthViewBuilders.onCellTap].
  final DateTime? selectedDate;

  /// Set of dates that are selected via [MonthViewBuilders.onDateLongPressMoveUpdate]
  final Set<DateTime> multiDateSelectionRange;

  /// Color of the date cells selected via [MonthViewBuilders.onDateLongPressMoveUpdate]
  final Color? multiDateSelectionColor;

  final MonthViewMode monthViewMode;

  @override
  MonthViewState<T> createState() => MonthViewState<T>();
}

/// State of month view.
class MonthViewState<T extends Object?> extends State<MonthView<T>> {
  /// Minimum date user can scroll to. Reference date for page index calculation.
  /// Stored without time component. See [_setDateRange] for calculation.
  late DateTime _minDate;

  /// Maximum date user can scroll to. Aligned to month boundary.
  /// Stored without time component. See [_setDateRange] for calculation.
  late DateTime _maxDate;

  /// Currently displayed month. Updated when user navigates between months.
  late DateTime _currentDate;

  /// Current page index in PageView. Calculated from date difference.
  /// See [_regulateCurrentDate] for calculation: `pageIndex = minDate.getMonthDifference(currentDate) - 1`
  late int _currentIndex;

  /// Total number of months available between _minDate and _maxDate.
  /// See [_setDateRange] for calculation.
  int _totalMonths = 0;

  /// Whether multi date selection is in progress.
  bool _isMultiDateSelectionInProgress = false;

  /// Controls page transitions between months (horizontal paging).
  late PageController _pageController;

  /// Total width of the month view widget in pixels.
  late double _width;

  /// Total height available for displaying month cells.
  late double _height;

  /// Width of each cell in the month grid. Calculated as: `_width / 7`
  late double _cellWidth;

  /// Height of each cell in the month grid. Calculated based on cellAspectRatio.
  late double _cellHeight;

  /// Current selected date (single date).
  DateTime? _selectedDate;

  /// Builder function for rendering individual calendar cells.
  late CellBuilder<T> _cellBuilder;

  /// Builder function for rendering week day headers (Mon, Tue, etc).
  late WeekDayBuilder _weekBuilder;

  /// Builder function for rendering the month view header.
  late DateWidgetBuilder _headerBuilder;

  /// Event controller for managing calendar events across the month.
  EventController<T>? _controller;

  /// Callback triggered when events change or rebuild is needed.
  late VoidCallback _reloadCallback;

  /// Current style configuration for the month view layout and appearance.
  late MonthViewStyle _monthViewStyle = widget.monthViewStyle;

  /// Current custom builders for month view components.
  late MonthViewBuilders<T> _monthViewBuilders = widget.monthViewBuilders;

  /// Current theme settings for month view colors and text styles.
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

    _selectedDate = widget.selectedDate?.withoutTime;

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

    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate?.withoutTime;
    } else if (oldWidget.selectedDate != null) {
      _selectedDate = oldWidget.selectedDate?.withoutTime;
    }

    updateViewDimensions();
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);

    _pageController.dispose();
    super.dispose();
  }

  void _onBoundaryDragEnd(
    DragEndDetails dragEndDetails, {
    required bool isFirstPage,
    required bool isLastPage,
    required Axis scrollDirection,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final velocity = scrollDirection == Axis.horizontal
        ? (dragEndDetails.primaryVelocity ?? 0)
        : dragEndDetails.velocity.pixelsPerSecond.dy;
    if (velocity == 0) return;

    final isRtl = textDirection == TextDirection.rtl;
    final isSwipingToPrevious = scrollDirection == Axis.horizontal
        ? (isRtl ? velocity < 0 : velocity > 0)
        : velocity > 0;
    final isSwipingToNext = scrollDirection == Axis.horizontal
        ? (isRtl ? velocity > 0 : velocity < 0)
        : velocity < 0;

    if (isFirstPage && isLastPage) {
      // Only one page - trigger both callbacks based on swipe direction
      if (isSwipingToPrevious) {
        widget.monthViewBuilders.onHasReachedStart
            ?.call(_currentDate, _currentIndex);
      } else if (isSwipingToNext) {
        widget.monthViewBuilders.onHasReachedEnd
            ?.call(_currentDate, _currentIndex);
      }
    } else if (isFirstPage) {
      // First page - can go next, but swiping to previous triggers callback
      if (isSwipingToNext) {
        nextPage();
      } else if (isSwipingToPrevious) {
        widget.monthViewBuilders.onHasReachedStart
            ?.call(_currentDate, _currentIndex);
      }
    } else if (isLastPage) {
      // Last page - can go previous, but swiping to next triggers callback
      if (isSwipingToPrevious) {
        previousPage();
      } else if (isSwipingToNext) {
        widget.monthViewBuilders.onHasReachedEnd
            ?.call(_currentDate, _currentIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = PackageStrings.currentLocale.isRTL
        ? TextDirection.rtl
        : TextDirection.ltr;
    final columnCount = _monthViewStyle.showWeekends ? 7 : 5;

    return SafeAreaWrapper(
      option: _monthViewStyle.safeAreaOption,
      child: SizedBox(
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _width,
              child: _headerBuilder(_currentDate),
            ),
            Expanded(
              child: PageView.builder(
                scrollDirection: widget.monthViewMode == MonthViewMode.standard
                    ? Axis.horizontal
                    : Axis.vertical,
                controller: _pageController,
                physics: _isMultiDateSelectionInProgress
                    ? const NeverScrollableScrollPhysics()
                    : _monthViewStyle.pageViewPhysics,
                onPageChanged: _onPageChange,
                itemBuilder: (_, index) {
                  final date = DateTime(_minDate.year, _minDate.month + index);
                  final weekDays = date.datesOfWeek(
                    start: _monthViewStyle.startDay,
                    showWeekEnds: _monthViewStyle.showWeekends,
                  );
                  final Widget monthPageContent = Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                                        columnCount: columnCount,
                                      )
                                    : _monthViewStyle.cellAspectRatio;

                            return SizedBox(
                              height: _height,
                              width: _width,
                              child: _MonthPageBuilder<T>(
                                key: ValueKey(date.toIso8601String()),
                                onCellTap: _handleCellTap,
                                onDateLongPress:
                                    _monthViewBuilders.onDateLongPress,
                                onDateLongPressMoveUpdate: _monthViewBuilders
                                    .onDateLongPressMoveUpdate,
                                onLongPressSelectionStateChange:
                                    _handleLongPressSelectionStateChange,
                                width: _width,
                                height: _height,
                                controller: controller,
                                borderColor: _monthViewStyle.borderColor,
                                borderSize: _monthViewStyle.borderSize,
                                cellBuilder: _cellBuilder,
                                selectedDate: _selectedDate,
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

                  if (widget.monthViewBuilders.onHasReachedEnd != null ||
                      widget.monthViewBuilders.onHasReachedStart != null) {
                    final isFirstPage = index == 0;
                    final isLastPage = index == _totalMonths - 1;
                    if (isFirstPage || isLastPage) {
                      final axis =
                          widget.monthViewMode == MonthViewMode.standard
                              ? Axis.horizontal
                              : Axis.vertical;
                      return GestureDetector(
                        onHorizontalDragEnd: axis == Axis.horizontal
                            ? (details) => _onBoundaryDragEnd(
                                  details,
                                  isFirstPage: isFirstPage,
                                  isLastPage: isLastPage,
                                  scrollDirection: axis,
                                  textDirection: textDirection,
                                )
                            : null,
                        onVerticalDragEnd: axis == Axis.vertical
                            ? (details) => _onBoundaryDragEnd(
                                  details,
                                  isFirstPage: isFirstPage,
                                  isLastPage: isLastPage,
                                  scrollDirection: axis,
                                  textDirection: textDirection,
                                )
                            : null,
                        child: monthPageContent,
                      );
                    }
                  }

                  return monthPageContent;
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

  bool _isSameDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) {
      return first == second;
    }

    return first.withoutTime.compareWithoutTime(second.withoutTime);
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleLongPressSelectionStateChange(bool isInProgress) {
    if (_isMultiDateSelectionInProgress == isInProgress || !mounted) return;
    setState(() {
      _isMultiDateSelectionInProgress = isInProgress;
    });
  }

  void updateViewDimensions() {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    final columnCount = _monthViewStyle.showWeekends ? 7 : 5;
    _cellWidth = _width / columnCount;
    _cellHeight = _cellWidth / _monthViewStyle.cellAspectRatio;
    _height = _cellHeight * 6;
  }

  double calculateCellAspectRatio({
    required double height,
    required int daysInMonth,
    required int columnCount,
  }) {
    // Calculate no of rows (based on whether weekends are visible or not)
    final rows = (daysInMonth / columnCount).ceilToDouble();
    final cellHeight = height / rows;
    return _cellWidth / cellHeight;
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
      'Minimum date should be less than maximum date.\n'
      'Provided minimum date: $_minDate, maximum date: $_maxDate',
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
          await _monthViewBuilders.onHeaderTitleTap!(date);
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

  /// Default cell builder. Used when [_cellBuilder] is null
  Widget _defaultCellBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
    bool isInMonth,
    bool isSelected,
    bool hideDaysNotInMonth,
  ) {
    // Normalize both the input date and selected dates to date-only (midnight)
    // This ensures selection works regardless of time component in selectedDates
    final normalizedDate = date.withoutTime;
    final isMultiSelected = widget.multiDateSelectionRange.any(
      (selectedDate) => selectedDate.withoutTime == normalizedDate,
    );
    final color = isMultiSelected ? widget.multiDateSelectionColor : null;
    final themeColor = context.monthViewColors;
    final shouldHighlight = isSelected || isToday;
    final highlightedTitleColor = isSelected
        ? _monthViewThemeSettings.selectedTitleColor
        : hideDaysNotInMonth
            ? _monthViewThemeSettings.cellsNotInMonthHighlightedTitleColor
            : _monthViewThemeSettings.cellsInMonthHighlightedTitleColor;
    final highlightColor = isSelected
        ? _monthViewThemeSettings.selectedHighlightColor
        : hideDaysNotInMonth
            ? themeColor.cellHighlightColor
            : _monthViewThemeSettings.cellsInMonthHighlightColor;
    final highlightRadius = isSelected
        ? _monthViewThemeSettings.selectedHighlightRadius
        : hideDaysNotInMonth
            ? _monthViewThemeSettings.cellsNotInMonthHighlightRadius
            : _monthViewThemeSettings.cellsInMonthHighlightRadius;

    if (hideDaysNotInMonth) {
      return FilledCell<T>(
        date: date,
        shouldHighlight: shouldHighlight,
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
        highlightColor: highlightColor,
        tileColor: themeColor.weekDayTileColor,
        highlightRadius: highlightRadius,
        highlightedTitleColor: highlightedTitleColor,
        multipleDateSelectionColor: color,
      );
    }
    return FilledCell<T>(
      date: date,
      shouldHighlight: shouldHighlight,
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
      highlightedTitleColor: highlightedTitleColor,
      highlightRadius: highlightRadius,
      tileColor: _monthViewThemeSettings.cellsInMonthTileColor,
      highlightColor: highlightColor,
      multipleDateSelectionColor: color,
    );
  }

  /// Handles cell tap event. Updates selected date if [widget.selectedDate]
  /// is null and calls [MonthViewBuilders.onCellTap] callback.
  void _handleCellTap(List<CalendarEventData<T>> events, DateTime date) {
    if (widget.selectedDate == null &&
        !_isSameDate(_selectedDate, date.withoutTime) &&
        mounted) {
      setState(() {
        _selectedDate = date.withoutTime;
      });
    }

    _monthViewBuilders.onCellTap?.call(events, date);
  }

  /// Animate to next page (next month).
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthViewStyle.pageTransitionDuration] and
  /// [MonthViewStyle.pageTransitionCurve] respectively.
  ///
  /// See also: [previousPage], [jumpToMonth], [animateToMonth]
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? _monthViewStyle.pageTransitionDuration,
      curve: curve ?? _monthViewStyle.pageTransitionCurve,
    );
  }

  /// Animate to previous page (previous month).
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthViewStyle.pageTransitionDuration] and
  /// [MonthViewStyle.pageTransitionCurve] respectively.
  ///
  /// See also: [nextPage], [jumpToMonth], [animateToMonth]
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? _monthViewStyle.pageTransitionDuration,
      curve: curve ?? _monthViewStyle.pageTransitionCurve,
    );
  }

  /// Jumps to page index without animation.
  ///
  /// **Page Index Formula:** `pageIndex = month.getMonthDifference(minMonth) - 1`
  /// For calculation details, see [jumpToMonth].
  ///
  /// **Prefer:** Use [jumpToMonth] instead of this method for date-based navigation.
  ///
  /// See also: [jumpToMonth], [animateToPage]
  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  /// Animates to the specified page index with animation.
  ///
  /// The [page] parameter represents the page index calculated as:
  /// `pageIndex = minMonth.getMonthDifference(targetMonth) - 1`
  ///
  /// Optional [duration] and [curve] parameters override the default transition
  /// values from [MonthViewStyle.pageTransitionDuration] and
  /// [MonthViewStyle.pageTransitionCurve].
  ///
  /// **Recommendation:** For date-based navigation, prefer using [animateToMonth]
  /// instead, as it accepts a [DateTime] and handles the page index calculation
  /// automatically.
  ///
  /// See also: [animateToMonth], [jumpToPage], [jumpToMonth]
  Future<void> animateToPage(
    int page, {
    Duration? duration,
    Curve? curve,
  }) async {
    await _pageController.animateToPage(
      page,
      duration: duration ?? _monthViewStyle.pageTransitionDuration,
      curve: curve ?? _monthViewStyle.pageTransitionCurve,
    );
  }

  /// Returns current page index (number of months since
  /// [MonthViewStyle.minMonth]).
  ///
  /// Use [currentDate] to get the current month as a DateTime.
  ///
  /// See also: [currentDate], [jumpToMonth]
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
  /// as [MonthViewStyle.pageTransitionDuration] and
  /// [MonthViewStyle.pageTransitionCurve] respectively.
  Future<void> animateToMonth(
    DateTime month, {
    Duration? duration,
    Curve? curve,
  }) async {
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
class _MonthPageBuilder<T> extends StatefulWidget {
  const _MonthPageBuilder({
    required this.cellRatio,
    required this.showBorder,
    required this.borderSize,
    required this.cellBuilder,
    required this.selectedDate,
    required this.date,
    required this.controller,
    required this.width,
    required this.height,
    required this.onCellTap,
    required this.onDateLongPress,
    required this.onDateLongPressMoveUpdate,
    required this.onLongPressSelectionStateChange,
    required this.startDay,
    required this.physics,
    required this.hideDaysNotInMonth,
    required this.weekDays,
    Key? key,
    this.borderColor,
  }) : super(key: key);

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
  final DateLongPressMoveUpdateCallback? onDateLongPressMoveUpdate;
  final ValueChanged<bool>? onLongPressSelectionStateChange;
  final WeekDays startDay;
  final ScrollPhysics physics;
  final bool hideDaysNotInMonth;
  final int weekDays;
  final DateTime? selectedDate;

  @override
  State<_MonthPageBuilder<T>> createState() => _MonthPageBuilderState<T>();
}

class _MonthPageBuilderState<T> extends State<_MonthPageBuilder<T>> {
  DateTime? _lastReportedDate;
  bool _isLongPressActive = false;

  @override
  void dispose() {
    _cancelLongPressTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = widget.date.datesOfMonths(
      startDay: widget.startDay,
      hideDaysNotInMonth: widget.hideDaysNotInMonth,
      showWeekends: widget.weekDays == 7,
    );
    final rowCount = (monthDays.length / widget.weekDays).ceil();

    // Highlight tiles which is not in current month
    final grid = SizedBox(
      width: widget.width,
      height: widget.height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: widget.physics,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.weekDays,
          childAspectRatio: widget.cellRatio,
        ),
        itemCount: monthDays.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // Hide events if `hideDaysNotInMonth` true
          final events = widget.hideDaysNotInMonth &&
                  (monthDays[index].month != widget.date.month)
              ? <CalendarEventData<T>>[]
              : widget.controller.getEventsOnDay(monthDays[index]);
          final isSelected =
              widget.selectedDate?.compareWithoutTime(monthDays[index]) ??
                  false;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onCellTap?.call(events, monthDays[index]),
            child: Container(
              decoration: BoxDecoration(
                border: widget.showBorder
                    ? Border.all(
                        color: widget.borderColor ??
                            context.monthViewColors.cellBorderColor,
                        width: widget.borderSize,
                      )
                    : null,
              ),
              child: widget.cellBuilder(
                monthDays[index],
                events,
                monthDays[index].compareWithoutTime(DateTime.now()),
                monthDays[index].month == widget.date.month,
                isSelected,
                widget.hideDaysNotInMonth,
              ),
            ),
          );
        },
      ),
    );

    if (!_hasLongPressCallbacks) {
      return grid;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (details) => _handleLongPressStart(
        details,
        monthDays,
        rowCount,
      ),
      onLongPressMoveUpdate: (details) => _handleLongPressMoveUpdate(
        details,
        monthDays,
        rowCount,
      ),
      onLongPressEnd: (_) => _cancelLongPressTracking(),
      onLongPressCancel: _cancelLongPressTracking,
      child: grid,
    );
  }

  bool get _hasLongPressCallbacks {
    return widget.onDateLongPress != null ||
        widget.onDateLongPressMoveUpdate != null;
  }

  void _handleLongPressStart(
    LongPressStartDetails details,
    List<DateTime> monthDays,
    int rowCount,
  ) {
    if (!_hasLongPressCallbacks) return;

    _isLongPressActive = true;
    widget.onLongPressSelectionStateChange?.call(true);
    _lastReportedDate = null;
    _notifyLongPressDate(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
      monthDays: monthDays,
      rowCount: rowCount,
      isMoveUpdate: false,
    );
  }

  void _handleLongPressMoveUpdate(
    LongPressMoveUpdateDetails details,
    List<DateTime> monthDays,
    int rowCount,
  ) {
    if (!_isLongPressActive) return;

    _notifyLongPressDate(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
      monthDays: monthDays,
      rowCount: rowCount,
      isMoveUpdate: true,
      moveDetails: details,
    );
  }

  void _notifyLongPressDate({
    required Offset localPosition,
    required Offset globalPosition,
    required List<DateTime> monthDays,
    required int rowCount,
    required bool isMoveUpdate,
    LongPressMoveUpdateDetails? moveDetails,
  }) {
    final date = _getDateFromPosition(
      localPosition: localPosition,
      monthDays: monthDays,
      rowCount: rowCount,
    );

    if (date == null) return;

    if (date == _lastReportedDate) return;

    if (!isMoveUpdate) {
      widget.onDateLongPress?.call(date);
    } else if (widget.onDateLongPressMoveUpdate != null) {
      widget.onDateLongPressMoveUpdate!(
        date,
        moveDetails ??
            LongPressMoveUpdateDetails(
              globalPosition: globalPosition,
              localPosition: localPosition,
              offsetFromOrigin: Offset.zero,
              localOffsetFromOrigin: Offset.zero,
            ),
      );
    }

    _lastReportedDate = date;
  }

  DateTime? _getDateFromPosition({
    required Offset localPosition,
    required List<DateTime> monthDays,
    required int rowCount,
  }) {
    final size = context.size;
    if (size == null || size.width <= 0 || size.height <= 0) return null;
    if (localPosition.dx < 0 ||
        localPosition.dy < 0 ||
        localPosition.dx >= size.width ||
        localPosition.dy >= size.height) {
      return null;
    }

    final columnWidth = size.width / widget.weekDays;
    final rowHeight = size.height / rowCount;
    final column = (localPosition.dx / columnWidth).floor();
    final row = (localPosition.dy / rowHeight).floor();
    final index = row * widget.weekDays + column;

    if (index < 0 || index >= monthDays.length) return null;
    return monthDays[index];
  }

  void _cancelLongPressTracking() {
    final wasLongPressActive = _isLongPressActive;
    _lastReportedDate = null;
    _isLongPressActive = false;
    if (wasLongPressActive) {
      widget.onLongPressSelectionStateChange?.call(false);
    }
  }
}

class MonthHeader {
  /// Hide Header Widget
  static Widget hidden(DateTime date) => const SizedBox.shrink();
}
