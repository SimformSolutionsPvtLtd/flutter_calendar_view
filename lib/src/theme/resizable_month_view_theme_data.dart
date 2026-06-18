// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

/// Theme extension that controls all colours used by [ResizableMonthView].
///
/// Register it in [MaterialApp.theme.extensions] to provide custom colours.
/// If not registered, [ResizableMonthViewThemeData.light] is used as fallback.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       ResizableMonthViewThemeData(
///         headerBackgroundColor: Colors.deepPurple,
///         headerTextColor: Colors.white,
///         // …
///       ),
///     ],
///   ),
/// )
/// ```
class ResizableMonthViewThemeData
    extends ThemeExtension<ResizableMonthViewThemeData> {
  ResizableMonthViewThemeData({
    // ── Cell colours ───────────────────────────────────────────────────
    required this.cellInMonthColor,
    required this.cellNotInMonthColor,
    required this.cellTextColor,
    required this.cellBorderColor,
    required this.cellHighlightColor,

    // ── Weekday-header colours ─────────────────────────────────────────
    required this.weekDayTileColor,
    required this.weekDayTextColor,
    required this.weekDayBorderColor,

    // ── Page-header colours ────────────────────────────────────────────
    required this.headerIconColor,
    required this.headerTextColor,
    required this.headerBackgroundColor,

    // ── Mode-toggle pill colours ───────────────────────────────────────
    required this.modeToggleActiveColor,
    required this.modeToggleTextColor,
    required this.modeToggleInactiveColor,

    // ── Event-list colours ─────────────────────────────────────────────
    required this.eventListBackgroundColor,
    required this.eventListItemColor,
    required this.eventListItemTextColor,
    required this.eventListItemSubtextColor,
    required this.eventListSeparatorColor,
  });

  // ── Cell ───────────────────────────────────────────────────────────────
  /// Background colour for cells that belong to the currently displayed month.
  final Color cellInMonthColor;

  /// Background colour for cells that fall outside the displayed month.
  final Color cellNotInMonthColor;

  /// Day-number text colour inside each cell.
  final Color cellTextColor;

  /// Grid border / cell border colour.
  final Color cellBorderColor;

  /// Colour of the highlight circle shown on today's date.
  final Color cellHighlightColor;

  // ── Weekday header ─────────────────────────────────────────────────────
  /// Background of the weekday-label tiles (Mon, Tue, …).
  final Color weekDayTileColor;

  /// Text colour of the weekday-label tiles.
  final Color weekDayTextColor;

  /// Border colour of the weekday-label tiles.
  final Color weekDayBorderColor;

  // ── Page header ────────────────────────────────────────────────────────
  /// Colour of the previous / next navigation arrow icons.
  final Color headerIconColor;

  /// Colour of the month/year title text.
  final Color headerTextColor;

  /// Background colour of the header bar.
  final Color headerBackgroundColor;

  // ── Mode-toggle pill ───────────────────────────────────────────────────
  /// Background colour of the **active** mode pill segment.
  final Color modeToggleActiveColor;

  /// Text / icon colour on the active mode pill segment.
  final Color modeToggleTextColor;

  /// Background colour of the **inactive** mode pill segments.
  final Color modeToggleInactiveColor;

  // ── Event list ─────────────────────────────────────────────────────────
  /// Background of the entire event-list area below the calendar.
  final Color eventListBackgroundColor;

  /// Background of individual event tiles in the list.
  final Color eventListItemColor;

  /// Primary (title) text colour for event tiles.
  final Color eventListItemTextColor;

  /// Secondary (time / sub-label) text colour for event tiles.
  final Color eventListItemSubtextColor;

  /// Colour of the separator between event tiles.
  final Color eventListSeparatorColor;

  // ── Named constructors ─────────────────────────────────────────────────

  /// Predefined colours for a light theme.
  ResizableMonthViewThemeData.light()
      : cellInMonthColor = LightAppColors.surfaceContainerLowest,
        cellNotInMonthColor = LightAppColors.surfaceContainerLow,
        cellTextColor = LightAppColors.onSurface,
        cellBorderColor = LightAppColors.surfaceContainerHigh,
        cellHighlightColor = LightAppColors.primary,
        weekDayTileColor = LightAppColors.surfaceContainerHigh,
        weekDayTextColor = LightAppColors.onSurface,
        weekDayBorderColor = LightAppColors.outlineVariant,
        headerIconColor = LightAppColors.onPrimary,
        headerTextColor = LightAppColors.onPrimary,
        headerBackgroundColor = LightAppColors.primary,
        modeToggleActiveColor = LightAppColors.primary,
        modeToggleTextColor = LightAppColors.onPrimary,
        modeToggleInactiveColor = LightAppColors.surfaceContainerHigh,
        eventListBackgroundColor = LightAppColors.surfaceContainerLowest,
        eventListItemColor = LightAppColors.surfaceContainerLowest,
        eventListItemTextColor = LightAppColors.onSurface,
        eventListItemSubtextColor = LightAppColors.onSurface,
        eventListSeparatorColor = LightAppColors.outlineVariant;

  /// Predefined colours for a dark theme.
  ResizableMonthViewThemeData.dark()
      : cellInMonthColor = DarkAppColors.surfaceContainerLowest,
        cellNotInMonthColor = DarkAppColors.surfaceContainerLow,
        cellTextColor = DarkAppColors.onSurface,
        cellBorderColor = DarkAppColors.surfaceContainerHigh,
        cellHighlightColor = DarkAppColors.primary,
        weekDayTileColor = DarkAppColors.surfaceContainerHigh,
        weekDayTextColor = DarkAppColors.onSurface,
        weekDayBorderColor = DarkAppColors.outlineVariant,
        headerIconColor = DarkAppColors.onPrimary,
        headerTextColor = DarkAppColors.onPrimary,
        headerBackgroundColor = DarkAppColors.primary,
        modeToggleActiveColor = DarkAppColors.primary,
        modeToggleTextColor = DarkAppColors.onPrimary,
        modeToggleInactiveColor = DarkAppColors.surfaceContainerHigh,
        eventListBackgroundColor = DarkAppColors.surfaceContainerLowest,
        eventListItemColor = DarkAppColors.surfaceContainerHigh,
        eventListItemTextColor = DarkAppColors.onSurface,
        eventListItemSubtextColor = DarkAppColors.onSurface,
        eventListSeparatorColor = DarkAppColors.outlineVariant;

  // ── ThemeExtension overrides ───────────────────────────────────────────

  @override
  ResizableMonthViewThemeData copyWith({
    Color? cellInMonthColor,
    Color? cellNotInMonthColor,
    Color? cellTextColor,
    Color? cellBorderColor,
    Color? cellHighlightColor,
    Color? weekDayTileColor,
    Color? weekDayTextColor,
    Color? weekDayBorderColor,
    Color? headerIconColor,
    Color? headerTextColor,
    Color? headerBackgroundColor,
    Color? modeToggleActiveColor,
    Color? modeToggleTextColor,
    Color? modeToggleInactiveColor,
    Color? eventListBackgroundColor,
    Color? eventListItemColor,
    Color? eventListItemTextColor,
    Color? eventListItemSubtextColor,
    Color? eventListSeparatorColor,
  }) {
    return ResizableMonthViewThemeData(
      cellInMonthColor: cellInMonthColor ?? this.cellInMonthColor,
      cellNotInMonthColor: cellNotInMonthColor ?? this.cellNotInMonthColor,
      cellTextColor: cellTextColor ?? this.cellTextColor,
      cellBorderColor: cellBorderColor ?? this.cellBorderColor,
      cellHighlightColor: cellHighlightColor ?? this.cellHighlightColor,
      weekDayTileColor: weekDayTileColor ?? this.weekDayTileColor,
      weekDayTextColor: weekDayTextColor ?? this.weekDayTextColor,
      weekDayBorderColor: weekDayBorderColor ?? this.weekDayBorderColor,
      headerIconColor: headerIconColor ?? this.headerIconColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      modeToggleActiveColor:
          modeToggleActiveColor ?? this.modeToggleActiveColor,
      modeToggleTextColor: modeToggleTextColor ?? this.modeToggleTextColor,
      modeToggleInactiveColor:
          modeToggleInactiveColor ?? this.modeToggleInactiveColor,
      eventListBackgroundColor:
          eventListBackgroundColor ?? this.eventListBackgroundColor,
      eventListItemColor: eventListItemColor ?? this.eventListItemColor,
      eventListItemTextColor:
          eventListItemTextColor ?? this.eventListItemTextColor,
      eventListItemSubtextColor:
          eventListItemSubtextColor ?? this.eventListItemSubtextColor,
      eventListSeparatorColor:
          eventListSeparatorColor ?? this.eventListSeparatorColor,
    );
  }

  @override
  ResizableMonthViewThemeData lerp(
    covariant ThemeExtension<ResizableMonthViewThemeData>? other,
    double t,
  ) {
    if (other is! ResizableMonthViewThemeData) return this;
    return ResizableMonthViewThemeData(
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
      cellHighlightColor:
          Color.lerp(cellHighlightColor, other.cellHighlightColor, t) ??
              cellHighlightColor,
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
      modeToggleActiveColor:
          Color.lerp(modeToggleActiveColor, other.modeToggleActiveColor, t) ??
              modeToggleActiveColor,
      modeToggleTextColor:
          Color.lerp(modeToggleTextColor, other.modeToggleTextColor, t) ??
              modeToggleTextColor,
      modeToggleInactiveColor: Color.lerp(
              modeToggleInactiveColor, other.modeToggleInactiveColor, t) ??
          modeToggleInactiveColor,
      eventListBackgroundColor: Color.lerp(
              eventListBackgroundColor, other.eventListBackgroundColor, t) ??
          eventListBackgroundColor,
      eventListItemColor:
          Color.lerp(eventListItemColor, other.eventListItemColor, t) ??
              eventListItemColor,
      eventListItemTextColor:
          Color.lerp(eventListItemTextColor, other.eventListItemTextColor, t) ??
              eventListItemTextColor,
      eventListItemSubtextColor: Color.lerp(
              eventListItemSubtextColor, other.eventListItemSubtextColor, t) ??
          eventListItemSubtextColor,
      eventListSeparatorColor: Color.lerp(
              eventListSeparatorColor, other.eventListSeparatorColor, t) ??
          eventListSeparatorColor,
    );
  }

  /// Merges another [ResizableMonthViewThemeData] into this one,
  /// preferring values from [other].
  ResizableMonthViewThemeData merge(
    ResizableMonthViewThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      cellInMonthColor: other.cellInMonthColor,
      cellNotInMonthColor: other.cellNotInMonthColor,
      cellTextColor: other.cellTextColor,
      cellBorderColor: other.cellBorderColor,
      cellHighlightColor: other.cellHighlightColor,
      weekDayTileColor: other.weekDayTileColor,
      weekDayTextColor: other.weekDayTextColor,
      weekDayBorderColor: other.weekDayBorderColor,
      headerIconColor: other.headerIconColor,
      headerTextColor: other.headerTextColor,
      headerBackgroundColor: other.headerBackgroundColor,
      modeToggleActiveColor: other.modeToggleActiveColor,
      modeToggleTextColor: other.modeToggleTextColor,
      modeToggleInactiveColor: other.modeToggleInactiveColor,
      eventListBackgroundColor: other.eventListBackgroundColor,
      eventListItemColor: other.eventListItemColor,
      eventListItemTextColor: other.eventListItemTextColor,
      eventListItemSubtextColor: other.eventListItemSubtextColor,
      eventListSeparatorColor: other.eventListSeparatorColor,
    );
  }
}
