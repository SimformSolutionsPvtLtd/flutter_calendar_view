// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../components/_internal_components.dart';
import '../components/event_scroll_notifier.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../extensions.dart';
import '../modals.dart';
import '../painters.dart';
import '../typedefs.dart';
import '../zoom_scroll_controller.dart';

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

  /// Scroll listener to set every page's last offset.
  final void Function(
    int pageIndex,
    double offset,
    ZoomScrollController controller,
  ) scrollListener;

  /// Page index in the parent [PageView].
  final int pageIndex;

  /// Whether this page is currently visible in parent [PageView].
  final bool isCurrentPage;

  /// Last scroll offset of day view page.
  final double lastScrollOffset;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for day view
  final int endHour;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

  final TimestampCallback? onTimestampTap;

  /// A callback for rendering custom time slot background colors.
  final TimeSlotColorBuilder? timeSlotColorBuilder;

  /// Flag to display the 00:00 (midnight) hour in the timeline.
  ///
  /// When set to true, the 00:00 label will be shown on the timeline.
  /// Default value is false.
  final bool showMidnightHour;

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
    required this.scrollPhysics,
    required this.scrollListener,
    required this.pageIndex,
    required this.isCurrentPage,
    required this.dayDetectorBuilder,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.halfHourIndicatorSettings,
    required this.startHour,
    required this.endHour,
    required this.quarterHourIndicatorSettings,
    required this.emulateVerticalOffsetBy,
    required this.onTileDoubleTap,
    required this.onTimestampTap,
    this.timeSlotColorBuilder,
    this.lastScrollOffset = 0.0,
    this.keepScrollOffset = false,
    this.showMidnightHour = false,
  }) : super(key: key);

  @override
  _InternalDayViewPageState<T> createState() => _InternalDayViewPageState<T>();
}

class _InternalDayViewPageState<T extends Object?>
    extends State<InternalDayViewPage<T>> {
  late ZoomScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ZoomScrollController(
      initialScrollOffset: widget.lastScrollOffset,
    );
    scrollController.addListener(_scrollControllerListener);

    if (widget.isCurrentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.scrollListener(
          widget.pageIndex,
          scrollController.offset,
          scrollController,
        );
      });
    }
  }

  @override
  void didUpdateWidget(InternalDayViewPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.heightPerMinute != oldWidget.heightPerMinute &&
        widget.keepScrollOffset) {
      final currentOffset = scrollController.hasClients
          ? scrollController.offset
          : widget.lastScrollOffset;
      final scaledOffset = currentOffset *
          widget.heightPerMinute /
          (oldWidget.heightPerMinute > 0 ? oldWidget.heightPerMinute : 1.0);
      scrollController.prepareZoomJump(scaledOffset);
    }

    if (!widget.keepScrollOffset &&
        widget.isCurrentPage &&
        !oldWidget.isCurrentPage &&
        scrollController.hasClients) {
      scrollController.jumpTo(widget.lastScrollOffset);
    }

    if (widget.isCurrentPage && !oldWidget.isCurrentPage) {
      widget.scrollListener(
        widget.pageIndex,
        scrollController.hasClients
            ? scrollController.offset
            : widget.lastScrollOffset,
        scrollController,
      );
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
    widget.scrollListener(
      widget.pageIndex,
      scrollController.offset,
      scrollController,
    );
  }

  /// Builds the background color layer for time slots in the day view.
  ///
  /// Uses the [timeSlotColorBuilder] callback to determine each slot's color,
  /// creating a vertical grid of colored rectangles for the day.
  ///
  /// Returns a [Widget] rendering the colored background for all time slots.
  Widget _buildTimeSlotBackground() {
    // Extract the minute duration of each time slot (e.g., 15, 30, 60 minutes)
    final slotMinutes = widget.minuteSlotSize.minutes;
    // Calculate the pixel height occupied by one time slot
    final heightPerSlot = widget.heightPerMinute * slotMinutes;
    // Calculate the total number of time slots in the day view
    // based on start and end hours
    final totalSlots =
        ((widget.endHour - widget.startHour) * 60) ~/ slotMinutes;
    final startDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      widget.startHour,
    );
    final slotDuration = Duration(minutes: slotMinutes);
    // Generate a list of colors for each time slot of the day
    final slotColors = List<Color>.generate(
      totalSlots,
      (slotIndex) {
        final slotStartTime = startDateTime.add(slotDuration * slotIndex);
        final slotEndTime = slotStartTime.add(slotDuration);
        return widget.timeSlotColorBuilder!(
          widget.date,
          slotStartTime,
          slotEndTime,
          slotIndex,
        );
      },
    );
    final direction = Directionality.of(context);
    // Calculate the width of the content area, excluding the time line and
    // hour indicator lines
    final contentWidth = widget.width -
        widget.timeLineWidth -
        widget.hourIndicatorSettings.offset -
        widget.verticalLineOffset;

    return Align(
      alignment: direction == TextDirection.rtl
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: SizedBox(
        width: contentWidth,
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
  }

  @override
  Widget build(BuildContext context) {
    final fullDayEventList = widget.controller.getFullDayEvent(widget.date);
    final direction = Directionality.of(context);

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
            // Fix to ===> scroll controller exception
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: widget.keepScrollOffset,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: widget.scrollPhysics,
                child: SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: Stack(
                    children: [
                      // Render time slot backgrounds if color builder is provided
                      if (widget.timeSlotColorBuilder != null)
                        _buildTimeSlotBackground(),
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
                            startHour: widget.startHour,
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
                      widget.dayDetectorBuilder(
                        width: widget.width,
                        height: widget.height,
                        heightPerMinute: widget.heightPerMinute,
                        date: widget.date,
                        minuteSlotSize: widget.minuteSlotSize,
                      ),
                      Align(
                        alignment: direction == TextDirection.rtl
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
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
                        pageDate: widget.date,
                        showHalfHours: widget.showHalfHours,
                        startHour: widget.startHour,
                        endHour: widget.endHour,
                        showQuarterHours: widget.showQuarterHours,
                        key: ValueKey(widget.heightPerMinute),
                        liveTimeIndicatorSettings:
                            widget.liveTimeIndicatorSettings,
                        onTimestampTap: widget.onTimestampTap,
                        showMidnightHour: widget.showMidnightHour,
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
          ),
        ],
      ),
    );
  }
}
