import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';

class CalendarControllerProvider<T> extends InheritedWidget {

  /// Event controller for Calendar views.
  final EventController<T> controller;

  /// This will provide controller to its subtree.
  /// If controller argument is not provided in calendar views then controller from this class will be considered.
  /// 
  /// Use this widget to provide same controller object to all calendar view widgets and synchronize events between them.
  const CalendarControllerProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  static CalendarControllerProvider<T> of<T>(BuildContext context) {
    final CalendarControllerProvider<T>? result = context
        .dependOnInheritedWidgetOfExactType<CalendarControllerProvider<T>>();
    assert(
        result != null,
        'No CalendarControllerProvider found in context. '
        'To solve this issue either wrap material app with '
        '\'CalendarControllerProvider\' or provide controller argument in '
        'respected calendar view class.');
    return result!;
  }

  @override
  bool updateShouldNotify(CalendarControllerProvider old) => false;
}
