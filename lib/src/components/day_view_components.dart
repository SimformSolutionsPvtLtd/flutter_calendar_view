import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common_components.dart';

/// This class defines default tile to display in day view.
class RoundedEventTile extends StatelessWidget {
  /// Title of the tile.
  final String title;

  /// Description of the tile.
  final String description;

  /// Background color of tile.
  /// Default color is [Colors.blue]
  final Color backgroundColor;

  /// Called when user taps on tile.
  final VoidCallback? onTap;

  /// If same tile can have multiple events.
  /// In most cases this value will be 1 less than total events.
  final int extraEvents;

  /// Padding of the tile. Default padding is [EdgeInsets.zero]
  final EdgeInsets padding;

  /// Margin of the tile. Default margin is [EdgeInsets.zero]
  final EdgeInsets margin;

  /// Border radius of tile.
  final BorderRadius borderRadius;

  /// This is default tile to display in day view.
  const RoundedEventTile({
    Key? key,
    required this.title,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.description = "",
    this.borderRadius = BorderRadius.zero,
    this.onTap,
    this.extraEvents = 0,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != "")
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (description != "")
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ),
              ),
            if (extraEvents > 0) Expanded(child: Text("+$extraEvents more")),
          ],
        ),
      ),
    );
  }
}

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    required DateTime date,
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextDay,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder: DayPageHeader._dayStringBuilder,
        );
  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} - ${date.month} - ${date.year}";
}
