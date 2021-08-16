import 'package:flutter/material.dart';

import 'calendar_event_data.dart';

typedef CellBuilder<T> = Widget Function(
  DateTime date,
  List<CalendarEventData<T>> event,
  bool isToday,
  bool isInMonth,
);

typedef EventTileBuilder<T> = Widget Function(
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
