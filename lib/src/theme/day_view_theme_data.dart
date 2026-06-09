import 'package:flutter/material.dart';

import 'calendar_view_colors.dart';

class DayViewThemeData extends ThemeExtension<DayViewThemeData> {
  /// Define custom colors
  DayViewThemeData({
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
  DayViewThemeData.light()
      : hourLineColor = CalendarViewColors.light.surfaceContainerHighest,
        halfHourLineColor = CalendarViewColors.light.surfaceContainerHighest,
        quarterHourLineColor = CalendarViewColors.light.surfaceContainerHighest,
        pageBackgroundColor = CalendarViewColors.light.surfaceContainerLowest,
        liveIndicatorColor = CalendarViewColors.light.primary,
        headerIconColor = CalendarViewColors.light.onPrimary,
        headerTextColor = CalendarViewColors.light.onPrimary,
        headerBackgroundColor = CalendarViewColors.light.primary,
        timelineTextColor = CalendarViewColors.light.onSurface;

  /// Get pre-defined colors for dark theme
  DayViewThemeData.dark()
      : hourLineColor = CalendarViewColors.dark.surfaceContainerHighest,
        halfHourLineColor = CalendarViewColors.dark.surfaceContainerHighest,
        quarterHourLineColor = CalendarViewColors.dark.surfaceContainerHighest,
        pageBackgroundColor = CalendarViewColors.dark.surfaceContainerLowest,
        liveIndicatorColor = CalendarViewColors.dark.primary,
        headerIconColor = CalendarViewColors.dark.onPrimary,
        headerTextColor = CalendarViewColors.dark.onPrimary,
        headerBackgroundColor = CalendarViewColors.dark.primary,
        timelineTextColor = CalendarViewColors.dark.onSurface;

  @override
  ThemeExtension<DayViewThemeData> copyWith({
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
    return DayViewThemeData(
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
  ThemeExtension<DayViewThemeData> lerp(
    covariant ThemeExtension<DayViewThemeData>? other,
    double t,
  ) {
    if (other is! DayViewThemeData) {
      return this;
    }
    return DayViewThemeData(
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

  /// Merges another `DayViewThemeData` into this one.
  ThemeExtension<DayViewThemeData> merge(DayViewThemeData? other) {
    if (other == null) return this;

    return copyWith(
      hourLineColor: other.hourLineColor,
      halfHourLineColor: other.halfHourLineColor,
      quarterHourLineColor: other.quarterHourLineColor,
      pageBackgroundColor: other.pageBackgroundColor,
      liveIndicatorColor: other.liveIndicatorColor,
      headerIconColor: other.headerIconColor,
      headerTextColor: other.headerTextColor,
      headerBackgroundColor: other.headerBackgroundColor,
      timelineTextColor: other.timelineTextColor,
    );
  }
}
