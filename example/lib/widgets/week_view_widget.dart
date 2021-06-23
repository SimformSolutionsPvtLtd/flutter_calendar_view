import 'package:example/model/event.dart';
import 'package:example/widgets/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<Event>(
      key: state,
      width: width,
      pageTransitionDuration: Duration(milliseconds: 300),
      pageTransitionCurve: Curves.ease,
      controller: DataProvider.of(context).controller,
      showLiveTimeLineInAllDays: false,
    );
  }
}
