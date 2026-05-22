// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../components/_internal_components.dart';
import '../extensions.dart';
import '../painters.dart';
import '../zoom_scroll_controller.dart';

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

  /// Settings for divider between FullDay events and weekdays header.
  final DividerSettings dividerSettings;

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

  /// Background color of week title
  final Color? weekTitleBackgroundColor;

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

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

  /// This method will be called when user taps on timestamp in timeline.
  final TimestampCallback? onTimestampTap;

  /// Use this to change background color of week view page
  final Color? backgroundColor;

  /// A callback for rendering custom time slot background colors.
  final TimeSlotColorBuilder? timeSlotColorBuilder;

  /// Flag to display the 00:00 (midnight) hour in the timeline.
  ///
  /// When set to true, the 00:00 label will be shown on the timeline.
  /// Default value is false.
  final bool showMidnightHour;

  /// Controls orientation behavior for week view rendering.
  final WeekViewMode weekViewMode;

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
    required this.dividerSettings,
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
    required this.weekTitleBackgroundColor,
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
    required this.onTimestampTap,
    required this.fullDayHeaderTextConfig,
    required this.scrollPhysics,
    required this.scrollListener,
    required this.weekViewScrollController,
    this.backgroundColor,
    this.timeSlotColorBuilder,
    this.fullDayHeaderTitle = '',
    this.lastScrollOffset = 0.0,
    this.keepScrollOffset = false,
    this.showMidnightHour = false,
    this.weekViewMode = WeekViewMode.standard,
  }) : super(key: key);

  @override
  _InternalWeekViewPageState<T> createState() =>
      _InternalWeekViewPageState<T>();
}

class _InternalWeekViewPageState<T extends Object?>
    extends State<InternalWeekViewPage<T>> {
  static const double _verticalCompactTileHeightThreshold = 60;
  static const double _verticalCompactTileWidthThreshold = 70;
  static const double _verticalTinyTileWidthThreshold = 20;

  late ZoomScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ZoomScrollController(
      initialScrollOffset: widget.lastScrollOffset,
    );
    scrollController.addListener(_scrollControllerListener);
  }

  @override
  void didUpdateWidget(InternalWeekViewPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.heightPerMinute != oldWidget.heightPerMinute &&
        widget.keepScrollOffset) {
      // keepScrollOffset=true means the local scrollController drives
      // the SingleChildScrollView. Scale its offset to keep the same time
      // position visible after zoom.
      final currentOffset = scrollController.hasClients
          ? scrollController.offset
          : widget.lastScrollOffset;
      final scaledOffset = currentOffset *
          widget.heightPerMinute /
          (oldWidget.heightPerMinute > 0 ? oldWidget.heightPerMinute : 1.0);
      scrollController.prepareZoomJump(scaledOffset);
    }
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

  /// Builds background layers for time slots in the week view.
  /// Uses [timeSlotColorBuilder] to determine each slot's color and paints
  /// a grid of colored rectangles (one column per day, one row per slot).
  ///
  /// Parameter: [filteredDates] — visible dates for the page.
  /// Returns a [Widget] that paints the slot backgrounds.
  Widget _buildWeekTimeSlotBackgrounds(List<DateTime> filteredDates) {
    // Extract the minute duration of each time slot (e.g., 15, 30, 60 minutes)
    final slotMinutes = widget.minuteSlotSize.minutes;
    // Calculate the pixel height occupied by one time slot
    final heightPerSlot = widget.heightPerMinute * slotMinutes;
    // Calculate the total number of time slots to display
    // Formula: (number of hours × 60 minutes) ÷ slot size
    final totalSlots =
        ((widget.endHour - widget.startHour) * 60) ~/ slotMinutes;

    return Align(
      // Align the time slot backgrounds to the right (or left in RTL mode)
      alignment: Directionality.of(context) == TextDirection.ltr
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: SizedBox(
        // Width spans across all visible days
        width: widget.weekTitleWidth * filteredDates.length,
        height: widget.height,
        child: Row(
          children: [
            // Generate a column for each visible day
            ...List.generate(
              filteredDates.length,
              (dayIndex) {
                final dayDate = filteredDates[dayIndex];
                final dayStart = DateTime(
                  dayDate.year,
                  dayDate.month,
                  dayDate.day,
                  widget.startHour,
                );

                final slotDuration = Duration(minutes: slotMinutes);
                // Generate a list of colors for each time slot of this day
                final slotColors = List<Color>.generate(
                  totalSlots,
                  (slotIndex) {
                    // Calculate the start time adn end time of this slot
                    final slotStartTime =
                        dayStart.add(slotDuration * slotIndex);
                    final slotEndTime = slotStartTime.add(slotDuration);

                    // Query the color builder to get the background color for this slot
                    return widget.timeSlotColorBuilder!(
                      dayDate,
                      slotStartTime,
                      slotEndTime,
                      slotIndex,
                    );
                  },
                );

                return ClipRect(
                  child: SizedBox(
                    width: widget.weekTitleWidth,
                    height: widget.height,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: TimeSlotBackgroundPainter(
                          heightPerSlot: heightPerSlot,
                          slotColors: slotColors,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDates = _filteredDate();
    final themeColor = context.weekViewColors;
    final direction = Directionality.of(context);

    if (widget.weekViewMode == WeekViewMode.verticalWeek) {
      return _buildVerticalWeekMode(filteredDates, themeColor, direction);
    }

    return Container(
      color: widget.backgroundColor ?? themeColor.pageBackgroundColor,
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
            child: ColoredBox(
              color: widget.weekTitleBackgroundColor ??
                  themeColor.weekDayTileColor,
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
          ),
          Divider(
            thickness: widget.dividerSettings.thickness,
            height: widget.dividerSettings.height,
            color: widget.dividerSettings.color,
            indent: widget.dividerSettings.indent,
            endIndent: widget.dividerSettings.endIndent,
          ),
          SizedBox(
            width: widget.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: themeColor.borderColor,
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
            // Fix to ===> scroll controller exception
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: widget.keepScrollOffset,
              ),
              child: SingleChildScrollView(
                controller: widget.keepScrollOffset
                    ? scrollController
                    : widget.weekViewScrollController,
                physics: widget.scrollPhysics,
                child: SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: Stack(
                    children: [
                      // Render time slot backgrounds if color builder is provided
                      if (widget.timeSlotColorBuilder != null)
                        _buildWeekTimeSlotBackgrounds(filteredDates),
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: widget.hourLinePainter(
                          widget.hourIndicatorSettings.color,
                          widget.hourIndicatorSettings.height,
                          widget.timeLineWidth +
                              widget.hourIndicatorSettings.offset,
                          widget.heightPerMinute,
                          widget.showVerticalLine,
                          widget.verticalLineOffset,
                          widget.hourIndicatorSettings.lineStyle,
                          widget.hourIndicatorSettings.dashWidth,
                          widget.hourIndicatorSettings.dashSpaceWidth,
                          widget.emulateVerticalOffsetBy,
                          widget.startHour,
                          widget.endHour,
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
                            lineStyle:
                                widget.halfHourIndicatorSettings.lineStyle,
                            dashWidth:
                                widget.halfHourIndicatorSettings.dashWidth,
                            dashSpaceWidth:
                                widget.halfHourIndicatorSettings.dashSpaceWidth,
                            startHour:
                                widget.halfHourIndicatorSettings.startHour,
                            endHour: widget.endHour,
                            textDirection: direction,
                          ),
                        ),
                      if (widget.showQuarterHours)
                        CustomPaint(
                          size: Size(widget.width, widget.height),
                          painter: QuarterHourLinePainter(
                            lineColor:
                                widget.quarterHourIndicatorSettings.color,
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
                            textDirection: direction,
                          ),
                        ),
                      Align(
                        alignment: direction == TextDirection.ltr
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
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
                                          // To apply different colors to the timeline
                                          // and cells, use the background color for the timeline.
                                          // Additionally, set the `color` property here with an alpha value
                                          // to see horizontal & vertical lines

                                          border: Border(
                                            right:
                                                direction == TextDirection.ltr
                                                    ? BorderSide(
                                                        color: themeColor
                                                            .verticalLinesColor,
                                                        width: widget
                                                            .hourIndicatorSettings
                                                            .height,
                                                      )
                                                    : BorderSide.none,
                                            left: direction == TextDirection.rtl
                                                ? BorderSide(
                                                    color: themeColor
                                                        .verticalLinesColor,
                                                    width: widget
                                                        .hourIndicatorSettings
                                                        .height,
                                                  )
                                                : BorderSide.none,
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
                                        eventTileBuilder:
                                            widget.eventTileBuilder,
                                        scrollNotifier:
                                            widget.scrollConfiguration,
                                        startHour: widget.startHour,
                                        events:
                                            widget.controller.getEventsOnDay(
                                          filteredDates[index],
                                          includeFullDayEvents: false,
                                        ),
                                        heightPerMinute: widget.heightPerMinute,
                                        endHour: widget.endHour,
                                      ),
                                      if (widget.liveTimeIndicatorSettings
                                                  .height >
                                              0 &&
                                          widget.liveTimeIndicatorSettings
                                              .onlyShowToday)
                                        LiveTimeIndicator(
                                          liveTimeIndicatorSettings:
                                              widget.liveTimeIndicatorSettings,
                                          width: widget.width,
                                          height: widget.height,
                                          heightPerMinute:
                                              widget.heightPerMinute,
                                          timeLineWidth: widget.timeLineWidth,
                                          startHour: widget.startHour,
                                          endHour: widget.endHour,
                                          onlyShowToday: widget
                                              .liveTimeIndicatorSettings
                                              .onlyShowToday,
                                          date: filteredDates[index],
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
                        pageDate:
                            filteredDates.isEmpty ? null : filteredDates.first,
                        startHour: widget.startHour,
                        showHalfHours: widget.showHalfHours,
                        showQuarterHours: widget.showQuarterHours,
                        liveTimeIndicatorSettings:
                            widget.liveTimeIndicatorSettings,
                        endHour: widget.endHour,
                        onTimestampTap: widget.onTimestampTap,
                        showMidnightHour: widget.showMidnightHour,
                      ),
                      if (widget.showLiveLine &&
                          widget.liveTimeIndicatorSettings.height > 0 &&
                          !widget.liveTimeIndicatorSettings.onlyShowToday)
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
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalWeekMode(
    List<DateTime> filteredDates,
    WeekViewThemeData themeColor,
    TextDirection direction,
  ) {
    if (filteredDates.isEmpty) {
      return SizedBox.shrink();
    }

    // Keep each day row equal to one-hour slot height so switching
    // between standard and vertical modes does not introduce size changes.
    final rowHeight = widget.hourHeight;
    final contentHeight = rowHeight * filteredDates.length;
    final minutesVisible = (widget.endHour - widget.startHour) * 60;
    final hourContentWidth = minutesVisible * widget.heightPerMinute;
    final weekdayColumnWidth =
        widget.timeLineWidth + widget.hourIndicatorSettings.offset;
    final fullDayColumnWidth = widget.weekTitleWidth;
    // In vertical mode, timeline thickness follows timeLineWidth because the
    // time axis becomes horizontal.
    final timelineBandHeight = widget.timeLineWidth;
    final rowOffset = timelineBandHeight + widget.hourIndicatorSettings.offset;
    final totalHeight = rowOffset + contentHeight;
    final activeController = widget.keepScrollOffset
        ? scrollController
        : widget.weekViewScrollController;

    return Container(
      color: widget.backgroundColor ?? themeColor.pageBackgroundColor,
      height: totalHeight,
      width: widget.width,
      child: Row(
        children: [
          SizedBox(
            width: weekdayColumnWidth,
            height: totalHeight,
            child: Column(
              children: [
                Container(
                  height: rowOffset,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.weekTitleBackgroundColor ??
                        themeColor.weekDayTileColor,
                    border: Border(
                      bottom: BorderSide(color: themeColor.borderColor),
                      right: direction == TextDirection.ltr
                          ? BorderSide(color: themeColor.borderColor)
                          : BorderSide.none,
                      left: direction == TextDirection.rtl
                          ? BorderSide(color: themeColor.borderColor)
                          : BorderSide.none,
                    ),
                  ),
                ),
                ...List.generate(
                  filteredDates.length,
                  (index) => _buildVerticalWeekdayColumnCell(
                    filteredDates[index],
                    rowHeight,
                    themeColor,
                    direction,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: fullDayColumnWidth,
            height: totalHeight,
            child: Column(
              children: [
                Container(
                  height: rowOffset,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.weekTitleBackgroundColor ??
                        themeColor.weekDayTileColor,
                    border: Border(
                      bottom: BorderSide(color: themeColor.borderColor),
                      right: direction == TextDirection.ltr
                          ? BorderSide(color: themeColor.borderColor)
                          : BorderSide.none,
                      left: direction == TextDirection.rtl
                          ? BorderSide(color: themeColor.borderColor)
                          : BorderSide.none,
                    ),
                  ),
                ),
                ...List.generate(
                  filteredDates.length,
                  (index) => _buildVerticalFullDayColumnCell(
                    filteredDates[index],
                    rowHeight,
                    themeColor,
                    direction,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRect(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: activeController,
                physics: widget.scrollPhysics,
                child: SizedBox(
                  width: hourContentWidth,
                  height: totalHeight,
                  child: Stack(
                    children: [
                      if (widget.timeSlotColorBuilder != null)
                        _buildVerticalWeekTimeSlotBackgrounds(
                          filteredDates: filteredDates,
                          rowHeight: rowHeight,
                          rowOffset: rowOffset,
                          hourContentWidth: hourContentWidth,
                          direction: direction,
                        ),
                      ..._buildVerticalHourMarkers(
                        minutesVisible: minutesVisible,
                        direction: direction,
                        themeColor: themeColor,
                      ),
                      ..._buildVerticalDayRows(
                        filteredDates: filteredDates,
                        rowHeight: rowHeight,
                        rowOffset: rowOffset,
                        hourContentWidth: hourContentWidth,
                        themeColor: themeColor,
                        direction: direction,
                      ),
                      ..._buildVerticalLiveIndicators(
                        filteredDates: filteredDates,
                        rowHeight: rowHeight,
                        rowOffset: rowOffset,
                        hourContentWidth: hourContentWidth,
                        themeColor: themeColor,
                        direction: direction,
                      ),
                      // Drawn last so the band renders on top of all rows.
                      ..._buildHorizontalTimelineIndicators(
                        filteredDates: filteredDates,
                        timelineBandHeight: timelineBandHeight,
                        rowOffset: rowOffset,
                        hourContentWidth: hourContentWidth,
                        direction: direction,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalWeekdayColumnCell(
    DateTime date,
    double rowHeight,
    WeekViewThemeData themeColor,
    TextDirection direction,
  ) {
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: widget.weekTitleBackgroundColor ?? themeColor.weekDayTileColor,
        border: Border(
          right: direction == TextDirection.ltr
              ? BorderSide(color: themeColor.borderColor)
              : BorderSide.none,
          left: direction == TextDirection.rtl
              ? BorderSide(color: themeColor.borderColor)
              : BorderSide.none,
          bottom: BorderSide(color: themeColor.borderColor),
        ),
      ),
      child: SizedBox(
        height: rowHeight,
        width: double.infinity,
        child: widget.weekDayBuilder(date),
      ),
    );
  }

  Widget _buildVerticalFullDayColumnCell(
    DateTime date,
    double rowHeight,
    WeekViewThemeData themeColor,
    TextDirection direction,
  ) {
    final fullDayEventList = widget.controller.getFullDayEvent(date);

    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? themeColor.pageBackgroundColor,
        border: Border(
          right: direction == TextDirection.ltr
              ? BorderSide(color: themeColor.borderColor)
              : BorderSide.none,
          left: direction == TextDirection.rtl
              ? BorderSide(color: themeColor.borderColor)
              : BorderSide.none,
          bottom: BorderSide(color: themeColor.borderColor),
        ),
      ),
      child: fullDayEventList.isEmpty
          ? SizedBox.shrink()
          : ClipRect(
              child: SizedBox(
                height: rowHeight,
                width: double.infinity,
                child: widget.fullDayEventBuilder(fullDayEventList, date),
              ),
            ),
    );
  }

  List<Widget> _buildHorizontalTimelineIndicators({
    required List<DateTime> filteredDates,
    required double timelineBandHeight,
    required double rowOffset,
    required double hourContentWidth,
    required TextDirection direction,
  }) {
    if (timelineBandHeight <= 0) {
      return const [];
    }

    final isRtl = direction == TextDirection.rtl;
    final labelDate =
        filteredDates.isEmpty ? DateTime.now() : filteredDates.first;
    final widgets = <Widget>[
      Positioned(
        left: 0,
        right: 0,
        top: 0,
        height: timelineBandHeight,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          child: SizedBox.expand(),
        ),
      ),
    ];

    final hourCount = widget.endHour - widget.startHour;
    for (int i = 0; i <= hourCount; i++) {
      final hour = widget.startHour + i;
      if (!widget.showMidnightHour && hour == 0) continue;

      final dateTime = DateTime(
        labelDate.year,
        labelDate.month,
        labelDate.day,
        hour,
      );

      final offset = i * 60 * widget.heightPerMinute;
      final labelWidth = math.max(30.0, 60 * widget.heightPerMinute);
      final anchoredOffset = offset - widget.timeLineOffset;

      widgets.add(
        Positioned(
          left: isRtl ? null : anchoredOffset,
          right: isRtl ? anchoredOffset : null,
          top: 10,
          width: labelWidth,
          height: timelineBandHeight,
          child: InkWell(
            onTap: widget.onTimestampTap.safeVoidCall(dateTime),
            child: widget.timeLineBuilder(dateTime),
          ),
        ),
      );
    }

    // Full-width divider separating the header band from the day rows.
    widgets.add(
      Positioned(
        left: 0,
        right: 0,
        top: rowOffset,
        child: Divider(
          height: widget.hourIndicatorSettings.height,
          thickness: widget.hourIndicatorSettings.height,
          color: context.weekViewColors.borderColor,
        ),
      ),
    );

    return widgets;
  }

  Widget _buildVerticalWeekTimeSlotBackgrounds({
    required List<DateTime> filteredDates,
    required double rowHeight,
    required double rowOffset,
    required double hourContentWidth,
    required TextDirection direction,
  }) {
    final slotMinutes = widget.minuteSlotSize.minutes;
    final slotWidth = slotMinutes * widget.heightPerMinute;
    final totalSlots =
        ((widget.endHour - widget.startHour) * 60) ~/ slotMinutes;
    final isRtl = direction == TextDirection.rtl;

    return Stack(
      children: [
        for (int dayIndex = 0; dayIndex < filteredDates.length; dayIndex++)
          for (int slotIndex = 0; slotIndex < totalSlots; slotIndex++)
            Positioned(
              left: isRtl ? null : slotIndex * slotWidth,
              right: isRtl ? slotIndex * slotWidth : null,
              top: rowOffset + dayIndex * rowHeight,
              width: slotWidth,
              height: rowHeight,
              child: ColoredBox(
                color: widget.timeSlotColorBuilder!(
                  filteredDates[dayIndex],
                  _slotDateTime(
                      filteredDates[dayIndex], slotIndex, slotMinutes),
                  _slotDateTime(
                      filteredDates[dayIndex], slotIndex + 1, slotMinutes),
                  slotIndex,
                ),
              ),
            ),
      ],
    );
  }

  List<Widget> _buildVerticalHourMarkers({
    required int minutesVisible,
    required TextDirection direction,
    required WeekViewThemeData themeColor,
  }) {
    final widgets = <Widget>[];
    final isRtl = direction == TextDirection.rtl;

    final hourCount = widget.endHour - widget.startHour;
    for (int index = 0; index <= hourCount; index++) {
      final hour = widget.startHour + index;
      if (!widget.showMidnightHour && hour == 0) continue;

      final offset = index * 60 * widget.heightPerMinute;
      widgets.add(
        Positioned(
          left: isRtl ? null : offset,
          right: isRtl ? offset : null,
          top: 0,
          bottom: 0,
          child: Container(
            width: widget.hourIndicatorSettings.height,
            color: widget.hourIndicatorSettings.color,
          ),
        ),
      );
    }

    if (widget.showHalfHours) {
      for (int index = 0; index < hourCount; index++) {
        final offset = (index * 60 + 30) * widget.heightPerMinute;
        widgets.add(
          Positioned(
            left: isRtl ? null : offset,
            right: isRtl ? offset : null,
            top: 0,
            bottom: 0,
            child: Container(
              width: widget.halfHourIndicatorSettings.height,
              color: widget.halfHourIndicatorSettings.color,
            ),
          ),
        );
      }
    }

    if (widget.showQuarterHours) {
      for (int index = 0; index < hourCount; index++) {
        for (final minute in [15, 45]) {
          final offset = (index * 60 + minute) * widget.heightPerMinute;
          widgets.add(
            Positioned(
              left: isRtl ? null : offset,
              right: isRtl ? offset : null,
              top: 0,
              bottom: 0,
              child: Container(
                width: widget.quarterHourIndicatorSettings.height,
                color: widget.quarterHourIndicatorSettings.color,
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  List<Widget> _buildVerticalDayRows({
    required List<DateTime> filteredDates,
    required double rowHeight,
    required double rowOffset,
    required double hourContentWidth,
    required WeekViewThemeData themeColor,
    required TextDirection direction,
  }) {
    final widgets = <Widget>[];
    final isRtl = direction == TextDirection.rtl;

    for (int index = 0; index < filteredDates.length; index++) {
      final date = filteredDates[index];
      final rowTop = rowOffset + rowHeight * index;

      widgets.add(
        Positioned(
          left: 0,
          right: 0,
          top: rowTop,
          height: rowHeight,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: widget.onDateTap == null
                ? null
                : (details) {
                    widget.onDateTap!.call(_dateFromHorizontalOffset(
                      date,
                      details.localPosition.dx,
                      hourContentWidth,
                      isRtl,
                    ));
                  },
            onLongPressStart: widget.onDateLongPress == null
                ? null
                : (details) {
                    widget.onDateLongPress!.call(_dateFromHorizontalOffset(
                      date,
                      details.localPosition.dx,
                      hourContentWidth,
                      isRtl,
                    ));
                  },
            child: SizedBox.expand(),
          ),
        ),
      );

      final arranged = widget.eventArranger.arrange(
        events: widget.controller.getEventsOnDay(
          date,
          includeFullDayEvents: false,
        ),
        height: hourContentWidth,
        width: rowHeight,
        heightPerMinute: widget.heightPerMinute,
        startHour: widget.startHour,
        calendarViewDate: date,
      );

      for (final organized in arranged) {
        final eventLeft = organized.top;
        final eventTop = rowTop + organized.left;
        final eventWidth = math
            .max(0.0, hourContentWidth - organized.bottom - organized.top)
            .toDouble();
        final eventHeight = math
            .max(0.0, rowHeight - organized.right - organized.left)
            .toDouble();

        if (widget.scrollConfiguration.shouldScroll &&
            organized.events
                .any((e) => e == widget.scrollConfiguration.event)) {
          _scrollToHorizontalEvent(eventLeft);
        }

        widgets.add(
          Positioned(
            left: isRtl ? null : eventLeft,
            right: isRtl ? eventLeft : null,
            top: eventTop,
            width: eventWidth,
            height: eventHeight,
            child: GestureDetector(
              onLongPress: widget.onTileLongTap == null
                  ? null
                  : () => widget.onTileLongTap!.call(organized.events, date),
              onTap: widget.onTileTap == null
                  ? null
                  : () => widget.onTileTap!.call(organized.events, date),
              onDoubleTap: widget.onTileDoubleTap == null
                  ? null
                  : () => widget.onTileDoubleTap!.call(organized.events, date),
              child: ClipRect(
                child: _buildVerticalEventTile(
                  date: date,
                  organized: organized,
                  eventWidth: eventWidth,
                  eventHeight: eventHeight,
                ),
              ),
            ),
          ),
        );
      }

      widgets.add(
        Positioned(
          left: 0,
          right: 0,
          top: rowTop,
          child: Divider(
            height: widget.hourIndicatorSettings.height,
            thickness: widget.hourIndicatorSettings.height,
            color: themeColor.borderColor,
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildVerticalLiveIndicators({
    required List<DateTime> filteredDates,
    required double rowHeight,
    required double rowOffset,
    required double hourContentWidth,
    required WeekViewThemeData themeColor,
    required TextDirection direction,
  }) {
    if (!widget.showLiveLine || widget.liveTimeIndicatorSettings.height <= 0) {
      return const [];
    }

    final isRtl = direction == TextDirection.rtl;
    final now = widget.liveTimeIndicatorSettings.currentTimeProvider?.call() ??
        DateTime.now();
    final minuteOffset = now.hour * 60 + now.minute - widget.startHour * 60;
    final lineX = minuteOffset * widget.heightPerMinute;

    if (lineX < 0 || lineX > hourContentWidth) {
      return const [];
    }

    final widgets = <Widget>[];
    for (int index = 0; index < filteredDates.length; index++) {
      final date = filteredDates[index];
      final showOnlyToday = widget.liveTimeIndicatorSettings.onlyShowToday;
      final showForDate = !showOnlyToday || DateUtils.isSameDay(date, now);
      if (!showForDate) continue;

      widgets.add(
        Positioned(
          left: isRtl ? null : lineX,
          right: isRtl ? lineX : null,
          top: rowOffset + rowHeight * index,
          height: rowHeight,
          child: Container(
            width: widget.liveTimeIndicatorSettings.height,
            color: widget.liveTimeIndicatorSettings.color,
          ),
        ),
      );
    }

    return widgets;
  }

  DateTime _slotDateTime(DateTime date, int slotIndex, int slotMinutes) {
    final minute = widget.startHour * 60 + slotIndex * slotMinutes;
    return DateTime(
      date.year,
      date.month,
      date.day,
      minute ~/ 60,
      minute % 60,
    );
  }

  DateTime _dateFromHorizontalOffset(
    DateTime date,
    double dx,
    double hourContentWidth,
    bool isRtl,
  ) {
    // In RTL the time axis is mirrored: dx=0 is the end-hour edge and
    // dx=hourContentWidth is the start-hour edge, so invert before mapping.
    final effectiveDx = isRtl ? (hourContentWidth - dx) : dx;
    final startMinute = widget.startHour * 60;
    final endMinute = widget.endHour * 60;
    final tappedMinute =
        (startMinute + (effectiveDx / widget.heightPerMinute).floor())
            .clamp(startMinute, endMinute - 1);
    return DateTime(
      date.year,
      date.month,
      date.day,
      tappedMinute ~/ 60,
      tappedMinute % 60,
    );
  }

  void _scrollToHorizontalEvent(double targetOffset) {
    final duration = widget.scrollConfiguration.duration ?? Duration.zero;
    final curve = widget.scrollConfiguration.curve ?? Curves.ease;
    final activeController = widget.keepScrollOffset
        ? scrollController
        : widget.weekViewScrollController;

    widget.scrollConfiguration.resetScrollEvent();

    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      try {
        await activeController.animateTo(
          math.max(0, targetOffset - 20),
          duration: duration,
          curve: curve,
        );
      } finally {
        widget.scrollConfiguration.completeScroll();
      }
    });
  }

  Widget _buildVerticalEventTile({
    required DateTime date,
    required OrganizedCalendarEventData<T> organized,
    required double eventWidth,
    required double eventHeight,
  }) {
    final useCompactTile = (eventHeight < _verticalCompactTileHeightThreshold ||
            eventWidth < _verticalCompactTileWidthThreshold) &&
        organized.events.isNotEmpty;

    if (!useCompactTile) {
      return widget.eventTileBuilder(
        date,
        organized.events,
        Rect.fromLTWH(0, 0, eventWidth, eventHeight),
        organized.startDuration,
        organized.endDuration,
      );
    }

    final primaryEvent = organized.events.first;
    final title = primaryEvent.title.trim();
    final text = title.isNotEmpty
        ? title
        : (primaryEvent.description?.trim().isNotEmpty ?? false)
            ? primaryEvent.description!.trim()
            : 'Event';
    final tinyLabel = text[0];

    if (eventWidth <= _verticalTinyTileWidthThreshold) {
      return Container(
        margin: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
          color: primaryEvent.color,
          borderRadius: BorderRadius.circular(3.0),
        ),
        alignment: Alignment.center,
        child: Text(
          tinyLabel,
          maxLines: 1,
          style: TextStyle(
            color: primaryEvent.color.accent,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: primaryEvent.color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      alignment: Alignment.center,
      child: Builder(
        builder: (context) {
          final textStyle = (primaryEvent.titleStyle ??
                  TextStyle(
                    color: primaryEvent.color.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ))
              .copyWith(
            fontSize: 10,
            overflow: TextOverflow.ellipsis,
          );
          final label = Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: textStyle,
          );
          final rotatesToFit = eventWidth < eventHeight;

          if (!rotatesToFit) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: math.max(0.0, eventWidth - 4.0),
                child: label,
              ),
            );
          }

          final isRtl = Directionality.of(context) == TextDirection.rtl;

          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: isRtl ? 1 : 3,
              child: SizedBox(
                width: math.max(0.0, eventHeight - 4.0),
                child: label,
              ),
            ),
          );
        },
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
