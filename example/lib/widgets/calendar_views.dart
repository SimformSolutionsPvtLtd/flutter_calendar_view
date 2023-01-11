import "dart:math";

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../enumerations.dart';
import '../extension.dart';

final _maxWidth = 510.0;

class CalendarViews extends StatelessWidget {
  final CalendarView view;

  const CalendarViews({Key? key, this.view = CalendarView.month})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    if (width.isWeb) width /= 2;

    width = min(width, _maxWidth);

    return Container(
      width: width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.grey,
      child: Center(
        child: view == CalendarView.month
            ? MonthView(
                width: width,
              )
            : view == CalendarView.day
                ? DayView(
                    width: width,
                  )
                : WeekView(
                    width: width,
                  ),
      ),
    );
  }
}
