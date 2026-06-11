import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Configures the visual appearance, layout, and interaction behavior of a
/// year-based calendar [YearView].
@immutable
class YearViewStyle {
  const YearViewStyle({
    this.initialYear,
    this.minYear,
    this.maxYear,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.pageViewPhysics,
    this.pagePhysics = const ClampingScrollPhysics(),
    this.safeAreaOption = const SafeAreaOption(),
    this.columnCount = 3,
    this.displayMode = YearViewDisplayMode.miniCalendarGrid,
    this.monthAspectRatio = 0.8,
  });

  /// Defines initial display year.
  ///
  /// If not provided [DateTime.now] is default date.
  final DateTime? initialYear;

  /// Determines the lower boundary user can scroll.
  final DateTime? minYear;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided, [CalendarConstants.maxDate] is used.
  final DateTime? maxYear;

  /// Page transition duration used when user try to change page using
  /// [YearViewState.nextPage] or [YearViewState.previousPage].
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [YearViewState.nextPage] or [YearViewState.previousPage].
  final Curve pageTransitionCurve;

  /// Defines scroll physics for the horizontally scrollable year page view.
  ///
  /// This can be used to disable horizontal paging between year pages.
  final ScrollPhysics? pageViewPhysics;

  /// Defines scroll physics for the vertically scrollable content of a year
  /// page.
  ///
  /// Default value is [ClampingScrollPhysics].
  final ScrollPhysics pagePhysics;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Number of columns to display the months in.
  ///
  /// Default value is 3.
  final int columnCount;

  /// Display mode of the year view.
  ///
  /// Default value is [YearViewDisplayMode.miniCalendarGrid].
  final YearViewDisplayMode displayMode;

  /// Aspect ratio for each month grid item.
  /// 
  /// Only applicable in [YearViewDisplayMode.titleGrid] or when
  /// custom month builder is used.
  final double monthAspectRatio;

  /// Creates a copy of this style with the given fields replaced.
  YearViewStyle copyWith({
    DateTime? initialYear,
    DateTime? minYear,
    DateTime? maxYear,
    Duration? pageTransitionDuration,
    Curve? pageTransitionCurve,
    ScrollPhysics? pageViewPhysics,
    ScrollPhysics? pagePhysics,
    SafeAreaOption? safeAreaOption,
    int? columnCount,
    YearViewDisplayMode? displayMode,
    double? monthAspectRatio,
  }) {
    return YearViewStyle(
      initialYear: initialYear ?? this.initialYear,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      pageTransitionDuration: pageTransitionDuration ?? this.pageTransitionDuration,
      pageTransitionCurve: pageTransitionCurve ?? this.pageTransitionCurve,
      pageViewPhysics: pageViewPhysics ?? this.pageViewPhysics,
      pagePhysics: pagePhysics ?? this.pagePhysics,
      safeAreaOption: safeAreaOption ?? this.safeAreaOption,
      columnCount: columnCount ?? this.columnCount,
      displayMode: displayMode ?? this.displayMode,
      monthAspectRatio: monthAspectRatio ?? this.monthAspectRatio,
    );
  }

  /// Merges this style with another, preferring values from [other].
  YearViewStyle merge(YearViewStyle? other) {
    if (other == null) return this;
    return copyWith(
      initialYear: other.initialYear,
      minYear: other.minYear,
      maxYear: other.maxYear,
      pageTransitionDuration: other.pageTransitionDuration,
      pageTransitionCurve: other.pageTransitionCurve,
      pageViewPhysics: other.pageViewPhysics,
      pagePhysics: other.pagePhysics,
      safeAreaOption: other.safeAreaOption,
      columnCount: other.columnCount,
      displayMode: other.displayMode,
      monthAspectRatio: other.monthAspectRatio,
    );
  }
}
