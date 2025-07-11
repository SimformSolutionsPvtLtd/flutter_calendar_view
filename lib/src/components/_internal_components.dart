// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../extensions.dart';
import '../modals.dart';
import '../painters.dart';
import '../typedefs.dart';
import 'event_scroll_notifier.dart';

/// Widget to display tile line according to current time.
class LiveTimeIndicator extends StatefulWidget {
  /// Width of indicator
  final double width;

  /// Height of total display area indicator will be displayed
  /// within this height.
  final double height;

  /// Width of time line use to calculate offset of indicator.
  final double timeLineWidth;

  /// settings for time line. Defines color, extra offset,
  /// height of indicator and also allow to show time with custom format.
  final LiveTimeIndicatorSettings liveTimeIndicatorSettings;

  /// Defines height occupied by one minute.
  final double heightPerMinute;

  /// First hour displayed in the layout, goes from 0 to 24
  final int startHour;

  /// This field will be used to set end hour for day and week view
  final int endHour;

  /// Flag to show only today's events.
  final bool onlyShowToday;

  /// Widget to display tile line according to current time.
  const LiveTimeIndicator(
      {Key? key,
      required this.width,
      required this.height,
      required this.timeLineWidth,
      required this.liveTimeIndicatorSettings,
      required this.heightPerMinute,
      required this.startHour,
      this.endHour = Constants.hoursADay,
      this.onlyShowToday = false})
      : super(key: key);

  @override
  _LiveTimeIndicatorState createState() => _LiveTimeIndicatorState();
}

class _LiveTimeIndicatorState extends State<LiveTimeIndicator> {
  late Timer _timer;
  late TimeOfDay _currentTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _currentTime = _updateCurrentTime();
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Returns the current time to display in the live time indicator.
  ///
  /// If [LiveTimeIndicatorSettings.currentTimeProvider] is provided,
  /// uses that function to get the current time.
  ///
  /// Otherwise falls back to [DateTime.now] for the device's local time.
  DateTime _getCurrentDateTime() {
    final settings = widget.liveTimeIndicatorSettings;
    return settings.currentTimeProvider?.call() ?? DateTime.now();
  }

  /// Update the current time based on timezone settings
  TimeOfDay _updateCurrentTime() {
    final dateTime = _getCurrentDateTime();
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  /// Creates an recursive call that runs every 1 seconds.
  /// This will rebuild TimeLineIndicator every second. This will allow us
  /// to indicate live time in Week and Day view.
  void _onTick(Timer? timer) {
    final time = _currentTime;
    _currentTime = _updateCurrentTime();
    if (time == _currentTime || !mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentHour = _currentTime.hourOfPeriod.appendLeadingZero();
    final currentMinute = _currentTime.minute.appendLeadingZero();
    final currentPeriod = _currentTime.period.name;
    final currentDateTime = _getCurrentDateTime();
    final timeString = widget.liveTimeIndicatorSettings.timeStringBuilder
            ?.call(currentDateTime) ??
        '$currentHour:$currentMinute $currentPeriod';

    /// remove startHour minute from [_currentTime.getTotalMinutes]
    /// to set dy offset of live time indicator
    final startMinutes = widget.startHour * 60;

    /// Check if live time is not between startHour and endHour if it is then
    /// don't show live time indicator
    ///
    /// e.g. startHour : 1:00, endHour : 13:00 and live time is 17:00
    /// then no need to display live time indicator on timeline
    if (_currentTime.hour > widget.startHour &&
        widget.endHour <= _currentTime.hour) {
      return SizedBox.shrink();
    }
    return CustomPaint(
      size: Size(widget.width, widget.liveTimeIndicatorSettings.height),
      painter: CurrentTimeLinePainter(
        color: widget.liveTimeIndicatorSettings.color,
        height: widget.liveTimeIndicatorSettings.height,
        offset: Offset(
          widget.onlyShowToday
              ? 0
              : widget.timeLineWidth + widget.liveTimeIndicatorSettings.offset,
          (_currentTime.getTotalMinutes - startMinutes) *
              widget.heightPerMinute,
        ),
        timeString: timeString,
        showBullet: widget.liveTimeIndicatorSettings.showBullet,
        showTime: widget.liveTimeIndicatorSettings.showTime,
        showTimeBackgroundView:
            widget.liveTimeIndicatorSettings.showTimeBackgroundView,
        bulletRadius: widget.liveTimeIndicatorSettings.bulletRadius,
        timeBackgroundViewWidth:
            widget.liveTimeIndicatorSettings.timeBackgroundViewWidth,
      ),
    );
  }
}

/// Time line to display time at left side of day or week view.
class TimeLine extends StatefulWidget {
  /// Width of timeline
  final double timeLineWidth;

  /// Height for one hour.
  final double hourHeight;

  /// Total height of timeline.
  final double height;

  /// Offset for time line
  final double timeLineOffset;

  /// This will display time string in timeline.
  final DateWidgetBuilder timeLineBuilder;

  /// This method will be called when user taps on timestamp in timeline.
  final TimestampCallback? onTimestampTap;

  /// Flag to display half hours.
  final bool showHalfHours;

  /// First hour displayed in the layout
  final int startHour;

  /// Flag to display quarter hours.
  final bool showQuarterHours;

  /// settings for time line. Defines color, extra offset,
  /// height of indicator and also allow to show time with custom format.
  final LiveTimeIndicatorSettings liveTimeIndicatorSettings;

  double get _halfHourHeight => hourHeight / 2;

  /// This field will be used to set end hour for day and week view
  final int endHour;

  /// Time line to display time at left side of day or week view.
  const TimeLine({
    Key? key,
    required this.timeLineWidth,
    required this.hourHeight,
    required this.height,
    required this.timeLineOffset,
    required this.timeLineBuilder,
    required this.onTimestampTap,
    this.startHour = 0,
    this.showHalfHours = false,
    this.showQuarterHours = false,
    required this.liveTimeIndicatorSettings,
    this.endHour = Constants.hoursADay,
  }) : super(key: key);

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  late Timer _timer;
  late TimeOfDay _currentTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _currentTime = _updateCurrentTime();
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Returns the current time for the timeline, respecting timezone settings.
  DateTime _getCurrentDateTime() {
    final settings = widget.liveTimeIndicatorSettings;

    if (settings.currentTimeProvider != null) {
      return settings.currentTimeProvider!();
    } else {
      return DateTime.now();
    }
  }

  /// Update the current time based on timezone settings
  TimeOfDay _updateCurrentTime() {
    final dateTime = _getCurrentDateTime();
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  /// Creates an recursive call that runs every 1 seconds.
  /// This will rebuild TimeLine every second. This will allow us
  /// to show/hide time line when there is overlap with
  /// live time line indicator in Week and Day view.
  void _onTick(Timer? timer) {
    final time = _currentTime;
    _currentTime = _updateCurrentTime();
    if (time == _currentTime || !mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: ValueKey(widget.hourHeight),
      constraints: BoxConstraints(
        maxWidth: widget.timeLineWidth,
        minWidth: widget.timeLineWidth,
        maxHeight: widget.height,
        minHeight: widget.height,
      ),
      child: Stack(
        children: [
          for (int i = widget.startHour + 1; i < widget.endHour; i++)
            _timelinePositioned(
              topPosition: widget.hourHeight * (i - widget.startHour) -
                  widget.timeLineOffset,
              bottomPosition: widget.height -
                  (widget.hourHeight * (i - widget.startHour + 1)) +
                  widget.timeLineOffset,
              hour: i,
            ),
          if (widget.showHalfHours)
            for (int i = widget.startHour; i < widget.endHour; i++)
              _timelinePositioned(
                topPosition: widget.hourHeight * (i - widget.startHour) -
                    widget.timeLineOffset +
                    widget._halfHourHeight,
                bottomPosition: widget.height -
                    (widget.hourHeight * (i - widget.startHour + 1)) +
                    widget.timeLineOffset,
                hour: i,
                minutes: 30,
              ),
          if (widget.showQuarterHours)
            for (int i = widget.startHour; i < widget.endHour; i++) ...[
              /// this is for 15 minutes
              _timelinePositioned(
                topPosition: widget.hourHeight * (i - widget.startHour) -
                    widget.timeLineOffset +
                    widget.hourHeight * 0.25,
                bottomPosition: widget.height -
                    (widget.hourHeight * (i - widget.startHour + 1)) +
                    widget.timeLineOffset,
                hour: i,
                minutes: 15,
              ),

              /// this is for 45 minutes
              _timelinePositioned(
                topPosition: widget.hourHeight * (i - widget.startHour) -
                    widget.timeLineOffset +
                    widget.hourHeight * 0.75,
                bottomPosition: widget.height -
                    (widget.hourHeight * (i - widget.startHour + 1)) +
                    widget.timeLineOffset,
                hour: i,
                minutes: 45,
              ),
            ],
        ],
      ),
    );
  }

  /// To avoid overlap of live time line indicator, show time line when
  /// current min is less than 45 min and is previous hour or
  /// current min is greater than 15 min and is current hour
  Widget _timelinePositioned({
    required double topPosition,
    required double bottomPosition,
    required int hour,
    int minutes = 0,
  }) {
    final currentDateTime = _getCurrentDateTime();

    final dateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      hour,
      minutes,
    );

    return Visibility(
      visible: !((_currentTime.minute >= 45 && _currentTime.hour == hour - 1) ||
              (_currentTime.minute <= 15 && _currentTime.hour == hour)) ||
          !(widget.liveTimeIndicatorSettings.showTime ||
              widget.liveTimeIndicatorSettings.showTimeBackgroundView),
      child: Positioned(
        top: topPosition,
        left: 0,
        right: 0,
        bottom: bottomPosition,
        child: Container(
          height: widget.hourHeight,
          width: widget.timeLineWidth,
          child: InkWell(
            onTap: widget.onTimestampTap.safeVoidCall(dateTime),
            child: widget.timeLineBuilder.call(dateTime),
          ),
        ),
      ),
    );
  }
}

/// A widget that display event tiles in day/week view.
class EventGenerator<T extends Object?> extends StatelessWidget {
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

  /// First hour displayed in the layout
  final int startHour;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onTileLongTap;

  /// Called when user double tap on any event tile
  final CellTapCallback<T>? onTileDoubleTap;

  final EventScrollConfiguration scrollNotifier;

  /// This field will be used to set end hour for day and week view
  final int endHour;

  /// A widget that display event tiles in day/week view.
  const EventGenerator({
    Key? key,
    required this.height,
    required this.width,
    required this.events,
    required this.heightPerMinute,
    required this.eventArranger,
    required this.startHour,
    required this.eventTileBuilder,
    required this.date,
    required this.onTileTap,
    required this.onTileLongTap,
    required this.scrollNotifier,
    required this.onTileDoubleTap,
    this.endHour = Constants.hoursADay,
  }) : super(key: key);

  /// Arrange events and returns list of [Widget] that displays event
  /// tile on display area. This method uses [eventArranger] to get position
  /// of events and [eventTileBuilder] to display events.
  List<Widget> _generateEvents(BuildContext context) {
    final events = eventArranger.arrange(
      events: this.events,
      height: height,
      width: width,
      heightPerMinute: heightPerMinute,
      startHour: startHour,
      calendarViewDate: date,
    );
    return List.generate(events.length, (index) {
      return Positioned(
        top: events[index].top,
        bottom: events[index].bottom,
        left: events[index].left,
        right: events[index].right,
        child: GestureDetector(
          onLongPress: () => onTileLongTap?.call(events[index].events, date),
          onTap: () => onTileTap?.call(events[index].events, date),
          onDoubleTap: () => onTileDoubleTap?.call(events[index].events, date),
          child: Builder(builder: (context) {
            if (scrollNotifier.shouldScroll &&
                events[index]
                    .events
                    .any((element) => element == scrollNotifier.event)) {
              _scrollToEvent(context);
            }
            return eventTileBuilder(
              date,
              events[index].events,
              Rect.fromLTWH(
                  events[index].left,
                  events[index].top,
                  width - events[index].right - events[index].left,
                  height - events[index].bottom - events[index].top),
              events[index].startDuration,
              events[index].endDuration,
            );
          }),
        ),
      );
    });
  }

  void _scrollToEvent(BuildContext context) {
    final duration = scrollNotifier.duration ?? Duration.zero;
    final curve = scrollNotifier.curve ?? Curves.ease;

    scrollNotifier.resetScrollEvent();

    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((timeStamp) async {
      try {
        await Scrollable.ensureVisible(
          context,
          duration: duration,
          curve: curve,
          alignment: 0.5,
        );
      } finally {
        scrollNotifier.completeScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Use SizedBox If possible.
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: _generateEvents(context),
      ),
    );
  }
}

/// A widget that allow to long press on calendar.
class PressDetector extends StatelessWidget {
  /// Height of display area
  final double height;

  /// width of display area
  final double width;

  /// Defines height of single minute in day/week view page.
  final double heightPerMinute;

  /// Defines date for which events will be displayed in given display area.
  final DateTime date;

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
  /// where events are not available.
  final MinuteSlotSize minuteSlotSize;

  /// First hour displayed in the layout
  final int startHour;

  /// A widget that display event tiles in day/week view.
  const PressDetector({
    Key? key,
    required this.height,
    required this.width,
    required this.heightPerMinute,
    required this.date,
    required this.onDateLongPress,
    required this.onDateTap,
    required this.minuteSlotSize,
    required this.startHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightPerSlot = minuteSlotSize.minutes * heightPerMinute;
    final slots =
        ((Constants.hoursADay - startHour) * 60) ~/ minuteSlotSize.minutes;

    return Container(
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
                onTap: () => onDateTap?.call(
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                    0,
                    minuteSlotSize.minutes * i,
                  ),
                ),
                onLongPress: () => onDateLongPress?.call(
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                    0,
                    minuteSlotSize.minutes * i,
                  ),
                ),
                child: SizedBox(width: width, height: heightPerSlot),
              ),
            ),
        ],
      ),
    );
  }
}
