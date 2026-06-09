import 'package:flutter/material.dart';

import 'calendar_view_colors.dart';

class MonthViewThemeData extends ThemeExtension<MonthViewThemeData> {
  /// Define custom colors
  MonthViewThemeData({
    required this.cellInMonthColor,
    required this.cellNotInMonthColor,
    required this.cellTextColor,
    required this.cellBorderColor,
    required this.weekDayTileColor,
    required this.weekDayTextColor,
    required this.weekDayBorderColor,
    required this.headerIconColor,
    required this.headerTextColor,
    required this.headerBackgroundColor,
    required this.cellHighlightColor,
  });

  // Cell properties
  final Color cellInMonthColor;
  final Color cellNotInMonthColor;
  final Color cellTextColor;
  final Color cellBorderColor;

  // Weekday tile properties
  final Color weekDayTileColor;
  final Color weekDayTextColor;
  final Color weekDayBorderColor;

  // Page header properties
  final Color headerIconColor;
  final Color headerTextColor;
  final Color headerBackgroundColor;

  final Color cellHighlightColor;

  // final Color

  /// Get pre-defined colors for light theme
  MonthViewThemeData.light()
      : cellInMonthColor = CalendarViewColors.light.surfaceContainerLowest,
        cellNotInMonthColor = CalendarViewColors.light.surfaceContainerLow,
        cellTextColor = CalendarViewColors.light.onSurface,
        cellBorderColor = CalendarViewColors.light.surfaceContainerHigh,
        weekDayTileColor = CalendarViewColors.light.surfaceContainerHigh,
        weekDayTextColor = CalendarViewColors.light.onSurface,
        weekDayBorderColor = CalendarViewColors.light.outlineVariant,
        headerIconColor = CalendarViewColors.light.onPrimary,
        headerTextColor = CalendarViewColors.light.onPrimary,
        headerBackgroundColor = CalendarViewColors.light.primary,
        cellHighlightColor = CalendarViewColors.light.primary;

  /// Get pre-defined colors for dark theme
  MonthViewThemeData.dark()
      : cellInMonthColor = CalendarViewColors.dark.surfaceContainerLowest,
        cellNotInMonthColor = CalendarViewColors.dark.surfaceContainerLow,
        cellTextColor = CalendarViewColors.dark.onSurface,
        cellBorderColor = CalendarViewColors.dark.surfaceContainerHigh,
        weekDayTileColor = CalendarViewColors.dark.surfaceContainerHigh,
        weekDayTextColor = CalendarViewColors.dark.onSurface,
        weekDayBorderColor = CalendarViewColors.dark.outlineVariant,
        headerIconColor = CalendarViewColors.dark.onPrimary,
        headerTextColor = CalendarViewColors.dark.onPrimary,
        headerBackgroundColor = CalendarViewColors.dark.primary,
        cellHighlightColor = CalendarViewColors.dark.primary;

  @override
  ThemeExtension<MonthViewThemeData> copyWith({
    Color? cellInMonthColor,
    Color? cellNotInMonthColor,
    Color? cellTextColor,
    Color? cellBorderColor,
    Color? weekDayTileColor,
    Color? weekDayTextColor,
    Color? weekDayBorderColor,
    Color? headerIconColor,
    Color? headerTextColor,
    Color? headerBackgroundColor,
    Color? cellHighlightColor,
  }) {
    return MonthViewThemeData(
      cellInMonthColor: cellInMonthColor ?? this.cellInMonthColor,
      cellNotInMonthColor: cellNotInMonthColor ?? this.cellNotInMonthColor,
      cellTextColor: cellTextColor ?? this.cellTextColor,
      cellBorderColor: cellBorderColor ?? this.cellBorderColor,
      weekDayTileColor: weekDayTileColor ?? this.weekDayTileColor,
      weekDayTextColor: weekDayTextColor ?? this.weekDayTextColor,
      weekDayBorderColor: weekDayBorderColor ?? this.weekDayBorderColor,
      headerIconColor: headerIconColor ?? this.headerIconColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      cellHighlightColor: cellHighlightColor ?? this.cellHighlightColor,
    );
  }

  @override
  ThemeExtension<MonthViewThemeData> lerp(
    covariant ThemeExtension<MonthViewThemeData>? other,
    double t,
  ) {
    if (other is! MonthViewThemeData) {
      return this;
    }
    return MonthViewThemeData(
      cellInMonthColor:
          Color.lerp(cellInMonthColor, other.cellInMonthColor, t) ??
              cellInMonthColor,
      cellNotInMonthColor:
          Color.lerp(cellNotInMonthColor, other.cellNotInMonthColor, t) ??
              cellNotInMonthColor,
      cellTextColor:
          Color.lerp(cellTextColor, other.cellTextColor, t) ?? cellTextColor,
      cellBorderColor: Color.lerp(cellBorderColor, other.cellBorderColor, t) ??
          cellBorderColor,
      weekDayTileColor:
          Color.lerp(weekDayTileColor, other.weekDayTileColor, t) ??
              weekDayTileColor,
      weekDayTextColor:
          Color.lerp(weekDayTextColor, other.weekDayTextColor, t) ??
              weekDayTextColor,
      weekDayBorderColor:
          Color.lerp(weekDayBorderColor, other.weekDayBorderColor, t) ??
              weekDayBorderColor,
      headerIconColor: Color.lerp(headerIconColor, other.headerIconColor, t) ??
          headerIconColor,
      headerTextColor: Color.lerp(headerTextColor, other.headerTextColor, t) ??
          headerTextColor,
      headerBackgroundColor:
          Color.lerp(headerBackgroundColor, other.headerBackgroundColor, t) ??
              headerBackgroundColor,
      cellHighlightColor:
          Color.lerp(cellHighlightColor, other.cellHighlightColor, t) ??
              cellHighlightColor,
    );
  }

  /// Merges another `MonthViewThemeData` into this one.
  ThemeExtension<MonthViewThemeData> merge(MonthViewThemeData? other) {
    if (other == null) return this;

    return copyWith(
      cellInMonthColor: other.cellInMonthColor,
      cellNotInMonthColor: other.cellNotInMonthColor,
      cellTextColor: other.cellTextColor,
      cellBorderColor: other.cellBorderColor,
      weekDayTileColor: other.weekDayTileColor,
      weekDayTextColor: other.weekDayTextColor,
      weekDayBorderColor: other.weekDayBorderColor,
      headerIconColor: other.headerIconColor,
      headerTextColor: other.headerTextColor,
      headerBackgroundColor: other.headerBackgroundColor,
      cellHighlightColor: other.cellHighlightColor,
    );
  }
}
