import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;
  final double heightPerMinute;

  const WeekViewWidget({
    super.key,
    this.state,
    this.width,
    this.heightPerMinute = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return WeekView(
      key: state,
      width: width,
      heightPerMinute: heightPerMinute,
      showWeekends: true,
      showMidnightHour: true,
      showLiveTimeLineInAllDays: true,
      timeSlotColorBuilder: (_, slotStartTime, __, ___) {
        final hour = slotStartTime.hour;
        final isBusinessHours = hour >= 9 && hour < 17;
        final isLunchBreak = hour == 12;
        final isWeekend =
            slotStartTime.weekday == DateTime.saturday ||
            slotStartTime.weekday == DateTime.sunday;

        return isWeekend
            ? Colors.grey.shade100
            : isLunchBreak
            ? Colors.orange.shade100
            : isBusinessHours
            ? Colors.green.shade50
            : Colors.transparent;
      },
      eventArranger: SideEventArranger(),
      timeLineWidth: 65,
      scrollPhysics: const BouncingScrollPhysics(),
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        showTime: true,
      ),
      dividerSettings: DividerSettings(
        color: Colors.redAccent.withAlpha(40),
        thickness: 0.5,
        height: 0.5,
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
    );
  }
}
