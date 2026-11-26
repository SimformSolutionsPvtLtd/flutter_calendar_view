import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({super.key, this.state, this.width});

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return DayView(
      key: state,
      width: width,
      startDuration: Duration(hours: 8),
      showHalfHours: true,
      heightPerMinute: 3,
      timeLineBuilder: (date) => _timeLineBuilder(date, isLtr),
      scrollPhysics: const BouncingScrollPhysics(),
      eventArranger: SideEventArranger(),
      showQuarterHours: false,
      showMidnightHour: true,
      hourIndicatorSettings: HourIndicatorSettings(
        color: Theme.of(context).dividerColor,
      ),
      onTimestampTap: (date) {
        SnackBar snackBar = SnackBar(
          content: Text("On tap: ${date.hour} Hr : ${date.minute} Min"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onEventTap: (events, date) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsPage(event: events.first, date: date),
          ),
        );
      },
      onEventLongTap: (events, date) {
        SnackBar snackBar = SnackBar(content: Text("on LongTap"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      halfHourIndicatorSettings: HourIndicatorSettings(
        color: CalendarThemeProvider.of(
          context,
        ).calendarTheme.dayViewTheme.hourLineColor,
        lineStyle: LineStyle.dashed,
      ),
      verticalLineOffset: 0,
      timeLineWidth: 65,
      // Each slot can be any widget, not just a color.
      timeSlotBuilder: (_, slotStartTime, __, ___) =>
          _buildTimeSlot(slotStartTime.hour),
      showLiveTimeLineInAllDays: true,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        showBullet: false,
        showTime: true,
        showTimeBackgroundView: true,
      ),
    );
  }

  Widget _buildTimeSlot(int hour) {
    // Lunch break: a photo with the label on top.
    if (hour == 12) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/lunch.jpg', fit: BoxFit.cover),
          const ColoredBox(color: Colors.black45),
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.restaurant, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Lunch break',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final isBusinessHours = hour >= 9 && hour < 17;
    return ColoredBox(
      color: isBusinessHours ? Colors.green.shade50 : Colors.grey.shade100,
    );
  }

  Widget _timeLineBuilder(DateTime date, bool isLtr) {
    if (date.minute != 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: -8,
            right: 8,
            left: 8,
            child: Text(
              "${PackageStrings.localizeNumber(date.hour)}:${PackageStrings.localizeNumber(date.minute)}",
              textAlign: isLtr ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    final hour = ((date.hour - 1) % 12) + 1;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -8,
          right: 8,
          left: 8,
          child: Text(
            "${PackageStrings.localizeNumber(hour)} ${date.hour ~/ 12 == 0 ? PackageStrings.currentLocale.am : PackageStrings.currentLocale.pm}",
            textAlign: isLtr ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
