import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/multi_day_view_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class MultiDayViewDemo extends StatefulWidget {
  const MultiDayViewDemo({super.key});

  @override
  _MultiDayViewDemoState createState() => _MultiDayViewDemoState();
}

class _MultiDayViewDemoState extends State<MultiDayViewDemo> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      webWidget: WebHomePage(selectedView: CalendarView.week),
      mobileWidget: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: context.appColors.onPrimary,
          ),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        body: MultiDayViewWidget(),
      ),
    );
  }
}
