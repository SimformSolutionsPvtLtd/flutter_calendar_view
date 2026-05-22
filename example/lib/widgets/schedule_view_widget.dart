import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class ScheduleViewWidget extends StatelessWidget {
  final double? width;

  const ScheduleViewWidget({super.key, this.width});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ScheduleView(
        initialDay: DateTime.now(),

        // Navigate to event details when an event tile is tapped.
        onEventTap: (events, date) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsPage(event: events.first, date: date),
          ),
        ),

        // Show a snackbar on event long-press.
        onEventLongTap: (events, date) =>
            _showSnackBar(context, 'on LongTap'),

        // Show the tapped date in a snackbar.
        onDateTap: (date) => _showSnackBar(
          context,
          'Tapped ${date.day}/${date.month}/${date.year}',
        ),

        // Show the long-pressed date in a snackbar.
        onDateLongPress: (date) => _showSnackBar(
          context,
          'Long pressed ${date.day}/${date.month}/${date.year}',
        ),

        // Custom month header string (demonstrates dateStringBuilder / i18n).
        dateStringBuilder: (date, {secondaryDate}) {
          const months = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
          ];
          return '${months[date.month - 1]} ${date.year}';
        },

        // Custom weekday abbreviation (demonstrates weekDayStringBuilder / i18n).
        weekDayStringBuilder: (weekday) {
          const abbrs = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          return abbrs[(weekday - 1).clamp(0, 6)];
        },

        // Custom date column that also shows a dot when there are events
        // (demonstrates dayDetectorBuilder — it owns tap detection).
        dayDetectorBuilder: (date, events) {
          const abbrs = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final now = DateTime.now();
          final isToday = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showSnackBar(
              context,
              'Custom detector: ${date.day}/${date.month}/${date.year}',
            ),
            onLongPress: () => _showSnackBar(
              context,
              'Custom long-press: ${date.day}/${date.month}/${date.year}',
            ),
            child: Column(
              children: [
                Text(
                  abbrs[(date.weekday - 1).clamp(0, 6)],
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
                    border: isToday
                        ? null
                        : Border.all(color: Colors.grey.shade300),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isToday ? FontWeight.bold : FontWeight.w500,
                      color: isToday ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (events.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
