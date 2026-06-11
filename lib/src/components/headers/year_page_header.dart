// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../calendar_view.dart';
import '../../constants.dart';

class YearPageHeader extends CalendarPageHeader {
  /// A header widget to display on year view.
  const YearPageHeader({
    Key? key,
    VoidCallback? onNextYear,
    bool showNextIcon = true,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousYear,
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
          onNextDay: onNextYear,
          showNextIcon: showNextIcon,
          onPreviousDay: onPreviousYear,
          showPreviousIcon: showPreviousIcon,
          onTitleTapped: onTitleTapped,
          // ignore_for_file: deprecated_member_use_from_same_package
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          dateStringBuilder:
              dateStringBuilder ?? YearPageHeader._yearStringBuilder,
          headerStyle: headerStyle,
        );

  static String _yearStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      PackageStrings.localizeNumber(date.year).toString();
}
