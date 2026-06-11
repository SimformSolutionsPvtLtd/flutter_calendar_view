import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Collection of builder callbacks and interaction handlers used to
/// customize the appearance and behavior of a [YearView].
@immutable
class YearViewBuilders<T extends Object?> {
  const YearViewBuilders({
    this.monthTileBuilder,
    this.miniMonthBuilder,
    this.headerBuilder,
    this.headerStringBuilder,
    this.monthStringBuilder,
    this.onMonthTap,
    this.onDateTap,
    this.onPageChange,
    this.onHeaderTitleTap,
    this.onHasReachedEnd,
    this.onHasReachedStart,
  }) : assert(!(onHeaderTitleTap != null && headerBuilder != null),
            "can't use [onHeaderTitleTap] & [headerBuilder] simultaneously");

  /// A function that returns a [Widget] that determines the appearance of
  /// each month tile in the year view (Title Grid Mode).
  final MonthTileBuilder? monthTileBuilder;

  /// A function that returns a [Widget] that determines the appearance of
  /// the mini month calendar in the year view (Mini Calendar Mode).
  final MiniMonthBuilder<T>? miniMonthBuilder;

  /// Builds year page title header.
  final DateWidgetBuilder? headerBuilder;

  /// This function will generate DateString in the calendar header.
  /// Useful for I18n.
  final StringProvider? headerStringBuilder;

  /// This function will generate the month string for month tiles.
  /// Useful for I18n.
  final StringProvider? monthStringBuilder;

  /// Called when user changes year page.
  final CalendarPageChangeCallBack? onPageChange;

  /// This function will be called when user taps on a month.
  final MonthTapCallback? onMonthTap;

  /// This function will be called when user taps on a date in mini calendar mode.
  final CellTapCallback<T>? onDateTap;

  /// Callback for the Header title tap.
  final HeaderTitleCallback? onHeaderTitleTap;

  /// This function will be called when the user drags
  /// the last page to the left, requesting a new page.
  final CalendarPageChangeCallBack? onHasReachedEnd;

  /// This function will be called when the user drags
  /// the first page to the right, requesting a new previous page.
  final CalendarPageChangeCallBack? onHasReachedStart;
}
