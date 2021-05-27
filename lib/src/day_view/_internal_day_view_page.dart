import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/extensions.dart';

import '../painters.dart';
import 'modals.dart';

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

  Widget _buildTimeLine() {
    return ConstrainedBox(
      key: ValueKey(this.heightPerMinute),
      constraints: BoxConstraints(
        maxWidth: timeLineWidth,
        minWidth: timeLineWidth,
        maxHeight: height,
        minHeight: height,
      ),
      child: Stack(
        children: [
          for (int i = 1; i < 24; i++)
            Positioned(
              top: hourHeight * i - timeLineOffset,
              left: 0,
              right: 0,
              bottom: height - (hourHeight * (i + 1)) + timeLineOffset,
              child: Container(
                height: hourHeight,
                width: timeLineWidth,
                child: timeLineBuilder.call(DateTime(
                  date.year,
                  date.month,
                  date.day,
                  i,
                  0,
                  0,
                )),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          if (showLiveLine && liveTimeIndicatorSettings.height > 0)
            _LiveTimeIndicator(
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
            child: Container(
              height: height,
              width: width - timeLineWidth - hourIndicatorSettings.offset,
              child: Stack(
                children: _generateEvents(),
              ),
            ),
          ),
          Align(
            key: ValueKey(heightPerMinute),
            child: _buildTimeLine(),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

  List<Widget> _generateEvents() {
    List<OrganizedCalendarEventData<T>> events = eventArranger.arrange(
      events: controller.getEventsOnDay(date),
      height: height,
      width: width - timeLineWidth - hourIndicatorSettings.offset,
      heightPerMinute: heightPerMinute,
    );

    return List.generate(events.length, (index) {
      return Positioned(
        top: events[index].top,
        bottom: events[index].bottom,
        left: events[index].left,
        right: events[index].right,
        child: eventTileBuilder(
          date,
          events[index].events,
          Rect.fromLTWH(
              events[index].left,
              events[index].top,
              width - events[index].right - events[index].left,
              height - events[index].bottom - events[index].top),
          events[index].startDuration ?? DateTime.now(),
          events[index].endDuration ?? DateTime.now(),
        ),
      );
    });
  }
}

/// This widget displays time line on day view page based on current time.
class _LiveTimeIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double timeLineWidth;
  final HourIndicatorSettings liveTimeIndicatorSettings;
  final double heightPerMinute;

  /// This widget displays time line on day view page based on current time.
  const _LiveTimeIndicator(
      {Key? key,
      required this.width,
      required this.height,
      required this.timeLineWidth,
      required this.liveTimeIndicatorSettings,
      required this.heightPerMinute})
      : super(key: key);

  @override
  _LiveTimeIndicatorState createState() => _LiveTimeIndicatorState();
}

class _LiveTimeIndicatorState extends State<_LiveTimeIndicator> {
  late Timer _timer;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();

    _currentDate = DateTime.now();
    _timer = Timer(Duration(seconds: 1), setTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setTimer() {
    if (mounted)
      setState(() {
        _currentDate = DateTime.now();
        _timer = Timer(Duration(seconds: 1), setTimer);
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: CurrentTimeLinePainter(
        color: widget.liveTimeIndicatorSettings.color,
        height: widget.liveTimeIndicatorSettings.height,
        offset: Offset(
          widget.timeLineWidth + widget.liveTimeIndicatorSettings.offset,
          _currentDate.getTotalMinutes * widget.heightPerMinute,
        ),
      ),
    );
  }
}
