import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/components/_internal_components.dart';
import 'package:flutter_calendar_page/src/extensions.dart';

import '../modals.dart';
import '../painters.dart';

/// Defines a single day page.
class InternalDayViewPage<T> extends StatelessWidget {
  /// Width of the page
  final double width;

  /// Height of the page.
  final double height;

  /// Date for which we are displaying page.
  final DateTime date;

  /// A builder that returns a widget to show event on screen.
  final EventTileBuilder<T> eventTileBuilder;

  /// Controller for calendar
  final CalendarController<T> controller;

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
          if (showLiveLine && liveTimeIndicatorSettings.height > 0)
            LiveTimeIndicator(
              liveTimeIndicatorSettings: liveTimeIndicatorSettings,
              width: width,
              height: height,
              heightPerMinute: heightPerMinute,
              timeLineWidth: timeLineWidth,
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
