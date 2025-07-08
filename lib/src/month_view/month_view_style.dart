import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Configures the visual appearance, layout, and interaction behavior of a
/// month-based calendar [MonthView].
///
/// Use this class to customize borders, header appearance, visible date
/// range, scrolling physics, cell layout, and safe area handling for month
/// pages. Instances are immutable and can be safely reused across multiple
/// [MonthView] widgets.
@immutable
class MonthViewStyle {
  const MonthViewStyle({
    this.showBorder = true,
    this.borderColor,
    this.minMonth,
    this.maxMonth,
    this.initialMonth,
    this.showWeekends = true,
    this.borderSize = 1,
    this.useAvailableVerticalSpace = false,
    this.cellAspectRatio = 0.55,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.startDay = WeekDays.monday,
    this.headerStyle,
    this.safeAreaOption = const SafeAreaOption(),
    this.pagePhysics = const ClampingScrollPhysics(),
    this.pageViewPhysics,
    this.showWeekTileBorder = true,
    this.hideDaysNotInMonth = false,
  });

  /// Show weekends or not.
  /// Default value is true.
  final bool showWeekends;

  /// Determines the lower boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.epochDate] is default.
  final DateTime? minMonth;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.maxDate] is default.
  final DateTime? maxMonth;

  /// Defines initial display month.
  ///
  /// If not provided [DateTime.now] is default date.
  final DateTime? initialMonth;

  /// Defines whether to show default borders or not.
  ///
  /// Default value is true
  ///
  /// Use [borderSize] to define width of the border and
  /// [borderColor] to define color of the border.
  final bool showBorder;

  /// Defines whether to show default borders or not for weekTile.
  ///
  /// Default value is true
  ///
  final bool showWeekTileBorder;

  /// Defines the color of the default border.
  /// This will only take effect if [showBorder] is set to true.
  final Color? borderColor;

  /// Page transition duration used when user try to change page using
  /// [MonthView.nextPage] or [MonthView.previousPage]
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [MonthView.nextPage] or [MonthView.previousPage]
  final Curve pageTransitionCurve;

  /// Defines width of default border
  ///
  /// Default value is 1
  ///
  /// It will take affect only if [showBorder] is set.
  final double borderSize;

  /// Automated Calculate cellAspectRatio using available vertical space.
  final bool useAvailableVerticalSpace;

  /// Defines aspect ratio of day cells in month calendar page.
  final double cellAspectRatio;

  /// Defines the day from which the week starts.
  ///
  /// Default value is [WeekDays.monday].
  final WeekDays startDay;

  /// Style for MonthView header.
  final HeaderStyle? headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Defines scroll physics for the vertically scrollable content of a month
  /// page.
  ///
  /// This can be used to disable the vertical scroll within a single month
  /// page.
  /// Default value is [ClampingScrollPhysics].
  final ScrollPhysics pagePhysics;

  /// Defines scroll physics for the horizontally scrollable month page view.
  ///
  /// This can be used to disable horizontal paging between month pages.
  final ScrollPhysics? pageViewPhysics;

  /// Defines whether to show or hide cells that are not in the current month.
  final bool hideDaysNotInMonth;

  /// Creates a copy of this style with the given fields replaced.
  MonthViewStyle copyWith({
    bool? showBorder,
    Color? borderColor,
    DateTime? minMonth,
    DateTime? maxMonth,
    DateTime? initialMonth,
    bool? showWeekends,
    double? borderSize,
    bool? useAvailableVerticalSpace,
    double? cellAspectRatio,
    Duration? pageTransitionDuration,
    Curve? pageTransitionCurve,
    WeekDays? startDay,
    HeaderStyle? headerStyle,
    SafeAreaOption? safeAreaOption,
    ScrollPhysics? pagePhysics,
    ScrollPhysics? pageViewPhysics,
    bool? showWeekTileBorder,
    bool? hideDaysNotInMonth,
  }) {
    return MonthViewStyle(
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      minMonth: minMonth ?? this.minMonth,
      maxMonth: maxMonth ?? this.maxMonth,
      initialMonth: initialMonth ?? this.initialMonth,
      showWeekends: showWeekends ?? this.showWeekends,
      borderSize: borderSize ?? this.borderSize,
      useAvailableVerticalSpace:
          useAvailableVerticalSpace ?? this.useAvailableVerticalSpace,
      cellAspectRatio: cellAspectRatio ?? this.cellAspectRatio,
      pageTransitionDuration:
          pageTransitionDuration ?? this.pageTransitionDuration,
      pageTransitionCurve: pageTransitionCurve ?? this.pageTransitionCurve,
      startDay: startDay ?? this.startDay,
      headerStyle: headerStyle ?? this.headerStyle,
      safeAreaOption: safeAreaOption ?? this.safeAreaOption,
      pagePhysics: pagePhysics ?? this.pagePhysics,
      pageViewPhysics: pageViewPhysics ?? this.pageViewPhysics,
      showWeekTileBorder: showWeekTileBorder ?? this.showWeekTileBorder,
      hideDaysNotInMonth: hideDaysNotInMonth ?? this.hideDaysNotInMonth,
    );
  }

  /// Merges this style with another, preferring values from [other].
  MonthViewStyle merge(MonthViewStyle? other) {
    if (other == null) return this;
    return copyWith(
      showBorder: other.showBorder,
      borderColor: other.borderColor,
      minMonth: other.minMonth,
      maxMonth: other.maxMonth,
      initialMonth: other.initialMonth,
      showWeekends: other.showWeekends,
      borderSize: other.borderSize,
      useAvailableVerticalSpace: other.useAvailableVerticalSpace,
      cellAspectRatio: other.cellAspectRatio,
      pageTransitionDuration: other.pageTransitionDuration,
      pageTransitionCurve: other.pageTransitionCurve,
      startDay: other.startDay,
      headerStyle: other.headerStyle,
      safeAreaOption: other.safeAreaOption,
      pagePhysics: other.pagePhysics,
      pageViewPhysics: other.pageViewPhysics,
      showWeekTileBorder: other.showWeekTileBorder,
      hideDaysNotInMonth: other.hideDaysNotInMonth,
    );
  }
}
