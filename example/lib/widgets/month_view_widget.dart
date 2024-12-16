import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;
  final bool isDarkMode;

  const MonthViewWidget({
    super.key,
    this.state,
    this.width,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(Shubham): Add isDarkMode
    debugPrint('MonthViewWidget --> ${isDarkMode}');
    return MonthView(
      key: state,
      width: width,
      isDarkMode: isDarkMode,
      showWeekends: false,
      useAvailableVerticalSpace: true,
      hideDaysNotInMonth: true,
      // headerStyle: HeaderStyle(),
      onEventTap: (event, date) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsPage(
              event: event,
            ),
          ),
        );
      },
      onEventLongTap: (event, date) {
        SnackBar snackBar = SnackBar(content: Text("on LongTap"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
