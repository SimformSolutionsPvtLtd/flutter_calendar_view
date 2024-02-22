// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';

typedef CellBuilder<T extends Object?> = Widget Function(
  DateTime date,
  List<CalendarEventData<T>> event,
  bool isToday,
  bool isInMonth,
);

typedef EventTileBuilder<T extends Object?> = Widget Function(
  DateTime date,
  List<CalendarEventData<T>> events,
  Rect boundary,
  DateTime startDuration,
  DateTime endDuration,
);

typedef DetectorBuilder<T extends Object?> = Widget Function({
  required DateTime date,
  required double height,
  required double width,
  required double heightPerMinute,
  required MinuteSlotSize minuteSlotSize,
});

typedef WeekDayBuilder = Widget Function(
  int day,
);

typedef DateWidgetBuilder = Widget Function(DateTime date);

typedef HeaderTitleCallback = Future<void> Function(DateTime date);

typedef WeekNumberBuilder = Widget? Function(
  DateTime firstDayOfWeek,
);

typedef FullDayEventBuilder<T> = Widget Function(
    List<CalendarEventData<T>> events, DateTime date);

typedef CalendarPageChangeCallBack = void Function(DateTime date, int page);

typedef PageChangeCallback = void Function(
  DateTime date,
  CalendarEventData event,
);

typedef StringProvider = String Function(DateTime date,
    {DateTime? secondaryDate});

typedef WeekPageHeaderBuilder = Widget Function(
  DateTime startDate,
  DateTime endDate,
);

typedef TileTapCallback<T extends Object?> = void Function(
    CalendarEventData<T> event, DateTime date);

typedef CellTapCallback<T extends Object?> = void Function(
    List<CalendarEventData<T>> events, DateTime date);

typedef DatePressCallback = void Function(DateTime date);

typedef DateTapCallback = void Function(DateTime date);

typedef EventFilter<T extends Object?> = List<CalendarEventData<T>> Function(
    DateTime date, List<CalendarEventData<T>> events);

/// Comparator for sorting events.
typedef EventSorter<T extends Object?> = int Function(
    CalendarEventData<T> a, CalendarEventData<T> b);

typedef CustomHourLinePainter = CustomPainter Function(
    Color lineColor,
    double lineHeight,
    double offset,
    double minuteHeight,
    bool showVerticalLine,
    double verticalLineOffset,
    LineStyle lineStyle,
    double dashWidth,
    double dashSpaceWidth,
    double emulateVerticalOffsetBy,
    int startHour);

typedef TestPredicate<T> = bool Function(T element);
