// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';

/// Theme settings for [ResizableMonthView].
///
/// Mirrors [MonthViewThemeSettings] exactly so that the two views can be
/// independently themed. No fields are shared by reference.
@immutable
class ResizableMonthViewThemeSettings {
  /// Creates default theme settings for [ResizableMonthView].
  const ResizableMonthViewThemeSettings({
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
    this.selectedHighlightColor = Colors.blue,
    this.selectedTitleColor = Constants.white,
    this.selectedHighlightRadius = 11,
  });

  /// Default border color for week-day header tiles.
  final Color? weekDayBorderColor;

  /// Default background color for week-day header tiles.
  final Color? weekDayBackgroundColor;

  /// Text style for week-day header labels.
  final TextStyle? weekDayTextStyle;

  /// Header style for the [ResizableMonthView] header row.
  final HeaderStyle? headerStyle;

  /// General text style for the view.
  final TextStyle? textStyle;

  /// Highlighted title color for cells **not** in the current month.
  final Color cellsNotInMonthHighlightedTitleColor;

  /// Highlight circle radius for cells **not** in the current month.
  final double cellsNotInMonthHighlightRadius;

  /// Highlighted title color for cells in the current month.
  final Color cellsInMonthHighlightedTitleColor;

  /// Highlight circle radius for cells in the current month.
  final double cellsInMonthHighlightRadius;

  /// Tile background color for cells in the current month.
  final Color cellsInMonthTileColor;

  /// Highlight circle color for cells in the current month (today).
  final Color cellsInMonthHighlightColor;

  /// Highlight circle color for the selected date.
  final Color selectedHighlightColor;

  /// Title (date number) color for the selected date.
  final Color selectedTitleColor;

  /// Highlight circle radius for the selected date.
  final double selectedHighlightRadius;

  /// Creates a copy with the given fields replaced.
  ResizableMonthViewThemeSettings copyWith({
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
    Color? selectedHighlightColor,
    Color? selectedTitleColor,
    double? selectedHighlightRadius,
  }) {
    return ResizableMonthViewThemeSettings(
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
      selectedHighlightColor:
          selectedHighlightColor ?? this.selectedHighlightColor,
      selectedTitleColor: selectedTitleColor ?? this.selectedTitleColor,
      selectedHighlightRadius:
          selectedHighlightRadius ?? this.selectedHighlightRadius,
    );
  }

  /// Merges this with [other], preferring non-null values from [other].
  ResizableMonthViewThemeSettings merge(
      ResizableMonthViewThemeSettings? other) {
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
      selectedHighlightColor: other.selectedHighlightColor,
      selectedTitleColor: other.selectedTitleColor,
      selectedHighlightRadius: other.selectedHighlightRadius,
    );
  }
}
