import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

class WeekViewThemeData extends ThemeExtension<WeekViewThemeData> {
  /// Define custom colors
  WeekViewThemeData({
    required this.weekDayTileColor,
    required this.weekDayTextColor,
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

  // Weekday tile properties
  final Color weekDayTileColor;
  final Color weekDayTextColor;

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
  final Color
      borderColor; // TODO(Shubham): Rename this its top border & bottom border
  final Color verticalLinesColor;

  /// Get pre-defined colors for light theme
  WeekViewThemeData.light()
      : weekDayTileColor = LightAppColors.surfaceContainerHigh,
        weekDayTextColor = LightAppColors.onSurface,
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
  WeekViewThemeData.dark()
      : weekDayTileColor = DarkAppColors.surfaceContainerHigh,
        weekDayTextColor = DarkAppColors.onSurface,
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
  ThemeExtension<WeekViewThemeData> copyWith({
    Color? weekDayTileColor,
    Color? weekDayTextColor,
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
    return WeekViewThemeData(
      weekDayTileColor: weekDayTileColor ?? this.weekDayTileColor,
      weekDayTextColor: weekDayTextColor ?? this.weekDayTextColor,
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
  ThemeExtension<WeekViewThemeData> lerp(
    covariant ThemeExtension<WeekViewThemeData>? other,
    double t,
  ) {
    if (other is! WeekViewThemeData) {
      return this;
    }
    return WeekViewThemeData(
      weekDayTileColor:
          Color.lerp(weekDayTileColor, other.weekDayTileColor, t) ??
              weekDayTileColor,
      weekDayTextColor:
          Color.lerp(weekDayTextColor, other.weekDayTextColor, t) ??
              weekDayTextColor,
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

  /// Merges another `WeekViewThemeData` into this one.
  ThemeExtension<WeekViewThemeData> merge(WeekViewThemeData? other) {
    if (other == null) return this;

    return copyWith(
      weekDayTileColor: other.weekDayTileColor,
      weekDayTextColor: other.weekDayTextColor,
      hourLineColor: other.hourLineColor,
      halfHourLineColor: other.halfHourLineColor,
      quarterHourLineColor: other.quarterHourLineColor,
      liveIndicatorColor: other.liveIndicatorColor,
      pageBackgroundColor: other.pageBackgroundColor,
      headerIconColor: other.headerIconColor,
      headerTextColor: other.headerTextColor,
      headerBackgroundColor: other.headerBackgroundColor,
      timelineTextColor: other.timelineTextColor,
      borderColor: other.borderColor,
      verticalLinesColor: other.verticalLinesColor,
    );
  }
}
