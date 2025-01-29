import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/month_view_widget.dart';
import '../widgets/responsive_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class MonthViewPageDemo extends StatefulWidget {
  const MonthViewPageDemo({
    super.key,
    this.directionality = TextDirection.ltr,
  });

  final TextDirection directionality;

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.directionality,
      child: ResponsiveWidget(
        webWidget: WebHomePage(
          selectedView: CalendarView.month,
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
          body: MonthViewWidget(),
        ),
      ),
    );
  }
}
