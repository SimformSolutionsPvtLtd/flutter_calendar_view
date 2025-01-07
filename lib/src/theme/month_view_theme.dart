import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class MonthViewTheme extends ThemeExtension<MonthViewTheme> {
  MonthViewTheme({
    required this.cellInMonth,
    required this.cellNotInMonth,
    required this.cellText,
    required this.cellBorder,
    required this.weekDayTile,
    required this.weekDayText,
    required this.weekDayBorder,
    required this.headerIcon,
    required this.headerText,
    required this.headerBackground,
  });

  final Color cellInMonth;
  final Color cellNotInMonth;
  final Color cellText;
  final Color cellBorder;
  final Color weekDayTile;
  final Color weekDayText;
  final Color weekDayBorder;

  // Calendar page header
  final Color headerIcon;
  final Color headerText;
  final Color headerBackground;

  // Light theme
  MonthViewTheme.light()
      : cellInMonth = LightAppColors.surfaceContainerLowest,
        cellNotInMonth = LightAppColors.surfaceContainerLow,
        cellText = LightAppColors.onSurface,
        cellBorder = LightAppColors.surfaceContainerHigh,
        weekDayTile = LightAppColors.surfaceContainerHigh,
        weekDayText = LightAppColors.onSurface,
        weekDayBorder = LightAppColors.outlineVariant,
        headerIcon = LightAppColors.onPrimary,
        headerText = LightAppColors.onPrimary,
        headerBackground = LightAppColors.primary;

  // Dark theme
  MonthViewTheme.dark()
      : cellInMonth = DarkAppColors.surfaceContainerLowest,
        cellNotInMonth = DarkAppColors.surfaceContainerLow,
        cellText = DarkAppColors.onSurface,
        cellBorder = DarkAppColors.surfaceContainerHigh,
        weekDayTile = DarkAppColors.surfaceContainerHigh,
        weekDayText = DarkAppColors.onSurface,
        weekDayBorder = DarkAppColors.outlineVariant,
        headerIcon = DarkAppColors.onPrimary,
        headerText = DarkAppColors.onPrimary,
        headerBackground = DarkAppColors.primary;

  @override
  ThemeExtension<MonthViewTheme> copyWith({
    Color? cellInMonth,
    Color? cellNotInMonth,
    Color? cellText,
    Color? cellBorder,
    Color? weekDayTile,
    Color? weekDayText,
    Color? weekDayBorder,
    Color? headerIcon,
    Color? headerText,
    Color? headerBackground,
  }) {
    return MonthViewTheme(
      cellInMonth: cellInMonth ?? this.cellInMonth,
      cellNotInMonth: cellNotInMonth ?? this.cellNotInMonth,
      cellText: cellText ?? this.cellText,
      cellBorder: cellBorder ?? this.cellBorder,
      weekDayTile: weekDayTile ?? this.weekDayTile,
      weekDayText: weekDayText ?? this.weekDayText,
      weekDayBorder: weekDayBorder ?? this.weekDayBorder,
      headerIcon: headerIcon ?? this.headerIcon,
      headerText: headerText ?? this.headerText,
      headerBackground: headerBackground ?? this.headerBackground,
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
      cellInMonth: Color.lerp(cellInMonth, other.cellInMonth, t) ?? cellInMonth,
      cellNotInMonth:
          Color.lerp(cellNotInMonth, other.cellNotInMonth, t) ?? cellNotInMonth,
      cellText: Color.lerp(cellText, other.cellText, t) ?? cellText,
      cellBorder: Color.lerp(cellBorder, other.cellBorder, t) ?? cellBorder,
      weekDayTile: Color.lerp(weekDayTile, other.weekDayTile, t) ?? weekDayTile,
      weekDayText: Color.lerp(weekDayText, other.weekDayText, t) ?? weekDayText,
      weekDayBorder:
          Color.lerp(weekDayBorder, other.weekDayBorder, t) ?? weekDayBorder,
      headerIcon: Color.lerp(headerIcon, other.headerIcon, t) ?? headerIcon,
      headerText: Color.lerp(headerText, other.headerText, t) ?? headerText,
      headerBackground:
          Color.lerp(headerBackground, other.headerBackground, t) ??
              headerBackground,
    );
  }
}
