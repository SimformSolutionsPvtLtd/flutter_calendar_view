import 'package:calendar_view/calendar_view.dart';
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
    return InteractiveDayView<Event>(
      key: state,
      width: width,
      onEventChanged: (event) {
        /// This is where I update the event in the database.
      },
    );
  }
}
