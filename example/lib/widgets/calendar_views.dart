import 'dart:math';

import 'package:example/app_colors.dart';
import 'package:example/enumerations.dart';
import 'package:example/widgets/day_view_widget.dart';
import 'package:example/widgets/month_view_widget.dart';
import 'package:example/widgets/week_view_widget.dart';
import 'package:flutter/material.dart';

class CalendarViews extends StatelessWidget {
  final CalendarView view;

  const CalendarViews({Key? key, this.view = CalendarView.month})
      : super(key: key);

  final _breakPoint = 490.0;

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
    double width = min(_breakPoint, availableWidth);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColors.grey,
      child: Center(
        child: view == CalendarView.month
            ? MonthViewWidget(
                width: width,
              )
            : view == CalendarView.day
                ? DayViewWidget(
                    width: width,
                  )
                : WeekViewWidget(
                    width: width,
                  ),
      ),
    );
  }
}
