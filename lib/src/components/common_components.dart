// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../style/header_style.dart';
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

  // TODO: Need to remove after next release
  /// background color of header.
  @Deprecated("Use Header Style to provide background")
  final Color backgroundColor;

  // TODO: Need to remove after next release
  /// Color of icons at both sides of header.
  @Deprecated("Use Header Style to provide icon color")
  final Color iconColor;

  /// Style for Calendar's header
  final HeaderStyle headerStyle;

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
    @Deprecated("Use Header Style to provide background")
    this.backgroundColor = Constants.headerBackground,
    @Deprecated("Use Header Style to provide icon color")
    this.iconColor = Constants.black,
    this.headerStyle = const HeaderStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      decoration:
          // ignore_for_file: deprecated_member_use_from_same_package
          headerStyle.decoration ?? BoxDecoration(color: backgroundColor),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (headerStyle.leftIconVisible)
            IconButton(
              onPressed: onPreviousDay,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: headerStyle.leftIconPadding,
              icon: headerStyle.leftIcon ??
                  Icon(
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
                textAlign: headerStyle.titleAlign,
                style: headerStyle.headerTextStyle,
              ),
            ),
          ),
          if (headerStyle.rightIconVisible)
            IconButton(
              onPressed: onNextDay,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: headerStyle.rightIconPadding,
              icon: headerStyle.rightIcon ??
                  Icon(
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
