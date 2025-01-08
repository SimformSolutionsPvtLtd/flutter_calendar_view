import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({super.key, this.state, this.width});

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    return MonthView(
      key: state,
      width: width,
      monthViewThemeSettings: MonthViewThemeSettings(
        cellsInMonthHighlightColor: Colors.blue,
      ),
      monthViewStyle: MonthViewStyle(
        startDay: WeekDays.friday,
        useAvailableVerticalSpace: true,
        hideDaysNotInMonth: true,
        // Define the range of months to display
        maxMonth: DateTime(2027, 12, 31),
        minMonth: DateTime(2020, 1, 1),
        pagePhysics: NeverScrollableScrollPhysics(),
      ),
      monthViewBuilders: MonthViewBuilders(
        //When user tries to scroll beyond the max month or min month
        // these callbacks will be triggered.
        onHasReachedEnd: (date, page) {
          SnackBar snackBar = SnackBar(
            content: Text(translate.reachedTheEndPage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onHasReachedStart: (date, page) {
          SnackBar snackBar = SnackBar(
            content: Text(translate.reachedTheStartPage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onEventTap: (event, date) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailsPage(event: event, date: date),
            ),
          );
        },
        onEventLongTap: (event, date) {
          SnackBar snackBar = SnackBar(content: Text("on LongTap"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }
}
