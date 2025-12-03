import 'package:flutter/material.dart';

import '../calendar_view.dart';

class CalendarThemeProvider extends InheritedWidget {
  /// This will provide the theme to its subtree.
  ///
  /// Use this widget to provide the same theme object to all calendar
  /// view widgets and synchronize the theme between them.
  const CalendarThemeProvider({
    required this.calendarTheme,
    required super.child,
    super.key,
  });

  /// Theme for Calendar views.
  final CalendarThemeData calendarTheme;

  static CalendarThemeProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CalendarThemeProvider>();
    assert(
        result != null,
        'No CalendarThemeProvider found in context. '
        'To solve this issue, either wrap the material app with '
        "'CalendarThemeProvider' or provide a theme argument in "
        'the respective calendar view class.');
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarThemeProvider oldWidget) =>
      oldWidget.calendarTheme != calendarTheme;
}
