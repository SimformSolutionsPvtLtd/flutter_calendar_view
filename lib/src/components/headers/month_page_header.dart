// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../style/header_style.dart';
import '../../typedefs.dart';
import 'calendar_page_header.dart';

class MonthPageHeader extends CalendarPageHeader {
  /// A header widget to display on month view.
  const MonthPageHeader({
    Key? key,
    VoidCallback? onNextMonth,
    bool showNextIcon = true,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousMonth,
    bool showPreviousIcon = true,
    @Deprecated("Use HeaderStyle to provide icon color") Color? iconColor,
    @Deprecated("Use HeaderStyle to provide background color")
    Color backgroundColor = Constants.headerBackground,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextMonth,
          showNextIcon: showNextIcon,
          onPreviousDay: onPreviousMonth,
          showPreviousIcon: showPreviousIcon,
          onTitleTapped: onTitleTapped,
          // ignore_for_file: deprecated_member_use_from_same_package
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          dateStringBuilder:
              dateStringBuilder ?? MonthPageHeader._monthStringBuilder,
          headerStyle: headerStyle,
        );

  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month} - ${date.year}";
}
