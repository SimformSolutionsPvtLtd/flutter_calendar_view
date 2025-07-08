import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Collection of builder callbacks and interaction handlers used to
/// customize the appearance and behavior of a [MonthView].
///
/// A [MonthViewBuilders] instance is typically passed to [MonthView] via
/// its `builders` parameter. It allows you to:
///
/// * Override how each day cell is rendered using [cellBuilder].
/// * Customize the month header using [headerBuilder] or by providing
///   only label builders such as [headerStringBuilder],
///   [dateStringBuilder], and [weekDayStringBuilder].
/// * React to page changes using [onPageChange].
/// * Handle taps and gestures on dates and events using callbacks such as
///   [onCellTap], [onDateLongPress], [onEventTap], [onEventLongTap],
///   [onEventDoubleTap] and their corresponding `*Details` variants.
///
/// Note that [onHeaderTitleTap] and [headerBuilder] are mutually
/// exclusive; providing both at the same time is not allowed and will
/// trigger an assertion in debug mode.
@immutable
class MonthViewBuilders<T extends Object?> {
  const MonthViewBuilders({
    this.cellBuilder,
    this.headerBuilder,
    this.headerStringBuilder,
    this.dateStringBuilder,
    this.weekDayStringBuilder,
    this.onPageChange,
    this.onCellTap,
    this.onEventTap,
    this.onEventLongTap,
    this.onEventDoubleTap,
    this.weekDayBuilder,
    this.onDateLongPress,
    this.onHeaderTitleTap,
    this.onEventTapDetails,
    this.onEventLongTapDetails,
    this.onEventDoubleTapDetails,
  }) : assert(!(onHeaderTitleTap != null && headerBuilder != null),
            "can't use [onHeaderTitleTap] & [headerBuilder] simultaneously");

  /// A function that returns a [Widget] that determines appearance of
  /// each cell in month calendar.
  final CellBuilder<T>? cellBuilder;

  /// Builds month page title.
  ///
  /// If there are some configurations that is not directly available
  /// in [MonthView], override this to create your custom header or reuse,
  /// [CalendarPageHeader] | [DayPageHeader] | [MonthPageHeader] |
  /// [WeekPageHeader] widgets provided by this package with your custom
  /// configurations.
  ///
  final DateWidgetBuilder? headerBuilder;

  /// This function will generate DateString in the calendar header.
  /// Useful for I18n
  final StringProvider? headerStringBuilder;

  /// This function will generate DayString in month view cell.
  /// Useful for I18n
  final StringProvider? dateStringBuilder;

  /// This function will generate WeekDayString in weekday view.
  /// Useful for I18n
  /// Ex : ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
  final String Function(int)? weekDayStringBuilder;

  /// Called when user changes month.
  final CalendarPageChangeCallBack? onPageChange;

  /// This function will be called when user taps on month view cell.
  final CellTapCallback<T>? onCellTap;

  /// This function will be called when user will tap on a single event
  /// tile inside a cell.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileTapCallback<T>? onEventTap;

  /// This function will be called when user will long press on a single event
  /// tile inside a cell.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileTapCallback<T>? onEventLongTap;

  /// This method will be called when user double taps on event tile.
  final TileTapCallback<T>? onEventDoubleTap;

  /// Builds the name of the weeks.
  ///
  /// Used default week builder if null.
  ///
  /// Here day will range from 0 to 6 starting from Monday to Sunday.
  final WeekDayBuilder? weekDayBuilder;

  /// This method will be called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Callback for the Header title
  final HeaderTitleCallback? onHeaderTitleTap;

  /// This function will be called when user will tap on a single event
  /// tile inside a cell and gives additional details offset.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileTapDetailsCallback<T>? onEventTapDetails;

  /// This function will be called when user will long press on a single event
  /// tile inside a cell and gives additional details offset.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileLongTapDetailsCallback<T>? onEventLongTapDetails;

  /// This function will be called when user will double tap on a single event
  /// tile inside a cell and gives additional details offset.
  ///
  /// This function will only work if [cellBuilder] is null.
  final TileDoubleTapDetailsCallback<T>? onEventDoubleTapDetails;
}
