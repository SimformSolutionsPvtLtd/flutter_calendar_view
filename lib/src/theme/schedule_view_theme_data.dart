import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

/// Theme data for the default built-in widget builders of [ScheduleView].
///
/// Colors are applied only when the package-provided fallback widgets render
/// (e.g. the default date cell, event tile, or empty-state labels). Fully
/// custom builders supplied via [ScheduleView.dayDetectorBuilder],
/// [ScheduleView.eventTileBuilder], etc. are unaffected.
///
/// Register as a [ThemeExtension] on [MaterialApp.theme] / [MaterialApp.darkTheme]
/// to override the defaults:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [ScheduleViewThemeData.light().copyWith(todayHighlightColor: Colors.teal)],
///   ),
/// )
/// ```
class ScheduleViewThemeData extends ThemeExtension<ScheduleViewThemeData> {
  const ScheduleViewThemeData({
    required this.todayHighlightColor,
    required this.todayTextColor,
    required this.dateTextColor,
    required this.weekdayTextColor,
    required this.dateDividerColor,
    required this.emptyContentColor,
    required this.eventTitleColor,
    required this.eventSecondaryTextColor,
    required this.eventTileAlpha,
    required this.eventTimeColorLightnessAdjust,
    required this.monthHeaderTextColor,
    required this.transparent,
    required this.monthHeaderGradientStartColor,
    required this.monthHeaderGradientEndColor,
    required this.monthHeaderTextShadowColor,
  });

  /// Background fill of the circular highlight drawn on today's date cell.
  final Color todayHighlightColor;

  /// Color of the date number rendered inside the today highlight circle.
  final Color todayTextColor;

  /// Default color of date numbers on non-today days.
  final Color dateTextColor;

  /// Color of weekday abbreviations (Mon, Tue, …) on non-today days.
  /// Also used for today's weekday abbreviation alongside [todayHighlightColor].
  final Color weekdayTextColor;

  /// Color of the divider drawn beneath the date header when
  /// [ScheduleView.dateLayout] is [ScheduleDateLayout.top], separating each
  /// day's header from its events (and from the previous day).
  final Color dateDividerColor;

  /// Color for empty-state labels: the day-level "no events" placeholder,
  /// the past sentinel, and the future sentinel.
  final Color emptyContentColor;

  /// Color for event tile title text.
  final Color eventTitleColor;

  /// Color for event tile description text and secondary UI (chevron, badges).
  final Color eventSecondaryTextColor;

  /// Alpha value applied to the event's own color for the tile background:
  /// `event.color.withAlpha(eventTileAlpha)`.
  /// Lower in light mode (~28) to avoid overpowering the background;
  /// higher in dark mode (~45) to keep the tint visible.
  final int eventTileAlpha;

  /// HSL lightness adjustment applied to the event color for the time label.
  /// Negative values darken the color (use in light mode for contrast);
  /// 0.0 means no adjustment (use in dark mode to preserve the event color).
  final double eventTimeColorLightnessAdjust;

  /// Text and icon color for the month-header image overlay.
  /// Typically white in both light and dark mode because the header always
  /// has a dark gradient over the photograph.
  final Color monthHeaderTextColor;

  /// Fully transparent color; used as the date-cell background for non-today
  /// days and as the start of the month-header gradient overlay.
  final Color transparent;

  /// Start color of the gradient overlay drawn on top of the month-header
  /// image (transparent end, so the image shows through at the top).
  final Color monthHeaderGradientStartColor;

  /// End color of the gradient overlay drawn on top of the month-header
  /// image; a semi-opaque dark color so white text remains readable.
  final Color monthHeaderGradientEndColor;

  /// Color used for text shadow on the month-header title, providing contrast
  /// against the background image.
  final Color monthHeaderTextShadowColor;

  /// Pre-defined colors for a light theme.
  const ScheduleViewThemeData.light()
      : todayHighlightColor = LightAppColors.primary,
        todayTextColor = LightAppColors.onPrimary,
        dateTextColor = LightAppColors.onSurface,
        weekdayTextColor = LightAppColors.outlineVariant,
        dateDividerColor = LightAppColors.outlineVariant,
        emptyContentColor = LightAppColors.emptyContent,
        eventTitleColor = LightAppColors.onSurface,
        eventSecondaryTextColor = LightAppColors.outline,
        eventTileAlpha = 28,
        eventTimeColorLightnessAdjust = -0.1,
        monthHeaderTextColor = LightAppColors.monthHeaderText,
        transparent = LightAppColors.transparent,
        monthHeaderGradientStartColor = LightAppColors.transparent,
        monthHeaderGradientEndColor = LightAppColors.monthHeaderGradientEnd,
        monthHeaderTextShadowColor = LightAppColors.monthHeaderTextShadow;

  /// Pre-defined colors for a dark theme.
  const ScheduleViewThemeData.dark()
      : todayHighlightColor = DarkAppColors.primary,
        todayTextColor = DarkAppColors.onPrimary,
        dateTextColor = DarkAppColors.onSurface,
        weekdayTextColor = DarkAppColors.outlineVariant,
        dateDividerColor = DarkAppColors.outlineVariant,
        emptyContentColor = DarkAppColors.emptyContent,
        eventTitleColor = DarkAppColors.onSurface,
        eventSecondaryTextColor = DarkAppColors.outline,
        eventTileAlpha = 45,
        eventTimeColorLightnessAdjust = 0.0,
        monthHeaderTextColor = DarkAppColors.monthHeaderText,
        transparent = LightAppColors.transparent,
        monthHeaderGradientStartColor = LightAppColors.transparent,
        monthHeaderGradientEndColor = DarkAppColors.monthHeaderGradientEnd,
        monthHeaderTextShadowColor = DarkAppColors.monthHeaderTextShadow;

  @override
  ThemeExtension<ScheduleViewThemeData> copyWith({
    Color? todayHighlightColor,
    Color? todayTextColor,
    Color? dateTextColor,
    Color? weekdayTextColor,
    Color? dateDividerColor,
    Color? emptyContentColor,
    Color? eventTitleColor,
    Color? eventSecondaryTextColor,
    int? eventTileAlpha,
    double? eventTimeColorLightnessAdjust,
    Color? monthHeaderTextColor,
    Color? transparent,
    Color? monthHeaderGradientStartColor,
    Color? monthHeaderGradientEndColor,
    Color? monthHeaderTextShadowColor,
  }) {
    return ScheduleViewThemeData(
      todayHighlightColor: todayHighlightColor ?? this.todayHighlightColor,
      todayTextColor: todayTextColor ?? this.todayTextColor,
      dateTextColor: dateTextColor ?? this.dateTextColor,
      weekdayTextColor: weekdayTextColor ?? this.weekdayTextColor,
      dateDividerColor: dateDividerColor ?? this.dateDividerColor,
      emptyContentColor: emptyContentColor ?? this.emptyContentColor,
      eventTitleColor: eventTitleColor ?? this.eventTitleColor,
      eventSecondaryTextColor:
          eventSecondaryTextColor ?? this.eventSecondaryTextColor,
      eventTileAlpha: eventTileAlpha ?? this.eventTileAlpha,
      eventTimeColorLightnessAdjust:
          eventTimeColorLightnessAdjust ?? this.eventTimeColorLightnessAdjust,
      monthHeaderTextColor: monthHeaderTextColor ?? this.monthHeaderTextColor,
      transparent: transparent ?? this.transparent,
      monthHeaderGradientStartColor:
          monthHeaderGradientStartColor ?? this.monthHeaderGradientStartColor,
      monthHeaderGradientEndColor:
          monthHeaderGradientEndColor ?? this.monthHeaderGradientEndColor,
      monthHeaderTextShadowColor:
          monthHeaderTextShadowColor ?? this.monthHeaderTextShadowColor,
    );
  }

  @override
  ThemeExtension<ScheduleViewThemeData> lerp(
    covariant ThemeExtension<ScheduleViewThemeData>? other,
    double t,
  ) {
    if (other is! ScheduleViewThemeData) return this;
    return ScheduleViewThemeData(
      todayHighlightColor:
          Color.lerp(todayHighlightColor, other.todayHighlightColor, t) ??
              todayHighlightColor,
      todayTextColor:
          Color.lerp(todayTextColor, other.todayTextColor, t) ?? todayTextColor,
      dateTextColor:
          Color.lerp(dateTextColor, other.dateTextColor, t) ?? dateTextColor,
      weekdayTextColor:
          Color.lerp(weekdayTextColor, other.weekdayTextColor, t) ??
              weekdayTextColor,
      dateDividerColor:
          Color.lerp(dateDividerColor, other.dateDividerColor, t) ??
              dateDividerColor,
      emptyContentColor:
          Color.lerp(emptyContentColor, other.emptyContentColor, t) ??
              emptyContentColor,
      eventTitleColor: Color.lerp(eventTitleColor, other.eventTitleColor, t) ??
          eventTitleColor,
      eventSecondaryTextColor: Color.lerp(
            eventSecondaryTextColor,
            other.eventSecondaryTextColor,
            t,
          ) ??
          eventSecondaryTextColor,
      eventTileAlpha:
          lerpDouble(eventTileAlpha, other.eventTileAlpha, t)?.round() ??
              eventTileAlpha,
      eventTimeColorLightnessAdjust: lerpDouble(
            eventTimeColorLightnessAdjust,
            other.eventTimeColorLightnessAdjust,
            t,
          ) ??
          eventTimeColorLightnessAdjust,
      monthHeaderTextColor:
          Color.lerp(monthHeaderTextColor, other.monthHeaderTextColor, t) ??
              monthHeaderTextColor,
      transparent: Color.lerp(transparent, other.transparent, t) ?? transparent,
      monthHeaderGradientStartColor: Color.lerp(
            monthHeaderGradientStartColor,
            other.monthHeaderGradientStartColor,
            t,
          ) ??
          monthHeaderGradientStartColor,
      monthHeaderGradientEndColor: Color.lerp(
            monthHeaderGradientEndColor,
            other.monthHeaderGradientEndColor,
            t,
          ) ??
          monthHeaderGradientEndColor,
      monthHeaderTextShadowColor: Color.lerp(
            monthHeaderTextShadowColor,
            other.monthHeaderTextShadowColor,
            t,
          ) ??
          monthHeaderTextShadowColor,
    );
  }

  /// Merges another [ScheduleViewThemeData] into this one.
  ThemeExtension<ScheduleViewThemeData> merge(ScheduleViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      todayHighlightColor: other.todayHighlightColor,
      todayTextColor: other.todayTextColor,
      dateTextColor: other.dateTextColor,
      weekdayTextColor: other.weekdayTextColor,
      dateDividerColor: other.dateDividerColor,
      emptyContentColor: other.emptyContentColor,
      eventTitleColor: other.eventTitleColor,
      eventSecondaryTextColor: other.eventSecondaryTextColor,
      eventTileAlpha: other.eventTileAlpha,
      eventTimeColorLightnessAdjust: other.eventTimeColorLightnessAdjust,
      monthHeaderTextColor: other.monthHeaderTextColor,
      transparent: other.transparent,
      monthHeaderGradientStartColor: other.monthHeaderGradientStartColor,
      monthHeaderGradientEndColor: other.monthHeaderGradientEndColor,
      monthHeaderTextShadowColor: other.monthHeaderTextShadowColor,
    );
  }
}
