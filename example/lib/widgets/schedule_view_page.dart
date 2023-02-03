import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../model/event.dart';
import '../pages/create_event_page.dart';
import 'schedule_view_widget.dart';

class ScheduleViewDemo extends StatefulWidget {
  const ScheduleViewDemo({Key? key}) : super(key: key);

  @override
  _ScheduleViewDemoState createState() => _ScheduleViewDemoState();
}

class _ScheduleViewDemoState extends State<ScheduleViewDemo> {

  //final GlobalKey<ScheduleViewState>? state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: ScheduleViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    final event =
    await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
      withDuration: true,
    ));
    if (event == null) return;
    CalendarControllerProvider.of<Event>(context).controller.add(event);
  }
}
