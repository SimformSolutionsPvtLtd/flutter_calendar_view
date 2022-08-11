import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/calendar_settings/calendar_settings_provider.dart';

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
    final settings = CalendarSettingsProvider.of(context);

    return MonthView<String>(
      key: state,
      width: width,
      initialMonth: settings.initialDate,
      maxMonth: settings.maxDate,
      minMonth: settings.minDate,
    );
  }
}
