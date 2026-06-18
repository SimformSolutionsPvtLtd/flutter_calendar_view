// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Collection of builder callbacks and interaction handlers used to
/// customise the appearance and behaviour of a [ResizableMonthView].
///
/// Mirrors [MonthViewBuilders] but adds resizable-specific callbacks:
/// * [eventListBuilder] — custom widget for the event-list area.
/// * [eventListItemBuilder] — custom per-event tile.
/// * [onModeChanged] — fired when the user switches display modes.
///
/// Note: [onHeaderTitleTap] and [headerBuilder] are mutually exclusive.
@immutable
class ResizableMonthViewBuilders<T extends Object?> {
  const ResizableMonthViewBuilders({
    this.cellBuilder,
    this.headerBuilder,
    this.headerStringBuilder,
    this.dateStringBuilder,
    this.weekDayStringBuilder,
    this.onPageChange,
    this.onCellTap,
    this.onCellDoubleTap,
    this.onEventTap,
    this.onEventLongTap,
    this.onEventDoubleTap,
    this.weekDayBuilder,
    this.onDateLongPress,
    this.onDateLongPressMoveUpdate,
    this.onHeaderTitleTap,
    this.onEventTapDetails,
    this.onEventLongTapDetails,
    this.onEventDoubleTapDetails,
    this.onHasReachedEnd,
    this.onHasReachedStart,
    // Resizable-specific
    this.eventListBuilder,
    this.eventListItemBuilder,
    this.onModeChanged,
    this.onEventDismissed,
  }) : assert(
          !(onHeaderTitleTap != null && headerBuilder != null),
          "can't use [onHeaderTitleTap] & [headerBuilder] simultaneously",
        );

  // ── Standard month-view callbacks (mirrored from MonthViewBuilders) ──

  /// Builds each day cell.
  final CellBuilder<T>? cellBuilder;

  /// Builds the entire header row.
  ///
  /// When provided, [onHeaderTitleTap] must be null.
  final DateWidgetBuilder? headerBuilder;

  /// Generates the date string shown in the header (e.g. for i18n).
  final StringProvider? headerStringBuilder;

  /// Generates the day-number string inside each cell (e.g. for i18n).
  final StringProvider? dateStringBuilder;

  /// Generates the weekday-label string (Mon, Tue … Sun) for i18n.
  final String Function(int)? weekDayStringBuilder;

  /// Called when the displayed month page changes.
  final CalendarPageChangeCallBack? onPageChange;

  /// Called when the user taps on a day cell.
  final CellTapCallback<T>? onCellTap;

  /// Called when the user double-taps on a day cell.
  final CellTapCallback<T>? onCellDoubleTap;

  /// Called when the user taps a single event tile.
  ///
  /// Only fires when [cellBuilder] is null (default cell is used).
  final TileTapCallback<T>? onEventTap;

  /// Called when the user long-presses a single event tile.
  ///
  /// Only fires when [cellBuilder] is null.
  final TileTapCallback<T>? onEventLongTap;

  /// Called when the user double-taps a single event tile.
  ///
  /// Only fires when [cellBuilder] is null.
  final TileTapCallback<T>? onEventDoubleTap;

  /// Builds the weekday-name row tiles (Mon, Tue …).
  final WeekDayBuilder? weekDayBuilder;

  /// Called when the user long-presses on the calendar.
  final DatePressCallback? onDateLongPress;

  /// Called when the user moves the pointer after a long-press on a cell.
  final DateLongPressMoveUpdateCallback? onDateLongPressMoveUpdate;

  /// Callback for tapping the header title (e.g. to open a date-picker).
  ///
  /// Mutually exclusive with [headerBuilder].
  final HeaderTitleCallback? onHeaderTitleTap;

  /// Tap callback with additional [TapUpDetails].
  final TileTapDetailsCallback<T>? onEventTapDetails;

  /// Long-press callback with additional [LongPressStartDetails].
  final TileLongTapDetailsCallback<T>? onEventLongTapDetails;

  /// Double-tap callback with additional [TapDownDetails].
  final TileDoubleTapDetailsCallback<T>? onEventDoubleTapDetails;

  /// Fired when the user drags the last page leftward (request next data).
  final CalendarPageChangeCallBack? onHasReachedEnd;

  /// Fired when the user drags the first page rightward (request prior data).
  final CalendarPageChangeCallBack? onHasReachedStart;

  // ── Resizable-specific callbacks ─────────────────────────────────────

  /// Builds the entire event-list area shown below the calendar grid.
  ///
  /// Receives the list of events for the currently selected date and the
  /// selected [DateTime]. Return `null` to fall back to the default list.
  final Widget? Function(List<CalendarEventData<T>> events, DateTime date)?
      eventListBuilder;

  /// Builds a single event tile inside the default event list.
  ///
  /// Only used when [eventListBuilder] is null.
  final Widget Function(CalendarEventData<T> event, DateTime date)?
      eventListItemBuilder;

  /// Called whenever the user taps the mode-toggle pill and the display
  /// mode changes.
  final void Function(ResizableMonthViewMode mode)? onModeChanged;

  /// Called when the user swipes an event tile in the list to dismiss it.
  ///
  /// The [direction] indicates whether the user swiped left or right.
  /// Use this to delete or archive the event.
  final void Function(
    CalendarEventData<T> event,
    DateTime date,
    DismissDirection direction,
  )? onEventDismissed;
}
