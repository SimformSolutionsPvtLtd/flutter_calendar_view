import 'package:calendar_view/calendar_view.dart';
import 'package:example/model/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

DateTime get _now => DateTime.now();

class DataProvider extends InheritedWidget {
  final EventController<Event> controller;

  late final InputDecoration inputDecoration;

  DataProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child) {
    var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(
        width: 2,
        color: AppColors.lightNavyBlue,
      ),
    );

    inputDecoration = InputDecoration(
      border: inputBorder,
      disabledBorder: inputBorder,
      errorBorder: inputBorder.copyWith(
        borderSide: BorderSide(
          width: 2,
          color: AppColors.red,
        ),
      ),
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
      focusedErrorBorder: inputBorder,
      hintText: "Event Title",
      hintStyle: TextStyle(
        color: AppColors.black,
        fontSize: 17,
      ),
      labelStyle: TextStyle(
        color: AppColors.black,
        fontSize: 17,
      ),
      helperStyle: TextStyle(
        color: AppColors.black,
        fontSize: 17,
      ),
      errorStyle: TextStyle(
        color: AppColors.red,
        fontSize: 12,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
    );

    controller.addAll(_events);
  }

  static DataProvider of(BuildContext context) {
    final DataProvider? result =
        context.dependOnInheritedWidgetOfExactType<DataProvider>();
    assert(result != null, 'No DataProvider<T> found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DataProvider old) => false;
}

List<CalendarEventData<Event>> _events = [
  CalendarEventData(
    date: _now,
    event: Event(title: "Joe's Birthday"),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 1)),
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    event: Event(title: "Wedding anniversary"),
    title: "Wedding anniversary",
    description: "Attend uncle's wedding anniversary.",
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    event: Event(title: "Football Tournament"),
    title: "Football Tournament",
    description: "Go to football tournament.",
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 3)),
    startTime: DateTime(
        _now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month,
        _now.add(Duration(days: 3)).day,
        10,
        0),
    endTime: DateTime(
        _now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month,
        _now.add(Duration(days: 3)).day,
        14,
        0),
    event: Event(title: "Project Submission."),
    title: "Project Submission.",
    description: "Last day of project submission for last year.",
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        14,
        0),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        16,
        0),
    event: Event(title: "Physics Viva"),
    title: "Physics Viva",
    description: "Physics viva.",
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        10,
        0),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        12,
        0),
    event: Event(title: "Chemistry Viva"),
    title: "Chemistry Viva",
    description: "Today is Joe's birthday.",
  ),
];
