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

  /// Builds custom PressDetector widget
  final DetectorBuilder dayDetectorBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Custom painter for hour line.
  final CustomHourLinePainter hourLinePainter;

  /// Flag to display live time indicator.
  /// If true then indicator will be displayed else not.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final LiveTimeIndicatorSettings liveTimeIndicatorSettings;

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

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onTileLongTap;

  /// Called when user double tap on any event tile.
  final CellTapCallback<T>? onTileDoubleTap;

  /// Called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Called when user taps on day view page.
  ///
  /// This callback will have a date parameter which
  /// will provide the time span on which user has tapped.
  ///
  /// Ex, User Taps on Date page with date 11/01/2022 and time span is 1PM to 2PM.
  /// then DateTime object will be  DateTime(2022,01,11,1,0)
  final DateTapCallback? onDateTap;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  final MinuteSlotSize minuteSlotSize;

  /// Notifies if there is any event that needs to be visible instantly.
  final EventScrollConfiguration scrollNotifier;

  /// Display full day events.
  final FullDayEventBuilder<T> fullDayEventBuilder;

  /// Flag to display half hours.
  final bool showHalfHours;

  /// Flag to display quarter hours.
  final bool showQuarterHours;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings halfHourIndicatorSettings;

  /// First hour displayed in the layout
  final int startHour;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings quarterHourIndicatorSettings;

  final ScrollController scrollController;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// Defines a single day page.
  const InternalDayViewPage({
    super.key,
    required this.showVerticalLine,
    required this.width,
    required this.date,
    required this.eventTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.hourLinePainter,
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
    required this.onTileLongTap,
    required this.onDateLongPress,
    required this.onDateTap,
    required this.minuteSlotSize,
    required this.scrollNotifier,
    required this.fullDayEventBuilder,
    required this.scrollController,
    required this.dayDetectorBuilder,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.halfHourIndicatorSettings,
    required this.startHour,
    required this.quarterHourIndicatorSettings,
    required this.emulateVerticalOffsetBy,
    required this.onTileDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final fullDayEventList = controller.getFullDayEvent(date);
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          fullDayEventList.isEmpty
              ? SizedBox.shrink()
              : fullDayEventBuilder(fullDayEventList, date),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
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
                          lineStyle: hourIndicatorSettings.lineStyle,
                          dashWidth: hourIndicatorSettings.dashWidth,
                          dashSpaceWidth: hourIndicatorSettings.dashSpaceWidth,
                          emulateVerticalOffsetBy: emulateVerticalOffsetBy,
                          startHour: startHour),
                    ),
                    if (showHalfHours)
                      CustomPaint(
                        size: Size(width, height),
                        painter: HalfHourLinePainter(
                          lineColor: halfHourIndicatorSettings.color,
                          lineHeight: halfHourIndicatorSettings.height,
                          offset:
                              timeLineWidth + halfHourIndicatorSettings.offset,
                          minuteHeight: heightPerMinute,
                          lineStyle: halfHourIndicatorSettings.lineStyle,
                          dashWidth: halfHourIndicatorSettings.dashWidth,
                          dashSpaceWidth:
                              halfHourIndicatorSettings.dashSpaceWidth,
                          startHour: startHour,
                        ),
                      ),
                    if (showQuarterHours)
                      CustomPaint(
                        size: Size(width, height),
                        painter: QuarterHourLinePainter(
                          lineColor: quarterHourIndicatorSettings.color,
                          lineHeight: quarterHourIndicatorSettings.height,
                          offset: timeLineWidth +
                              quarterHourIndicatorSettings.offset,
                          minuteHeight: heightPerMinute,
                          lineStyle: quarterHourIndicatorSettings.lineStyle,
                          dashWidth: quarterHourIndicatorSettings.dashWidth,
                          dashSpaceWidth:
                              quarterHourIndicatorSettings.dashSpaceWidth,
                        ),
                      ),
                    dayDetectorBuilder(
                      width: width,
                      height: height,
                      heightPerMinute: heightPerMinute,
                      date: date,
                      minuteSlotSize: minuteSlotSize,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: EventGenerator<T>(
                        height: height,
                        date: date,
                        onTileLongTap: onTileLongTap,
                        onTileDoubleTap: onTileDoubleTap,
                        onTileTap: onTileTap,
                        eventArranger: eventArranger,
                        events: controller.getEventsOnDay(
                          date,
                          includeFullDayEvents: false,
                        ),
                        heightPerMinute: heightPerMinute,
                        eventTileBuilder: eventTileBuilder,
                        scrollNotifier: scrollNotifier,
                        startHour: startHour,
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
                      showHalfHours: showHalfHours,
                      startHour: startHour,
                      showQuarterHours: showQuarterHours,
                      key: ValueKey(heightPerMinute),
                      liveTimeIndicatorSettings: liveTimeIndicatorSettings,
                    ),
                    if (showLiveLine && liveTimeIndicatorSettings.height > 0)
                      IgnorePointer(
                        child: LiveTimeIndicator(
                          liveTimeIndicatorSettings: liveTimeIndicatorSettings,
                          width: width,
                          height: height,
                          heightPerMinute: heightPerMinute,
                          timeLineWidth: timeLineWidth,
                          startHour: startHour,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
