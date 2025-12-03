// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';
import '../extensions.dart';

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
    super.key,
    required this.date,
    this.events = const [],
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightedTitleColor = Constants.white,
    this.titleColor = Constants.black,
  });

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

class FilledCell<T extends Object?> extends StatelessWidget {
  /// Date of current cell.
  final DateTime date;

  /// List of events on for current date.
  final List<CalendarEventData<T>> events;

  /// defines date string for current cell.
  final StringProvider? dateStringBuilder;

  /// Defines if cell should be highlighted or not.
  /// If true it will display date title in a circle.
  final bool shouldHighlight;

  /// Defines background color of cell.
  final Color backgroundColor;

  /// Defines highlight color.
  final Color highlightColor;

  /// Color for event tile.
  final Color tileColor;

  // TODO(Shubham): Move all callbacks to separate class
  /// Called when user taps on any event tile.
  final TileTapCallback<T>? onTileTap;

  /// Called when user long press on any event tile.
  final TileTapCallback<T>? onTileLongTap;

  /// Called when user double tap on any event tile.
  final TileTapCallback<T>? onTileDoubleTap;

  /// Similar to [onTileTap] with additional tap details callback.
  final TileTapDetailsCallback<T>? onTileTapDetails;

  /// Similar to [onTileDoubleTap] with additional tap details callback.
  final TileDoubleTapDetailsCallback<T>? onTileDoubleTapDetails;

  /// Similar to [onTileLongTap] with additional tap details callback.
  final TileLongTapDetailsCallback<T>? onTileLongTapDetails;

  /// defines that [date] is in current month or not.
  final bool isInMonth;

  /// defines radius of highlighted date.
  final double highlightRadius;

  /// color of cell title
  final Color titleColor;

  /// color of highlighted cell title
  final Color highlightedTitleColor;

  /// defines that show and hide cell not is in current month
  final bool hideDaysNotInMonth;

  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const FilledCell({
    super.key,
    required this.date,
    required this.events,
    this.isInMonth = false,
    this.hideDaysNotInMonth = true,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.onTileTap,
    this.onTileLongTap,
    this.onTileTapDetails,
    this.onTileDoubleTapDetails,
    this.onTileLongTapDetails,
    this.tileColor = Colors.blue,
    this.highlightRadius = 11,
    this.titleColor = Constants.black,
    this.highlightedTitleColor = Constants.white,
    this.dateStringBuilder,
    this.onTileDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          if (!(!isInMonth && hideDaysNotInMonth))
            CircleAvatar(
              radius: highlightRadius,
              backgroundColor:
                  shouldHighlight ? highlightColor : Colors.transparent,
              child: Text(
                dateStringBuilder?.call(date) ?? "${date.day}",
                style: TextStyle(
                  color: shouldHighlight ? highlightedTitleColor : titleColor,
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
                        onTap: onTileTap.safeVoidCall(events[index], date),
                        onLongPress:
                            onTileLongTap.safeVoidCall(events[index], date),
                        onDoubleTap:
                            onTileDoubleTap.safeVoidCall(events[index], date),
                        onTapUp: onTileTapDetails == null
                            ? null
                            : (details) => onTileTapDetails?.call(
                                  events[index],
                                  date,
                                  details,
                                ),
                        onLongPressStart: onTileLongTapDetails == null
                            ? null
                            : (details) => onTileLongTapDetails?.call(
                                  events[index],
                                  date,
                                  details,
                                ),
                        onDoubleTapDown: onTileDoubleTapDetails == null
                            ? null
                            : (details) => onTileDoubleTapDetails?.call(
                                  events[index],
                                  date,
                                  details,
                                ),
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
                                  style: events[index].titleStyle ??
                                      TextStyle(
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

class WeekDayTile extends StatefulWidget {
  /// Index of week day.
  final int dayIndex;

  /// display week day
  final String Function(int)? weekDayStringBuilder;

  /// Background color of single week day tile.
  final Color? backgroundColor;

  final Color? borderColor;

  /// Should display border or not.
  final bool displayBorder;

  /// Style for week day string.
  final TextStyle? textStyle;

  /// Title for week day in month view.
  const WeekDayTile({
    super.key,
    required this.dayIndex,
    this.backgroundColor,
    this.borderColor,
    this.displayBorder = true,
    this.textStyle,
    this.weekDayStringBuilder,
  });

  @override
  State<WeekDayTile> createState() => _WeekDayTileState();
}

class _WeekDayTileState extends State<WeekDayTile> {
  @override
  Widget build(BuildContext context) {
    final themeColors = context.monthViewColors;

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? themeColors.weekDayTileColor,
        border: widget.displayBorder
            ? Border.all(
                color: widget.borderColor ?? themeColors.weekDayBorderColor,
                width: 0.5,
              )
            : null,
      ),
      child: Text(
        widget.weekDayStringBuilder?.call(widget.dayIndex) ??
            Constants.weekTitles[widget.dayIndex],
        style: widget.textStyle ??
            TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: themeColors.weekDayTextColor,
            ),
      ),
    );
  }
}
