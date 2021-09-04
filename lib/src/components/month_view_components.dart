// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../extensions.dart';
import '../typedefs.dart';
import 'common_components.dart';

class CircularCell extends StatelessWidget {
  /// Date of cell.
  final DateTime date;

  /// List of Events for current date.
  final List<CalendarEventData> events;

  /// Defines if [date] is [DateTime.now] or not.
  final bool shouldHighlight;

  /// Background color of circle around date title.
  final Color backgroundColor;

  /// Title color when title is highlighted.
  final Color highlightedTitleColor;

  /// Color of cell title.
  final Color titleColor;

  /// This class will defines how cell will be displayed.
  /// To get proper view user [CircularCell] with 1 [MonthView.cellAspectRatio].
  const CircularCell({
    Key? key,
    required this.date,
    this.events = const [],
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightedTitleColor = Constants.white,
    this.titleColor = Constants.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: shouldHighlight ? backgroundColor : Colors.transparent,
        child: Text(
          "${date.day}",
          style: TextStyle(
            fontSize: 20,
            color: shouldHighlight ? highlightedTitleColor : titleColor,
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
  final TileTapCallback<T>? onTileTap;

  /// defines that [date] is in current month or not.
  final bool isInMonth;

  /// defines radius of highlighted date.
  final double highlightRadius;

  /// color of cell title
  final Color titleColor;

  /// color of highlighted cell title
  final Color highlightedTitleColor;

  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const FilledCell({
    Key? key,
    required this.date,
    required this.events,
    this.isInMonth = false,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.onTileTap,
    this.tileColor = Colors.blue,
    this.highlightRadius = 11,
    this.titleColor = Constants.black,
    this.highlightedTitleColor = Constants.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor:
                shouldHighlight ? highlightColor : Colors.transparent,
            child: Text(
              "${date.day}",
              style: TextStyle(
                color: shouldHighlight
                    ? highlightedTitleColor
                    : isInMonth
                        ? titleColor
                        : titleColor.withOpacity(0.4),
                fontSize: 12,
              ),
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
                    children: List.generate(
                      events.length,
                      (index) => GestureDetector(
                        onTap: () =>
                            onTileTap?.call(events[index], events[index].date),
                        child: Container(
                          decoration: BoxDecoration(
                            color: events[index].color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 3.0),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  events[index].title,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: events[index].color.accent,
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
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    required DateTime date,
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextMonth,
          onPreviousDay: onPreviousMonth,
          onTitleTapped: onTitleTapped,
          iconColor: iconColor,
          backgroundColor: backgroundColor,
          dateStringBuilder: MonthPageHeader._monthStringBuilder,
        );
  static String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.month} - ${date.year}";
}

class WeekDayTile extends StatelessWidget {
  /// Index of week day.
  final int dayIndex;

  /// Background color of single week day tile.
  final Color backgroundColor;

  /// Should display border or not.
  final bool displayBorder;

  /// Style for week day string.
  final TextStyle? textStyle;

  /// Title for week day in month view.
  const WeekDayTile({
    Key? key,
    required this.dayIndex,
    this.backgroundColor = Constants.white,
    this.displayBorder = true,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: Constants.defaultBorderColor,
          width: displayBorder ? 0.5 : 0,
        ),
      ),
      child: Text(
        Constants.weekTitles[dayIndex],
        style: textStyle ??
            TextStyle(
              fontSize: 17,
              color: Constants.black,
            ),
      ),
    );
  }
}
