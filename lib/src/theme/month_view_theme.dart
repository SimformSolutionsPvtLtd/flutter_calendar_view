import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class MonthViewTheme extends ThemeExtension<MonthViewTheme> {
  /// Define custom colors
  MonthViewTheme({
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

  /// Get pre-defined colors for light theme
  MonthViewTheme.light()
      : cellInMonthColor = LightAppColors.surfaceContainerLowest,
        cellNotInMonthColor = LightAppColors.surfaceContainerLow,
        cellTextColor = LightAppColors.onSurface,
        cellBorderColor = LightAppColors.surfaceContainerHigh,
        weekDayTileColor = LightAppColors.surfaceContainerHigh,
        weekDayTextColor = LightAppColors.onSurface,
        weekDayBorderColor = LightAppColors.outlineVariant,
        headerIconColor = LightAppColors.onPrimary,
        headerTextColor = LightAppColors.onPrimary,
        headerBackgroundColor = LightAppColors.primary;

  /// Get pre-defined colors for dark theme
  MonthViewTheme.dark()
      : cellInMonthColor = DarkAppColors.surfaceContainerLowest,
        cellNotInMonthColor = DarkAppColors.surfaceContainerLow,
        cellTextColor = DarkAppColors.onSurface,
        cellBorderColor = DarkAppColors.surfaceContainerHigh,
        weekDayTileColor = DarkAppColors.surfaceContainerHigh,
        weekDayTextColor = DarkAppColors.onSurface,
        weekDayBorderColor = DarkAppColors.outlineVariant,
        headerIconColor = DarkAppColors.onPrimary,
        headerTextColor = DarkAppColors.onPrimary,
        headerBackgroundColor = DarkAppColors.primary;

  @override
  ThemeExtension<MonthViewTheme> copyWith({
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
  }) {
    return MonthViewTheme(
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
    );
  }

  @override
  ThemeExtension<MonthViewTheme> lerp(
    covariant ThemeExtension<MonthViewTheme>? other,
    double t,
  ) {
    if (other is! MonthViewTheme) {
      return this;
    }
    return MonthViewTheme(
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
    );
  }
}
