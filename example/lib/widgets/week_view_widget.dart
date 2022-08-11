import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/calendar_settings/calendar_settings_provider.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = CalendarSettingsProvider.of(context);

    return WeekView<String>(
      key: state,
      width: width,
      initialDay: settings.initialDate,
      maxDay: settings.maxDate,
      minDay: settings.minDate,
    );
  }
}
