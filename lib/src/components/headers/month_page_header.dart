// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../../../calendar_view.dart';

class MonthPageHeader extends CalendarPageHeader {
  /// A header widget to display on month view.
  const MonthPageHeader({
    Key? key,
    VoidCallback? onNextMonth,
    bool showNextIcon = true,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousMonth,
    bool showPreviousIcon = true,
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
          dateStringBuilder:
              dateStringBuilder ?? MonthPageHeader._monthStringBuilder,
          headerStyle: headerStyle,
        );

  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${PackageStrings.localizeNumber(date.month)} - ${PackageStrings.localizeNumber(date.year)}";
}
