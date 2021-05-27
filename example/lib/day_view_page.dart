import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import 'create_event_page.dart';
import 'event.dart';
import 'extension.dart';

class DayViewPageDemo extends StatefulWidget {
  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  CalendarController<Event> _controller = CalendarController();
  GlobalKey<DayViewState> _dayViewKey = GlobalKey();

  DateTime date = DateTime(2021, 5, 31);

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
          _controller.addEvent(event);
        },
      ),
      body: DayView<Event>(
        key: _dayViewKey,
        pageTransitionDuration: Duration(milliseconds: 300),
        pageTransitionCurve: Curves.ease,
        controller: _controller,
        heightPerMinute: 0.7,
        showLiveTimeLineInAllDays: false,
      ),
    );
  }
}
