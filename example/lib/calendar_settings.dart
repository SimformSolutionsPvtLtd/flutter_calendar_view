import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';

import 'enumerations.dart';

class CalendarSettings {
  static final ValueNotifier<CalendarSettings> notifier =
      ValueNotifier(CalendarSettings.initial);

  static final initial = CalendarSettings(
    minDate: CalendarConstants.minDate,
    maxDate: CalendarConstants.maxDate,
    initialDate: DateTime.now(),
    animationCurve: CurveTypes.easeIn,
  );

  final DateTime minDate;
  final DateTime maxDate;
  final DateTime initialDate;
  final CurveTypes animationCurve;

  const CalendarSettings({
    required this.minDate,
    required this.maxDate,
    required this.initialDate,
    required this.animationCurve,
  });
}
