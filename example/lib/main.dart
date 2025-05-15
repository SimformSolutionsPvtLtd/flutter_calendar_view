import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:example/pages/month_view_page.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

DateTime get _now => DateTime.now();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        title: 'Flutter Calendar Page Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        scrollBehavior: ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        home: MonthViewPageDemo(),
      ),
    );
  }
}
