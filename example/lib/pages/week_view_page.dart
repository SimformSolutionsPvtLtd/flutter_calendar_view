import 'package:example/widgets/event_provider.dart';
import 'package:example/widgets/week_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import '../extension.dart';
import '../model/event.dart';
import 'create_event_page.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({Key? key}) : super(key: key);

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  late CalendarController<Event> _controller;

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
        onPressed: _addEvent,
      ),
      body: WeekViewWidget(),
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
