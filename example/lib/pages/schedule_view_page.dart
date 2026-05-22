import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/schedule_view_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class ScheduleViewPageDemo extends StatefulWidget {
  @override
  _ScheduleViewPageDemoState createState() => _ScheduleViewPageDemoState();
}

class _ScheduleViewPageDemoState extends State<ScheduleViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final translate = context.translate;

    return ResponsiveWidget(
      webWidget: WebHomePage(selectedView: CalendarView.schedule),
      mobileWidget: Scaffold(
        appBar: AppBar(title: Text(translate.scheduleView), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          heroTag: 'add_event_schedule_view',
          child: Icon(Icons.add, color: appColors.onPrimary),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        body: ScheduleViewWidget(),
      ),
    );
  }
}
