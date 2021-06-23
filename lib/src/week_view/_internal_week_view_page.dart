import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/components/_internal_components.dart';
import 'package:flutter_calendar_page/src/extensions.dart';

import '../painters.dart';

/// A single page for week view.
class InternalWeekViewPage<T> extends StatelessWidget {
  /// Width of the page.
  final double width;

  /// Height of the page.
  final double height;

  /// Dates to display on page.
  final List<DateTime> dates;

  /// Builds tile for a single event.
  final EventTileBuilder<T> eventTileBuilder;

  /// A calendar controller that controls all the events and rebuilds widget if event(s) are added or removed.
  final CalendarController<T> controller;

  /// A builder to build time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Flag to display live line.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final HourIndicatorSettings liveTimeIndicatorSettings;

  ///  Height occupied by one minute time span.
  final double heightPerMinute;

  /// Width of timeline.
  final double timeLineWidth;

  /// Offset of timeline.
  final double timeLineOffset;

  /// Height occupied by one hour time span.
  final double hourHeight;

  /// Arranger to arrange events.
  final EventArranger<T> eventArranger;

  /// Flag to display vertical line or not.
  final bool showVerticalLine;

  /// Offset for vertical line offset.
  final double verticalLineOffset;

  /// Builder for week day title.
  final DateWidgetBuilder weekDayBuilder;

  /// Height of week title.
  final double weekTitleHeight;

  /// Width of week title.
  final double weekTitleWidth;

  /// A single page for week view.
  const InternalWeekViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.weekTitleHeight,
    required this.weekDayBuilder,
    required this.width,
    required this.dates,
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
    required this.weekTitleWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + weekTitleHeight,
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: weekTitleHeight,
            width: width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: weekTitleHeight,
                  width: timeLineWidth,
                ),
                ...List.generate(
                  dates.length,
                  (index) => SizedBox(
                    height: weekTitleHeight,
                    width: weekTitleWidth,
                    child: weekDayBuilder(
                      dates[index],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
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
                  child: SizedBox(
                    width: weekTitleWidth * dates.length,
                    height: height,
                    child: Row(
                      children: [
                        ...List.generate(
                          dates.length,
                          (index) => Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                              color: hourIndicatorSettings.color,
                              width: hourIndicatorSettings.height,
                            ))),
                            height: height,
                            width: weekTitleWidth,
                            child: EventGenerator<T>(
                              height: height,
                              date: dates[index],
                              width: weekTitleWidth,
                              eventArranger: eventArranger,
                              eventTileBuilder: eventTileBuilder,
                              events: controller.getEventsOnDay(dates[index]),
                              heightPerMinute: heightPerMinute,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                TimeLine(
                  timeLineWidth: timeLineWidth,
                  hourHeight: hourHeight,
                  height: height,
                  timeLineOffset: timeLineOffset,
                  timeLineBuilder: timeLineBuilder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
