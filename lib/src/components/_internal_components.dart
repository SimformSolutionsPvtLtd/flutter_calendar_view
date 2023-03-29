// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
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
  /// and height of indicator.
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

  /// Creates an recursive call that runs every 1 seconds.
  /// This will rebuild TimeLineIndicator every second. This will allow us
  /// to indicate live time in Week and Day view.
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

  /// This will display time string in timeline.
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
      key: ValueKey(hourHeight),
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
                child: timeLineBuilder.call(
                  DateTime(
                    _date.year,
                    _date.month,
                    _date.day,
                    i,
                  ),
                ),
              ),
            ),
        ],
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

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  final EventScrollConfiguration scrollNotifier;

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
    required this.onTileTap,
    required this.scrollNotifier,
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
    );

    return List.generate(events.length, (index) {
      return Positioned(
        top: events[index].top,
        bottom: events[index].bottom,
        left: events[index].left,
        right: events[index].right,
        child: GestureDetector(
          onTap: () => onTileTap?.call(events[index].events, date),
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
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: _generateEvents(context),
      ),
    );
  }
}

/// A widget that display event tiles in day/week view.
class SelectedEventGenerator<T extends Object?> extends StatelessWidget {
  /// Height of display area
  final double height;

  /// width of display area
  final double width;

  /// List of events to display.
  final ValueNotifier<CalendarEventData<T>?> selectedEvent;

  /// Called when user modifies event.
  final Function(CalendarEventData<T> changedEvent) onEventChanged;

  /// Defines height of single minute in day/week view page.
  final double heightPerMinute;

  /// Defines how to arrange events.
  final EventArranger<T> eventArranger;

  /// Defines how event tile will be displayed.
  final SelectedEventTileBuilder<T> selectedEventTileBuilder;

  /// Defines date for which events will be displayed in given display area.
  final DateTime date;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  final EventScrollConfiguration scrollNotifier;

  /// A widget that display event tiles in day/week view.
  const SelectedEventGenerator({
    Key? key,
    required this.height,
    required this.width,
    required this.selectedEvent,
    required this.heightPerMinute,
    required this.eventArranger,
    required this.selectedEventTileBuilder,
    required this.onEventChanged,
    required this.date,
    required this.onTileTap,
    required this.scrollNotifier,
  }) : super(key: key);

  /// Arrange events and returns list of [Widget] that displays event
  /// tile on display area. This method uses [eventArranger] to get position
  /// of events and [selectedEventTileBuilder] to display events.
  List<Widget> _generateEvents(BuildContext context) {
    if (selectedEvent.value == null) return [];

    final events = eventArranger.arrange(
      events: [selectedEvent.value!],
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
        child: GestureDetector(
          onTap: () => onTileTap?.call(events[index].events, date),
          child: Builder(builder: (context) {
            if (scrollNotifier.shouldScroll &&
                events[index]
                    .events
                    .any((element) => element == scrollNotifier.event)) {
              _scrollToEvent(context);
            }
            return selectedEventTileBuilder(
              date,
              events[index].events,
              Rect.fromLTWH(
                  events[index].left,
                  events[index].top,
                  width - events[index].right - events[index].left,
                  height - events[index].bottom - events[index].top),
              events[index].startDuration,
              events[index].endDuration,
              (primaryDelta) {
                final newEventData = selectedEvent.value!.updateEventStartTime(
                  primaryDelta: primaryDelta,
                  heightPerMinute: heightPerMinute,
                );

                selectedEvent.value = newEventData;
              },
              (primaryDelta) {
                final newEventData = selectedEvent.value!.updateEventEndTime(
                  primaryDelta: primaryDelta,
                  heightPerMinute: heightPerMinute,
                );
                selectedEvent.value = newEventData;
              },
              (primaryDelta) {
                final newEventData = selectedEvent.value!.rescheduleEvent(
                  primaryDelta: primaryDelta,
                  heightPerMinute: heightPerMinute,
                );

                if (newEventData == null) return;
                selectedEvent.value = newEventData;
              },
              () {
                onEventChanged(selectedEvent.value!);
              },
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
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: _generateEvents(context),
      ),
    );
  }
}

/// A widget that display event tiles in day/week view.
class InteractiveEventLayout<T extends Object?> extends StatefulWidget {
  /// Calendar controller.
  final EventController<T> controller;

  /// Height of display area
  final double height;

  /// width of display area
  final double width;

  /// Defines height of single minute in day/week view page.
  final double heightPerMinute;

  /// Defines how to arrange events.
  final EventArranger<T> eventArranger;

  /// Defines how event tile will be displayed.
  final EventTileBuilder<T> eventTileBuilder;

  /// Defines how event tile will be displayed.
  final SelectedEventTileBuilder<T> selectedEventTileBuilder;

  /// Called when user modifies event.
  final Function(CalendarEventData<T> event) onEventChanged;

  /// Defines date for which events will be displayed in given display area.
  final DateTime date;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  final EventScrollConfiguration scrollNotifier;

  /// A widget that display event tiles in day/week view.
  const InteractiveEventLayout({
    Key? key,
    required this.controller,
    required this.height,
    required this.width,
    required this.heightPerMinute,
    required this.eventArranger,
    required this.eventTileBuilder,
    required this.selectedEventTileBuilder,
    required this.onEventChanged,
    required this.date,
    required this.onTileTap,
    required this.scrollNotifier,
  }) : super(key: key);

  @override
  State<InteractiveEventLayout<T>> createState() =>
      _InteractiveEventLayoutState<T>();
}

class _InteractiveEventLayoutState<T extends Object?>
    extends State<InteractiveEventLayout<T>> {
  /// The selected event.
  ValueNotifier<CalendarEventData<T>?> selectedEvent =
      ValueNotifier<CalendarEventData<T>?>(null);

  void onTileTap(List<CalendarEventData<T>> events, DateTime date) {
    widget.onTileTap?.call(events, date);
    if (selectedEvent.value == null) {
      selectedEvent.value = events.first;
    } else {
      if (selectedEvent.value!.compareWithoutTime(events.first)) {
        selectedEvent.value = null;
      } else {
        selectedEvent.value = events.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: ValueListenableBuilder<CalendarEventData<T>?>(
        valueListenable: selectedEvent,
        builder: (context, value, child) {
          if (value == null) {
            return EventGenerator<T>(
              height: widget.height,
              date: widget.date,
              onTileTap: onTileTap,
              eventArranger: widget.eventArranger,
              events: widget.controller.getEventsOnDay(widget.date),
              heightPerMinute: widget.heightPerMinute,
              eventTileBuilder: widget.eventTileBuilder,
              scrollNotifier: widget.scrollNotifier,
              width: widget.width,
            );
          } else {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => selectedEvent.value = null,
                ),
                EventGenerator<T>(
                  height: widget.height,
                  date: widget.date,
                  onTileTap: onTileTap,
                  eventArranger: widget.eventArranger,
                  events: widget.controller.getEventsOnDay(widget.date)
                    ..removeWhere(
                      (element) => element.compareWithoutTime(value),
                    ),
                  heightPerMinute: widget.heightPerMinute,
                  eventTileBuilder: widget.eventTileBuilder,
                  scrollNotifier: widget.scrollNotifier,
                  width: widget.width,
                ),
                SelectedEventGenerator<T>(
                  onEventChanged: (modifiedEvent) {
                    widget.controller.replace(modifiedEvent);
                    widget.onEventChanged(modifiedEvent);
                  },
                  height: widget.height,
                  date: widget.date,
                  onTileTap: onTileTap,
                  eventArranger: widget.eventArranger,
                  selectedEvent: selectedEvent,
                  heightPerMinute: widget.heightPerMinute,
                  selectedEventTileBuilder: widget.selectedEventTileBuilder,
                  scrollNotifier: widget.scrollNotifier,
                  width: widget.width,
                ),
              ],
            );
          }
        },
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightPerSlot = minuteSlotSize.minutes * heightPerMinute;
    final slots = (Constants.hoursADay * 60) ~/ minuteSlotSize.minutes;

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
