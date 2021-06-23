import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/components/_internal_components.dart';
import 'package:flutter_calendar_page/src/extensions.dart';

import '../modals.dart';
import '../painters.dart';

/// Defines a single day page.
class InternalDayViewPage<T> extends StatelessWidget {
  final double width;
  final double height;
  final DateTime date;
  final EventTileBuilder<T> eventTileBuilder;
  final CalendarController<T> controller;
  final DateWidgetBuilder timeLineBuilder;
  final HourIndicatorSettings hourIndicatorSettings;
  final bool showLiveLine;
  final HourIndicatorSettings liveTimeIndicatorSettings;
  final double heightPerMinute;
  final double timeLineWidth;
  final double timeLineOffset;
  final double hourHeight;
  final EventArranger<T> eventArranger;
  final bool showVerticalLine;
  final double verticalLineOffset;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          if (showLiveLine && liveTimeIndicatorSettings.height > 0)
            LiveTimeIndicator(
              liveTimeIndicatorSettings: liveTimeIndicatorSettings,
              width: width,
              height: height,
              heightPerMinute: heightPerMinute,
              timeLineWidth: timeLineWidth,
            ),
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
          Align(
            alignment: Alignment.centerRight,
            child: EventGenerator<T>(
              height: height,
              date: date,
              eventArranger: eventArranger,
              events: controller.getEventsOnDay(date),
              heightPerMinute: heightPerMinute,
              eventTileBuilder: eventTileBuilder,
              width: width -
                  timeLineWidth -
                  hourIndicatorSettings.offset -
                  verticalLineOffset,
            ),
          ),
          TimeLine(
            height: height,
            heightPerMinute: heightPerMinute,
            hourHeight: hourHeight,
            timeLineBuilder: timeLineBuilder,
            timeLineOffset: timeLineOffset,
            timeLineWidth: timeLineWidth,
            key: ValueKey(heightPerMinute),
          ),
        ],
      ),
    );
  }
}
