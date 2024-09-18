// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../style/header_style.dart';
import '../../typedefs.dart';

class CalendarPageHeader extends StatelessWidget {
  /// When user taps on right arrow.
  ///
  /// This will be ignored if right icon is provided in [headerStyle].
  final VoidCallback? onNextDay;

  /// When user taps on left arrow.
  ///
  /// This will be ignored if left icon is provided in [headerStyle].
  final VoidCallback? onPreviousDay;

  /// When user taps on title.
  ///
  /// This will be ignored if [titleBuilder] is provided.
  final AsyncCallback? onTitleTapped;

  /// Date of month/day.
  final DateTime date;

  /// Secondary date. This date will be used when we need to define a
  /// range of dates.
  /// [date] can be starting date and [secondaryDate] can be end date.
  ///
  final DateTime? secondaryDate;

  /// Provides string to display as title.
  final StringProvider? dateStringBuilder;

  /// Builds the custom header title.
  ///
  /// This is useful when we need to add icon or something with the title.
  ///
  /// If [titleBuilder] is provided, [onTitleTapped] will be ignored.
  ///
  /// So, you need to handle the tap event manually if required.
  ///
  final WidgetBuilder? titleBuilder;

  // TODO: Need to remove after next major release
  /// background color of header.
  ///
  /// NOTE: This property is deprecated.
  /// Use [HeaderStyle.decoration] to provide colors to header.
  @Deprecated("Use HeaderStyle.decoration to provide background")
  final Color backgroundColor;

  // TODO: Need to remove after next major release
  /// Color of icons at both sides of header.
  ///
  /// NOTE: This property id deprecated. Use
  /// [HeaderStyle.leftIconConfig] or [HeaderStyle.rightIconConfig]
  /// to provide style to respective icons.
  ///
  @Deprecated("Use HeaderStyle to provide icon color")
  final Color? iconColor;

  /// Style for Calendar's header
  final HeaderStyle headerStyle;

  /// Common header for month and day view In this header user can define format
  /// in which date will be displayed by providing [dateStringBuilder] function.
  const CalendarPageHeader({
    Key? key,
    required this.date,
    this.dateStringBuilder,
    this.titleBuilder,
    this.onNextDay,
    this.onTitleTapped,
    this.onPreviousDay,
    this.secondaryDate,
    @Deprecated("Use HeaderStyle.decoration to provide background")
    this.backgroundColor = Constants.headerBackground,
    @Deprecated("Use HeaderStyle to provide icon color")
    this.iconColor = Constants.black,
    this.headerStyle = const HeaderStyle(),
  })  : assert(
            titleBuilder != null || dateStringBuilder != null,
            'titleBuilder and dateStringBuilder '
            'can not be null at the same time'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      decoration:
          headerStyle.decoration ?? BoxDecoration(color: backgroundColor),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: headerStyle.mainAxisSize,
        mainAxisAlignment: headerStyle.mainAxisAlignment,
        children: [
          if (headerStyle.leftIconVisible && headerStyle.leftIconConfig != null)
            headerStyle.leftIconConfig!.icon?.call(context) ??
                IconButton(
                  onPressed: onPreviousDay,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: headerStyle.leftIconPadding ??
                      headerStyle.leftIconConfig!.padding,
                  icon: headerStyle.leftIcon ??
                      Icon(
                        Icons.chevron_left,
                        size: headerStyle.leftIconConfig!.size,
                        color: iconColor ?? headerStyle.leftIconConfig!.color,
                      ),
                ),
          Expanded(
            child: titleBuilder != null
                ? DefaultTextStyle.merge(
                    style: headerStyle.headerTextStyle,
                    textAlign: headerStyle.titleAlign,
                    child: titleBuilder!(context),
                  )
                : InkWell(
                    onTap: onTitleTapped,
                    child: DefaultTextStyle.merge(
                      child: Text(
                        dateStringBuilder?.call(date,
                                secondaryDate: secondaryDate) ??
                            '',
                        textAlign: headerStyle.titleAlign,
                        style: headerStyle.headerTextStyle,
                      ),
                    ),
                  ),
          ),
          if (headerStyle.rightIconVisible &&
              headerStyle.rightIconConfig != null)
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
                    size: headerStyle.rightIconConfig?.size,
                    color: iconColor ?? headerStyle.rightIconConfig?.color,
                  ),
            ),
        ],
      ),
    );
  }
}
