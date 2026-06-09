import 'dart:math';

import 'package:flutter/material.dart';

import '../enumerations.dart';
import 'day_view_widget.dart';
import 'month_view_widget.dart';
import 'resizable_month_view_widget.dart';
import 'week_view_widget.dart';

class CalendarViews extends StatelessWidget {
  final CalendarView view;

  const CalendarViews({super.key, this.view = CalendarView.month});

  /// Maximum width for the calendar preview on web.
  static const _maxCalendarWidth = 600.0;

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;
    final width = min(_maxCalendarWidth, availableWidth);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: switch (view) {
          CalendarView.month => MonthViewWidget(width: width),
          CalendarView.day => DayViewWidget(width: width),
          CalendarView.week => WeekViewWidget(width: width),
          CalendarView.resizableMonth => ResizableMonthViewWidget(width: width),
        },
      ),
    );
  }
}
