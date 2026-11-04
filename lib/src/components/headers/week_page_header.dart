// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../../../calendar_view.dart';

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
          dateStringBuilder:
              headerStringBuilder ?? WeekPageHeader._weekStringBuilder,
          headerStyle: headerStyle,
        );

  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) {
    String formatDate(DateTime d) =>
        "${PackageStrings.localizeNumber(d.day)} / "
        "${PackageStrings.localizeNumber(d.month)} / "
        "${PackageStrings.localizeNumber(d.year)}";

    final start = formatDate(date);
    final end = secondaryDate != null ? formatDate(secondaryDate) : "";

    return end.isNotEmpty ? "$start to $end" : start;
  }
}
