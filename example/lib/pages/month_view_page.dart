import 'package:calendar_view/calendar_view.dart';
import 'package:example/pages/create_event_page.dart';
import 'package:example/widgets/month_view_widget.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../model/event.dart';

class MonthViewPageDemo extends StatefulWidget {
  const MonthViewPageDemo({
    Key? key,
  }) : super(key: key);

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: MonthViewWidget(),
    );
  }

  void _addEvent() async {
    CalendarEventData<Event>? event =
        await context.pushRoute<CalendarEventData<Event>>(
      CreateEventPage(
        withDuration: true,
      ),
    );
    if (event == null) return;
    CalendarControllerProvider.of(context).controller.add(event);
  }
}
