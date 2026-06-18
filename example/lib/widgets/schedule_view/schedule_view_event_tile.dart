import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

class ScheduleViewEventTile extends StatelessWidget {
  const ScheduleViewEventTile({
    super.key,
    required this.event,
    required this.date,
  });

  final CalendarEventData event;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final scheduleColors = context.scheduleViewColors;
    final tileColor = event.color.withAlpha(scheduleColors.eventTileAlpha);
    final hsl = HSLColor.fromColor(event.color);
    final timeColor = hsl
        .withLightness(
          (hsl.lightness + scheduleColors.eventTimeColorLightnessAdjust).clamp(
            0.0,
            1.0,
          ),
        )
        .toColor()
        .withAlpha(200);
    final timeLabel = _buildTimeLabel(context, event);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: event.color, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time + badges row
                  Row(
                    children: [
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: timeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (event.isRecurringEvent) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.repeat, size: 12, color: timeColor),
                      ],
                      if (event.isRangingEvent) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.date_range, size: 12, color: timeColor),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheduleColors.eventTitleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Description preview
                  if (event.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheduleColors.eventSecondaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: scheduleColors.eventSecondaryTextColor.withAlpha(120),
            ),
          ],
        ),
      ),
    );
  }

  // Demo-only: always renders 12-hour times (digits/AM-PM are still localized
  // via PackageStrings inside getTimeInFormat). A real app would pick the
  // format from the locale / MediaQuery.alwaysUse24HourFormat.
  String _formatTime(TimeOfDay time) =>
      time.getTimeInFormat(TimeStampFormat.parse_12);

  String _buildTimeLabel(BuildContext context, CalendarEventData event) {
    final translate = context.translate;
    if (event.isFullDayEvent) return translate.scheduleAllDay;
    final start = event.startTime;
    final end = event.endTime;
    if (start != null && end != null) {
      return '${_formatTime(start)} – ${_formatTime(end)}';
    }
    if (start != null) return _formatTime(start);
    return translate.scheduleAllDay;
  }
}
