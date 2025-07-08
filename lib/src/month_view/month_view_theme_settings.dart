import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';

@immutable

/// Month view theme settings.
class MonthViewThemeSettings {
  /// Creates a default month view theme settings.
  const MonthViewThemeSettings({
    this.weekDayBorderColor,
    this.weekDayBackgroundColor,
    this.weekDayTextStyle,
    this.headerStyle,
    this.textStyle,
    this.cellsNotInMonthHighlightedTitleColor = Constants.white,
    this.cellsNotInMonthHighlightRadius = 11,
    this.cellsInMonthHighlightedTitleColor = Constants.white,
    this.cellsInMonthHighlightRadius = 11,
    this.cellsInMonthTileColor = Colors.blue,
    this.cellsInMonthHighlightColor = Colors.blue,
  });

  /// Default border color for week day cells.
  final Color? weekDayBorderColor;

  /// Default background color for week day cells.
  final Color? weekDayBackgroundColor;

  /// Default text style for week day cells.
  final TextStyle? weekDayTextStyle;

  /// Default header style for month view.
  final HeaderStyle? headerStyle;

  /// Default text style for month view.
  final TextStyle? textStyle;

  /// Highlighted title color for cells not in the current month.
  final Color cellsNotInMonthHighlightedTitleColor;

  /// Highlight radius for cells not in the current month.
  final double cellsNotInMonthHighlightRadius;

  /// Highlighted title color for cells in the current month.
  final Color cellsInMonthHighlightedTitleColor;

  /// Highlight radius for cells in the current month.
  final double cellsInMonthHighlightRadius;

  /// Tile color for cells in the current month.
  final Color cellsInMonthTileColor;

  /// Highlight color for cells in the current month.
  final Color cellsInMonthHighlightColor;

  /// Creates a copy of this theme settings with the given fields replaced.
  MonthViewThemeSettings copyWith({
    Color? weekDayBorderColor,
    Color? weekDayBackgroundColor,
    TextStyle? weekDayTextStyle,
    HeaderStyle? headerStyle,
    TextStyle? textStyle,
    Color? cellsNotInMonthHighlightedTitleColor,
    double? cellsNotInMonthHighlightRadius,
    Color? cellsInMonthHighlightedTitleColor,
    double? cellsInMonthHighlightRadius,
    Color? cellsInMonthTileColor,
    Color? cellsInMonthHighlightColor,
  }) {
    return MonthViewThemeSettings(
      weekDayBorderColor: weekDayBorderColor ?? this.weekDayBorderColor,
      weekDayBackgroundColor:
          weekDayBackgroundColor ?? this.weekDayBackgroundColor,
      weekDayTextStyle: weekDayTextStyle ?? this.weekDayTextStyle,
      headerStyle: headerStyle ?? this.headerStyle,
      textStyle: textStyle ?? this.textStyle,
      cellsNotInMonthHighlightedTitleColor:
          cellsNotInMonthHighlightedTitleColor ??
              this.cellsNotInMonthHighlightedTitleColor,
      cellsNotInMonthHighlightRadius:
          cellsNotInMonthHighlightRadius ?? this.cellsNotInMonthHighlightRadius,
      cellsInMonthHighlightedTitleColor: cellsInMonthHighlightedTitleColor ??
          this.cellsInMonthHighlightedTitleColor,
      cellsInMonthHighlightRadius:
          cellsInMonthHighlightRadius ?? this.cellsInMonthHighlightRadius,
      cellsInMonthTileColor:
          cellsInMonthTileColor ?? this.cellsInMonthTileColor,
      cellsInMonthHighlightColor:
          cellsInMonthHighlightColor ?? this.cellsInMonthHighlightColor,
    );
  }

  /// Merges this theme settings with another, preferring values from [other].
  MonthViewThemeSettings merge(MonthViewThemeSettings? other) {
    if (other == null) return this;
    return copyWith(
      weekDayBorderColor: other.weekDayBorderColor,
      weekDayBackgroundColor: other.weekDayBackgroundColor,
      weekDayTextStyle: other.weekDayTextStyle,
      headerStyle: other.headerStyle,
      textStyle: other.textStyle,
      cellsNotInMonthHighlightedTitleColor:
          other.cellsNotInMonthHighlightedTitleColor,
      cellsNotInMonthHighlightRadius: other.cellsNotInMonthHighlightRadius,
      cellsInMonthHighlightedTitleColor:
          other.cellsInMonthHighlightedTitleColor,
      cellsInMonthHighlightRadius: other.cellsInMonthHighlightRadius,
      cellsInMonthTileColor: other.cellsInMonthTileColor,
      cellsInMonthHighlightColor: other.cellsInMonthHighlightColor,
    );
  }
}
