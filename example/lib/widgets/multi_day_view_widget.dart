import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class MultiDayViewWidget extends StatelessWidget {
  final GlobalKey<MultiDayViewState>? state;
  final double? width;

  const MultiDayViewWidget({super.key, this.state, this.width});

  @override
  Widget build(BuildContext context) {
    return MultiDayView(
      key: state,
      daysInView: 3,
      width: width,
      showLiveTimeLineInAllDays: true,
      eventArranger: SideEventArranger(maxWidth: 30),
      timeLineWidth: 65,
      scrollPhysics: const BouncingScrollPhysics(),
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        // showTime: true,
        onlyShowToday: true,
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
}
