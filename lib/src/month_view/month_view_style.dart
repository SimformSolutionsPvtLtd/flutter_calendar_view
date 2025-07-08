import 'package:flutter/material.dart';

import '../../calendar_view.dart';

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

  ///   /// Defines the day from which the week starts.
  ///
  /// Default value is [WeekDays.monday].
  final WeekDays startDay;

  /// Style for MontView header.
  final HeaderStyle? headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Defines scroll physics for a page of a month view.
  ///
  /// This can be used to disable the vertical scroll of a page.
  /// Default value is [ClampingScrollPhysics].
  final ScrollPhysics pagePhysics;

  /// Defines scroll physics for a page of a month view.
  ///
  /// This can be used to disable the horizontal scroll of a page.
  final ScrollPhysics? pageViewPhysics;

  /// defines that show and hide cell not is in current month
  final bool hideDaysNotInMonth;
}
