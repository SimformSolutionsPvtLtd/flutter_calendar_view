// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Configures the visual appearance, layout, interaction behaviour, and
/// display mode of a [ResizableMonthView].
///
/// This is a standalone class modelled after [MonthViewStyle] but augmented
/// with resizable-specific fields such as [initialMode], mode-toggle styling,
/// event-list spacing, and height-transition animation settings.
///
/// Instances are immutable and can be reused across widgets.
@immutable
class ResizableMonthViewStyle {
  const ResizableMonthViewStyle({
    // ── Resizable-specific fields ─────────────────────────────────────
    this.initialMode = ResizableMonthViewMode.monthly,
    this.showModeToggle = true,
    this.modeToggleActiveColor,
    this.modeToggleTextColor,
    this.modeToggleBorderRadius = 20,
    this.eventListPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.eventListSeparatorHeight = 8,
    this.animationDuration = const Duration(milliseconds: 350),
    this.animationCurve = Curves.easeInOut,
    // ── Drag-to-switch fields ─────────────────────────────────────────
    this.enableDragToSwitchMode = false,
    this.dragHandleColor,
    this.dragThreshold = 40.0,
    // ── Fields mirrored from MonthViewStyle ──────────────────────────
    this.showBorder = true,
    this.borderColor,
    this.minMonth,
    this.maxMonth,
    this.initialMonth,
    this.showWeekends = true,
    this.borderSize = 1,
    this.cellAspectRatio = 0.55,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.startDay = WeekDays.monday,
    this.headerStyle,
    this.safeAreaOption = const SafeAreaOption(),
    this.pageViewPhysics,
    this.showWeekTileBorder = true,
    this.hideDaysNotInMonth = false,
  });

  // ── Resizable-specific ─────────────────────────────────────────────

  /// The display mode shown when the widget first renders.
  ///
  /// Defaults to [ResizableMonthViewMode.monthly].
  final ResizableMonthViewMode initialMode;

  /// Whether to render the mode-toggle pill button inside the header.
  ///
  /// Set to `false` to hide the button and lock the view to [initialMode].
  final bool showModeToggle;

  /// Background color of the active mode-toggle pill.
  ///
  /// If null, falls back to the theme's primary color.
  final Color? modeToggleActiveColor;

  /// Text / icon color inside the mode-toggle pill.
  ///
  /// If null, falls back to the theme's onPrimary color.
  final Color? modeToggleTextColor;

  /// Corner radius of the mode-toggle pill button.
  ///
  /// Defaults to 20.
  final double modeToggleBorderRadius;

  /// Padding applied around the event-list area that appears below the grid.
  final EdgeInsets eventListPadding;

  /// Vertical gap (in pixels) between the calendar grid and the event list.
  final double eventListSeparatorHeight;

  /// Duration of the animated height transition when the user switches modes.
  final Duration animationDuration;

  /// Easing curve used during the mode-switch height animation.
  final Curve animationCurve;

  // ── Drag-to-switch ────────────────────────────────────────────────

  /// Whether to show a drag handle at the bottom of the calendar that
  /// lets users switch between display modes by dragging up or down.
  ///
  /// When `true`, a [CalendarDragHandle] is rendered below the calendar
  /// grid. Dragging down advances through the mode ladder
  /// (weekly → biWeekly → monthly → monthlyScrollable) and dragging up
  /// reverses it. The feature is disabled by default.
  final bool enableDragToSwitchMode;

  /// Color of the drag-handle pill indicator.
  ///
  /// If null, a neutral grey adapted to the current [Brightness] is used.
  final Color? dragHandleColor;

  /// Minimum cumulative vertical drag delta (in logical pixels) required
  /// to advance one step in the mode ladder.
  ///
  /// Smaller values feel more responsive; larger values require a more
  /// deliberate gesture. Defaults to 40.0.
  final double dragThreshold;

  // ── MonthViewStyle mirrors ─────────────────────────────────────────

  /// Show weekends in the grid.
  final bool showWeekends;

  /// Lower boundary the user can scroll to (base date for page indexing).
  final DateTime? minMonth;

  /// Upper boundary the user can scroll to.
  final DateTime? maxMonth;

  /// Initial month displayed when the widget first renders.
  final DateTime? initialMonth;

  /// Whether to show cell borders.
  final bool showBorder;

  /// Whether to show borders on the weekday-name row tiles.
  final bool showWeekTileBorder;

  /// Color of cell borders (only used when [showBorder] is true).
  final Color? borderColor;

  /// Duration used for month-page transitions.
  final Duration pageTransitionDuration;

  /// Curve used for month-page transitions.
  final Curve pageTransitionCurve;

  /// Width of cell borders.
  final double borderSize;

  /// Aspect ratio (width / height) for each day cell.
  final double cellAspectRatio;

  /// Day of the week that starts each row.
  final WeekDays startDay;

  /// Optional custom style for the header widget.
  final HeaderStyle? headerStyle;

  /// Safe-area configuration.
  final SafeAreaOption safeAreaOption;

  /// Scroll physics for the horizontal [PageView] (Full mode only).
  final ScrollPhysics? pageViewPhysics;

  /// Whether to hide day cells that belong to the previous/next month.
  final bool hideDaysNotInMonth;

  /// Creates a copy of this style with the given fields replaced.
  ResizableMonthViewStyle copyWith({
    ResizableMonthViewMode? initialMode,
    bool? showModeToggle,
    Color? modeToggleActiveColor,
    Color? modeToggleTextColor,
    double? modeToggleBorderRadius,
    EdgeInsets? eventListPadding,
    double? eventListSeparatorHeight,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableDragToSwitchMode,
    Color? dragHandleColor,
    double? dragThreshold,
    bool? showBorder,
    Color? borderColor,
    DateTime? minMonth,
    DateTime? maxMonth,
    DateTime? initialMonth,
    bool? showWeekends,
    double? borderSize,
    double? cellAspectRatio,
    Duration? pageTransitionDuration,
    Curve? pageTransitionCurve,
    WeekDays? startDay,
    HeaderStyle? headerStyle,
    SafeAreaOption? safeAreaOption,
    ScrollPhysics? pageViewPhysics,
    bool? showWeekTileBorder,
    bool? hideDaysNotInMonth,
  }) {
    return ResizableMonthViewStyle(
      initialMode: initialMode ?? this.initialMode,
      showModeToggle: showModeToggle ?? this.showModeToggle,
      modeToggleActiveColor:
          modeToggleActiveColor ?? this.modeToggleActiveColor,
      modeToggleTextColor: modeToggleTextColor ?? this.modeToggleTextColor,
      modeToggleBorderRadius:
          modeToggleBorderRadius ?? this.modeToggleBorderRadius,
      eventListPadding: eventListPadding ?? this.eventListPadding,
      eventListSeparatorHeight:
          eventListSeparatorHeight ?? this.eventListSeparatorHeight,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableDragToSwitchMode:
          enableDragToSwitchMode ?? this.enableDragToSwitchMode,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      dragThreshold: dragThreshold ?? this.dragThreshold,
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      minMonth: minMonth ?? this.minMonth,
      maxMonth: maxMonth ?? this.maxMonth,
      initialMonth: initialMonth ?? this.initialMonth,
      showWeekends: showWeekends ?? this.showWeekends,
      borderSize: borderSize ?? this.borderSize,
      cellAspectRatio: cellAspectRatio ?? this.cellAspectRatio,
      pageTransitionDuration:
          pageTransitionDuration ?? this.pageTransitionDuration,
      pageTransitionCurve: pageTransitionCurve ?? this.pageTransitionCurve,
      startDay: startDay ?? this.startDay,
      headerStyle: headerStyle ?? this.headerStyle,
      safeAreaOption: safeAreaOption ?? this.safeAreaOption,
      pageViewPhysics: pageViewPhysics ?? this.pageViewPhysics,
      showWeekTileBorder: showWeekTileBorder ?? this.showWeekTileBorder,
      hideDaysNotInMonth: hideDaysNotInMonth ?? this.hideDaysNotInMonth,
    );
  }

  /// Merges this style with [other], preferring non-null values from [other].
  ResizableMonthViewStyle merge(ResizableMonthViewStyle? other) {
    if (other == null) return this;
    return copyWith(
      initialMode: other.initialMode,
      showModeToggle: other.showModeToggle,
      modeToggleActiveColor: other.modeToggleActiveColor,
      modeToggleTextColor: other.modeToggleTextColor,
      modeToggleBorderRadius: other.modeToggleBorderRadius,
      eventListPadding: other.eventListPadding,
      eventListSeparatorHeight: other.eventListSeparatorHeight,
      animationDuration: other.animationDuration,
      animationCurve: other.animationCurve,
      enableDragToSwitchMode: other.enableDragToSwitchMode,
      dragHandleColor: other.dragHandleColor,
      dragThreshold: other.dragThreshold,
      showBorder: other.showBorder,
      borderColor: other.borderColor,
      minMonth: other.minMonth,
      maxMonth: other.maxMonth,
      initialMonth: other.initialMonth,
      showWeekends: other.showWeekends,
      borderSize: other.borderSize,
      cellAspectRatio: other.cellAspectRatio,
      pageTransitionDuration: other.pageTransitionDuration,
      pageTransitionCurve: other.pageTransitionCurve,
      startDay: other.startDay,
      headerStyle: other.headerStyle,
      safeAreaOption: other.safeAreaOption,
      pageViewPhysics: other.pageViewPhysics,
      showWeekTileBorder: other.showWeekTileBorder,
      hideDaysNotInMonth: other.hideDaysNotInMonth,
    );
  }
}
