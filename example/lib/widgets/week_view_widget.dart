import 'package:calendar_view/calendar_view.dart';
import 'package:example/constants.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({super.key, this.state, this.width});

  @override
  Widget build(BuildContext context) {
    return WeekView(
      key: state,
      width: width,
      headerStringBuilder: (DateTime date, {DateTime? secondaryDate}) =>
          _weekStringBuilder(
        date,
        secondaryDate: secondaryDate,
        textDirection: Directionality.of(context),
      ),
      showWeekends: true,
      showLiveTimeLineInAllDays: true,
      eventArranger: SideEventArranger(
        directionality: Directionality.of(context),
      ),
      timeLineWidth: 68,
      scrollPhysics: const BouncingScrollPhysics(),
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        timeBackgroundViewWidth: 68,
        offset: 0,
        showTime: true,
        showBullet: true,
        showTimeBackgroundView: true,
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
            builder: (_) => DetailsPage(
              event: events.first,
              date: date,
              directionality: Directionality.of(context),
            ),
          ),
        );
      },
      onEventLongTap: (events, date) {
        SnackBar snackBar = SnackBar(content: Text("on LongTap"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

  String _weekStringBuilder(DateTime date,
      {DateTime? secondaryDate, TextDirection? textDirection}) {
    final dateString = "${date.day} / ${date.month} / ${date.year}";
    final secondaryDateString = secondaryDate != null
        ? "${secondaryDate.day} / ${secondaryDate.month} / ${secondaryDate.year}"
        : "";

    if (textDirection == TextDirection.rtl) {
      return "${AppConstants.ltr}${secondaryDateString} to ${dateString}";
    } else {
      return "${AppConstants.ltr}${dateString} to ${secondaryDateString}";
    }
  }
}
