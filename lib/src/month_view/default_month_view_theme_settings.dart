import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';

@immutable
class DefaultMonthViewThemeSettings {
  const DefaultMonthViewThemeSettings({
    this.weekDayDefaultBorderColor,
    this.weekDayDefaultBackgroundColor,
    this.weekDayDefaultTextStyle,
    this.defaultHeaderStyle,
    this.textStyle,
    this.cellsNotInMonthHighlightedTitleColor = Constants.white,
    this.cellsNotInMonthHighlightRadius = 11,
    this.cellsInMonthHighlightedTitleColor = Constants.white,
    this.cellsInMonthHighlightRadius = 11,
    this.cellsInMonthTileColor = Colors.blue,
    this.cellsInMonthHighlightColor = Colors.blue,
  });

  final Color? weekDayDefaultBorderColor;
  final Color? weekDayDefaultBackgroundColor;
  final TextStyle? weekDayDefaultTextStyle;
  final HeaderStyle? defaultHeaderStyle;
  final TextStyle? textStyle;
  final Color cellsNotInMonthHighlightedTitleColor;
  final double cellsNotInMonthHighlightRadius;
  final Color cellsInMonthHighlightedTitleColor;
  final double cellsInMonthHighlightRadius;
  final Color cellsInMonthTileColor;
  final Color cellsInMonthHighlightColor;
}
