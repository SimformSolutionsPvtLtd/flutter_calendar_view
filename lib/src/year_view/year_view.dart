// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';

/// Default English month names for YearView.
/// Developers can use [YearViewBuilders.monthStringBuilder] to override.
const List<String> _defaultMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class YearView<T extends Object?> extends StatefulWidget {
  /// Main [Widget] to display year view.
  const YearView({
    Key? key,
    this.yearViewStyle = const YearViewStyle(),
    this.yearViewBuilders = const YearViewBuilders(),
    this.yearViewThemeSettings = const YearViewThemeSettings(),
    this.controller,
    this.width,
    // Mini calendar settings (shared with MonthView logic)
    this.startDay = WeekDays.monday,
    this.showWeekends = true,
    this.hideDaysNotInMonth = false,
  }) : super(key: key);

  /// A required parameter that controls events for year view.
  ///
  /// If [controller] is null it will take controller from
  /// [CalendarControllerProvider.controller].
  final EventController<T>? controller;

  /// Style of year view.
  final YearViewStyle yearViewStyle;

  /// Builders for year view.
  final YearViewBuilders<T> yearViewBuilders;

  /// Theme settings for year view.
  final YearViewThemeSettings yearViewThemeSettings;

  /// Width of year view.
  ///
  /// If null is provided then It will take width of closest [MediaQuery].
  final double? width;

  /// Defines the day from which the week starts.
  /// Only applies in [YearViewDisplayMode.miniCalendarGrid].
  ///
  /// Default value is [WeekDays.monday].
  final WeekDays startDay;

  /// Show weekends or not.
  /// Only applies in [YearViewDisplayMode.miniCalendarGrid].
  ///
  /// Default value is true.
  final bool showWeekends;

  /// Defines whether to show or hide cells that are not in the current month.
  /// Only applies in [YearViewDisplayMode.miniCalendarGrid].
  final bool hideDaysNotInMonth;

  @override
  YearViewState<T> createState() => YearViewState<T>();
}

/// State of year view.
class YearViewState<T extends Object?> extends State<YearView<T>> {
  /// Minimum year user can scroll to.
  late DateTime _minYear;

  /// Maximum year user can scroll to.
  late DateTime _maxYear;

  /// Currently displayed year.
  late DateTime _currentYear;

  /// Current page index in PageView.
  late int _currentIndex;

  /// Total number of years available between _minYear and _maxYear.
  late int _totalYears;

  /// Controls page transitions between years.
  late PageController _pageController;

  /// Total width of the year view widget in pixels.
  late double _width;

  /// Event controller for managing calendar events.
  EventController<T>? _controller;

  /// Callback triggered when events change or rebuild is needed.
  late VoidCallback _reloadCallback;

  /// Current style configuration for the year view.
  late YearViewStyle _yearViewStyle = widget.yearViewStyle;

  /// Current custom builders for year view components.
  late YearViewBuilders<T> _yearViewBuilders = widget.yearViewBuilders;

  /// Current theme settings for year view.
  late YearViewThemeSettings _yearViewThemeSettings =
      widget.yearViewThemeSettings;

  late DateWidgetBuilder _headerBuilder;

  @override
  void initState() {
    super.initState();
    _reloadCallback = _reload;

    _setDateRange();

    // Initialize current year.
    _currentYear =
        DateTime((_yearViewStyle.initialYear ?? DateTime.now()).year);

    _regulateCurrentYear();

    // Initialize page controller.
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
        ..removeListener(_reloadCallback)
        ..addListener(_reloadCallback);
    }

    _updateWidth();
  }

  @override
  void didUpdateWidget(YearView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;
    _yearViewStyle = widget.yearViewStyle;
    _yearViewBuilders = widget.yearViewBuilders;
    _yearViewThemeSettings = widget.yearViewThemeSettings;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    // Update date range.
    if (_yearViewStyle.minYear != oldWidget.yearViewStyle.minYear ||
        _yearViewStyle.maxYear != oldWidget.yearViewStyle.maxYear) {
      _setDateRange();
      _regulateCurrentYear();
      _pageController.jumpToPage(_currentIndex);
    }

    _assignBuilders();
    _updateWidth();
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);
    _pageController.dispose();
    super.dispose();
  }

  void _updateWidth() {
    _width = widget.width ?? MediaQuery.of(context).size.width;
  }

  void _assignBuilders() {
    _headerBuilder = _yearViewBuilders.headerBuilder ?? _defaultHeaderBuilder;
  }

  /// Sets the current year.
  void _regulateCurrentYear() {
    if (_currentYear.isBefore(_minYear)) {
      _currentYear = _minYear;
    } else if (_currentYear.isAfter(_maxYear)) {
      _currentYear = _maxYear;
    }
    _currentIndex = _currentYear.year - _minYear.year;
  }

  /// Sets the minimum and maximum years.
  void _setDateRange() {
    _minYear =
        DateTime((_yearViewStyle.minYear ?? CalendarConstants.epochDate).year);
    _maxYear =
        DateTime((_yearViewStyle.maxYear ?? CalendarConstants.maxDate).year);

    assert(
      _minYear.isBefore(_maxYear),
      'Minimum year should be less than maximum year.\n'
      'Provided minimum year: $_minYear, maximum year: $_maxYear',
    );

    _totalYears = _maxYear.year - _minYear.year + 1;
  }

  /// Called when user changes page.
  void _onPageChange(int value) {
    if (mounted) {
      setState(() {
        _currentYear = DateTime(_minYear.year + value);
        _currentIndex = value;
      });
    }
    _yearViewBuilders.onPageChange?.call(_currentYear, _currentIndex);
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
      option: _yearViewStyle.safeAreaOption,
      child: SizedBox(
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _width,
              child: _headerBuilder(_currentYear),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: _yearViewStyle.pageViewPhysics,
                onPageChanged: _onPageChange,
                itemCount: _totalYears,
                itemBuilder: (_, index) {
                  final yearDate = DateTime(_minYear.year + index);
                  final yearPageContent =
                      _yearViewStyle.displayMode == YearViewDisplayMode.titleGrid
                          ? _buildTitleGrid(yearDate)
                          : _buildMiniCalendarGrid(yearDate);

                  if (_yearViewBuilders.onHasReachedEnd != null ||
                      _yearViewBuilders.onHasReachedStart != null) {
                    final isFirstPage = index == 0;
                    final isLastPage = index == _totalYears - 1;
                    if (isFirstPage || isLastPage) {
                      return GestureDetector(
                        onHorizontalDragEnd: (details) =>
                            _onHorizontalDragEnd(
                          details,
                          isFirstPage: isFirstPage,
                          isLastPage: isLastPage,
                        ),
                        child: yearPageContent,
                      );
                    }
                  }

                  return yearPageContent;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Title Grid Mode
  // ---------------------------------------------------------------------------

  Widget _buildTitleGrid(DateTime yearDate) {
    final columnCount = _yearViewStyle.columnCount;
    return SingleChildScrollView(
      physics: _yearViewStyle.pagePhysics,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          childAspectRatio: _yearViewStyle.monthAspectRatio,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = DateTime(yearDate.year, index + 1);
          final isCurrentMonth = month.year == DateTime.now().year &&
              month.month == DateTime.now().month;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _yearViewBuilders.onMonthTap?.call(month),
            child: _yearViewBuilders.monthTileBuilder != null
                ? _yearViewBuilders.monthTileBuilder!(
                    context, month, isCurrentMonth)
                : _defaultMonthTile(month, isCurrentMonth),
          );
        },
      ),
    );
  }

  Widget _defaultMonthTile(DateTime month, bool isCurrentMonth) {
    final themeSettings = _yearViewThemeSettings;
    final highlightColor = themeSettings.currentMonthHighlightColor ??
        context.monthViewColors.cellHighlightColor;
    final monthName = _yearViewBuilders.monthStringBuilder?.call(month) ??
        _defaultMonthNames[month.month - 1];
    final bgColor = themeSettings.monthTitleBackgroundColor;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
            BorderRadius.circular(themeSettings.currentMonthHighlightRadius),
        border: themeSettings.gridBorderColor != null
            ? Border.all(
                color: themeSettings.gridBorderColor!,
                width: themeSettings.gridBorderSize,
              )
            : null,
      ),
      child: Center(
        child: isCurrentMonth
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(
                      themeSettings.currentMonthHighlightRadius),
                ),
                child: Text(
                  monthName,
                  textAlign: TextAlign.center,
                  style: themeSettings.monthTitleStyle?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
              )
            : Text(
                monthName,
                textAlign: TextAlign.center,
                style: themeSettings.monthTitleStyle ??
                    TextStyle(
                      fontSize: 16,
                      color: context.monthViewColors.cellTextColor,
                    ),
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mini Calendar Grid Mode
  // ---------------------------------------------------------------------------

  Widget _buildMiniCalendarGrid(DateTime yearDate) {
    final columnCount = _yearViewStyle.columnCount;
    return SingleChildScrollView(
      physics: _yearViewStyle.pagePhysics,
      child: GridView.builder(
        padding: const EdgeInsets.all(4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          childAspectRatio: 0.75,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = DateTime(yearDate.year, index + 1);
          final isCurrentMonth = month.year == DateTime.now().year &&
              month.month == DateTime.now().month;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _yearViewBuilders.onMonthTap?.call(month),
            child: _yearViewBuilders.miniMonthBuilder != null
                ? _yearViewBuilders.miniMonthBuilder!(
                    context, month, isCurrentMonth)
                : _defaultMiniMonth(month, isCurrentMonth),
          );
        },
      ),
    );
  }

  Widget _defaultMiniMonth(DateTime month, bool isCurrentMonth) {
    final themeSettings = _yearViewThemeSettings;
    final today = DateTime.now().withoutTime;
    final monthName = _yearViewBuilders.monthStringBuilder?.call(month) ??
        _defaultMonthNames[month.month - 1];
    final columnCount = widget.showWeekends ? 7 : 5;

    // Generate dates for this mini month using the same logic as MonthView
    final dates = month.datesOfMonths(
      startDay: widget.startDay,
      hideDaysNotInMonth: widget.hideDaysNotInMonth,
      showWeekends: widget.showWeekends,
    );

    // Get weekday headers
    final weekDayHeaders = month.datesOfWeek(
      start: widget.startDay,
      showWeekEnds: widget.showWeekends,
    );

    final borderColor = themeSettings.gridBorderColor ??
        context.monthViewColors.cellBorderColor;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: themeSettings.gridBorderSize),
        borderRadius: BorderRadius.circular(6),
        color: isCurrentMonth
            ? (themeSettings.currentMonthHighlightColor ?? Theme.of(context).primaryColor).withAlpha(15)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isCurrentMonth
                  ? (themeSettings.currentMonthHighlightColor ??
                      Theme.of(context).primaryColor)
                  : context.monthViewColors.headerBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            child: Center(
              child: Text(
                monthName,
                style: themeSettings.monthTitleStyle?.copyWith(
                      color: isCurrentMonth ? Colors.white : null,
                      fontWeight: FontWeight.w600,
                    ) ??
                    TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isCurrentMonth
                          ? Colors.white
                          : context.monthViewColors.headerTextColor,
                    ),
              ),
            ),
          ),
          // Weekday headers row
          Row(
            children: List.generate(
              columnCount,
              (i) => Expanded(
                child: Center(
                  child: Text(
                    PackageStrings.currentLocale.weekdays[weekDayHeaders[i].weekday - 1],
                    style: themeSettings.monthTitleStyle?.copyWith(fontSize: 8) ??
                        TextStyle(
                          fontSize: 8,
                          color: context.monthViewColors.weekDayTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
          ),
          // Date grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
              ),
              itemCount: dates.length,
              itemBuilder: (context, i) {
                final date = dates[i];
                final isToday = date.compareWithoutTime(today);
                final isInMonth = date.month == month.month;
                final hide = widget.hideDaysNotInMonth && !isInMonth;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!hide) {
                      final events = _controller?.getEventsOnDay(date) ?? [];
                      _yearViewBuilders.onDateTap?.call(events, date);
                    }
                  },
                  child: Center(
                    child: hide
                        ? const SizedBox.shrink()
                        : Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday
                                  ? themeSettings.currentDateHighlightColor
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: isToday
                                      ? Colors.white
                                      : isInMonth
                                          ? context.monthViewColors.cellTextColor
                                          : context.monthViewColors.cellTextColor
                                              .withAlpha(100),
                                ),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------------

  void _onHorizontalDragEnd(
    DragEndDetails dragEndDetails, {
    required bool isFirstPage,
    required bool isLastPage,
  }) {
    final velocity = dragEndDetails.primaryVelocity ?? 0;
    if (velocity == 0) return;

    final isSwipingToPrevious = velocity > 0;
    final isSwipingToNext = velocity < 0;

    if (isFirstPage && isLastPage) {
      if (isSwipingToPrevious) {
        _yearViewBuilders.onHasReachedStart?.call(_currentYear, _currentIndex);
      } else if (isSwipingToNext) {
        _yearViewBuilders.onHasReachedEnd?.call(_currentYear, _currentIndex);
      }
    } else if (isFirstPage) {
      if (isSwipingToNext) {
        nextPage();
      } else if (isSwipingToPrevious) {
        _yearViewBuilders.onHasReachedStart?.call(_currentYear, _currentIndex);
      }
    } else if (isLastPage) {
      if (isSwipingToPrevious) {
        previousPage();
      } else if (isSwipingToNext) {
        _yearViewBuilders.onHasReachedEnd?.call(_currentYear, _currentIndex);
      }
    }
  }

  /// Default year view header builder.
  Widget _defaultHeaderBuilder(DateTime date) {
    return YearPageHeader(
      showPreviousIcon: date.year != _minYear.year,
      showNextIcon: date.year != _maxYear.year,
      onTitleTapped: () async {
        if (_yearViewBuilders.onHeaderTitleTap != null) {
          await _yearViewBuilders.onHeaderTitleTap!(date);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: _minYear,
            lastDate: _maxYear,
            locale: Locale(PackageStrings.selectedLocale),
          );

          if (selectedDate == null) return;
          jumpToYear(selectedDate.year);
        }
      },
      onPreviousYear: previousPage,
      date: date,
      dateStringBuilder: _yearViewBuilders.headerStringBuilder,
      onNextYear: nextPage,
      headerStyle: _yearViewThemeSettings.headerStyle ??
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

  // ---------------------------------------------------------------------------
  // Public Navigation API
  // ---------------------------------------------------------------------------

  /// Returns [EventController] associated with this Widget.
  EventController<T> get controller {
    if (_controller == null) {
      throw "EventController is not initialized yet.";
    }
    return _controller!;
  }

  /// Returns current page index.
  int get currentPage => _currentIndex;

  /// Returns the current visible year.
  DateTime get currentDate => DateTime(_currentYear.year);

  /// Animate to next page (next year).
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? _yearViewStyle.pageTransitionDuration,
      curve: curve ?? _yearViewStyle.pageTransitionCurve,
    );
  }

  /// Animate to previous page (previous year).
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? _yearViewStyle.pageTransitionDuration,
      curve: curve ?? _yearViewStyle.pageTransitionCurve,
    );
  }

  /// Jumps to page for given [year] without animation.
  void jumpToYear(int year) {
    final targetYear = DateTime(year);
    if (targetYear.isBefore(_minYear) || targetYear.isAfter(_maxYear)) {
      throw "Invalid year selected. Year must be between ${_minYear.year} and ${_maxYear.year}.";
    }
    _pageController.jumpToPage(year - _minYear.year);
  }

  /// Animates to page for given [year].
  Future<void> animateToYear(
    int year, {
    Duration? duration,
    Curve? curve,
  }) async {
    final targetYear = DateTime(year);
    if (targetYear.isBefore(_minYear) || targetYear.isAfter(_maxYear)) {
      throw "Invalid year selected. Year must be between ${_minYear.year} and ${_maxYear.year}.";
    }
    await _pageController.animateToPage(
      year - _minYear.year,
      duration: duration ?? _yearViewStyle.pageTransitionDuration,
      curve: curve ?? _yearViewStyle.pageTransitionCurve,
    );
  }

  /// Jumps to the page at [page] index without animation.
  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  /// Animates to the page at [page] index.
  Future<void> animateToPage(
    int page, {
    Duration? duration,
    Curve? curve,
  }) async {
    await _pageController.animateToPage(
      page,
      duration: duration ?? _yearViewStyle.pageTransitionDuration,
      curve: curve ?? _yearViewStyle.pageTransitionCurve,
    );
  }
}

class YearHeader {
  /// Hide Header Widget
  static Widget hidden(DateTime date) => const SizedBox.shrink();
}
