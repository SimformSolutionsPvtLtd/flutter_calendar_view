// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';
import '_calendar_drag_handle.dart';
import '_event_list_panel.dart';
import '_resizable_month_header.dart';
import '_resizable_month_page.dart';

/// A resizable calendar widget that displays a month-based calendar with
/// three interchangeable display modes:
///
/// * **Full** ([ResizableMonthViewMode.monthly]) – shows the entire month grid
///   (up to six rows). A scrollable event list for the selected date is
///   shown below the grid.
///
/// * **Compact** ([ResizableMonthViewMode.biWeekly]) – shows exactly two rows
///   (bi-weekly view). The header arrows navigate one week-pair at a time.
///
/// * **Minimal** ([ResizableMonthViewMode.weekly]) – shows a single row
///   (the current week). The header arrows navigate one week at a time.
///
/// The user can cycle through modes by tapping the mode-toggle pill that is
/// embedded in the header row. The current mode can also be changed
/// programmatically via [ResizableMonthViewState.setMode].
///
/// This widget is a **completely separate implementation** from [MonthView].
/// It shares only public types (typedefs, extensions, enums, theme data) and
/// does not extend or override any `MonthView` class.
class ResizableMonthView<T extends Object?> extends StatefulWidget {
  /// Creates a [ResizableMonthView].
  const ResizableMonthView({
    Key? key,
    this.style = const ResizableMonthViewStyle(),
    this.builders = const ResizableMonthViewBuilders(),
    this.themeSettings = const ResizableMonthViewThemeSettings(),
    this.controller,
    this.width,
    this.height,
    this.selectedDate,
    this.multiDateSelectionRange = const {},
    this.multiDateSelectionColor,
  }) : super(key: key);

  /// Event controller. Falls back to
  /// [CalendarControllerProvider.controller] if null.
  final EventController<T>? controller;

  /// Style configuration for this view.
  final ResizableMonthViewStyle style;

  /// Builder callbacks for this view.
  final ResizableMonthViewBuilders<T> builders;

  /// Theme-color settings for this view.
  final ResizableMonthViewThemeSettings themeSettings;

  /// Fixed width of this widget.
  ///
  /// If null the width of the closest [MediaQuery] is used.
  final double? width;

  /// Fixed height of the calendar grid in full mode.
  ///
  /// If null, the grid height will adjust dynamically to tightly fit the
  /// required number of rows based on the cell size.
  final double? height;

  /// Externally controlled selected date.
  ///
  /// When non-null the view does **not** update the selection on cell tap;
  /// tapping only fires [ResizableMonthViewBuilders.onCellTap].
  final DateTime? selectedDate;

  /// Set of dates highlighted by a long-press drag.
  final Set<DateTime> multiDateSelectionRange;

  /// Highlight color for multi-selected dates.
  final Color? multiDateSelectionColor;

  @override
  ResizableMonthViewState<T> createState() => ResizableMonthViewState<T>();
}

/// State for [ResizableMonthView].
///
/// Exposes:
/// * [nextPage] / [previousPage] / [jumpToMonth] / [animateToMonth] — same
///   as [MonthViewState] (only meaningful in Full mode).
/// * [setMode] — programmatically switch display modes.
/// * [currentDate] / [currentPage] — current visible month / page index.
class ResizableMonthViewState<T extends Object?>
    extends State<ResizableMonthView<T>> {
  // ── Date-range state ──────────────────────────────────────────────────
  late DateTime _minDate;
  late DateTime _maxDate;
  late DateTime _currentDate; // currently visible month (Full mode)
  late int _currentIndex;
  int _totalMonths = 0;

  // ── Mode state ────────────────────────────────────────────────────────
  late ResizableMonthViewMode _currentMode;

  /// For Compact and Minimal modes: the first day (startDay-aligned Monday
  /// equivalent) of the visible week strip.
  late DateTime _currentWeekStart;

  // ── Selection ─────────────────────────────────────────────────────────
  DateTime? _selectedDate;

  // ── Layout ────────────────────────────────────────────────────────────
  late double _width;
  late double _cellWidth;
  late double _cellHeight;

  // ── PageController (Full mode) ────────────────────────────────────────
  late PageController _pageController;

  // ── PageController (Weekly / BiWeekly mode) ──────────────────────────
  /// Virtual midpoint page index for the week-strip [PageView].
  /// Using a large fixed pool (10 000 pages) avoids computing bounds up front.
  static const int _weekPageMidpoint = 5000;

  /// Current page index inside [_weekPageController].
  int _weekPageIndex = _weekPageMidpoint;

  /// Controller for the week-strip [PageView] used in Compact / Minimal modes.
  /// Created lazily when first entering a strip mode and disposed when leaving.
  PageController? _weekPageController;

  // ── Controller / callback wiring ─────────────────────────────────────
  EventController<T>? _controller;
  late VoidCallback _reloadCallback;

  // ── Builder cache ─────────────────────────────────────────────────────
  late CellBuilder<T> _cellBuilder;
  late WeekDayBuilder _weekBuilder;

  // ── Layout measurement keys (monthlyScrollable grid height) ───────────
  /// Key attached to the rendered header so we can measure its height.
  final GlobalKey _headerKey = GlobalKey();

  /// Key attached to the rendered weekday-label row so we can measure its height.
  final GlobalKey _weekDayRowKey = GlobalKey();

  /// Last measured height of the header widget. Defaults to 60 px (a safe
  /// approximation used before the first frame completes measurement).
  double _measuredHeaderHeight = 60.0;

  /// Last measured height of the weekday-label row. Defaults to 37 px
  /// (vertical: 10 padding × 2 + fontSize 17).
  double _measuredWeekDayRowHeight = 37.0;

  // ── Computed style shortcuts ──────────────────────────────────────────
  ResizableMonthViewStyle get _style => widget.style;

  ResizableMonthViewBuilders<T> get _builders => widget.builders;

  ResizableMonthViewThemeSettings get _theme => widget.themeSettings;

  // ─────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────

  /// Initialises all state fields from widget configuration.
  ///
  /// Order matters:
  /// 1. Compute the valid date range (`_minDate` / `_maxDate`).
  /// 2. Derive the initial visible month and clamp it to the range.
  /// 3. Resolve the week-start anchor for Compact / Minimal strips.
  /// 4. Seed the [PageController] at the correct page index.
  /// 5. Cache builder callbacks so they are ready for the first frame.
  @override
  void initState() {
    super.initState();
    _reloadCallback = _reload;
    _currentMode = _style.initialMode;

    _setDateRange();

    _currentDate = (_style.initialMonth ?? DateTime.now()).withoutTime;
    _regulateCurrentDate();

    _currentWeekStart = _currentDate.firstDayOfWeek(start: _style.startDay);

    _selectedDate = widget.selectedDate?.withoutTime;

    _pageController = PageController(initialPage: _currentIndex);

    // Initialise the week-strip controller only when the view starts in a
    // strip mode so we don't create an unused controller in the common case.
    if (_currentMode == ResizableMonthViewMode.weekly ||
        _currentMode == ResizableMonthViewMode.biWeekly) {
      _initWeekPageController();
    }

    _assignBuilders();
  }

  /// Re-resolves the [EventController] from the widget tree whenever an
  /// inherited widget changes, and recalculates layout dimensions.
  ///
  /// The controller may come from the widget property or from
  /// [CalendarControllerProvider]; either way, stale listeners are
  /// detached before attaching the new one.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    _updateDimensions();
  }

  /// Reacts to parent rebuilds by diffing the old and new widget.
  ///
  /// Key reconciliation steps:
  /// * Re-wires the [EventController] if it changed.
  /// * Recomputes the date range and jumps the [PageView] when
  ///   [ResizableMonthViewStyle.minMonth] or `maxMonth` changed.
  /// * Preserves external selection: if [widget.selectedDate] becomes
  ///   null after being non-null, the last externally provided value
  ///   is kept so the UI doesn't lose the highlight.
  @override
  void didUpdateWidget(ResizableMonthView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    if (_style.minMonth != oldWidget.style.minMonth ||
        _style.maxMonth != oldWidget.style.maxMonth) {
      _setDateRange();
      _regulateCurrentDate();
      _pageController.jumpToPage(_currentIndex);
    }

    _assignBuilders();

    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate?.withoutTime;
    } else if (oldWidget.selectedDate != null) {
      _selectedDate = oldWidget.selectedDate?.withoutTime;
    }

    _updateDimensions();
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);
    _pageController.dispose();
    _weekPageController?.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────

  /// Returns the [EventController] wired to this widget.
  EventController<T> get controller {
    if (_controller == null) {
      throw StateError('EventController is not initialized yet.');
    }
    return _controller!;
  }

  /// The currently displayed month.
  DateTime get currentDate => DateTime(_currentDate.year, _currentDate.month);

  /// Current page index in the [PageView] (Full mode only).
  int get currentPage => _currentIndex;

  /// Programmatically change the display mode.
  void setMode(ResizableMonthViewMode mode) {
    if (!mounted || _currentMode == mode) return;
    setState(() => _applyModeChange(mode));
  }

  /// Navigate to the next month (Full mode) or the next week / week-pair
  /// (Compact / Minimal mode).
  void nextPage({Duration? duration, Curve? curve}) {
    if (_currentMode == ResizableMonthViewMode.monthly ||
        _currentMode == ResizableMonthViewMode.monthlyScrollable) {
      _pageController.nextPage(
        duration: duration ?? _style.pageTransitionDuration,
        curve: curve ?? _style.pageTransitionCurve,
      );
    } else {
      _weekPageController?.nextPage(
        duration: duration ?? _style.pageTransitionDuration,
        curve: curve ?? _style.pageTransitionCurve,
      );
    }
  }

  /// Navigate to the previous month (Full mode) or the previous week /
  /// week-pair (Compact / Minimal mode).
  void previousPage({Duration? duration, Curve? curve}) {
    if (_currentMode == ResizableMonthViewMode.monthly ||
        _currentMode == ResizableMonthViewMode.monthlyScrollable) {
      _pageController.previousPage(
        duration: duration ?? _style.pageTransitionDuration,
        curve: curve ?? _style.pageTransitionCurve,
      );
    } else {
      _weekPageController?.previousPage(
        duration: duration ?? _style.pageTransitionDuration,
        curve: curve ?? _style.pageTransitionCurve,
      );
    }
  }

  /// Jumps to the page for [month] without animation (Full mode).
  void jumpToMonth(DateTime month) {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw ArgumentError(
          'Invalid date selected: $month. Must be between $_minDate and $_maxDate');
    }
    _pageController.jumpToPage(_minDate.getMonthDifference(month) - 1);
  }

  /// Animates to the page for [month] (Full mode).
  Future<void> animateToMonth(
    DateTime month, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (month.isBefore(_minDate) || month.isAfter(_maxDate)) {
      throw ArgumentError(
          'Invalid date selected: $month. Must be between $_minDate and $_maxDate');
    }
    await _pageController.animateToPage(
      _minDate.getMonthDifference(month) - 1,
      duration: duration ?? _style.pageTransitionDuration,
      curve: curve ?? _style.pageTransitionCurve,
    );
  }

  /// Jumps to [page] index without animation.
  void jumpToPage(int page) => _pageController.jumpToPage(page);

  /// Animates to [page] index.
  Future<void> animateToPage(
    int page, {
    Duration? duration,
    Curve? curve,
  }) async {
    await _pageController.animateToPage(
      page,
      duration: duration ?? _style.pageTransitionDuration,
      curve: curve ?? _style.pageTransitionCurve,
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────

  /// Builds the complete resizable month view.
  ///
  /// Layout structure:
  /// 1. **Header** – navigation arrows, title, and mode-toggle pill.
  /// 2. **Calendar area** – weekday labels + animated cell grid.
  /// 3. **Event list panel** – sliver list for the selected date.
  /// 4. **Drag handle** (optional) – overlaid at the bottom of the widget via
  ///    a [Stack] when [ResizableMonthViewStyle.enableDragToSwitchMode] is
  ///    `true`. A matching bottom spacer sliver keeps the last list item from
  ///    being hidden behind the handle.
  @override
  Widget build(BuildContext context) {
    const double handleTouchTarget = 44.0;
    final bool showHandle = _style.enableDragToSwitchMode;

    return SafeAreaWrapper(
      option: _style.safeAreaOption,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isBounded = constraints.hasBoundedHeight;

          final scrollView = CustomScrollView(
            shrinkWrap: !isBounded,
            physics: isBounded
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              SliverToBoxAdapter(
                child: _buildCalendarArea(constraints),
              ),
              if (showHandle)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: handleTouchTarget,
                    child: CalendarDragHandle(
                      onDragUp: _onDragHandleUp,
                      onDragDown: _onDragHandleDown,
                      threshold: _style.dragThreshold,
                      handleColor: _style.dragHandleColor,
                    ),
                  ),
                ),
              if (_currentMode != ResizableMonthViewMode.monthlyScrollable)
                EventListPanel<T>(
                  selectedDate: _selectedDate ?? DateTime.now().withoutTime,
                  controller: controller,
                  builders: _builders,
                  padding: _style.eventListPadding,
                  separatorHeight: _style.eventListSeparatorHeight,
                ),
              // Bottom spacer so the event list isn't hidden behind the
              // handle overlay when the user has scrolled to the bottom.
            ],
          );

          // No drag-to-switch → return the scroll view directly (no overhead).
          if (!showHandle) return scrollView;

          // Stack the drag handle at the very bottom of the available area.
          // Using Positioned.fill for the scroll view and Positioned(bottom:0)
          // for the handle guarantees the pill is always visible, regardless
          // of how much content the event list contains or which mode is active.
          return scrollView;
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────────────

  /// Builds the header bar.
  ///
  /// If a fully custom [ResizableMonthViewBuilders.headerBuilder] is
  /// provided, the entire header is delegated to it. Otherwise a default
  /// [ResizableMonthViewHeader] is composed by merging:
  /// * The user-provided [ResizableMonthViewThemeSettings.headerStyle]
  ///   (falling back to theme-extension colours).
  /// * Mode-toggle pill colours from [_style] or the theme extension.
  /// * Navigation callbacks (`previousPage` / `nextPage`), visibility
  ///   flags (`_canGoPrevious` / `_canGoNext`), and an optional title-tap
  ///   handler that opens the platform date picker.
  Widget _buildHeader() {
    // Allow fully custom header builder.
    if (_builders.headerBuilder != null) {
      return SizedBox(
        width: _width,
        child: _builders.headerBuilder!(_displayDate),
      );
    }

    final themeColors = context.resizableMonthViewColors;

    final effectiveHeaderStyle = _theme.headerStyle ??
        HeaderStyle(
          decoration: BoxDecoration(
            color: themeColors.headerBackgroundColor,
          ),
          leftIconConfig: IconDataConfig(
            color: themeColors.headerIconColor,
          ),
          rightIconConfig: IconDataConfig(
            color: themeColors.headerIconColor,
          ),
          headerTextStyle: TextStyle(
            color: themeColors.headerTextColor,
            fontWeight: FontWeight.w500,
          ),
        );

    final toggleColor =
        _style.modeToggleActiveColor ?? themeColors.modeToggleActiveColor;
    final toggleTextColor =
        _style.modeToggleTextColor ?? themeColors.modeToggleTextColor;

    return SizedBox(
      key: _headerKey,
      width: _width,
      child: ResizableMonthViewHeader(
        currentDate: _displayDate,
        currentMode: _currentMode,
        onPrevious: previousPage,
        onNext: nextPage,
        onModeTap: _onModeTap,
        showPreviousIcon: _canGoPrevious,
        showNextIcon: _canGoNext,
        showModeToggle: _style.showModeToggle,
        headerStyle: effectiveHeaderStyle,
        modeToggleActiveColor: toggleColor,
        modeToggleTextColor: toggleTextColor,
        modeToggleBorderRadius: _style.modeToggleBorderRadius,
        dateStringBuilder: _builders.headerStringBuilder,
        onTitleTap: _builders.onHeaderTitleTap != null
            ? () => _builders.onHeaderTitleTap!(_displayDate)
            : (_builders.headerBuilder == null ? _defaultTitleTap : null),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Calendar area
  // ─────────────────────────────────────────────────────────────────────

  /// Assembles the calendar area: a static weekday-label row on top, and
  /// the day-cell grid below it, wrapped in [AnimatedSize] so that height
  /// transitions smoothly when the user toggles between Full / Compact /
  /// Minimal modes.
  ///
  /// The weekday row is rendered *outside* the paged / strip area
  /// intentionally — this avoids it being included in the height budget
  /// for the cell grid and prevents the row from being duplicated on
  /// every page of the [PageView].
  Widget _buildCalendarArea(BoxConstraints constraints) {
    // Schedule a measurement after this frame so _getFullGridHeight has
    // accurate values on the *next* build triggered by the setState below.
    _scheduleMeasurement();

    final weekDayRow = KeyedSubtree(
      key: _weekDayRowKey,
      child: _buildWeekDayRow(),
    );

    Widget gridArea;
    Key gridKey;
    switch (_currentMode) {
      case ResizableMonthViewMode.monthly:
      case ResizableMonthViewMode.monthlyScrollable:
        gridArea = _buildFullGrid(constraints);
        gridKey = const ValueKey('fullGrid');
        break;
      case ResizableMonthViewMode.biWeekly:
        gridArea = _buildWeekStripGrid(rowCount: 2);
        gridKey = const ValueKey('biWeekly');
        break;
      case ResizableMonthViewMode.weekly:
        gridArea = _buildWeekStripGrid(rowCount: 1);
        gridKey = const ValueKey('weekly');
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        weekDayRow,
        AnimatedSize(
          duration: _style.animationDuration,
          curve: _style.animationCurve,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: _style.animationDuration,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOut)),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: gridKey,
              child: gridArea,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the weekday-label row (Mon, Tue … Sun) using the active builder.
  Widget _buildWeekDayRow() {
    final weekDays = _currentWeekStart.datesOfWeek(
      start: _style.startDay,
      showWeekEnds: _style.showWeekends,
    );

    return SizedBox(
      width: _width,
      child: Row(
        children: List.generate(
          _columnCount,
          (i) => Expanded(
            child: SizedBox(
              width: _cellWidth,
              child: _weekBuilder(weekDays[i].weekday - 1),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the **Full-mode** grid: a horizontally-paged [PageView] where
  /// each page is one calendar month.
  ///
  /// For each page the dates list is generated via [DateTime.datesOfMonths]
  /// and then trimmed: any trailing full week that belongs entirely to the
  /// *next* month is removed so that the grid never displays an extra empty
  /// row. The minimum guaranteed row count is 4 (28-day February starting
  /// on the configured start day).
  ///
  /// The weekday-name row is *not* rendered here — it is placed once by
  /// [_buildCalendarArea] above the paged area.
  Widget _buildFullGrid(BoxConstraints constraints) {
    final double gridHeight = _getFullGridHeight(constraints);
    return GestureDetector(
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > 300 && _currentMode == ResizableMonthViewMode.monthly) {
          // Swipe down: switch to scrollable mode
          setMode(ResizableMonthViewMode.monthlyScrollable);
        } else if (velocity < -300 &&
            _currentMode == ResizableMonthViewMode.monthlyScrollable) {
          // Swipe up: switch back to normal monthly mode
          setMode(ResizableMonthViewMode.monthly);
        }
      },
      child: SizedBox(
        width: _width,
        height: gridHeight,
        child: PageView.builder(
          controller: _pageController,
          physics: _style.pageViewPhysics,
          onPageChanged: _onPageChange,
          itemCount: _totalMonths,
          itemBuilder: (_, index) {
            final monthDate = DateTime(_minDate.year, _minDate.month + index);
            var dates = monthDate
                .datesOfMonths(
                  startDay: _style.startDay,
                  hideDaysNotInMonth: _style.hideDaysNotInMonth,
                  showWeekends: _style.showWeekends,
                )
                .toList();

            final columnCount = _style.showWeekends ? 7 : 5;
            // Trim trailing rows that belong entirely to the next month so
            // the grid does not show a redundant empty row.
            while (dates.length > columnCount * 4) {
              final lastWeek = dates.sublist(dates.length - columnCount);
              if (lastWeek.every((d) => d.month != monthDate.month)) {
                dates.removeRange(dates.length - columnCount, dates.length);
              } else {
                break;
              }
            }
            return ResizableMonthPage<T>(
              key: ValueKey(monthDate.toIso8601String()),
              dates: dates,
              monthDate: monthDate,
              controller: controller,
              cellBuilder:
                  (date, events, isToday, isInMonth, isSelected, hideDays) {
                final child = _currentMode ==
                        ResizableMonthViewMode.monthlyScrollable
                    ? _scrollableCellBuilder(
                        date, events, isToday, isInMonth, isSelected, hideDays)
                    : _cellBuilder(
                        date, events, isToday, isInMonth, isSelected, hideDays);
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(_currentMode),
                    child: child,
                  ),
                );
              },
              weekDayBuilder: _weekBuilder,
              selectedDate: _selectedDate,
              style: _style,
              themeSettings: _theme,
              builders: _builders,
              onCellTap: _handleCellTap,
              width: _width,
              cellWidth: _cellWidth,
              cellHeight:
                  _currentMode == ResizableMonthViewMode.monthlyScrollable
                      ? gridHeight / (dates.length / columnCount).ceil()
                      : _cellHeight,
              showWeekDayRow: false,
            );
          },
        ),
      ),
    );
  }

  /// Builds the **Compact** (2-row) or **Minimal** (1-row) grid.
  ///
  /// Uses a virtually-infinite [PageView.builder] (10 000 pages, centred at
  /// [_weekPageMidpoint]) so that swiping produces the same native horizontal-
  /// slide effect as the Full-mode month [PageView].
  ///
  /// Dates for each page are computed on-the-fly by offsetting from the
  /// current [_currentWeekStart] anchor: a page at index `i` shows the weeks
  /// starting `(i − _weekPageIndex) × rowCount × 7` days from the anchor.
  ///
  /// Navigation callbacks (arrows) call [_weekPageController.nextPage] /
  /// [previousPage], and page-change state is managed by [_onWeekPageChanged].
  ///
  /// The weekday-name row is *not* rendered here — see [_buildCalendarArea].
  Widget _buildWeekStripGrid({required int rowCount}) {
    final gridHeight = _cellHeight * rowCount;

    return SizedBox(
      width: _width,
      height: gridHeight,
      child: PageView.builder(
        controller: _weekPageController,
        physics: _style.pageViewPhysics,
        onPageChanged: (index) => _onWeekPageChanged(index, rowCount),
        itemBuilder: (_, pageIndex) {
          // Compute the week-start for this virtual page relative to the
          // current anchor. Each page is `rowCount` weeks away from its
          // neighbour (1 week for Minimal, 2 weeks for Compact).
          final delta = pageIndex - _weekPageIndex;
          final weekStart = _currentWeekStart.add(
            Duration(days: delta * rowCount * 7),
          );
          final dates = _stripDatesForStart(weekStart, rowCount);
          return ResizableMonthPage<T>(
            key: ValueKey('${weekStart.toIso8601String()}_$rowCount'),
            dates: dates,
            monthDate: weekStart,
            controller: controller,
            cellBuilder: _cellBuilder,
            weekDayBuilder: _weekBuilder,
            selectedDate: _selectedDate,
            style: _style,
            themeSettings: _theme,
            builders: _builders,
            onCellTap: _handleCellTap,
            width: _width,
            cellWidth: _cellWidth,
            cellHeight: _cellHeight,
            showWeekDayRow: false,
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────────────────────────────

  /// Creates (or re-creates) [_weekPageController] anchored at the virtual
  /// midpoint so there is ample room to navigate in both directions.
  ///
  /// Always disposes the previous controller before creating a new one to
  /// avoid memory leaks.
  void _initWeekPageController() {
    _weekPageController?.dispose();
    _weekPageIndex = _weekPageMidpoint;
    _weekPageController = PageController(initialPage: _weekPageIndex);
  }

  /// Called by the week-strip [PageView] when the user swipes to a new page.
  ///
  /// Computes the new [_currentWeekStart] from the page delta, enforces
  /// min/max boundaries (bouncing back via [jumpToPage] when exceeded), and
  /// updates the header month label if it has changed.
  void _onWeekPageChanged(int newIndex, int rowCount) {
    if (!mounted) return;
    final delta = newIndex - _weekPageIndex;
    final newStart = _currentWeekStart.add(
      Duration(days: delta * rowCount * 7),
    );

    // ── Boundary checks ──────────────────────────────────────────────
    if (newStart.isBefore(_minDate) && delta < 0) {
      _builders.onHasReachedStart?.call(_currentWeekStart, _currentIndex);
      // Snap back to the current anchor page without animation.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _weekPageController?.jumpToPage(_weekPageIndex);
      });
      return;
    }
    final prospectiveDates = _stripDatesForStart(newStart, rowCount);
    if (prospectiveDates.isNotEmpty &&
        prospectiveDates.last.isAfter(_maxDate) &&
        delta > 0) {
      _builders.onHasReachedEnd?.call(_currentWeekStart, _currentIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _weekPageController?.jumpToPage(_weekPageIndex);
      });
      return;
    }

    final oldMonth = _currentDate.month;
    final oldYear = _currentDate.year;

    setState(() {
      _weekPageIndex = newIndex;
      _currentWeekStart = newStart;

      // Use a date 3 days into the strip as a heuristic for which month
      // the strip "belongs to" so the header title stays correct.
      final repr = newStart.add(const Duration(days: 3));
      if (repr.month != oldMonth || repr.year != oldYear) {
        _currentDate = DateTime(repr.year, repr.month);
        _regulateCurrentDate();
      }
    });

    if (_currentDate.month != oldMonth || _currentDate.year != oldYear) {
      _builders.onPageChange?.call(_currentDate, _currentIndex);
    }
  }

  /// Returns the date label shown in the header.
  DateTime get _displayDate {
    if (_currentMode == ResizableMonthViewMode.monthly ||
        _currentMode == ResizableMonthViewMode.monthlyScrollable) {
      return _currentDate;
    }
    // Compact / Minimal: show the month of the first visible cell.
    return _currentWeekStart;
  }

  /// Whether the "previous" arrow should be enabled.
  bool get _canGoPrevious {
    if (_currentMode == ResizableMonthViewMode.monthly ||
        _currentMode == ResizableMonthViewMode.monthlyScrollable) {
      return _currentDate != _minDate;
    }
    return _currentWeekStart.isAfter(_minDate);
  }

  /// Whether the "next" arrow should be enabled.
  bool get _canGoNext {
    if (_currentMode == ResizableMonthViewMode.monthly ||
        _currentMode == ResizableMonthViewMode.monthlyScrollable) {
      return _currentDate != _maxDate;
    }
    final lastVisible = _stripDates(_stripRowCount).last;
    return lastVisible.isBefore(_maxDate);
  }

  int get _stripRowCount =>
      _currentMode == ResizableMonthViewMode.biWeekly ? 2 : 1;

  /// Dynamically calculated height of the full-month grid based on the
  /// current month.
  ///
  /// For [ResizableMonthViewMode.monthlyScrollable] the grid height is computed
  /// as:
  ///   `screenUsableHeight - measuredHeaderHeight - measuredWeekDayRowHeight
  ///    - dragHandleTouchTarget (if enabled)`
  ///
  /// The header and weekday row heights are measured via [GlobalKey] after the
  /// first frame and kept updated — no hardcoded values.
  ///
  /// For all other modes the height is derived from the number of *visible*
  /// rows multiplied by [_cellHeight].
  double _getFullGridHeight(BoxConstraints constraints) {
    if (widget.height != null) return widget.height!;

    if (_currentMode == ResizableMonthViewMode.monthlyScrollable) {
      final mq = MediaQuery.of(context);
      // Total usable height = screen height minus system UI insets (status bar,
      // bottom nav bar, home indicator, etc.).
      final usable = mq.size.height - mq.padding.top - mq.padding.bottom;

      // Overhead = header + weekday row + drag handle (if shown).
      const double handleHeight = 44.0;
      final overhead = _measuredHeaderHeight +
          _measuredWeekDayRowHeight +
          (_style.enableDragToSwitchMode ? handleHeight : 0.0);

      // Clamp so the grid is never smaller than 4 rows of cells.
      return (usable - overhead).clamp(_cellHeight * 4, double.infinity);
    }

    final columnCount = _style.showWeekends ? 7 : 5;
    var dates = _currentDate
        .datesOfMonths(
          startDay: _style.startDay,
          hideDaysNotInMonth: _style.hideDaysNotInMonth,
          showWeekends: _style.showWeekends,
        )
        .toList();

    // Same trailing-row trim logic as _buildFullGrid's itemBuilder.
    while (dates.length > columnCount * 4) {
      final lastWeek = dates.sublist(dates.length - columnCount);
      if (lastWeek.every((d) => d.month != _currentDate.month)) {
        dates.removeRange(dates.length - columnCount, dates.length);
      } else {
        break;
      }
    }

    final rowCount = (dates.length / columnCount).ceil();
    return _cellHeight * rowCount;
  }

  int get _columnCount => _style.showWeekends ? 7 : 5;

  /// Generates the flat list of dates for a Compact (14 dates) or Minimal
  /// (7 dates) strip starting from the given [start] anchor.
  ///
  /// Each row is one full week (respecting [_style.startDay] and
  /// [_style.showWeekends]). Multiple rows are concatenated in order.
  List<DateTime> _stripDatesForStart(DateTime start, int rowCount) {
    return List.generate(rowCount, (index) {
      final weekStart = start.add(Duration(days: index * 7));
      return weekStart.datesOfWeek(
        start: _style.startDay,
        showWeekEnds: _style.showWeekends,
      );
    }).expand((element) => element).toList();
  }

  /// Convenience wrapper that returns strip dates anchored at the current
  /// [_currentWeekStart].
  List<DateTime> _stripDates(int rowCount) {
    return _stripDatesForStart(_currentWeekStart, rowCount);
  }

  /// Handler for taps on the mode-toggle pill in the header.
  ///
  /// Cycles full → compact → minimal → full and notifies external
  /// listeners via [ResizableMonthViewBuilders.onModeChanged].
  void _onModeTap() {
    final nextMode = _nextMode(_currentMode);
    setState(() => _applyModeChange(nextMode));
    _builders.onModeChanged?.call(nextMode);
  }

  // ── Drag-handle mode ladder ──────────────────────────────────────────

  /// Advances one step UP the mode ladder when the user drags upward.
  ///
  /// Ladder (upward direction):
  ///   monthlyScrollable → monthly → biWeekly → weekly (terminates)
  ///
  /// No-ops when already at [ResizableMonthViewMode.weekly].
  /// Reuses [_applyModeChange] so transitions are animated and both
  /// drag-based and button-based switching share the same state.
  void _onDragHandleUp() {
    final ResizableMonthViewMode? next;
    switch (_currentMode) {
      case ResizableMonthViewMode.weekly:
        next = null; // already at the top
        break;
      case ResizableMonthViewMode.biWeekly:
        next = ResizableMonthViewMode.weekly;
        break;
      case ResizableMonthViewMode.monthly:
        next = ResizableMonthViewMode.biWeekly;
        break;
      case ResizableMonthViewMode.monthlyScrollable:
        next = ResizableMonthViewMode.monthly;
        break;
    }
    if (next == null || !mounted) return;
    setState(() => _applyModeChange(next!));
    _builders.onModeChanged?.call(next);
  }

  /// Advances one step DOWN the mode ladder when the user drags downward.
  ///
  /// Ladder (downward direction):
  ///   weekly → biWeekly → monthly → monthlyScrollable (terminates)
  ///
  /// No-ops when already at [ResizableMonthViewMode.monthlyScrollable].
  /// Reuses [_applyModeChange] so transitions are animated and both
  /// drag-based and button-based switching share the same state.
  void _onDragHandleDown() {
    final ResizableMonthViewMode? next;
    switch (_currentMode) {
      case ResizableMonthViewMode.weekly:
        next = ResizableMonthViewMode.biWeekly;
        break;
      case ResizableMonthViewMode.biWeekly:
        next = ResizableMonthViewMode.monthly;
        break;
      case ResizableMonthViewMode.monthly:
        next = ResizableMonthViewMode.monthlyScrollable;
        break;
      case ResizableMonthViewMode.monthlyScrollable:
        next = null; // already at the bottom
        break;
    }
    if (next == null || !mounted) return;
    setState(() => _applyModeChange(next!));
    _builders.onModeChanged?.call(next);
  }

  /// Applies a mode transition by reconciling the [PageView] state and the
  /// week-strip anchor.
  ///
  /// **Full → (Compact | Minimal)**:
  ///   The strip is anchored to the week containing the currently selected
  ///   date (or, if none, the current month's first day). A post-frame
  ///   callback is *not* needed because the [PageView] is being replaced
  ///   by a static widget.
  ///
  /// **(Compact | Minimal) → Full**:
  ///   The [_currentDate] is set to the month of the current strip, and a
  ///   post-frame callback jumps the [PageController] to that month's page
  ///   — the jump must be deferred because the [PageView] has not been
  ///   laid out yet at the point [setState] runs.
  ///
  /// In both directions the representative-date heuristic is used to
  /// decide whether the header month label has changed, firing
  /// [onPageChange] if so.
  void _applyModeChange(ResizableMonthViewMode newMode) {
    _currentMode = newMode;

    if (newMode == ResizableMonthViewMode.monthly ||
        newMode == ResizableMonthViewMode.monthlyScrollable) {
      // When returning to Full, jump the PageView to the month of the
      // currently visible week strip.
      _currentDate = DateTime(
        _currentWeekStart.year,
        _currentWeekStart.month,
      );
      _regulateCurrentDate();
      // Dispose the week-strip controller — it is no longer needed.
      _weekPageController?.dispose();
      _weekPageController = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pageController.jumpToPage(_currentIndex);
      });
    } else {
      // Switching from Full or from the other strip mode: anchor the strip
      // to the week containing the selected date — but only if the selected
      // date is in the currently displayed month.  When the user has
      // navigated to a different month, we pick the 1st of that month as
      // the new selection so the strip stays on the visible month.
      DateTime anchor;
      if (_selectedDate != null &&
          _selectedDate!.month == _currentDate.month &&
          _selectedDate!.year == _currentDate.year) {
        anchor = _selectedDate!;
      } else {
        // Select the 1st of the currently displayed month (or today if
        // the displayed month is the current calendar month).
        final now = DateTime.now().withoutTime;
        if (now.month == _currentDate.month && now.year == _currentDate.year) {
          anchor = now;
        } else {
          anchor = DateTime(_currentDate.year, _currentDate.month);
        }
        _selectedDate = anchor;
      }
      _currentWeekStart = anchor.firstDayOfWeek(start: _style.startDay);

      final oldMonth = _currentDate.month;
      final oldYear = _currentDate.year;
      final representativeDate = _currentWeekStart.add(const Duration(days: 3));

      if (representativeDate.month != oldMonth ||
          representativeDate.year != oldYear) {
        _currentDate =
            DateTime(representativeDate.year, representativeDate.month);
        _regulateCurrentDate();
      }

      if (_currentDate.month != oldMonth || _currentDate.year != oldYear) {
        _builders.onPageChange?.call(_currentDate, _currentIndex);
      }

      // (Re-)initialise the week-strip PageController so it is ready when
      // the new strip mode's PageView is built in the next frame.
      _initWeekPageController();
    }
  }

  /// Returns the next mode in the cycle:
  /// full → compact → minimal → full.
  static ResizableMonthViewMode _nextMode(ResizableMonthViewMode current) {
    switch (current) {
      case ResizableMonthViewMode.monthly:
        return ResizableMonthViewMode.monthlyScrollable;
      case ResizableMonthViewMode.monthlyScrollable:
        return ResizableMonthViewMode.biWeekly;
      case ResizableMonthViewMode.biWeekly:
        return ResizableMonthViewMode.weekly;
      case ResizableMonthViewMode.weekly:
        return ResizableMonthViewMode.monthly;
    }
  }

  /// Recalculates layout dimensions from the available width.
  ///
  /// Cell width is derived by dividing the total width equally across
  /// columns (5 when weekends are hidden, 7 otherwise). Cell height is
  /// then determined by the configured [cellAspectRatio].
  void _updateDimensions() {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    _cellWidth = _width / _columnCount;
    _cellHeight = _cellWidth / _style.cellAspectRatio;
  }

  /// Initialises or refreshes the navigable date range and page count.
  ///
  /// Falls back to [CalendarConstants.epochDate] / [CalendarConstants.maxDate]
  /// when the user has not specified explicit bounds.
  void _setDateRange() {
    _minDate = (_style.minMonth ?? CalendarConstants.epochDate).withoutTime;
    _maxDate = (_style.maxMonth ?? CalendarConstants.maxDate).withoutTime;

    assert(
      _minDate.isBefore(_maxDate),
      'Minimum date should be less than maximum date.\n'
      'Provided minimum date: $_minDate, maximum date: $_maxDate',
    );

    _totalMonths = _maxDate.getMonthDifference(_minDate);
  }

  /// Clamps [_currentDate] to `[_minDate, _maxDate]` and recomputes
  /// [_currentIndex] so the [PageController] stays in sync.
  void _regulateCurrentDate() {
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }
    _currentIndex = _minDate.getMonthDifference(_currentDate) - 1;
  }

  /// Callback from the [PageView] when the visible page changes.
  ///
  /// Derives the new [_currentDate] from the page delta and fires
  /// [onPageChange] so external listeners (e.g. a header widget in a
  /// parent scaffold) stay synchronised.
  void _onPageChange(int value) {
    if (!mounted) return;
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + (value - _currentIndex),
      );
      _currentIndex = value;
    });
    _builders.onPageChange?.call(_currentDate, _currentIndex);
  }

  /// Handles a tap on a calendar day cell.
  ///
  /// When the widget is in **internally-managed selection mode**
  /// (`widget.selectedDate == null`), the tapped date is persisted in
  /// [_selectedDate] and the event-list panel updates automatically.
  /// When selection is **externally controlled**, the tap only forwards
  /// the event via [onCellTap] — the parent is responsible for updating
  /// [widget.selectedDate].
  void _handleCellTap(List<CalendarEventData<T>> events, DateTime date) {
    if (widget.selectedDate == null &&
        !_isSameDate(_selectedDate, date.withoutTime) &&
        mounted) {
      setState(() => _selectedDate = date.withoutTime);
    }
    _builders.onCellTap?.call(events, date);
  }

  /// Null-safe date comparison that ignores the time component.
  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a == b;
    return a.compareWithoutTime(b);
  }

  /// Lightweight rebuild trigger called when the [EventController]
  /// notifies that its event list has changed.
  void _reload() {
    if (mounted) setState(() {});
  }

  /// Schedules a single post-frame measurement of the header and weekday-row
  /// heights. If either has changed since the last measurement, calls
  /// [setState] so [_getFullGridHeight] recalculates with accurate values.
  ///
  /// Called at the start of every [_buildCalendarArea] invocation so that any
  /// layout change (e.g. font-size override, orientation change) is detected
  /// promptly. The guard on changed values prevents unnecessary rebuilds.
  void _scheduleMeasurement() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      double? newHeader;
      double? newWeekDay;

      final headerBox =
          _headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (headerBox != null && headerBox.hasSize) {
        newHeader = headerBox.size.height;
      }

      final weekDayBox =
          _weekDayRowKey.currentContext?.findRenderObject() as RenderBox?;
      if (weekDayBox != null && weekDayBox.hasSize) {
        newWeekDay = weekDayBox.size.height;
      }

      // Only rebuild when a measurement actually changed.
      final headerChanged =
          newHeader != null && newHeader != _measuredHeaderHeight;
      final weekDayChanged =
          newWeekDay != null && newWeekDay != _measuredWeekDayRowHeight;

      if (headerChanged || weekDayChanged) {
        setState(() {
          if (headerChanged) _measuredHeaderHeight = newHeader!;
          if (weekDayChanged) _measuredWeekDayRowHeight = newWeekDay!;
        });
      }
    });
  }

  // ── Builder assignment ─────────────────────────────────────────────

  /// Resolves builder callbacks, falling back to built-in implementations
  /// when the user has not supplied custom ones.
  void _assignBuilders() {
    _cellBuilder = _builders.cellBuilder ?? _defaultCellBuilder;
    _weekBuilder = _builders.weekDayBuilder ?? _defaultWeekDayBuilder;
  }

  // ── Default builder implementations ────────────────────────────────

  /// Default weekday-label builder (e.g. "Mon", "Tue").
  ///
  /// Uses theme-extension colours and the optional
  /// [weekDayStringBuilder] for localisation.
  Widget _defaultWeekDayBuilder(int index) {
    final themeColors = context.resizableMonthViewColors;
    return WeekDayTile(
      dayIndex: index,
      weekDayStringBuilder: _builders.weekDayStringBuilder,
      displayBorder: _style.showWeekTileBorder,
      borderColor: _theme.weekDayBorderColor ?? themeColors.weekDayBorderColor,
      backgroundColor:
          _theme.weekDayBackgroundColor ?? themeColors.weekDayTileColor,
      textStyle: _theme.weekDayTextStyle,
    );
  }

  /// Default cell builder used when no custom [CellBuilder] is provided.
  ///
  /// Rendering rules:
  /// * **Hidden out-of-month cells**: if [hideDaysNotInMonth] is `true` and
  ///   the cell does not belong to the displayed month, an empty coloured
  ///   box is returned immediately.
  /// * **Highlight cascade** (selected → today → normal): the circle
  ///   avatar colour and text colour are resolved in priority order so
  ///   that `selected` always wins over `today`.
  /// * **Event dots**: up to 4 small coloured dots are shown beneath the
  ///   date number, each matching the event's [CalendarEventData.color].
  Widget _defaultCellBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
    bool isInMonth,
    bool isSelected,
    bool hideDaysNotInMonth,
  ) {
    final themeColor = context.resizableMonthViewColors;
    final shouldHighlight = isSelected || isToday;

    // Resolve highlight colours with priority: selected > today > default.
    final highlightedTitleColor = isSelected
        ? _theme.selectedTitleColor
        : hideDaysNotInMonth
            ? _theme.cellsNotInMonthHighlightedTitleColor
            : _theme.cellsInMonthHighlightedTitleColor;

    final highlightColor = isSelected
        ? _theme.selectedHighlightColor
        : hideDaysNotInMonth
            ? themeColor.cellHighlightColor
            : _theme.cellsInMonthHighlightColor;

    final highlightRadius = isSelected
        ? _theme.selectedHighlightRadius
        : hideDaysNotInMonth
            ? _theme.cellsNotInMonthHighlightRadius
            : _theme.cellsInMonthHighlightRadius;

    // Early return: blank placeholder for out-of-month dates when hidden.
    if (hideDaysNotInMonth && !isInMonth) {
      return ColoredBox(
        color: themeColor.cellNotInMonthColor,
      );
    }

    final backgroundColor = isInMonth
        ? themeColor.cellInMonthColor
        : themeColor.cellNotInMonthColor;

    final cellTitleColor = isInMonth
        ? themeColor.cellTextColor
        : themeColor.cellTextColor.withAlpha(150);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 5),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor:
                shouldHighlight ? highlightColor : Colors.transparent,
            child: Text(
              _builders.dateStringBuilder?.call(date) ??
                  PackageStrings.localizeNumber(date.day),
              style: TextStyle(
                color: shouldHighlight ? highlightedTitleColor : cellTitleColor,
                fontSize: 12,
              ),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 4.0),
                alignment: Alignment.topCenter,
                child: Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  alignment: WrapAlignment.center,
                  children: events
                      .take(4) // Limit to 4 dots to prevent visual clutter.
                      .map((e) => CircleAvatar(
                            radius: 3.5,
                            backgroundColor: e.color,
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _scrollableCellBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
    bool isInMonth,
    bool isSelected,
    bool hideDaysNotInMonth,
  ) {
    final themeColor = context.resizableMonthViewColors;
    final shouldHighlight = isSelected || isToday;

    final highlightedTitleColor = isSelected
        ? _theme.selectedTitleColor
        : hideDaysNotInMonth
            ? _theme.cellsNotInMonthHighlightedTitleColor
            : _theme.cellsInMonthHighlightedTitleColor;

    final highlightColor = isSelected
        ? _theme.selectedHighlightColor
        : hideDaysNotInMonth
            ? themeColor.cellHighlightColor
            : _theme.cellsInMonthHighlightColor;

    final highlightRadius = isSelected
        ? _theme.selectedHighlightRadius
        : hideDaysNotInMonth
            ? _theme.cellsNotInMonthHighlightRadius
            : _theme.cellsInMonthHighlightRadius;

    if (hideDaysNotInMonth) {
      return FilledCell<T>(
        date: date,
        shouldHighlight: shouldHighlight,
        backgroundColor: isInMonth
            ? themeColor.cellInMonthColor
            : themeColor.cellNotInMonthColor,
        events: events,
        isInMonth: isInMonth,
        onTileTap: _builders.onEventTap,
        onTileDoubleTap: _builders.onEventDoubleTap,
        onTileLongTap: _builders.onEventLongTap,
        onTileTapDetails: _builders.onEventTapDetails,
        onTileDoubleTapDetails: _builders.onEventDoubleTapDetails,
        onTileLongTapDetails: _builders.onEventLongTapDetails,
        dateStringBuilder: _builders.dateStringBuilder,
        hideDaysNotInMonth: hideDaysNotInMonth,
        titleColor: themeColor.cellTextColor,
        highlightColor: highlightColor,
        tileColor: themeColor.cellHighlightColor,
        highlightRadius: highlightRadius,
        highlightedTitleColor: highlightedTitleColor,
      );
    }
    return FilledCell<T>(
      date: date,
      shouldHighlight: shouldHighlight,
      backgroundColor: isInMonth
          ? themeColor.cellInMonthColor
          : themeColor.cellNotInMonthColor,
      events: events,
      onTileTap: _builders.onEventTap,
      onTileLongTap: _builders.onEventLongTap,
      onTileTapDetails: _builders.onEventTapDetails,
      onTileDoubleTapDetails: _builders.onEventDoubleTapDetails,
      onTileLongTapDetails: _builders.onEventLongTapDetails,
      dateStringBuilder: _builders.dateStringBuilder,
      onTileDoubleTap: _builders.onEventDoubleTap,
      hideDaysNotInMonth: hideDaysNotInMonth,
      titleColor: isInMonth
          ? themeColor.cellTextColor
          : themeColor.cellTextColor.withAlpha(150),
      highlightedTitleColor: highlightedTitleColor,
      highlightRadius: highlightRadius,
      tileColor: themeColor.cellInMonthColor,
      highlightColor: highlightColor,
    );
  }

  /// Opens the platform date picker and navigates to the selected month
  /// or week, then selects the chosen date.
  ///
  /// In Full mode, the [PageView] jumps to the month containing the
  /// chosen date. In Compact / Minimal mode, the strip anchor is
  /// repositioned to the week containing the chosen date.
  ///
  /// In all modes, the picked date becomes the new [_selectedDate] and
  /// [onCellTap] is fired so that external listeners stay in sync.
  Future<void> _defaultTitleTap() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _displayDate,
      firstDate: _minDate,
      lastDate: _maxDate,
      locale: Locale(PackageStrings.selectedLocale),
    );
    if (pickedDate == null || !mounted) return;

    final normalised = pickedDate.withoutTime;

    if (_currentMode == ResizableMonthViewMode.monthly ||
        _currentMode == ResizableMonthViewMode.monthlyScrollable) {
      jumpToMonth(pickedDate);
    } else {
      // Re-anchor the strip to the week containing the picked date and
      // reset the virtual PageView to its midpoint so the user can navigate
      // freely in both directions from the new position.
      setState(() {
        _currentWeekStart = pickedDate.firstDayOfWeek(start: _style.startDay);
        _weekPageIndex = _weekPageMidpoint;
      });
      // Rebuild the week controller at the new anchor without animation.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _weekPageController?.jumpToPage(_weekPageMidpoint);
      });
    }

    // Update selection and notify listeners.
    if (widget.selectedDate == null) {
      setState(() => _selectedDate = normalised);
    }
    _builders.onCellTap?.call(
      controller.getEventsOnDay(normalised),
      normalised,
    );
  }
}
