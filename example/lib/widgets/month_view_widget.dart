import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class MonthViewWidget extends StatefulWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({super.key, this.state, this.width});

  @override
  State<MonthViewWidget> createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<MonthViewWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().withoutTime;
  }

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    return MonthView(
      key: widget.state,
      width: widget.width,
      selectedDate: _selectedDate,
      monthViewThemeSettings: MonthViewThemeSettings(
        cellsInMonthHighlightColor: Colors.blue,
        selectedHighlightColor: Colors.deepOrange,
        selectedTitleColor: Colors.white,
        selectedHighlightRadius: 12,
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
        onCellTap: (events, date) =>
            setState(() => _selectedDate = date.withoutTime),
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
