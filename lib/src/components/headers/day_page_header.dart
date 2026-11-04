// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../../../calendar_view.dart';

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    bool showNextIcon = true,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    bool showPreviousIcon = true,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextDay,
          showNextIcon: showNextIcon,
          onPreviousDay: onPreviousDay,
          showPreviousIcon: showPreviousIcon,
          onTitleTapped: onTitleTapped,
          dateStringBuilder:
              dateStringBuilder ?? DayPageHeader._dayStringBuilder,
          headerStyle: headerStyle,
        );

  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${PackageStrings.localizeNumber(date.day)} - ${PackageStrings.localizeNumber(date.month)} - ${PackageStrings.localizeNumber(date.year)}";
}
