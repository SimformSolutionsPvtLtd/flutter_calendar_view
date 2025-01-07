import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class DayViewTheme extends ThemeExtension<DayViewTheme> {
  DayViewTheme({
    required this.hourLine,
    required this.halfHourLine,
    required this.quarterHourLine,
    required this.pageBackground,
    required this.liveIndicator,
    required this.headerIcon,
    required this.headerText,
    required this.headerBackground,
  });

  final Color hourLine;
  final Color halfHourLine;
  final Color quarterHourLine;
  final Color pageBackground;
  final Color liveIndicator;

  // Calendar page header
  final Color headerIcon;
  final Color headerText;
  final Color headerBackground;

  // Light theme
  DayViewTheme.light()
      : hourLine = LightAppColors.surfaceContainerHighest,
        halfHourLine = LightAppColors.surfaceContainerHighest,
        quarterHourLine = LightAppColors.surfaceContainerHighest,
        pageBackground = LightAppColors.surfaceContainerLowest,
        liveIndicator = LightAppColors.primary,
        headerIcon = LightAppColors.onPrimary,
        headerText = LightAppColors.onPrimary,
        headerBackground = LightAppColors.primary;

  // Dark theme
  DayViewTheme.dark()
      : hourLine = DarkAppColors.surfaceContainerHighest,
        halfHourLine = DarkAppColors.surfaceContainerHighest,
        quarterHourLine = DarkAppColors.surfaceContainerHighest,
        pageBackground = DarkAppColors.surfaceContainerLowest,
        liveIndicator = DarkAppColors.primary,
        headerIcon = DarkAppColors.onPrimary,
        headerText = DarkAppColors.onPrimary,
        headerBackground = DarkAppColors.primary;

  @override
  ThemeExtension<DayViewTheme> copyWith({
    Color? hourLine,
    Color? halfHourLine,
    Color? quarterHourLine,
    Color? pageBackground,
    Color? liveIndicator,
    Color? headerIcon,
    Color? headerText,
    Color? headerBackground,
  }) {
    return DayViewTheme(
      hourLine: hourLine ?? this.hourLine,
      halfHourLine: halfHourLine ?? this.halfHourLine,
      quarterHourLine: quarterHourLine ?? this.quarterHourLine,
      pageBackground: pageBackground ?? this.pageBackground,
      liveIndicator: liveIndicator ?? this.liveIndicator,
      headerIcon: headerIcon ?? this.headerIcon,
      headerText: headerText ?? this.headerText,
      headerBackground: headerBackground ?? this.headerBackground,
    );
  }

  @override
  ThemeExtension<DayViewTheme> lerp(
    covariant ThemeExtension<DayViewTheme>? other,
    double t,
  ) {
    if (other is! DayViewTheme) {
      return this;
    }
    return DayViewTheme(
      hourLine: Color.lerp(hourLine, other.hourLine, t) ?? hourLine,
      halfHourLine:
          Color.lerp(halfHourLine, other.halfHourLine, t) ?? halfHourLine,
      quarterHourLine: Color.lerp(quarterHourLine, other.quarterHourLine, t) ??
          quarterHourLine,
      pageBackground:
          Color.lerp(pageBackground, other.pageBackground, t) ?? pageBackground,
      liveIndicator:
          Color.lerp(liveIndicator, other.liveIndicator, t) ?? liveIndicator,
      headerIcon: Color.lerp(headerIcon, other.headerIcon, t) ?? headerIcon,
      headerText: Color.lerp(headerText, other.headerText, t) ?? headerText,
      headerBackground:
          Color.lerp(headerBackground, other.headerBackground, t) ??
              headerBackground,
    );
  }
}
