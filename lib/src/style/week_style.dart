import 'package:flutter/material.dart';

/// Class for styling Calendar's week days.
class DaysOfWeekStyle {
  /// Provide text style for calendar's week days.
  final TextStyle? weekDayTexStyle;

  /// Define Alignment of week day.
  final Alignment weekDayAlignment;

  /// Provide padding for weekday
  final EdgeInsets weekDayPadding;

  /// Provide margin for weekday
  final EdgeInsets weekDayMargin;

  /// Decoration of week day.
  final BoxDecoration? weekDayDecoration;

  /// Provide padding for week day widget
  final EdgeInsets padding;

  /// Provide margin for week day widget
  final EdgeInsets margin;

  /// Create a `DaysOfWeekStyle` of calendar view
  const DaysOfWeekStyle({
    this.weekDayTexStyle,
    this.weekDayAlignment = Alignment.center,
    this.weekDayPadding = const EdgeInsets.symmetric(vertical: 10.0),
    this.weekDayMargin = EdgeInsets.zero,
    this.weekDayDecoration,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  });
}
