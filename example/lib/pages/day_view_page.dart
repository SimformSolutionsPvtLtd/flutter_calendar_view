import 'package:calendar_view/calendar_view.dart';
import 'package:example/widgets/day_view_widget.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../model/event.dart';
import 'create_event_page.dart';

class DayViewPageDemo extends StatefulWidget {
  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: () async {
          CalendarEventData<Event>? event =
              await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
            withDuration: true,
          ));
          if (event == null) return;
          CalendarControllerProvider.of(context).controller.add(event);
        },
      ),
      body: DayViewWidget(),
    );
  }
}
