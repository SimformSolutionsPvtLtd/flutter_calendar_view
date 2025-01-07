import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class WeekViewTheme extends ThemeExtension<WeekViewTheme> {
  WeekViewTheme({
    required this.weekDayTile,
    required this.weekDayText,
    required this.weekDayBorder,
    required this.hourLine,
    required this.halfHourLine,
    required this.quarterHourLine,
    required this.liveIndicator,
    required this.pageBackground,
    required this.headerIcon,
    required this.headerText,
    required this.headerBackground,
  });

  final Color weekDayTile;
  final Color weekDayText;
  final Color weekDayBorder;
  final Color hourLine;
  final Color halfHourLine;
  final Color quarterHourLine;
  final Color liveIndicator;
  final Color pageBackground;

  // Calendar page header
  final Color headerIcon;
  final Color headerText;
  final Color headerBackground;

  // Light theme
  WeekViewTheme.light()
      : weekDayTile = LightAppColors.surfaceContainerHigh,
        weekDayText = LightAppColors.onSurface,
        weekDayBorder = LightAppColors.outlineVariant,
        hourLine = LightAppColors.surfaceContainerHighest,
        halfHourLine = LightAppColors.surfaceContainerHighest,
        quarterHourLine = LightAppColors.surfaceContainerHighest,
        liveIndicator = LightAppColors.primary,
        pageBackground = LightAppColors.surfaceContainerLowest,
        headerIcon = LightAppColors.onPrimary,
        headerText = LightAppColors.onPrimary,
        headerBackground = LightAppColors.primary;

  // Dark theme
  WeekViewTheme.dark()
      : weekDayTile = DarkAppColors.surfaceContainerHigh,
        weekDayText = DarkAppColors.onSurface,
        weekDayBorder = DarkAppColors.outlineVariant,
        hourLine = DarkAppColors.surfaceContainerHighest,
        halfHourLine = DarkAppColors.surfaceContainerHighest,
        quarterHourLine = DarkAppColors.surfaceContainerHighest,
        liveIndicator = DarkAppColors.primary,
        pageBackground = DarkAppColors.surfaceContainerLowest,
        headerIcon = DarkAppColors.onPrimary,
        headerText = DarkAppColors.onPrimary,
        headerBackground = DarkAppColors.primary;

  @override
  ThemeExtension<WeekViewTheme> copyWith({
    Color? weekDayTile,
    Color? weekDayText,
    Color? weekDayBorder,
    Color? hourLine,
    Color? halfHourLine,
    Color? quarterHourLine,
    Color? liveIndicator,
    Color? pageBackground,
    Color? headerIcon,
    Color? headerText,
    Color? headerBackground,
  }) {
    return WeekViewTheme(
      weekDayTile: weekDayTile ?? this.weekDayTile,
      weekDayText: weekDayText ?? this.weekDayText,
      weekDayBorder: weekDayBorder ?? this.weekDayBorder,
      hourLine: hourLine ?? this.hourLine,
      halfHourLine: halfHourLine ?? this.halfHourLine,
      quarterHourLine: quarterHourLine ?? this.quarterHourLine,
      liveIndicator: liveIndicator ?? this.liveIndicator,
      pageBackground: pageBackground ?? this.pageBackground,
      headerIcon: headerIcon ?? this.headerIcon,
      headerText: headerText ?? this.headerText,
      headerBackground: headerBackground ?? this.headerBackground,
    );
  }

  @override
  ThemeExtension<WeekViewTheme> lerp(
    covariant ThemeExtension<WeekViewTheme>? other,
    double t,
  ) {
    if (other is! WeekViewTheme) {
      return this;
    }
    return WeekViewTheme(
      weekDayTile: Color.lerp(weekDayTile, other.weekDayTile, t) ?? weekDayTile,
      weekDayText: Color.lerp(weekDayText, other.weekDayText, t) ?? weekDayText,
      weekDayBorder:
          Color.lerp(weekDayBorder, other.weekDayBorder, t) ?? weekDayBorder,
      hourLine: Color.lerp(hourLine, other.hourLine, t) ?? hourLine,
      halfHourLine:
          Color.lerp(halfHourLine, other.halfHourLine, t) ?? halfHourLine,
      quarterHourLine: Color.lerp(quarterHourLine, other.quarterHourLine, t) ??
          quarterHourLine,
      liveIndicator:
          Color.lerp(liveIndicator, other.liveIndicator, t) ?? liveIndicator,
      pageBackground:
          Color.lerp(pageBackground, other.pageBackground, t) ?? pageBackground,
      headerIcon: Color.lerp(headerIcon, other.headerIcon, t) ?? headerIcon,
      headerText: Color.lerp(headerText, other.headerText, t) ?? headerText,
      headerBackground:
          Color.lerp(headerBackground, other.headerBackground, t) ??
              headerBackground,
    );
  }
}
