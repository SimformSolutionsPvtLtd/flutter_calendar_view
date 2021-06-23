import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/calendar_event_data.dart';

import 'common_components.dart';

class CircularCell extends StatelessWidget {
  /// Date of cell.
  final DateTime date;

  /// List of Events for current date.
  final List<CalendarEventData> events;

  /// Defines if [date] is [DateTime.now] or not.
  final bool shouldHighlight;

  /// Called when user taps on cell.
  final VoidCallback? onTap;

  /// Background color of circle around date title.
  final Color backgroundColor;

  /// This class will defines how cell will be displayed.
  /// To get proper view user [CircularCell] with 1 [MonthView.cellAspectRatio].
  const CircularCell({
    Key? key,
    required this.date,
    this.events = const [],
    this.onTap,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor:
              shouldHighlight ? backgroundColor : Colors.transparent,
          child: Text(
            "${date.day}",
            style: TextStyle(
              fontSize: 20,
              color: shouldHighlight ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class FilledCell<T> extends StatelessWidget {
  /// Date of current cell.
  final DateTime date;

  /// List of events on for current date.
  final List<CalendarEventData<T>> events;

  /// Defines if cell should be highlighted or not.
  /// If true it will display date title in a circle.
  final bool shouldHighlight;

  /// Defines background color of cell.
  final Color backgroundColor;

  /// Defines highlight color.
  final Color highlightColor;

  /// Color for event tile.
  final Color tileColor;

  /// Called when user taps on any event tile.
  final void Function(CalendarEventData<T> event, DateTime date)? onTileTap;

  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const FilledCell({
    Key? key,
    required this.date,
    required this.events,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.onTileTap,
    this.tileColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            radius: 15,
            backgroundColor:
                shouldHighlight ? highlightColor : Colors.transparent,
            child: Text(
              "${date.day}",
              style: TextStyle(
                  color: shouldHighlight ? Colors.white : Colors.black),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      events.length,
                      (index) => GestureDetector(
                        onTap: () =>
                            onTileTap?.call(events[index], events[index].date),
                        child: Container(
                          decoration: BoxDecoration(
                            color: highlightColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 3.0),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  events[index].title,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(240),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MonthPageHeader extends CalendarPageHeader {
  /// A header widget to display on month view.
  const MonthPageHeader({
    Key? key,
    VoidCallback? onNextMonth,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousMonth,
    required DateTime date,
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextMonth,
          onPreviousDay: onPreviousMonth,
          onTitleTapped: onTitleTapped,
          dateStringBuilder: MonthPageHeader._monthStringBuilder,
        );
  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month} - ${date.year}";
}
