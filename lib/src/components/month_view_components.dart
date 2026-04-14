// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';
import '../extensions.dart';

class CircularCell extends StatelessWidget {
  /// Defines how a cell will be displayed.
  /// For a proper view, use [CircularCell] with a [MonthViewStyle.cellAspectRatio].
  const CircularCell({
    required this.date,
    Key? key,
    this.events = const [],
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightedTitleColor = Constants.white,
    this.titleColor = Constants.black,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: shouldHighlight ? backgroundColor : Colors.transparent,
        child: Text(
          '${date.day}',
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
  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const FilledCell({
    required this.date,
    required this.events,
    Key? key,
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
    this.multipleDateSelectionColor,
  }) : super(key: key);

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

  /// Optional color overlay for multiple date selection.
  final Color? multipleDateSelectionColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: backgroundColor,
            child: Column(
              children: [
                const SizedBox(height: 5),
                if (!(!isInMonth && hideDaysNotInMonth))
                  CircleAvatar(
                    radius: highlightRadius,
                    backgroundColor:
                        shouldHighlight ? highlightColor : Colors.transparent,
                    child: Text(
                      dateStringBuilder?.call(date) ??
                          PackageStrings.localizeNumber(date.day),
                      style: TextStyle(
                        color: shouldHighlight
                            ? highlightedTitleColor
                            : titleColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (events.isNotEmpty)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            events.length,
                            (index) => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onTileTap.safeVoidCall(
                                events[index],
                                date,
                              ),
                              onLongPress: onTileLongTap.safeVoidCall(
                                events[index],
                                date,
                              ),
                              onDoubleTap: onTileDoubleTap.safeVoidCall(
                                events[index],
                                date,
                              ),
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
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 3,
                                ),
                                padding: const EdgeInsets.all(2),
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
          ),
          if (multipleDateSelectionColor != null)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(color: multipleDateSelectionColor!),
              ),
            ),
        ],
      ),
    );
  }
}

class WeekDayTile extends StatefulWidget {
  /// Title for week day in month view.
  const WeekDayTile({
    required this.dayIndex,
    Key? key,
    this.backgroundColor,
    this.borderColor,
    this.displayBorder = true,
    this.textStyle,
    this.weekDayStringBuilder,
  }) : super(key: key);

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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
            PackageStrings.currentLocale.weekdays[widget.dayIndex],
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
