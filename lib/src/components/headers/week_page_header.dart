// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import '../../typedefs.dart';
import 'calendar_page_header.dart';

class WeekPageHeader extends CalendarPageHeader {
  /// A header widget to display on week view.
  const WeekPageHeader({
    super.key,
    super.onNextDay,
    super.showNextIcon,
    super.onTitleTapped,
    super.onPreviousDay,
    super.showPreviousIcon,
    required DateTime startDate,
    required DateTime endDate,
    @Deprecated("Use HeaderStyle to provide icon color") super.iconColor,
    @Deprecated("Use HeaderStyle to provide background color")
    super.backgroundColor,
    StringProvider? headerStringBuilder,
    super.headerStyle,
  }) : super(
          date: startDate,
          secondaryDate: endDate,
          dateStringBuilder:
              headerStringBuilder ?? WeekPageHeader._weekStringBuilder,
        );

  static String _weekStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} / ${date.month} / ${date.year} to "
      "${secondaryDate != null ? "${secondaryDate.day} / "
          "${secondaryDate.month} / ${secondaryDate.year}" : ""}";
}
