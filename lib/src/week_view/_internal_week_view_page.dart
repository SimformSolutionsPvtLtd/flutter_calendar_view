import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/components/_internal_components.dart';
import 'package:flutter_calendar_page/src/extensions.dart';

import '../painters.dart';

class InternalWeekViewPage<T> extends StatelessWidget {
  final double width;
  final double height;
  final List<DateTime> dates;
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
  final DateWidgetBuilder weekDayBuilder;
  final double weekTitleHeight;
  final double weekTitleWidth;

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
                  heightPerMinute: heightPerMinute,
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
