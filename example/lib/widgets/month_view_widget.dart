import 'package:calendar_view/calendar_view.dart';
import 'package:example/model/event.dart';
import 'package:flutter/material.dart';

import 'event_provider.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView<Event>(
      key: state,
      width: width,
      controller: DataProvider.of(context).controller,
    );
  }
}
