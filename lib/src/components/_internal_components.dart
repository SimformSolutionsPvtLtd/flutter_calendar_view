import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/calendar_event_data.dart';
import 'package:flutter_calendar_page/src/event_arrangers/event_arrangers.dart';
import 'package:flutter_calendar_page/src/extensions.dart';
import 'package:flutter_calendar_page/src/modals.dart';
import 'package:flutter_calendar_page/src/painters.dart';

/// Widget to display tile line according to current time.
class LiveTimeIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double timeLineWidth;
  final HourIndicatorSettings liveTimeIndicatorSettings;
  final double heightPerMinute;

  /// Widget to display tile line according to current time.
  const LiveTimeIndicator(
      {Key? key,
      required this.width,
      required this.height,
      required this.timeLineWidth,
      required this.liveTimeIndicatorSettings,
      required this.heightPerMinute})
      : super(key: key);

  @override
  LiveTimeIndicatorState createState() => LiveTimeIndicatorState();
}

class LiveTimeIndicatorState extends State<LiveTimeIndicator> {
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
    if (mounted) {
      setState(() {
        _currentDate = DateTime.now();
        _timer = Timer(Duration(minutes: 1), setTimer);
      });
    }
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

/// Time line to display time at left side of day or week view.
class TimeLine extends StatelessWidget {
  final double timeLineWidth;
  final double hourHeight;
  final double height;
  final double timeLineOffset;
  final double heightPerMinute;

  final DateWidgetBuilder timeLineBuilder;

  static DateTime get _date => DateTime.now();

  /// Time line to display time at left side of day or week view.
  const TimeLine(
      {Key? key,
      required this.timeLineWidth,
      required this.hourHeight,
      required this.height,
      required this.timeLineOffset,
      required this.heightPerMinute,
      required this.timeLineBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          for (int i = 1; i < Constants.hoursADay; i++)
            Positioned(
              top: hourHeight * i - timeLineOffset,
              left: 0,
              right: 0,
              bottom: height - (hourHeight * (i + 1)) + timeLineOffset,
              child: Container(
                height: hourHeight,
                width: timeLineWidth,
                child: timeLineBuilder.call(DateTime(
                  _date.year,
                  _date.month,
                  _date.day,
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
}

class EventGenerator<T> extends StatelessWidget {
  final double height;
  final double width;
  final List<CalendarEventData<T>> events;
  final double heightPerMinute;
  final EventArranger<T> eventArranger;
  final EventTileBuilder<T> eventTileBuilder;
  final DateTime date;

  const EventGenerator({
    Key? key,
    required this.height,
    required this.width,
    required this.events,
    required this.heightPerMinute,
    required this.eventArranger,
    required this.eventTileBuilder,
    required this.date,
  }) : super(key: key);

  List<Widget> _generateEvents() {
    List<OrganizedCalendarEventData<T>> events = eventArranger.arrange(
      events: this.events,
      height: height,
      width: width,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: _generateEvents(),
      ),
    );
  }
}
