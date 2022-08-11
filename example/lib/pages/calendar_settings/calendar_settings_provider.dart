import 'package:flutter/material.dart';

import '../../enumerations.dart';

class CalendarSettingsProvider extends InheritedWidget {
  const CalendarSettingsProvider({
    Key? key,
    required Widget child,
    required this.maxDate,
    required this.minDate,
    required this.initialDate,
    required this.animationCurve,
  }) : super(key: key, child: child);

  final DateTime minDate;
  final DateTime maxDate;
  final DateTime initialDate;
  final CurveTypes animationCurve;

  static CalendarSettingsProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CalendarSettingsProvider>();
    assert(result != null, 'No CalendarSettingsProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarSettingsProvider oldWidget) =>
      oldWidget.minDate != minDate ||
      oldWidget.maxDate != maxDate ||
      oldWidget.initialDate != initialDate ||
      oldWidget.animationCurve != animationCurve;
}
