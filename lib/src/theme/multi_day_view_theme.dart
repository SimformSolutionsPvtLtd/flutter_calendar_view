import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class MultiDayViewTheme extends ThemeExtension<MultiDayViewTheme> {
  MultiDayViewTheme({
    required this.multiDayTileColor,
    required this.multiDayTextColor,
    required this.hourLineColor,
    required this.halfHourLineColor,
    required this.quarterHourLineColor,
    required this.liveIndicatorColor,
    required this.pageBackgroundColor,
    required this.headerIconColor,
    required this.headerTextColor,
    required this.headerBackgroundColor,
    required this.timelineTextColor,
    required this.borderColor,
    required this.verticalLinesColor,
  });

  // Multi day tile properties
  final Color multiDayTileColor;
  final Color multiDayTextColor;

  // Hour line properties
  final Color hourLineColor;
  final Color halfHourLineColor;
  final Color quarterHourLineColor;

  // Calendar page header
  final Color headerIconColor;
  final Color headerTextColor;
  final Color headerBackgroundColor;

  // Timeline property
  final Color timelineTextColor;

  // Other
  final Color liveIndicatorColor;
  final Color pageBackgroundColor;
  final Color borderColor;
  final Color verticalLinesColor;

  /// Get pre-defined colors for light theme
  MultiDayViewTheme.light()
      : multiDayTileColor = LightAppColors.surfaceContainerHigh,
        multiDayTextColor = LightAppColors.onSurface,
        hourLineColor = LightAppColors.surfaceContainerHighest,
        halfHourLineColor = LightAppColors.surfaceContainerHighest,
        quarterHourLineColor = LightAppColors.surfaceContainerHighest,
        liveIndicatorColor = LightAppColors.primary,
        pageBackgroundColor = LightAppColors.surfaceContainerLowest,
        headerIconColor = LightAppColors.onPrimary,
        headerTextColor = LightAppColors.onPrimary,
        headerBackgroundColor = LightAppColors.primary,
        timelineTextColor = LightAppColors.onSurface,
        borderColor = LightAppColors.surfaceContainerHighest,
        verticalLinesColor = LightAppColors.surfaceContainerHighest;

  /// Get pre-defined colors for dark theme
  MultiDayViewTheme.dark()
      : multiDayTileColor = DarkAppColors.surfaceContainerHigh,
        multiDayTextColor = DarkAppColors.onSurface,
        hourLineColor = DarkAppColors.surfaceContainerHighest,
        halfHourLineColor = DarkAppColors.surfaceContainerHighest,
        quarterHourLineColor = DarkAppColors.surfaceContainerHighest,
        liveIndicatorColor = DarkAppColors.primary,
        pageBackgroundColor = DarkAppColors.surfaceContainerLowest,
        headerIconColor = DarkAppColors.onPrimary,
        headerTextColor = DarkAppColors.onPrimary,
        headerBackgroundColor = DarkAppColors.primary,
        timelineTextColor = DarkAppColors.onSurface,
        borderColor = DarkAppColors.surfaceContainerHighest,
        verticalLinesColor = DarkAppColors.surfaceContainerHighest;

  @override
  ThemeExtension<MultiDayViewTheme> copyWith({
    Color? multiDayTileColor,
    Color? multiDayTextColor,
    Color? hourLineColor,
    Color? halfHourLineColor,
    Color? quarterHourLineColor,
    Color? liveIndicatorColor,
    Color? pageBackgroundColor,
    Color? headerIconColor,
    Color? headerTextColor,
    Color? headerBackgroundColor,
    Color? timelineTextColor,
    Color? borderColor,
    Color? verticalLinesColor,
  }) {
    return MultiDayViewTheme(
      multiDayTileColor: multiDayTileColor ?? this.multiDayTileColor,
      multiDayTextColor: multiDayTextColor ?? this.multiDayTextColor,
      hourLineColor: hourLineColor ?? this.hourLineColor,
      halfHourLineColor: halfHourLineColor ?? this.halfHourLineColor,
      quarterHourLineColor: quarterHourLineColor ?? this.quarterHourLineColor,
      liveIndicatorColor: liveIndicatorColor ?? this.liveIndicatorColor,
      pageBackgroundColor: pageBackgroundColor ?? this.pageBackgroundColor,
      headerIconColor: headerIconColor ?? this.headerIconColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      timelineTextColor: timelineTextColor ?? this.timelineTextColor,
      borderColor: borderColor ?? this.borderColor,
      verticalLinesColor: verticalLinesColor ?? this.verticalLinesColor,
    );
  }

  @override
  ThemeExtension<MultiDayViewTheme> lerp(
    covariant ThemeExtension<MultiDayViewTheme>? other,
    double t,
  ) {
    if (other is! MultiDayViewTheme) {
      return this;
    }
    return MultiDayViewTheme(
      multiDayTileColor:
          Color.lerp(multiDayTileColor, other.multiDayTileColor, t) ??
              multiDayTileColor,
      multiDayTextColor:
          Color.lerp(multiDayTextColor, other.multiDayTextColor, t) ??
              multiDayTextColor,
      hourLineColor:
          Color.lerp(hourLineColor, other.hourLineColor, t) ?? hourLineColor,
      halfHourLineColor:
          Color.lerp(halfHourLineColor, other.halfHourLineColor, t) ??
              halfHourLineColor,
      quarterHourLineColor:
          Color.lerp(quarterHourLineColor, other.quarterHourLineColor, t) ??
              quarterHourLineColor,
      liveIndicatorColor:
          Color.lerp(liveIndicatorColor, other.liveIndicatorColor, t) ??
              liveIndicatorColor,
      pageBackgroundColor:
          Color.lerp(pageBackgroundColor, other.pageBackgroundColor, t) ??
              pageBackgroundColor,
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
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      verticalLinesColor:
          Color.lerp(verticalLinesColor, other.verticalLinesColor, t) ??
              verticalLinesColor,
    );
  }
}
