// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../components/_internal_components.dart';
import '../components/week_view_components.dart';
import '../components/event_scroll_notifier.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../modals.dart';
import '../painters.dart';
import '../typedefs.dart';

/// A single page for week view.
class InternalWeekViewPage<T extends Object?> extends StatefulWidget {
  /// Width of the page.
  final double width;

  /// Height of the page.
  final double height;

  /// Dates to display on page.
  final List<DateTime> dates;

  /// Builds tile for a single event.
  final EventTileBuilder<T> eventTileBuilder;

  /// A calendar controller that controls all the events and rebuilds widget
  /// if event(s) are added or removed.
  final EventController<T> controller;

  /// A builder to build time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Custom painter for hour line.
  final CustomHourLinePainter hourLinePainter;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings halfHourIndicatorSettings;

  /// Settings for quarter hour indicator lines.
  final HourIndicatorSettings quarterHourIndicatorSettings;

  /// Flag to display live line.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final LiveTimeIndicatorSettings liveTimeIndicatorSettings;

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

  /// Builder for week number.
  final WeekNumberBuilder weekNumberBuilder;

  /// Builds custom PressDetector widget
  final DetectorBuilder weekDetectorBuilder;

  /// Height of week title.
  final double weekTitleHeight;

  /// Width of week title.
  final double weekTitleWidth;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onTileLongTap;

  /// Called when user double tap on any event tile.
  final CellTapCallback<T>? onTileDoubleTap;

  /// Defines which days should be displayed in one week.
  ///
  /// By default all the days will be visible.
  /// Sequence will be monday to sunday.
  final List<WeekDays> weekDays;

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

  final EventScrollConfiguration scrollConfiguration;

  /// Display full day events.
  final FullDayEventBuilder<T> fullDayEventBuilder;

  final ScrollController weekViewScrollController;

  /// First hour displayed in the layout
  final int startHour;

  /// If true this will show week day at bottom position.
  final bool showWeekDayAtBottom;

  /// Flag to display half hours
  final bool showHalfHours;

  /// Flag to display quarter hours
  final bool showQuarterHours;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for week view
  final int endHour;

  /// Title of the full day events row
  final String fullDayHeaderTitle;

  /// Defines full day events header text config
  final FullDayHeaderTextConfig fullDayHeaderTextConfig;

  /// Scroll listener to set every page's last offset
  final void Function(ScrollController) scrollListener;

  /// Last scroll offset of week view page.
  final double lastScrollOffset;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

  /// A single page for week view.
  const InternalWeekViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.weekTitleHeight,
    required this.weekDayBuilder,
    required this.weekNumberBuilder,
    required this.width,
    required this.dates,
    required this.eventTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.hourLinePainter,
    required this.halfHourIndicatorSettings,
    required this.quarterHourIndicatorSettings,
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
    required this.onTileTap,
    required this.onTileLongTap,
    required this.onDateLongPress,
    required this.onDateTap,
    required this.weekDays,
    required this.minuteSlotSize,
    required this.scrollConfiguration,
    required this.startHour,
    required this.fullDayEventBuilder,
    required this.weekDetectorBuilder,
    required this.showWeekDayAtBottom,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.emulateVerticalOffsetBy,
    required this.onTileDoubleTap,
    required this.endHour,
    this.fullDayHeaderTitle = '',
    required this.fullDayHeaderTextConfig,
    required this.scrollListener,
    required this.weekViewScrollController,
    this.lastScrollOffset = 0.0,
    this.keepScrollOffset = false,
  }) : super(key: key);

  @override
  _InternalWeekViewPageState<T> createState() => _InternalWeekViewPageState();
}

class _InternalWeekViewPageState<T extends Object?>
    extends State<InternalWeekViewPage<T>> {
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
    final filteredDates = _filteredDate();
    return Container(
      height: widget.height + widget.weekTitleHeight,
      width: widget.width,
      child: Column(
        verticalDirection: widget.showWeekDayAtBottom
            ? VerticalDirection.up
            : VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: widget.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: widget.weekTitleHeight,
                  width: widget.timeLineWidth +
                      widget.hourIndicatorSettings.offset,
                  child: widget.weekNumberBuilder.call(filteredDates[0]),
                ),
                ...List.generate(
                  filteredDates.length,
                  (index) => SizedBox(
                    height: widget.weekTitleHeight,
                    width: widget.weekTitleWidth,
                    child: widget.weekDayBuilder(
                      filteredDates[index],
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
          ),
          SizedBox(
            width: widget.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: widget.hourIndicatorSettings.color,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widget.timeLineWidth +
                        widget.hourIndicatorSettings.offset,
                    child: widget.fullDayHeaderTitle.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 1,
                            ),
                            child: Text(
                              widget.fullDayHeaderTitle,
                              textAlign:
                                  widget.fullDayHeaderTextConfig.textAlign,
                              maxLines: widget.fullDayHeaderTextConfig.maxLines,
                              overflow:
                                  widget.fullDayHeaderTextConfig.textOverflow,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  ...List.generate(
                    filteredDates.length,
                    (index) {
                      final fullDayEventList = widget.controller
                          .getFullDayEvent(filteredDates[index]);
                      return Container(
                        width: widget.weekTitleWidth,
                        child: fullDayEventList.isEmpty
                            ? null
                            : widget.fullDayEventBuilder.call(
                                fullDayEventList,
                                widget.dates[index],
                              ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.keepScrollOffset
                  ? scrollController
                  : widget.weekViewScrollController,
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
                        startHour: widget.startHour,
                        emulateVerticalOffsetBy: widget.emulateVerticalOffsetBy,
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
                          startHour: widget.halfHourIndicatorSettings.startHour,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: widget.weekTitleWidth * filteredDates.length,
                        height: widget.height,
                        child: Row(
                          children: [
                            ...List.generate(
                              filteredDates.length,
                              (index) => Container(
                                decoration: widget.showVerticalLine
                                    ? BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: widget
                                                .hourIndicatorSettings.color,
                                            width: widget
                                                .hourIndicatorSettings.height,
                                          ),
                                        ),
                                      )
                                    : null,
                                height: widget.height,
                                width: widget.weekTitleWidth,
                                child: Stack(
                                  children: [
                                    widget.weekDetectorBuilder(
                                      width: widget.weekTitleWidth,
                                      height: widget.height,
                                      heightPerMinute: widget.heightPerMinute,
                                      date: widget.dates[index],
                                      minuteSlotSize: widget.minuteSlotSize,
                                    ),
                                    EventGenerator<T>(
                                      height: widget.height,
                                      date: filteredDates[index],
                                      onTileTap: widget.onTileTap,
                                      onTileLongTap: widget.onTileLongTap,
                                      onTileDoubleTap: widget.onTileDoubleTap,
                                      width: widget.weekTitleWidth,
                                      eventArranger: widget.eventArranger,
                                      eventTileBuilder: widget.eventTileBuilder,
                                      scrollNotifier:
                                          widget.scrollConfiguration,
                                      startHour: widget.startHour,
                                      events: widget.controller.getEventsOnDay(
                                        filteredDates[index],
                                        includeFullDayEvents: false,
                                      ),
                                      heightPerMinute: widget.heightPerMinute,
                                      endHour: widget.endHour,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    TimeLine(
                      timeLineWidth: widget.timeLineWidth,
                      hourHeight: widget.hourHeight,
                      height: widget.height,
                      timeLineOffset: widget.timeLineOffset,
                      timeLineBuilder: widget.timeLineBuilder,
                      startHour: widget.startHour,
                      showHalfHours: widget.showHalfHours,
                      showQuarterHours: widget.showQuarterHours,
                      liveTimeIndicatorSettings:
                          widget.liveTimeIndicatorSettings,
                      endHour: widget.endHour,
                    ),
                    if (widget.showLiveLine &&
                        widget.liveTimeIndicatorSettings.height > 0)
                      LiveTimeIndicator(
                        liveTimeIndicatorSettings:
                            widget.liveTimeIndicatorSettings,
                        width: widget.width,
                        height: widget.height,
                        heightPerMinute: widget.heightPerMinute,
                        timeLineWidth: widget.timeLineWidth,
                        startHour: widget.startHour,
                        endHour: widget.endHour,
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

  List<DateTime> _filteredDate() {
    final output = <DateTime>[];

    final weekDays = widget.weekDays.toList();

    for (final date in widget.dates) {
      if (weekDays.any((weekDay) => weekDay.index + 1 == date.weekday)) {
        output.add(date);
      }
    }

    return output;
  }
}
