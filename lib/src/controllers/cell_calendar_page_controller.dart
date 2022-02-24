import 'package:flutter/material.dart';

import '../date_extension.dart';

class CellCalendarPageController extends PageController {
  CellCalendarPageController() : super(initialPage: initialPageIndex);

  void jumpToDate(DateTime date) {
    final currentDate = DateTime.now();
    final monthDif =
        (date.year - currentDate.year) * 12 + (date.month - currentDate.month);
    super.jumpToPage(initialPageIndex + monthDif);
  }

  Future<void> animateToDate(
    DateTime date, {
    required Duration duration,
    required Curve curve,
  }) {
    final currentDate = DateTime.now();
    final monthDif =
        (date.year - currentDate.year) * 12 + (date.month - currentDate.month);
    return super.animateToPage(initialPageIndex + monthDif,
        duration: duration, curve: curve);
  }

  /// [jumpToDate] is recommended
  @override
  void jumpToPage(int page) {
    super.jumpToPage(initialPageIndex + page);
  }

  /// [animateToDate] is recommended
  @override
  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    return super.animateToPage(initialPageIndex + page,
        duration: duration, curve: curve);
  }
}
