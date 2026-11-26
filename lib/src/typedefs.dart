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
  bool isSelected,
  bool hideDaysNotInMonth,
);

typedef EventTileBuilder<T extends Object?> = Widget Function(
  DateTime date,
  List<CalendarEventData<T>> events,
  Rect boundary,
  DateTime startDuration,
  DateTime endDuration,
);

/// {@template calendar_view.time_slot_builder_doc}
/// Builds the background widget for each visible time slot.
///
/// Useful for highlighting unavailable hours, business hours or blocked time,
/// or for showing an image or an illustration in a slot.
///
/// The returned widget fills the slot (the width of one day column and the
/// height of one slot) and is drawn behind the events. To paint a plain color,
/// return `ColoredBox(color: color)`. Return `null` to leave a slot empty; no
/// widget is built for it.
///
/// Slot granularity follows the view's `minuteSlotSize`. The builder is called
/// for every visible slot whenever the page builds, so keep it cheap. Slots
/// are not interactive: they sit behind the events and the tap detectors and
/// never receive gestures.
/// {@endtemplate}
typedef TimeSlotBuilder = Widget? Function(
  DateTime date,
  DateTime slotStartTime,
  DateTime slotEndTime,
  int index,
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

typedef TileTapDetailsCallback<T extends Object?> = void Function(
  CalendarEventData<T> event,
  DateTime date,
  TapUpDetails? tapDetails,
);

typedef TileLongTapDetailsCallback<T extends Object?> = void Function(
  CalendarEventData<T> event,
  DateTime date,
  LongPressStartDetails? longPressDetails,
);

typedef TileDoubleTapDetailsCallback<T extends Object?> = void Function(
  CalendarEventData<T> event,
  DateTime date,
  TapDownDetails? doubleTapDetails,
);

typedef CellTapCallback<T extends Object?> = void Function(
    List<CalendarEventData<T>> events, DateTime date);

typedef DatePressCallback = void Function(DateTime date);

typedef DateLongPressMoveUpdateCallback = void Function(
  DateTime date,
  LongPressMoveUpdateDetails details,
);

typedef DateTapCallback = void Function(DateTime date);

typedef TimestampCallback = void Function(DateTime date);

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
  int startHour,
  int endHour,
);

typedef TestPredicate<T> = bool Function(T element);
