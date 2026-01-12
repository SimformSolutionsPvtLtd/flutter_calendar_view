import 'dart:math';

import 'package:example/widgets/multi_day_view_widget.dart';
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../theme/app_colors.dart';
import 'day_view_widget.dart';
import 'month_view_widget.dart';
import 'week_view_widget.dart';

class CalendarViews extends StatelessWidget {
  final CalendarView view;

  const CalendarViews({super.key, this.view = CalendarView.month});

  final _breakPoint = 490.0;

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;
    final width = min(_breakPoint, availableWidth);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColors.grey,
      child: Center(
        child: view == CalendarView.multiDay
            ? MultiDayViewWidget(width: width)
            : view == CalendarView.month
            ? MonthViewWidget(width: width)
            : view == CalendarView.day
            ? DayViewWidget(width: width)
            : WeekViewWidget(width: width),
      ),
    );
  }
}
