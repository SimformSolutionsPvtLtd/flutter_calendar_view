// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';

/// Internal grid widget for [ResizableMonthView].
///
/// Renders the weekday-name row (optionally) and the day-cell grid for a
/// given set of [dates]. The caller controls which dates are supplied
/// depending on the active [ResizableMonthViewMode]:
///
/// * **Full** – all dates returned by [DateTime.datesOfMonths].
/// * **Compact** – 14 dates (two consecutive weeks).
/// * **Minimal** – 7 dates (one week).
///
/// When [showWeekDayRow] is `false` the weekday-label row is skipped
/// (because the parent already renders it once above the scrollable area).
class ResizableMonthPage<T extends Object?> extends StatefulWidget {
  const ResizableMonthPage({
    Key? key,
    required this.dates,
    required this.monthDate,
    required this.controller,
    required this.cellBuilder,
    required this.weekDayBuilder,
    required this.selectedDate,
    required this.style,
    required this.themeSettings,
    required this.builders,
    required this.onCellTap,
    required this.width,
    required this.cellWidth,
    required this.cellHeight,
    this.showWeekDayRow = true,
  }) : super(key: key);

  /// The date cells to render. Length drives the grid row count.
  final List<DateTime> dates;

  /// The reference month used to determine if a cell is "in month".
  final DateTime monthDate;

  /// Event controller.
  final EventController<T> controller;

  /// Cell builder (custom or default).
  final CellBuilder<T> cellBuilder;

  /// Week-day label builder.
  final WeekDayBuilder weekDayBuilder;

  /// Currently selected date (may be null).
  final DateTime? selectedDate;

  /// Style config.
  final ResizableMonthViewStyle style;

  /// Theme settings.
  final ResizableMonthViewThemeSettings themeSettings;

  /// Builders/callbacks.
  final ResizableMonthViewBuilders<T> builders;

  /// Tap handler wired from the parent state.
  final CellTapCallback<T>? onCellTap;

  /// Total widget width.
  final double width;

  /// Width of a single cell column.
  final double cellWidth;

  /// Height of a single cell row.
  final double cellHeight;

  /// Whether to render the weekday-name header row inside this widget.
  ///
  /// Set to `false` when the parent renders the header row once above the
  /// scrollable/paged area to avoid double rendering and height overflow.
  final bool showWeekDayRow;

  @override
  State<ResizableMonthPage<T>> createState() => _ResizableMonthPageState<T>();
}

/// State for [ResizableMonthPage].
///
/// Manages the long-press gesture pipeline (start → move → cancel) that
/// drives multi-date selection, and builds the cell grid + optional
/// weekday-label row.
class _ResizableMonthPageState<T extends Object?>
    extends State<ResizableMonthPage<T>> {
  /// The last date reported by the long-press gesture, used to de-duplicate
  /// callbacks when the finger stays over the same cell.
  DateTime? _lastReportedDate;

  /// Whether a long-press sequence is currently active. Guards move-update
  /// callbacks from firing after the gesture has been cancelled.
  bool _isLongPressActive = false;

  int get _columnCount => widget.style.showWeekends ? 7 : 5;

  @override
  void dispose() {
    _cancelLongPress();
    super.dispose();
  }

  /// Builds the day-cell grid, optionally preceded by a weekday-label row.
  ///
  /// **Grid construction**:
  /// A [GridView.builder] with non-scrollable physics and a fixed
  /// cross-axis count is used so that the grid always matches the exact
  /// height pre-computed by the parent ([widget.cellHeight] × row count).
  ///
  /// **Event resolution per cell**:
  /// When [style.hideDaysNotInMonth] is `true` and the cell date falls
  /// outside [widget.monthDate]'s month, an empty event list is used so
  /// that event dots are suppressed for placeholder cells.
  ///
  /// **Long-press wrapping**:
  /// The grid is wrapped in a [GestureDetector] only when at least one
  /// long-press callback is registered, avoiding unnecessary hit-testing
  /// overhead in the common case.
  @override
  Widget build(BuildContext context) {
    final themeColors = context.resizableMonthViewColors;

    // ── Cell grid ────────────────────────────────────────────────────
    final rowCount = (widget.dates.length / _columnCount).ceil();
    final gridHeight = widget.cellHeight * rowCount;

    final grid = SizedBox(
      width: widget.width,
      height: gridHeight,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columnCount,
          childAspectRatio: widget.style.cellAspectRatio,
        ),
        itemCount: widget.dates.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final date = widget.dates[index];
          final events = widget.style.hideDaysNotInMonth &&
                  date.month != widget.monthDate.month
              ? <CalendarEventData<T>>[]
              : widget.controller.getEventsOnDay(date);
          final isSelected =
              widget.selectedDate?.compareWithoutTime(date) ?? false;
          final isInMonth = date.month == widget.monthDate.month;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onCellTap?.call(events, date),
            onDoubleTap: widget.builders.onCellDoubleTap != null
                ? () => widget.builders.onCellDoubleTap!.call(events, date)
                : null,
            child: Container(
              decoration: BoxDecoration(
                border: widget.style.showBorder
                    ? Border.all(
                        color: widget.style.borderColor ??
                            themeColors.cellBorderColor,
                        width: widget.style.borderSize,
                      )
                    : null,
              ),
              child: widget.cellBuilder(
                date,
                events,
                date.compareWithoutTime(DateTime.now()),
                isInMonth,
                isSelected,
                widget.style.hideDaysNotInMonth,
              ),
            ),
          );
        },
      ),
    );

    // ── Weekday header row (optional) ─────────────────────────────────
    // Only built when the parent has not already placed it above the
    // scrollable area (showWeekDayRow == true).
    if (!widget.showWeekDayRow) {
      // Grid-only: the parent provided exact height for cells, no header.
      final topAlignedGrid = Align(alignment: Alignment.topCenter, child: grid);

      if (!_hasLongPressCallbacks) return topAlignedGrid;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPressStart: (d) => _onLongPressStart(d, rowCount),
        onLongPressMoveUpdate: (d) => _onLongPressMoveUpdate(d, rowCount),
        onLongPressEnd: (_) => _cancelLongPress(),
        onLongPressCancel: _cancelLongPress,
        child: topAlignedGrid,
      );
    }

    final weekDayRow = SizedBox(
      width: widget.width,
      child: Row(
        children: List.generate(
          _columnCount,
          (i) => Expanded(
            child: SizedBox(
              width: widget.cellWidth,
              child: widget.weekDayBuilder(
                widget.dates.isNotEmpty ? widget.dates[i].weekday - 1 : i,
              ),
            ),
          ),
        ),
      ),
    );

    if (!_hasLongPressCallbacks) return Column(children: [weekDayRow, grid]);

    return Column(
      children: [
        weekDayRow,
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPressStart: (d) => _onLongPressStart(d, rowCount),
          onLongPressMoveUpdate: (d) => _onLongPressMoveUpdate(d, rowCount),
          onLongPressEnd: (_) => _cancelLongPress(),
          onLongPressCancel: _cancelLongPress,
          child: grid,
        ),
      ],
    );
  }

  /// `true` when at least one long-press callback is registered,
  /// signalling that the grid should be wrapped in a [GestureDetector].
  bool get _hasLongPressCallbacks =>
      widget.builders.onDateLongPress != null ||
      widget.builders.onDateLongPressMoveUpdate != null;

  /// Begins a long-press sequence: resets tracking state and reports the
  /// initial cell under the finger.
  void _onLongPressStart(LongPressStartDetails d, int rowCount) {
    _isLongPressActive = true;
    _lastReportedDate = null;
    _reportDate(d.localPosition, d.globalPosition, rowCount, false, null);
  }

  /// Continues a long-press sequence: reports each *new* cell the finger
  /// moves over, de-duplicating calls when the finger stays on the same cell.
  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails d, int rowCount) {
    if (!_isLongPressActive) return;
    _reportDate(d.localPosition, d.globalPosition, rowCount, true, d);
  }

  /// Core date-reporting logic shared by long-press start and move.
  ///
  /// Converts the pointer's [local] position to a grid cell date via
  /// [_dateFromPosition]. If the resolved date is `null` (out of bounds)
  /// or identical to [_lastReportedDate], the callback is skipped.
  ///
  /// * On initial press ([isMoveUpdate] == `false`): fires
  ///   [onDateLongPress].
  /// * On drag ([isMoveUpdate] == `true`): fires
  ///   [onDateLongPressMoveUpdate] with the original [moveDetails].
  void _reportDate(
    Offset local,
    Offset global,
    int rowCount,
    bool isMoveUpdate,
    LongPressMoveUpdateDetails? moveDetails,
  ) {
    final date = _dateFromPosition(local, rowCount);
    if (date == null || date == _lastReportedDate) return;

    if (!isMoveUpdate) {
      widget.builders.onDateLongPress?.call(date);
    } else if (widget.builders.onDateLongPressMoveUpdate != null) {
      widget.builders.onDateLongPressMoveUpdate!(
        date,
        moveDetails ??
            LongPressMoveUpdateDetails(
              globalPosition: global,
              localPosition: local,
              offsetFromOrigin: Offset.zero,
              localOffsetFromOrigin: Offset.zero,
            ),
      );
    }
    _lastReportedDate = date;
  }

  /// Converts a local pixel position within the grid into the
  /// corresponding [DateTime] from [widget.dates].
  ///
  /// Returns `null` when the position falls outside the grid bounds or
  /// maps to an index beyond the dates list (possible for partially-filled
  /// last rows).
  DateTime? _dateFromPosition(Offset local, int rowCount) {
    final size = context.size;
    if (size == null || size.width <= 0 || size.height <= 0) return null;
    if (local.dx < 0 ||
        local.dy < 0 ||
        local.dx >= size.width ||
        local.dy >= size.height) {
      return null;
    }

    final col = (local.dx / (size.width / _columnCount)).floor();
    final row = (local.dy / (size.height / rowCount)).floor();
    final index = row * _columnCount + col;
    if (index < 0 || index >= widget.dates.length) return null;
    return widget.dates[index];
  }

  /// Resets long-press tracking state. Called on gesture end and cancel
  /// to ensure stale state does not leak into the next gesture.
  void _cancelLongPress() {
    _lastReportedDate = null;
    _isLongPressActive = false;
  }
}
