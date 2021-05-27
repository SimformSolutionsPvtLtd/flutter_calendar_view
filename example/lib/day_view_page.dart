import 'package:example/event_details_page.dart';
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
        eventTileBuilder: (date, events, area, startDuration, endDuration) {
          if (events.isEmpty) return Container();

          return RoundedEventTile(
            borderRadius: BorderRadius.circular(10.0),
            title: events[0]?.event.title ?? "",
            extraEvents: events.length - 1,
            onTap: () => context.pushRoute(DetailsPage(
                event: events[0] ??
                    CalendarEventData(date: DateTime.now(), event: []))),
            description: events[0]?.description ?? "",
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(2.0),
          );
        },
        pageTransitionDuration: Duration(milliseconds: 300),
        pageTransitionCurve: Curves.ease,
        controller: _controller,
        timeLineOffset: 0,
        heightPerMinute: 0.7,
        showLiveTimeLineInAllDays: false,
      ),
    );
  }
}
