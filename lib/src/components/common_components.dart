// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../typedefs.dart';

class CalendarPageHeader extends StatelessWidget {
  /// When user taps on right arrow.
  final VoidCallback? onNextDay;

  /// When user taps on left arrow.
  final VoidCallback? onPreviousDay;

  /// When user taps on title.
  final AsyncCallback? onTitleTapped;

  /// Date of month/day.
  final DateTime date;

  /// Secondary date. This date will be used when we need to define a
  /// range of dates.
  /// [date] can be starting date and [secondaryDate] can be end date.
  final DateTime? secondaryDate;

  /// Provides string to display as title.
  final StringProvider dateStringBuilder;

  /// backgeound color of header.
  final Color backgroundColor;

  /// Color of icons at both sides of header.
  final Color iconColor;

  /// Common header for month and day view In this header user can define format
  /// in which date will be displayed by providing [dateStringBuilder] function.
  const CalendarPageHeader({
    Key? key,
    required this.date,
    required this.dateStringBuilder,
    this.onNextDay,
    this.onTitleTapped,
    this.onPreviousDay,
    this.secondaryDate,
    this.backgroundColor = Constants.headerBackground,
    this.iconColor = Constants.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousDay,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            icon: Icon(
              Icons.chevron_left,
              size: 30,
              color: iconColor,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onTitleTapped,
              child: Text(
                dateStringBuilder(date, secondaryDate: secondaryDate),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            onPressed: onNextDay,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            icon: Icon(
              Icons.chevron_right,
              size: 30,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
