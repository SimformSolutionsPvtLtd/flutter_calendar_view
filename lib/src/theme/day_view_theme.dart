import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class DayViewTheme extends ThemeExtension<DayViewTheme> {
  /// Define custom colors
  DayViewTheme({
    required this.hourLineColor,
    required this.halfHourLineColor,
    required this.quarterHourLineColor,
    required this.pageBackgroundColor,
    required this.liveIndicatorColor,
    required this.headerIconColor,
    required this.headerTextColor,
    required this.headerBackgroundColor,
    required this.timelineTextColor,
  });

  // Hour line properties
  final Color hourLineColor;
  final Color halfHourLineColor;
  final Color quarterHourLineColor;

  // Calendar page header
  final Color headerIconColor;
  final Color headerTextColor;
  final Color headerBackgroundColor;

  // Other properties
  final Color pageBackgroundColor;
  final Color liveIndicatorColor;

  // Timeline property
  final Color timelineTextColor;

  /// Get pre-defined colors for light theme
  DayViewTheme.light()
      : hourLineColor = LightAppColors.surfaceContainerHighest,
        halfHourLineColor = LightAppColors.surfaceContainerHighest,
        quarterHourLineColor = LightAppColors.surfaceContainerHighest,
        pageBackgroundColor = LightAppColors.surfaceContainerLowest,
        liveIndicatorColor = LightAppColors.primary,
        headerIconColor = LightAppColors.onPrimary,
        headerTextColor = LightAppColors.onPrimary,
        headerBackgroundColor = LightAppColors.primary,
        timelineTextColor = LightAppColors.onSurface;

  /// Get pre-defined colors for dark theme
  DayViewTheme.dark()
      : hourLineColor = DarkAppColors.surfaceContainerHighest,
        halfHourLineColor = DarkAppColors.surfaceContainerHighest,
        quarterHourLineColor = DarkAppColors.surfaceContainerHighest,
        pageBackgroundColor = DarkAppColors.surfaceContainerLowest,
        liveIndicatorColor = DarkAppColors.primary,
        headerIconColor = DarkAppColors.onPrimary,
        headerTextColor = DarkAppColors.onPrimary,
        headerBackgroundColor = DarkAppColors.primary,
        timelineTextColor = DarkAppColors.onSurface;

  @override
  ThemeExtension<DayViewTheme> copyWith({
    Color? hourLineColor,
    Color? halfHourLineColor,
    Color? quarterHourLineColor,
    Color? pageBackgroundColor,
    Color? liveIndicatorColor,
    Color? headerIconColor,
    Color? headerTextColor,
    Color? headerBackgroundColor,
    Color? timelineTextColor,
  }) {
    return DayViewTheme(
      hourLineColor: hourLineColor ?? this.hourLineColor,
      halfHourLineColor: halfHourLineColor ?? this.halfHourLineColor,
      quarterHourLineColor: quarterHourLineColor ?? this.quarterHourLineColor,
      pageBackgroundColor: pageBackgroundColor ?? this.pageBackgroundColor,
      liveIndicatorColor: liveIndicatorColor ?? this.liveIndicatorColor,
      headerIconColor: headerIconColor ?? this.headerIconColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      timelineTextColor: timelineTextColor ?? this.timelineTextColor,
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
      hourLineColor:
          Color.lerp(hourLineColor, other.hourLineColor, t) ?? hourLineColor,
      halfHourLineColor:
          Color.lerp(halfHourLineColor, other.halfHourLineColor, t) ??
              halfHourLineColor,
      quarterHourLineColor:
          Color.lerp(quarterHourLineColor, other.quarterHourLineColor, t) ??
              quarterHourLineColor,
      pageBackgroundColor:
          Color.lerp(pageBackgroundColor, other.pageBackgroundColor, t) ??
              pageBackgroundColor,
      liveIndicatorColor:
          Color.lerp(liveIndicatorColor, other.liveIndicatorColor, t) ??
              liveIndicatorColor,
      headerIconColor: Color.lerp(headerIconColor, other.headerIconColor, t) ??
          headerIconColor,
      headerTextColor: Color.lerp(headerTextColor, other.headerTextColor, t) ??
          headerTextColor,
      headerBackgroundColor:
          Color.lerp(headerBackgroundColor, other.headerBackgroundColor, t) ??
              headerBackgroundColor,
      timelineTextColor:
          Color.lerp(timelineTextColor, other.timelineTextColor, t) ??
              timelineTextColor,
    );
  }
}
