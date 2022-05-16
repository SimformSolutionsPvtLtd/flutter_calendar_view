// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'calendar_event_data.dart';

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

typedef WeekDayBuilder = Widget Function(
  int day,
);

typedef DateWidgetBuilder = Widget Function(
  DateTime date,
);

typedef CalendarPageChangeCallBack = void Function(DateTime date, int page);

typedef PageChangeCallback = void Function(
  DateTime date,
  CalendarEventData event,
);

typedef StringProvider = String Function(DateTime date,
    {DateTime? secondaryDate});

typedef WeekPageHeaderBuilder = Widget Function(
    DateTime startDate, DateTime endDate);

typedef TileTapCallback<T extends Object?> = void Function(
    CalendarEventData<T> event, DateTime date);

typedef CellTapCallback<T extends Object?> = void Function(
    List<CalendarEventData<T>> events, DateTime date);

typedef DatePressCallback = void Function(DateTime date);

typedef EventFilter<T extends Object?> = List<CalendarEventData<T>> Function(
    DateTime date, List<CalendarEventData<T>> events);
