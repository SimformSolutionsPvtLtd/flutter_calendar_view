import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class ScheduleViewWidget extends StatelessWidget {
  final GlobalKey<ScheduleViewState>? state;
  final double? width;

  const ScheduleViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScheduleView<Event>(
      key: state,
    );
  }
}
