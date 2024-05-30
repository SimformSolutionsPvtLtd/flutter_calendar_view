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
class InternalDayViewPage<T extends Object?> extends StatefulWidget {
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

  final ScrollController dayViewScrollController;

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

  /// Scroll listener to set every page's last offset
  final void Function(ScrollController) scrollListener;

  /// Last scroll offset of day view page.
  final double lastScrollOffset;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for day view
  final int endHour;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

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
    required this.dayViewScrollController,
    required this.scrollListener,
    this.lastScrollOffset = 0.0,
    required this.dayDetectorBuilder,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.halfHourIndicatorSettings,
    required this.startHour,
    required this.endHour,
    required this.quarterHourIndicatorSettings,
    required this.emulateVerticalOffsetBy,
    required this.onTileDoubleTap,
    this.keepScrollOffset = false,
  }) : super(key: key);

  @override
  _InternalDayViewPageState<T> createState() => _InternalDayViewPageState();
}

class _InternalDayViewPageState<T extends Object?>
    extends State<InternalDayViewPage<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      initialScrollOffset: widget.lastScrollOffset,
    );
    scrollController.addListener(_scrollControllerListener);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_scrollControllerListener)
      ..dispose();
    super.dispose();
  }

  void _scrollControllerListener() {
    widget.scrollListener(scrollController);
  }

  @override
  Widget build(BuildContext context) {
    final fullDayEventList = widget.controller.getFullDayEvent(widget.date);
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          fullDayEventList.isEmpty
              ? SizedBox.shrink()
              : widget.fullDayEventBuilder(
                  widget.controller.getFullDayEvent(widget.date),
                  widget.date,
                ),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.keepScrollOffset
                  ? scrollController
                  : widget.dayViewScrollController,
              child: SizedBox(
                height: widget.height,
                width: widget.width,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(widget.width, widget.height),
                      painter: HourLinePainter(
                        lineColor: widget.hourIndicatorSettings.color,
                        lineHeight: widget.hourIndicatorSettings.height,
                        offset: widget.timeLineWidth +
                            widget.hourIndicatorSettings.offset,
                        minuteHeight: widget.heightPerMinute,
                        verticalLineOffset: widget.verticalLineOffset,
                        showVerticalLine: widget.showVerticalLine,
                        lineStyle: widget.hourIndicatorSettings.lineStyle,
                        dashWidth: widget.hourIndicatorSettings.dashWidth,
                        dashSpaceWidth:
                            widget.hourIndicatorSettings.dashSpaceWidth,
                        emulateVerticalOffsetBy: widget.emulateVerticalOffsetBy,
                        startHour: widget.startHour,
                        endHour: widget.endHour,
                      ),
                    ),
                    if (widget.showHalfHours)
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: HalfHourLinePainter(
                          lineColor: widget.halfHourIndicatorSettings.color,
                          lineHeight: widget.halfHourIndicatorSettings.height,
                          offset: widget.timeLineWidth +
                              widget.halfHourIndicatorSettings.offset,
                          minuteHeight: widget.heightPerMinute,
                          lineStyle: widget.halfHourIndicatorSettings.lineStyle,
                          dashWidth: widget.halfHourIndicatorSettings.dashWidth,
                          dashSpaceWidth:
                              widget.halfHourIndicatorSettings.dashSpaceWidth,
                          startHour: widget.startHour,
                          endHour: widget.endHour,
                        ),
                      ),
                    if (widget.showQuarterHours)
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: QuarterHourLinePainter(
                          lineColor: widget.quarterHourIndicatorSettings.color,
                          lineHeight:
                              widget.quarterHourIndicatorSettings.height,
                          offset: widget.timeLineWidth +
                              widget.quarterHourIndicatorSettings.offset,
                          minuteHeight: widget.heightPerMinute,
                          lineStyle:
                              widget.quarterHourIndicatorSettings.lineStyle,
                          dashWidth:
                              widget.quarterHourIndicatorSettings.dashWidth,
                          dashSpaceWidth: widget
                              .quarterHourIndicatorSettings.dashSpaceWidth,
                        ),
                      ),
                    widget.dayDetectorBuilder(
                      width: widget.width,
                      height: widget.height,
                      heightPerMinute: widget.heightPerMinute,
                      date: widget.date,
                      minuteSlotSize: widget.minuteSlotSize,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: EventGenerator<T>(
                        height: widget.height,
                        date: widget.date,
                        onTileLongTap: widget.onTileLongTap,
                        onTileDoubleTap: widget.onTileDoubleTap,
                        onTileTap: widget.onTileTap,
                        eventArranger: widget.eventArranger,
                        events: widget.controller.getEventsOnDay(
                          widget.date,
                          includeFullDayEvents: false,
                        ),
                        heightPerMinute: widget.heightPerMinute,
                        eventTileBuilder: widget.eventTileBuilder,
                        scrollNotifier: widget.scrollNotifier,
                        startHour: widget.startHour,
                        endHour: widget.endHour,
                        width: widget.width -
                            widget.timeLineWidth -
                            widget.hourIndicatorSettings.offset -
                            widget.verticalLineOffset,
                      ),
                    ),
                    TimeLine(
                      height: widget.height,
                      hourHeight: widget.hourHeight,
                      timeLineBuilder: widget.timeLineBuilder,
                      timeLineOffset: widget.timeLineOffset,
                      timeLineWidth: widget.timeLineWidth,
                      showHalfHours: widget.showHalfHours,
                      startHour: widget.startHour,
                      endHour: widget.endHour,
                      showQuarterHours: widget.showQuarterHours,
                      key: ValueKey(widget.heightPerMinute),
                      liveTimeIndicatorSettings:
                          widget.liveTimeIndicatorSettings,
                    ),
                    if (widget.showLiveLine &&
                        widget.liveTimeIndicatorSettings.height > 0)
                      IgnorePointer(
                        child: LiveTimeIndicator(
                          liveTimeIndicatorSettings:
                              widget.liveTimeIndicatorSettings,
                          width: widget.width,
                          height: widget.height,
                          heightPerMinute: widget.heightPerMinute,
                          timeLineWidth: widget.timeLineWidth,
                          startHour: widget.startHour,
                          endHour: widget.endHour,
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
