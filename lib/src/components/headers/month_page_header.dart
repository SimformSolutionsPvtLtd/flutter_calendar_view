// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../calendar_view.dart';

class MonthPageHeader extends CalendarPageHeader {
  /// A header widget to display on month view.
  const MonthPageHeader({
    super.key,
    VoidCallback? onNextMonth,
    super.showNextIcon,
    super.onTitleTapped,
    VoidCallback? onPreviousMonth,
    super.showPreviousIcon,
    @Deprecated("Use HeaderStyle to provide icon color")
    super.iconColor,
    @Deprecated("Use HeaderStyle to provide background color")
    super.backgroundColor,
    StringProvider? dateStringBuilder,
    required super.date,
    super.headerStyle,
  }) : super(
          onNextDay: onNextMonth,
          onPreviousDay: onPreviousMonth,
          dateStringBuilder:
              dateStringBuilder ?? MonthPageHeader._monthStringBuilder,
        );

  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month} - ${date.year}";
}
