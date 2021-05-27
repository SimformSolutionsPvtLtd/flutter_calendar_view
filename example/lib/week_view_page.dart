import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import 'create_event_page.dart';
import 'event.dart';
import 'extension.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({Key? key}) : super(key: key);

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  CalendarController<Event> _controller = CalendarController();
  GlobalKey<WeekViewState> _weekViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: WeekView<Event>(
        key: _weekViewKey,
        pageTransitionDuration: Duration(milliseconds: 300),
        pageTransitionCurve: Curves.ease,
        controller: _controller,
        showLiveTimeLineInAllDays: false,
      ),
    );
  }

  void _addEvent() async {
    CalendarEventData<Event>? event =
        await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
      withDuration: true,
    ));
    if (event == null) return;
    _controller.addEvent(event);
  }
}
