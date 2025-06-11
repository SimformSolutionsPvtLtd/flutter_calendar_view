import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:example/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'theme/app_colors.dart';

DateTime get _now => DateTime.now();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarThemeProvider(
      calendarTheme: CalendarTheme(
        monthViewTheme:
            isDarkMode ? MonthViewTheme.dark() : MonthViewTheme.light(),
        dayViewTheme: isDarkMode
            ? DayViewTheme.dark()
            : DayViewTheme.light().copyWith(hourLineColor: AppColors.primary)
                as DayViewTheme,
        weekViewTheme:
            isDarkMode ? WeekViewTheme.dark() : WeekViewTheme.light(),
      ),
      child: CalendarControllerProvider(
        controller: EventController()..addAll(_events),
        child: MaterialApp(
          title: 'Flutter Calendar Page Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          scrollBehavior: ScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.trackpad,
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
          home: HomePage(
            onChangeTheme: (isDark) => setState(() => isDarkMode = isDark),
          ),
        ),
      ),
    );
  }
}

List<CalendarEventData> _events = [
  CalendarEventData(
    date: _now,
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 3)),
    recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
      startDate: _now.subtract(Duration(days: 3)),
    ),
    title: 'Leetcode Contest',
    description: 'Give leetcode contest',
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 3)),
    recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
      startDate: _now.subtract(Duration(days: 3)),
      frequency: RepeatFrequency.daily,
      recurrenceEndOn: RecurrenceEnd.after,
      occurrences: 5,
    ),
    title: 'Physics test prep',
    description: 'Prepare for physics test',
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 1)),
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    recurrenceSettings: RecurrenceSettings(
      startDate: _now,
      endDate: _now.add(Duration(days: 5)),
      frequency: RepeatFrequency.daily,
      recurrenceEndOn: RecurrenceEnd.after,
      occurrences: 5,
    ),
    title: "Wedding anniversary",
    description: "Attend uncle's wedding anniversary.",
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    title: "Football Tournament",
    description: "Go to football tournament.",
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 3)),
    startTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
    endTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
    title: "Sprint Meeting.",
    description: "Last day of project submission for last year.",
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        14),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        16),
    title: "Team Meeting",
    description: "Team Meeting",
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        10),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        12),
    title: "Chemistry Viva",
    description: "Today is Joe's birthday.",
  ),
];
