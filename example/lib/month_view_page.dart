import 'package:example/create_event_page.dart';
import 'package:example/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import 'event.dart';
import 'extension.dart';

class MonthViewPageDemo extends StatefulWidget {
  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  CalendarController<Event> _controller = CalendarController();
  GlobalKey<MonthViewState> _monthViewState = GlobalKey();

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
      body: MonthView<Event>(
        key: _monthViewState,
        controller: _controller,
        borderSize: 0.5,
        showBorder: true,
        cellAspectRatio: 0.55,
        pageTransitionDuration: Duration(milliseconds: 300),
        pageTransitionCurve: Curves.ease,
        cellBuilder:
            (date, List<CalendarEventData<Event>> events, isToday, isInMonth) {
          return FilledCell(
            date: date,
            isInMonth: isInMonth,
            shouldHighlight: isToday,
            onTileTap: (event, _) =>
                context.pushRoute(DetailsPage(event: event)),
            backgroundColor: isInMonth ? Color(0xffffffff) : Color(0xffeeeeee),
            events: events,
          );
        },
      ),
    );
  }
}
