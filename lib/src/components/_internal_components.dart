import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/src/calendar_event_data.dart';
import 'package:flutter_calendar_page/src/event_arrangers/event_arrangers.dart';
import 'package:flutter_calendar_page/src/extensions.dart';
import 'package:flutter_calendar_page/src/modals.dart';
import 'package:flutter_calendar_page/src/painters.dart';

import '../constants.dart';
import '../extensions.dart';

/// Widget to display tile line according to current time.
class LiveTimeIndicator extends StatefulWidget {
  /// Width of indicator
  final double width;

  /// Height of total display area indicator will be displayed within this height.
  final double height;

  /// Width of time line use to calculate offset of indicator.
  final double timeLineWidth;

  /// settings for time line. Defines color, extra offset, and height of indicator.
  final HourIndicatorSettings liveTimeIndicatorSettings;

  /// Defines height occupied by one minute.
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
  _LiveTimeIndicatorState createState() => _LiveTimeIndicatorState();
}

class _LiveTimeIndicatorState extends State<LiveTimeIndicator> {
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
        _timer = Timer(Duration(seconds: 1), setTimer);
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
  /// Width of timeline
  final double timeLineWidth;

  /// Height for one hour.
  final double hourHeight;

  /// Total height of timeline.
  final double height;

  /// Offset for time line
  final double timeLineOffset;

  final DateWidgetBuilder timeLineBuilder;

  static DateTime get _date => DateTime.now();

  /// Time line to display time at left side of day or week view.
  const TimeLine(
      {Key? key,
      required this.timeLineWidth,
      required this.hourHeight,
      required this.height,
      required this.timeLineOffset,
      required this.timeLineBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: ValueKey(this.hourHeight),
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

/// A widget that display event tiles in day/week view.
class EventGenerator<T> extends StatelessWidget {
  /// Height of display area
  final double height;

  /// width of display area
  final double width;

  /// List of events to display.
  final List<CalendarEventData<T>> events;

  /// Defines height of single minute in day/week view page.
  final double heightPerMinute;

  /// Defines how to arrange events.
  final EventArranger<T> eventArranger;

  /// Defines how event tile will be displayed.
  final EventTileBuilder<T> eventTileBuilder;

  /// Defines date for which events will be displayed in given display area.
  final DateTime date;

  /// A widget that display event tiles in day/week view.
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

  /// Arrange events and returns list of [Widget] that displays event tile on display area.
  /// This method uses [eventArranger] to get position of events and [eventTileBuilder] to display events.
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
