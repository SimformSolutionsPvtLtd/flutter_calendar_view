import 'package:calendar_view/calendar_view.dart';
import 'package:example/enumerations.dart';
import 'package:example/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../widgets/week_view_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({Key? key}) : super(key: key);

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      webWidget: WebHomePage(
        selectedView: CalendarView.week,
      ),
      mobileWidget: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        body: WeekViewWidget(),
      ),
    );
  }
}
