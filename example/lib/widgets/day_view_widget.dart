import 'package:example/model/event.dart';
import 'package:example/widgets/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayView<Event>(
      key: state,
      pageTransitionDuration: Duration(milliseconds: 300),
      pageTransitionCurve: Curves.ease,
      width: width,
      controller: DataProvider.of(context).controller,
      heightPerMinute: 0.7,
      showLiveTimeLineInAllDays: false,
    );
  }
}
