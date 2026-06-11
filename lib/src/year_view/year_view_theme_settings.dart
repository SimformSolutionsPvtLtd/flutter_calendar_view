import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Year view theme settings.
@immutable
class YearViewThemeSettings {
  /// Creates a default year view theme settings.
  const YearViewThemeSettings({
    this.headerStyle,
    this.monthTitleStyle,
    this.monthTitleBackgroundColor,
    this.currentMonthHighlightColor,
    this.currentMonthHighlightRadius = 8.0,
    this.currentDateHighlightColor = Colors.blue,
    this.currentDateHighlightRadius = 11.0,
    this.gridBorderColor,
    this.gridBorderSize = 1.0,
  });

  /// Default header style for year view.
  final HeaderStyle? headerStyle;

  /// Text style for month titles in the grid.
  final TextStyle? monthTitleStyle;

  /// Background color for month title tiles.
  final Color? monthTitleBackgroundColor;

  /// Highlight color for the current month in title grid mode.
  final Color? currentMonthHighlightColor;

  /// Highlight radius for the current month in title grid mode.
  final double currentMonthHighlightRadius;

  /// Highlight color for the current date in mini calendar mode.
  final Color currentDateHighlightColor;

  /// Highlight radius for the current date in mini calendar mode.
  final double currentDateHighlightRadius;

  /// Border color for the grid.
  final Color? gridBorderColor;

  /// Border size for the grid.
  final double gridBorderSize;

  /// Creates a copy of this theme settings with the given fields replaced.
  YearViewThemeSettings copyWith({
    HeaderStyle? headerStyle,
    TextStyle? monthTitleStyle,
    Color? monthTitleBackgroundColor,
    Color? currentMonthHighlightColor,
    double? currentMonthHighlightRadius,
    Color? currentDateHighlightColor,
    double? currentDateHighlightRadius,
    Color? gridBorderColor,
    double? gridBorderSize,
  }) {
    return YearViewThemeSettings(
      headerStyle: headerStyle ?? this.headerStyle,
      monthTitleStyle: monthTitleStyle ?? this.monthTitleStyle,
      monthTitleBackgroundColor:
          monthTitleBackgroundColor ?? this.monthTitleBackgroundColor,
      currentMonthHighlightColor:
          currentMonthHighlightColor ?? this.currentMonthHighlightColor,
      currentMonthHighlightRadius:
          currentMonthHighlightRadius ?? this.currentMonthHighlightRadius,
      currentDateHighlightColor:
          currentDateHighlightColor ?? this.currentDateHighlightColor,
      currentDateHighlightRadius:
          currentDateHighlightRadius ?? this.currentDateHighlightRadius,
      gridBorderColor: gridBorderColor ?? this.gridBorderColor,
      gridBorderSize: gridBorderSize ?? this.gridBorderSize,
    );
  }

  /// Merges this theme settings with another, preferring values from [other].
  YearViewThemeSettings merge(YearViewThemeSettings? other) {
    if (other == null) return this;
    return copyWith(
      headerStyle: other.headerStyle,
      monthTitleStyle: other.monthTitleStyle,
      monthTitleBackgroundColor: other.monthTitleBackgroundColor,
      currentMonthHighlightColor: other.currentMonthHighlightColor,
      currentMonthHighlightRadius: other.currentMonthHighlightRadius,
      currentDateHighlightColor: other.currentDateHighlightColor,
      currentDateHighlightRadius: other.currentDateHighlightRadius,
      gridBorderColor: other.gridBorderColor,
      gridBorderSize: other.gridBorderSize,
    );
  }
}
