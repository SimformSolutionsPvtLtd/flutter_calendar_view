// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import '../../typedefs.dart';
import 'calendar_page_header.dart';

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    super.key,
    super.onNextDay,
    super.showNextIcon,
    super.onTitleTapped,
    super.onPreviousDay,
    super.showPreviousIcon,
    StringProvider? dateStringBuilder,
    required super.date,
    @Deprecated("Use HeaderStyle to provide icon color") super.iconColor,
    @Deprecated("Use HeaderStyle to provide background")
    super.backgroundColor,
    super.headerStyle,
  }) : super(
          dateStringBuilder:
              dateStringBuilder ?? DayPageHeader._dayStringBuilder,
        );

  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} - ${date.month} - ${date.year}";
}
