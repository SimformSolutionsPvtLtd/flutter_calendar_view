import 'package:example/widgets/day_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import '../extension.dart';
import '../model/event.dart';
import '../widgets/event_provider.dart';
import 'create_event_page.dart';

class DayViewPageDemo extends StatefulWidget {
  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  late CalendarController<Event> _controller;

  DateTime date = DateTime(2021, 5, 31);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = DataProvider.of(context).controller;
  }

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
      body: DayViewWidget(),
    );
  }
}
