// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';

class ScheduleView<T extends Object?> extends StatefulWidget {
  final EventController<T>? controller;
  final DateTime? initialDay;
  final DateTime? minDay;
  final DateTime? maxDay;

  /// Builds a custom header for a given month.
  final ScheduleMonthHeaderBuilder? monthHeaderBuilder;

  /// Builds a custom widget for the date column (left side of each day row).
  /// If provided alongside [onDateTap]/[onDateLongPress], those callbacks are
  /// still applied automatically around this builder's output.
  final ScheduleDateWidgetBuilder? dateHeaderBuilder;

  /// Replaces the entire date column including gesture detection.
  /// When set, [onDateTap] and [onDateLongPress] are NOT applied automatically;
  /// the builder is fully responsible for handling interaction.
  final ScheduleDateWidgetBuilder? dayDetectorBuilder;

  /// Builds a custom event tile for a given event and date.
  final ScheduleEventTileBuilder<T>? eventTileBuilder;

  /// Widget shown in the events area when there are no events on a day.
  final Widget? emptyTextWidget;

  /// Called when the date circle/column is tapped.
  final DateTapCallback? onDateTap;

  /// Called when the date circle/column is long-pressed.
  final DatePressCallback? onDateLongPress;

  /// Called when an event tile is tapped. Receives the single tapped event
  /// wrapped in a list, plus the date.
  final CellTapCallback<T>? onEventTap;

  /// Called when an event tile is long-pressed.
  final CellTapCallback<T>? onEventLongTap;

  /// Called when an event tile is double-tapped.
  final CellTapCallback<T>? onEventDoubleTap;

  /// Returns a custom string for the month header (e.g. for i18n).
  /// Receives the first day of the month. [secondaryDate] is not used.
  final StringProvider? dateStringBuilder;

  /// Returns a custom abbreviation for a weekday number (1=Mon … 7=Sun).
  final String Function(int weekday)? weekDayStringBuilder;

  const ScheduleView({
    Key? key,
    this.controller,
    this.initialDay,
    this.minDay,
    this.maxDay,
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
  }) : super(key: key);

  @override
  ScheduleViewState<T> createState() => ScheduleViewState<T>();
}

class ScheduleViewState<T extends Object?> extends State<ScheduleView<T>> {
  late EventController<T> _controller;
  late DateTime _initialDay;
  late DateTime _minDay;
  late DateTime _maxDay;

  @override
  void initState() {
    super.initState();
    _initialDay = widget.initialDay ?? DateTime.now();
    _minDay = widget.minDay ?? CalendarConstants.epochDate;
    _maxDay = widget.maxDay ?? CalendarConstants.maxDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    _controller.removeListener(_reload);
    _controller.addListener(_reload);
  }

  @override
  void didUpdateWidget(ScheduleView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_reload);
      _controller = widget.controller!;
      _controller.addListener(_reload);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    if (mounted) setState(() {});
  }

  // Cap the month count so ListView.builder always has a finite itemCount,
  // preventing an infinite build loop when months with no events return
  // zero-height widgets.
  int get _itemCount {
    final months = (_maxDay.year - _initialDay.year) * 12 +
        _maxDay.month -
        _initialDay.month +
        1;
    return months.clamp(1, 1200);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        final monthDate = DateTime(
          _initialDay.year,
          _initialDay.month + index,
          1,
        );

        if (monthDate.isBefore(DateTime(_minDay.year, _minDay.month, 1)) ||
            monthDate.isAfter(DateTime(_maxDay.year, _maxDay.month, 1))) {
          return const SizedBox.shrink();
        }

        // For the first month show only from the initial day onward so the
        // view opens with today visible at the top.
        final startDay = index == 0 ? _initialDay.day : 1;
        return _buildMonth(monthDate, startDay: startDay);
      },
    );
  }

  Widget _buildMonth(DateTime monthDate, {int startDay = 1}) {
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final List<Widget> dayWidgets = [];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int day = startDay; day <= daysInMonth; day++) {
      final date = DateTime(monthDate.year, monthDate.month, day);

      if (date.isBefore(DateTime(_minDay.year, _minDay.month, _minDay.day)) ||
          date.isAfter(DateTime(_maxDay.year, _maxDay.month, _maxDay.day))) {
        continue;
      }

      final events = _controller.getEventsOnDay(date);
      final isToday = date == today;

      if (events.isNotEmpty || isToday) {
        dayWidgets.add(_buildDayRow(date, events, isToday));
      }
    }

    if (dayWidgets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.monthHeaderBuilder != null)
          widget.monthHeaderBuilder!(monthDate)
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              widget.dateStringBuilder != null
                  ? widget.dateStringBuilder!(monthDate)
                  : '${_monthName(monthDate.month)} ${monthDate.year}',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        ...dayWidgets,
      ],
    );
  }

  Widget _buildDayRow(
      DateTime date, List<CalendarEventData<T>> events, bool isToday) {
    // Sort events: by start time, then title, then description.
    final sortedEvents = List.of(events)
      ..sort((a, b) {
        final ta = a.startTime;
        final tb = b.startTime;
        if (ta != null && tb != null) {
          final diff =
              (ta.hour * 60 + ta.minute) - (tb.hour * 60 + tb.minute);
          if (diff != 0) return diff;
        } else if (ta != null) {
          return -1;
        } else if (tb != null) {
          return 1;
        }
        final titleCmp = a.title.compareTo(b.title);
        if (titleCmp != 0) return titleCmp;
        return (a.description ?? '').compareTo(b.description ?? '');
      });

    final dateCell = _buildDateCell(date, sortedEvents, isToday);

    final eventsArea = sortedEvents.isEmpty
        ? (widget.emptyTextWidget ??
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Nothing planned. Tap to create.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sortedEvents.map((event) {
              final tile = widget.eventTileBuilder != null
                  ? widget.eventTileBuilder!(event, date)
                  : _defaultEventTile(event);

              return GestureDetector(
                onTap: widget.onEventTap != null
                    ? () => widget.onEventTap!([event], date)
                    : null,
                onLongPress: widget.onEventLongTap != null
                    ? () => widget.onEventLongTap!([event], date)
                    : null,
                onDoubleTap: widget.onEventDoubleTap != null
                    ? () => widget.onEventDoubleTap!([event], date)
                    : null,
                child: tile,
              );
            }).toList(),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 50, child: dateCell),
          const SizedBox(width: 16),
          Expanded(child: eventsArea),
        ],
      ),
    );
  }

  Widget _buildDateCell(
      DateTime date, List<CalendarEventData<T>> events, bool isToday) {
    if (widget.dayDetectorBuilder != null) {
      return widget.dayDetectorBuilder!(date, events);
    }

    final content = widget.dateHeaderBuilder != null
        ? widget.dateHeaderBuilder!(date, events)
        : _defaultDateHeader(date, isToday);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onDateTap != null ? () => widget.onDateTap!(date) : null,
      onLongPress: widget.onDateLongPress != null
          ? () => widget.onDateLongPress!(date)
          : null,
      child: content,
    );
  }

  Widget _defaultDateHeader(DateTime date, bool isToday) {
    final weekday = widget.weekDayStringBuilder != null
        ? widget.weekDayStringBuilder!(date.weekday)
        : _weekdayAbbr(date.weekday);

    return Column(
      children: [
        Text(
          weekday,
          style: TextStyle(
            fontSize: 12,
            color: isToday ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isToday ? Colors.blue : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
              color: isToday ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaultEventTile(CalendarEventData<T> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              event.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayAbbr(int weekday) {
    const abbrs = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return abbrs[(weekday - 1).clamp(0, 6)];
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[(month - 1).clamp(0, 11)];
  }
}
