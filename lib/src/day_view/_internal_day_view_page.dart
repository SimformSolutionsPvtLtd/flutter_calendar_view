// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../components/_internal_components.dart';
import '../components/event_scroll_notifier.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../modals.dart';
import '../painters.dart';
import '../typedefs.dart';

/// Defines a single day page.
class InternalDayViewPage<T extends Object?> extends StatelessWidget {
  /// Width of the page
  final double width;

  /// Height of the page.
  final double height;

  /// Date for which we are displaying page.
  final DateTime date;

  /// A builder that returns a widget to show event on screen.
  final EventTileBuilder<T> eventTileBuilder;

  /// Controller for calendar
  final EventController<T> controller;

  /// A builder that builds time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Flag to display live time indicator.
  /// If true then indicator will be displayed else not.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final HourIndicatorSettings liveTimeIndicatorSettings;

  /// Height occupied by one minute of time span.
  final double heightPerMinute;

  /// Width of time line.
  final double timeLineWidth;

  /// Offset for time line widgets.
  final double timeLineOffset;

  /// Height occupied by one hour of time span.
  final double hourHeight;

  /// event arranger to arrange events.
  final EventArranger<T> eventArranger;

  /// Flag to display vertical line.
  final bool showVerticalLine;

  /// Offset  of vertical line.
  final double verticalLineOffset;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// Called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  final MinuteSlotSize minuteSlotSize;

  /// Notifies if there is any event that needs to be visible instantly.
  final EventScrollConfiguration scrollNotifier;

  /// Defines a single day page.
  const InternalDayViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.width,
    required this.date,
    required this.eventTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.showLiveLine,
    required this.liveTimeIndicatorSettings,
    required this.heightPerMinute,
    required this.timeLineWidth,
    required this.timeLineOffset,
    required this.height,
    required this.hourHeight,
    required this.eventArranger,
    required this.verticalLineOffset,
    required this.onTileTap,
    required this.onDateLongPress,
    required this.minuteSlotSize,
    required this.scrollNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: HourLinePainter(
              lineColor: hourIndicatorSettings.color,
              lineHeight: hourIndicatorSettings.height,
              offset: timeLineWidth + hourIndicatorSettings.offset,
              minuteHeight: heightPerMinute,
              verticalLineOffset: verticalLineOffset,
              showVerticalLine: showVerticalLine,
            ),
          ),
          PressDetector(
            width: width,
            height: height,
            heightPerMinute: heightPerMinute,
            date: date,
            onDateLongPress: onDateLongPress,
            minuteSlotSize: minuteSlotSize,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: EventGenerator<T>(
              height: height,
              date: date,
              onTileTap: onTileTap,
              eventArranger: eventArranger,
              events: controller.getEventsOnDay(date),
              heightPerMinute: heightPerMinute,
              eventTileBuilder: eventTileBuilder,
              scrollNotifier: scrollNotifier,
              width: width -
                  timeLineWidth -
                  hourIndicatorSettings.offset -
                  verticalLineOffset,
            ),
          ),
          TimeLine(
            height: height,
            hourHeight: hourHeight,
            timeLineBuilder: timeLineBuilder,
            timeLineOffset: timeLineOffset,
            timeLineWidth: timeLineWidth,
            key: ValueKey(heightPerMinute),
          ),
          if (showLiveLine && liveTimeIndicatorSettings.height > 0)
            IgnorePointer(
              child: LiveTimeIndicator(
                liveTimeIndicatorSettings: liveTimeIndicatorSettings,
                width: width,
                height: height,
                heightPerMinute: heightPerMinute,
                timeLineWidth: timeLineWidth,
              ),
            ),
        ],
      ),
    );
  }
}
