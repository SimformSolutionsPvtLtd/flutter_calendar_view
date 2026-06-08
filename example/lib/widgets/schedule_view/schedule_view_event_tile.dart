import 'package:calendar_view/calendar_view.dart';
import 'package:example/event_types.dart';
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

    // Event types may carry a background image; when present it replaces the
    // solid tint and we render text over a scrim, mirroring the month header.
    final imagePath = kEventTypeConfigs[event.eventType]?.imagePath;
    final hasImage = imagePath != null;

    final hsl = HSLColor.fromColor(event.color);
    final tintedTimeColor = hsl
        .withLightness(
          (hsl.lightness + scheduleColors.eventTimeColorLightnessAdjust).clamp(
            0.0,
            1.0,
          ),
        )
        .toColor()
        .withAlpha(200);

    // Over an image, fall back to the header's light text + shadow so content
    // stays readable regardless of the photo behind it.
    final timeColor = hasImage
        ? scheduleColors.monthHeaderTextColor
        : tintedTimeColor;
    final titleColor = hasImage
        ? scheduleColors.monthHeaderTextColor
        : scheduleColors.eventTitleColor;
    final secondaryColor = hasImage
        ? scheduleColors.monthHeaderTextColor.withAlpha(220)
        : scheduleColors.eventSecondaryTextColor;
    final chevronColor = hasImage
        ? scheduleColors.monthHeaderTextColor.withAlpha(180)
        : scheduleColors.eventSecondaryTextColor.withAlpha(120);
    final textShadows = hasImage
        ? [
            Shadow(
              blurRadius: 4,
              color: scheduleColors.monthHeaderTextShadowColor,
            ),
          ]
        : null;

    final timeLabel = _buildTimeLabel(context, event);

    final content = Padding(
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
                        shadows: textShadows,
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
                    color: titleColor,
                    shadows: textShadows,
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
                      color: secondaryColor,
                      shadows: textShadows,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 16, color: chevronColor),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: hasImage ? 4 : 2, horizontal: 2),
      clipBehavior: hasImage ? Clip.antiAlias : Clip.none,
      // Image-backed tiles render taller than the text-only tiles so the
      // photo has room to read as a hero background.
      constraints: hasImage ? const BoxConstraints(minHeight: 120) : null,
      decoration: BoxDecoration(
        color: hasImage ? null : tileColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: event.color, width: 4)),
      ),
      child: hasImage
          ? Stack(
              // Center the content vertically within the taller image area.
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
                // Dark scrim keeps the light text legible over any photo.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          scheduleColors.monthHeaderGradientEndColor.withAlpha(
                            235,
                          ),
                          scheduleColors.monthHeaderGradientEndColor.withAlpha(
                            140,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                content,
              ],
            )
          : content,
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
