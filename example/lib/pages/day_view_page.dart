import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/day_view_widget.dart';
import '../widgets/responsive_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class DayViewPageDemo extends StatefulWidget {
  const DayViewPageDemo({super.key});

  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ResponsiveWidget(
      webWidget: WebHomePage(
        selectedView: CalendarView.day,
      ),
      mobileWidget: Scaffold(
        primary: false,
        appBar: AppBar(
          leading: const SizedBox.shrink(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: appColors.onPrimary,
          ),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        body: DayViewWidget(),
      ),
    );
  }
}
