import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/week_view_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({
    super.key,
    this.directionality = TextDirection.ltr,
  });

  final TextDirection directionality;

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.directionality,
      child: ResponsiveWidget(
        webWidget: WebHomePage(
          selectedView: CalendarView.week,
        ),
        mobileWidget: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            elevation: 8,
            onPressed: () => context.pushRoute(
              CreateEventPage(
                directionality: widget.directionality,
              ),
            ),
          ),
          body: WeekViewWidget(),
        ),
      ),
    );
  }
}
