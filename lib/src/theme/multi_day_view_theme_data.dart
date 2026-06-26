import 'package:flutter/material.dart';

import 'calendar_view_colors.dart';

class MultiDayViewThemeData extends ThemeExtension<MultiDayViewThemeData> {
  MultiDayViewThemeData({
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
  MultiDayViewThemeData.light()
      : multiDayTileColor = CalendarViewColors.light.surfaceContainerHigh,
        multiDayTextColor = CalendarViewColors.light.onSurface,
        hourLineColor = CalendarViewColors.light.surfaceContainerHighest,
        halfHourLineColor = CalendarViewColors.light.surfaceContainerHighest,
        quarterHourLineColor = CalendarViewColors.light.surfaceContainerHighest,
        liveIndicatorColor = CalendarViewColors.light.primary,
        pageBackgroundColor = CalendarViewColors.light.surfaceContainerLowest,
        headerIconColor = CalendarViewColors.light.onPrimary,
        headerTextColor = CalendarViewColors.light.onPrimary,
        headerBackgroundColor = CalendarViewColors.light.primary,
        timelineTextColor = CalendarViewColors.light.onSurface,
        borderColor = CalendarViewColors.light.surfaceContainerHighest,
        verticalLinesColor = CalendarViewColors.light.surfaceContainerHighest;

  /// Get pre-defined colors for dark theme
  MultiDayViewThemeData.dark()
      : multiDayTileColor = CalendarViewColors.dark.surfaceContainerHigh,
        multiDayTextColor = CalendarViewColors.dark.onSurface,
        hourLineColor = CalendarViewColors.dark.surfaceContainerHighest,
        halfHourLineColor = CalendarViewColors.dark.surfaceContainerHighest,
        quarterHourLineColor = CalendarViewColors.dark.surfaceContainerHighest,
        liveIndicatorColor = CalendarViewColors.dark.primary,
        pageBackgroundColor = CalendarViewColors.dark.surfaceContainerLowest,
        headerIconColor = CalendarViewColors.dark.onPrimary,
        headerTextColor = CalendarViewColors.dark.onPrimary,
        headerBackgroundColor = CalendarViewColors.dark.primary,
        timelineTextColor = CalendarViewColors.dark.onSurface,
        borderColor = CalendarViewColors.dark.surfaceContainerHighest,
        verticalLinesColor = CalendarViewColors.dark.surfaceContainerHighest;

  @override
  ThemeExtension<MultiDayViewThemeData> copyWith({
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
    return MultiDayViewThemeData(
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
  ThemeExtension<MultiDayViewThemeData> lerp(
    covariant ThemeExtension<MultiDayViewThemeData>? other,
    double t,
  ) {
    if (other is! MultiDayViewThemeData) {
      return this;
    }
    return MultiDayViewThemeData(
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

  /// Merges another `MultiDayViewThemeData` into this one.
  ThemeExtension<MultiDayViewThemeData> merge(MultiDayViewThemeData? other) {
    if (other == null) return this;

    return copyWith(
      multiDayTileColor: other.multiDayTileColor,
      multiDayTextColor: other.multiDayTextColor,
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
