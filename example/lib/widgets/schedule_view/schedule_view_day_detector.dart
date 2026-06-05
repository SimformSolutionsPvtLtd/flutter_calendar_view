import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

class ScheduleViewDayDetector extends StatelessWidget {
  final DateTime date;
  final List<CalendarEventData> events;

  /// Where the date sits relative to the events. Drives whether the date is
  /// rendered as a narrow vertical badge (left) or a full-width inline header
  /// (top), so the same detector adapts to either [ScheduleView.dateLayout].
  final ScheduleDateLayout layout;

  const ScheduleViewDayDetector({
    super.key,
    required this.date,
    required this.events,
    this.layout = ScheduleDateLayout.left,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleColors = context.scheduleViewColors;
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          context.showSnackBarWithText(date.localizedShortDate(context)),
      onLongPress: () => context.showSnackBarWithText(
        '${context.translate.scheduleLongPressed} ${date.localizedShortDate(context)}',
      ),
      child: layout == ScheduleDateLayout.top
          ? _buildTopHeader(context, scheduleColors, isToday)
          : _buildLeftBadge(context, scheduleColors, isToday),
    );
  }

  /// Vertical badge for the left layout: weekday over a circular day number
  /// with event dots beneath, sized to fit the fixed-width date column.
  Widget _buildLeftBadge(
    BuildContext context,
    ScheduleViewThemeData colors,
    bool isToday,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            date.weekDayEnum.abbreviation,
            style: TextStyle(
              fontSize: 11,
              color: isToday
                  ? colors.todayHighlightColor
                  : colors.weekdayTextColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isToday ? colors.todayHighlightColor : colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              date.localizedDay(context),
              style: TextStyle(
                fontSize: 15,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: isToday ? colors.todayTextColor : colors.dateTextColor,
              ),
            ),
          ),
          if (events.isNotEmpty) ...[
            const SizedBox(height: 4),
            _EventDots(events: events),
          ],
        ],
      ),
    );
  }

  /// Inline, full-width header for the top layout: the weekday in a circle —
  /// highlighted on today — beside the "day month" label, with event dots
  /// trailing and a divider separating it from the events.
  Widget _buildTopHeader(
    BuildContext context,
    ScheduleViewThemeData colors,
    bool isToday,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isToday
                    ? colors.todayHighlightColor
                    : colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                date.weekDayEnum.abbreviation,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isToday
                      ? colors.todayTextColor
                      : colors.weekdayTextColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${date.localizedDay(context)} '
              '${date.getMonthName(abbreviated: true)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                color: colors.dateTextColor,
              ),
            ),
            if (events.isNotEmpty) ...[
              const Spacer(),
              _EventDots(events: events),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Divider(height: 1, thickness: 1, color: colors.dateDividerColor),
      ],
    );
  }
}

/// Up to three small colored dots, one per event, used as an at-a-glance
/// density indicator in both date layouts.
class _EventDots extends StatelessWidget {
  const _EventDots({required this.events});

  final List<CalendarEventData> events;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: events
          .take(3)
          .map(
            (e) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: e.color, shape: BoxShape.circle),
            ),
          )
          .toList(),
    );
  }
}
