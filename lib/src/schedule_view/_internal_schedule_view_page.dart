// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Renders a single month block in the schedule view.
///
/// Displays the month header followed by a row for each day that has events,
/// is today, or should be shown due to [showDaysWithoutEvents].
class InternalScheduleViewPage<T extends Object?> extends StatelessWidget {
  final DateTime monthDate;
  final int startDay;
  final int? endDay;
  final bool showHeader;
  final DateTime minDay;
  final DateTime maxDay;
  final bool showDaysWithoutEvents;
  final List<CalendarEventData<T>> Function(DateTime date) eventsForDay;
  final ScheduleMonthHeaderBuilder? monthHeaderBuilder;
  final ScheduleDateWidgetBuilder? dateHeaderBuilder;
  final ScheduleDateWidgetBuilder? dayDetectorBuilder;
  final ScheduleEventTileBuilder<T>? eventTileBuilder;
  final Widget? emptyTextWidget;
  final DateTapCallback? onDateTap;
  final DatePressCallback? onDateLongPress;
  final CellTapCallback<T>? onEventTap;
  final CellTapCallback<T>? onEventLongTap;
  final CellTapCallback<T>? onEventDoubleTap;
  final StringProvider? dateStringBuilder;
  final String Function(int weekday)? weekDayStringBuilder;
  final ScheduleMonthHeaderBuilder? emptyMonthBuilder;
  final EventSorter<T>? eventSorter;
  final ScheduleDateLayout dateLayout;
  final DividerSettings? dividerSettings;
  final Widget? todayEmptyWidget;

  const InternalScheduleViewPage({
    Key? key,
    required this.monthDate,
    required this.startDay,
    this.endDay,
    this.showHeader = true,
    required this.minDay,
    required this.maxDay,
    required this.showDaysWithoutEvents,
    required this.eventsForDay,
    this.monthHeaderBuilder,
    this.dateHeaderBuilder,
    this.dayDetectorBuilder,
    this.eventTileBuilder,
    this.emptyTextWidget,
    this.onDateTap,
    this.onDateLongPress,
    this.onEventTap,
    this.onEventLongTap,
    this.onEventDoubleTap,
    this.dateStringBuilder,
    this.weekDayStringBuilder,
    this.emptyMonthBuilder,
    this.eventSorter,
    this.dateLayout = ScheduleDateLayout.left,
    this.dividerSettings,
    this.todayEmptyWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.scheduleViewColors;
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final lastDay = (endDay ?? daysInMonth).clamp(1, daysInMonth);
    final List<Widget> dayWidgets = [];
    final now = DateTime.now();

    for (int day = startDay; day <= lastDay; day++) {
      final date = DateTime(monthDate.year, monthDate.month, day);

      if (date.isBefore(DateTime(minDay.year, minDay.month, minDay.day)) ||
          date.isAfter(DateTime(maxDay.year, maxDay.month, maxDay.day))) {
        continue;
      }

      final events = eventsForDay(date);
      final isToday = date == DateTime(now.year, now.month, now.day);

      if (events.isNotEmpty || isToday || showDaysWithoutEvents) {
        dayWidgets.add(_buildDayRow(theme, date, events, isToday));
      }
    }

    // Empty month: pre-filtering guarantees this only occurs when
    // showEmptyMonths: true (false case is filtered before reaching here).
    // Restricted to the header-bearing piece (showHeader): the split anchor
    // month's head piece (endDay != null) renders just its header, and its
    // tail piece (showHeader == false) must not render a second standalone
    // empty-month block below that header for the same month.
    if (dayWidgets.isEmpty &&
        endDay == null &&
        showHeader &&
        emptyMonthBuilder != null) {
      return emptyMonthBuilder!(monthDate);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!showHeader)
          const SizedBox.shrink()
        else if (monthHeaderBuilder != null)
          monthHeaderBuilder!(monthDate)
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              dateStringBuilder != null
                  ? dateStringBuilder!(monthDate)
                  : monthDate.getMonthYear(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.dateTextColor,
              ),
            ),
          ),
        ...dayWidgets,
      ],
    );
  }

  /// Builds the row for a single [date]: a date cell paired with that day's
  /// events.
  ///
  /// When [eventSorter] is supplied the [events] are re-sorted with it;
  /// otherwise the controller-provided order is kept. An empty day falls back
  /// to [todayEmptyWidget] (when [isToday]), then [emptyTextWidget], then a
  /// plain divider. The cell and events are laid out vertically for
  /// [ScheduleDateLayout.top] and side by side otherwise.
  Widget _buildDayRow(
    ScheduleViewThemeData theme,
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
  ) {
    // [eventsForDay] returns a controller-sorted list; only re-sort when
    // this view supplies an eventSorter to override the controller's order.
    final sortedEvents =
        eventSorter == null ? events : (List.of(events)..sort(eventSorter!));

    final dateCell = _buildDateCell(theme, date, sortedEvents, isToday);

    Widget eventsArea;
    if (sortedEvents.isEmpty) {
      // [emptyTextWidget] only applies when empty days are rendered as a
      // first-class row (showDaysWithoutEvents). Today is always rendered even
      // in sparse mode, but there only [todayEmptyWidget] (then the divider)
      // applies — keeping release behaviour in step with the debug assert and
      // docs.
      eventsArea = (isToday ? todayEmptyWidget : null) ??
          (showDaysWithoutEvents ? emptyTextWidget : null) ??
          SizedBox(
            height: 60,
            child: Divider(color: theme.dateDividerColor),
          );
    } else {
      eventsArea = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedEvents.map((event) {
          final tile = eventTileBuilder != null
              ? eventTileBuilder!(event, date)
              : _defaultEventTile(theme, event);

          return GestureDetector(
            onTap: onEventTap != null ? () => onEventTap!([event], date) : null,
            onLongPress: onEventLongTap != null
                ? () => onEventLongTap!([event], date)
                : null,
            onDoubleTap: onEventDoubleTap != null
                ? () => onEventDoubleTap!([event], date)
                : null,
            child: tile,
          );
        }).toList(),
      );
    }

    if (dateLayout == ScheduleDateLayout.top) {
      // The date header spans the full row width above the events. `stretch`
      // lets the header (and its divider) fill the row, matching how the left
      // layout's [Expanded] events column already fills its side.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dateCell,
            const SizedBox(height: 8),
            eventsArea,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: sortedEvents.isEmpty
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          SizedBox(width: 50, child: dateCell),
          const SizedBox(width: 16),
          Expanded(child: eventsArea),
        ],
      ),
    );
  }

  /// Builds the date cell shown alongside a day's events.
  ///
  /// Prefers [dayDetectorBuilder] when provided (it owns its own gestures).
  /// Otherwise renders [dateHeaderBuilder] or the default header wrapped in a
  /// [GestureDetector] that forwards taps to [onDateTap] / [onDateLongPress].
  Widget _buildDateCell(
    ScheduleViewThemeData theme,
    DateTime date,
    List<CalendarEventData<T>> events,
    bool isToday,
  ) {
    if (dayDetectorBuilder != null) {
      return dayDetectorBuilder!(date, events, dateLayout);
    }

    final content = dateHeaderBuilder != null
        ? dateHeaderBuilder!(date, events, dateLayout)
        : _defaultDateHeader(theme, date, isToday);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onDateTap != null ? () => onDateTap!(date) : null,
      onLongPress:
          onDateLongPress != null ? () => onDateLongPress!(date) : null,
      child: content,
    );
  }

  /// Builds the default date header for a day.
  ///
  /// Shows the localized weekday abbreviation above the day number, with the
  /// number circled and recoloured when [isToday]. Delegates to
  /// [_defaultTopDateHeader] for the [ScheduleDateLayout.top] layout.
  Widget _defaultDateHeader(
    ScheduleViewThemeData theme,
    DateTime date,
    bool isToday,
  ) {
    final weekday = weekDayStringBuilder != null
        ? weekDayStringBuilder!(date.weekday)
        : date.weekDayEnum.abbreviation;

    if (dateLayout == ScheduleDateLayout.top) {
      return _defaultTopDateHeader(theme, date, isToday, weekday);
    }

    return Column(
      children: [
        Text(
          weekday,
          style: TextStyle(
            fontSize: 12,
            color: isToday ? theme.todayHighlightColor : theme.weekdayTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isToday ? theme.todayHighlightColor : theme.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            PackageStrings.localizeNumber(date.day),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
              color: isToday ? theme.todayTextColor : theme.dateTextColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the default date header for the [ScheduleDateLayout.top] layout.
  ///
  /// Lays out a circled [weekday] badge next to a localized "day month" label
  /// (e.g. "5 Jun"), followed by a full-width divider from [dividerSettings].
  Widget _defaultTopDateHeader(
    ScheduleViewThemeData theme,
    DateTime date,
    bool isToday,
    String weekday,
  ) {
    // e.g. "5 Jun" — day-of-month and abbreviated month, both localized.
    final dayMonth = '${PackageStrings.localizeNumber(date.day)} '
        '${date.getMonthName(abbreviated: true)}';

    final divider =
        dividerSettings ?? DividerSettings(color: theme.dateDividerColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isToday ? theme.todayHighlightColor : theme.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                weekday,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      isToday ? theme.todayTextColor : theme.weekdayTextColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              dayMonth,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                color: theme.dateTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(
          height: divider.height,
          thickness: divider.thickness,
          color: divider.color,
          indent: divider.indent,
          endIndent: divider.endIndent,
        ),
      ],
    );
  }

  /// Builds the default tile for a single [event].
  ///
  /// Renders the event title on a tinted background (the event colour at
  /// [ScheduleViewThemeData.eventTileAlpha]) with a coloured left border.
  Widget _defaultEventTile(
    ScheduleViewThemeData theme,
    CalendarEventData<T> event,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: event.color.withAlpha(theme.eventTileAlpha),
        borderRadius: BorderRadius.circular(10.0),
        border: Border(left: BorderSide(color: event.color, width: 4)),
      ),
      child: Text(
        event.title,
        style: TextStyle(
          color: theme.eventTitleColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
