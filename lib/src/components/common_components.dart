// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../enumerations.dart';
import '../extensions.dart';
import '../painters.dart';
import '../typedefs.dart';
import 'components.dart';

/// This will be used in day and week view
class DefaultPressDetector extends StatelessWidget {
  /// default press detector builder used in week and day view
  const DefaultPressDetector({
    required this.date,
    required this.height,
    required this.width,
    required this.heightPerMinute,
    required this.minuteSlotSize,
    this.onDateTap,
    this.onDateLongPress,
    this.startHour = 0,
  });

  final DateTime date;
  final double height;
  final double width;
  final double heightPerMinute;
  final MinuteSlotSize minuteSlotSize;
  final DateTapCallback? onDateTap;
  final DatePressCallback? onDateLongPress;
  final int startHour;

  @override
  Widget build(BuildContext context) {
    final heightPerSlot = minuteSlotSize.minutes * heightPerMinute;
    final slots = (Constants.hoursADay * 60) ~/ minuteSlotSize.minutes;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          for (int i = 0; i < slots; i++)
            Positioned(
              top: heightPerSlot * i,
              left: 0,
              right: 0,
              bottom: height - (heightPerSlot * (i + 1)),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPress: () => onDateLongPress?.call(
                  getSlotDateTime(i),
                ),
                onTap: () => onDateTap?.call(
                  getSlotDateTime(i),
                ),
                child: SizedBox(
                  width: width,
                  height: heightPerSlot,
                ),
              ),
            ),
        ],
      ),
    );
  }

  DateTime getSlotDateTime(int slot) => DateTime(
        date.year,
        date.month,
        date.day,
        0,
        (minuteSlotSize.minutes * slot) + (startHour * 60),
      );
}

/// This will be used in day and week view
class DefaultEventTile<T> extends StatelessWidget {
  const DefaultEventTile({
    required this.date,
    required this.events,
    required this.boundary,
    required this.startDuration,
    required this.endDuration,
  });

  final DateTime date;
  final List<CalendarEventData<T>> events;
  final Rect boundary;
  final DateTime startDuration;
  final DateTime endDuration;

  @override
  Widget build(BuildContext context) {
    if (events.isNotEmpty) {
      final event = events[0];
      return RoundedEventTile(
        borderRadius: BorderRadius.circular(10.0),
        title: event.title,
        totalEvents: events.length - 1,
        description: event.description,
        padding: EdgeInsets.all(10.0),
        backgroundColor: event.color,
        margin: EdgeInsets.all(2.0),
        titleStyle: event.titleStyle,
        descriptionStyle: event.descriptionStyle,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

/// Renders time-slot colored backgrounds for calendar views.
///
/// Accepts one or more [dates] (columns). For a single-day view pass a
/// one-element list; for week/multi-day views pass all visible dates.
/// Each column is painted with per-slot colors returned by
/// [timeSlotColorBuilder] and wrapped in a [RepaintBoundary] so repaints
/// are isolated to individual columns.
class TimeSlotBackgrounds extends StatelessWidget {
  /// Dates to render (one column per date).
  final List<DateTime> dates;

  /// Pixel width of each date column.
  final double columnWidth;

  /// Total pixel height of the scrollable area.
  final double height;

  /// Pixel height per minute used to compute slot height.
  final double heightPerMinute;

  /// Duration of each time slot.
  final MinuteSlotSize minuteSlotSize;

  /// First hour shown in the view.
  final int startHour;

  /// Last hour shown in the view.
  final int endHour;

  /// Callback that returns a background [Color] for each slot.
  final TimeSlotColorBuilder timeSlotColorBuilder;

  const TimeSlotBackgrounds({
    Key? key,
    required this.dates,
    required this.columnWidth,
    required this.height,
    required this.heightPerMinute,
    required this.minuteSlotSize,
    required this.startHour,
    required this.endHour,
    required this.timeSlotColorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Number of minutes each slot occupies (e.g. 15, 30, or 60).
    final slotMinutes = minuteSlotSize.minutes;
    // Pixel height of a single time slot rectangle.
    final heightPerSlot = heightPerMinute * slotMinutes;
    // Total number of slots that fit between startHour and endHour.
    final totalSlots = ((endHour - startHour) * 60) ~/ slotMinutes;
    // Convenience Duration used when computing slot start/end DateTimes.
    final slotDuration = Duration(minutes: slotMinutes);
    // Whether the ambient text direction is left-to-right.
    // Used to align the background layer correctly in RTL layouts.
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return Align(
      alignment: isLtr ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        width: columnWidth * dates.length,
        height: height,
        child: Row(
          children: List.generate(dates.length, (dayIndex) {
            final dayDate = dates[dayIndex];
            final dayStart = DateTime(
              dayDate.year,
              dayDate.month,
              dayDate.day,
              startHour,
            );
            final slotColors = List<Color>.generate(
              totalSlots,
              (slotIndex) {
                final slotStartTime = dayStart.add(slotDuration * slotIndex);
                final slotEndTime = slotStartTime.add(slotDuration);
                return timeSlotColorBuilder(
                  dayDate,
                  slotStartTime,
                  slotEndTime,
                  slotIndex,
                );
              },
            );
            return ClipRect(
              child: SizedBox(
                width: columnWidth,
                height: height,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: TimeSlotBackgroundPainter(
                      heightPerSlot: heightPerSlot,
                      slotColors: slotColors,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
