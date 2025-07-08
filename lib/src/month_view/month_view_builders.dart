import 'package:flutter/material.dart';

import '../../calendar_view.dart';

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

  /// This function will generate WeeDayString in weekday view.
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
}
