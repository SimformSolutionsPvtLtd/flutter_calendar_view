import 'package:calendar_view/calendar_view.dart';
import 'package:calendar_view/src/day_view/interactive_day_view_event_tile_builder.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class InteractiveDayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const InteractiveDayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayView<Event>(
      key: state,
      width: width,
      eventTileBuilder: (date, events, boundary, startDuration, endDuration) =>
          InteractiveDayViewEventTile(
        controller: CalendarControllerProvider.of<Event>(context).controller,
        boundary: boundary,
        date: date,
        endDuration: endDuration,
        events: events,
        startDuration: startDuration,
        editComplete: (updatedEventData) {
          // I update my database entry here with the new eventData.
        },
      ),
    );
  }
}
