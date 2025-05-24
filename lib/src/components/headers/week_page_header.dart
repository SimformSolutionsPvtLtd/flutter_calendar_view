// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../style/header_style.dart';
import '../../typedefs.dart';
import 'calendar_page_header.dart';

class WeekPageHeader extends CalendarPageHeader {
  /// A header widget to display on week view.
  const WeekPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    bool showNextIcon = true,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    bool showPreviousIcon = true,
    required DateTime startDate,
    required DateTime endDate,
    @Deprecated("Use HeaderStyle to provide icon color") Color? iconColor,
    @Deprecated("Use HeaderStyle to provide background color")
    Color backgroundColor = Constants.headerBackground,
    StringProvider? headerStringBuilder,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: startDate,
          secondaryDate: endDate,
          onNextDay: onNextDay,
          showNextIcon: showNextIcon,
          onPreviousDay: onPreviousDay,
          showPreviousIcon: showPreviousIcon,
          onTitleTapped: onTitleTapped,
          // ignore_for_file: deprecated_member_use_from_same_package
          iconColor: iconColor,
          backgroundColor: backgroundColor,
          dateStringBuilder:
              headerStringBuilder ?? WeekPageHeader._weekStringBuilder,
          headerStyle: headerStyle,
        );

  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} / ${date.month} / ${date.year} to "
      "${secondaryDate != null ? "${secondaryDate.day} / "
          "${secondaryDate.month} / ${secondaryDate.year}" : ""}";
}
