import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:example/test_datasets/merge_event_arranger_test_data.dart';
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
  final _controller = EventController()..addAll(_events);
  @override
  Widget build(BuildContext context) {
    return CalendarThemeProvider(
      calendarTheme: CalendarThemeData(
        monthViewTheme:
            isDarkMode ? MonthViewThemeData.dark() : MonthViewThemeData.light(),
        dayViewTheme: isDarkMode
            ? DayViewThemeData.dark()
            : DayViewThemeData.light()
                .copyWith(hourLineColor: AppColors.primary) as DayViewThemeData,
        weekViewTheme:
            isDarkMode ? WeekViewThemeData.dark() : WeekViewThemeData.light(),
        multiDayViewTheme: isDarkMode
            ? MultiDayViewThemeData.dark()
            : MultiDayViewThemeData.light(),
      ),
      child: CalendarControllerProvider(
        controller: _controller,
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

// List<CalendarEventData> _events = SideEventArrangerTestData.allTestCases.values.expand((e) => e).toList();
List<CalendarEventData> _events = MergeEventArrangerTestData.realWorldCalendarDay;