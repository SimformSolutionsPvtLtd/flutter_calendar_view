import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import 'schedule_view_page.dart';

class ScheduleView<T extends Object?> extends StatefulWidget {
  const ScheduleView({
    Key? key,
    this.eventController,
  }) : super(key: key);

  final EventController<T>? eventController;

  @override
  ScheduleViewState<T> createState() => ScheduleViewState<T>();
}

class ScheduleViewState<T extends Object?> extends State<ScheduleView<T>> {
  late EventController<T> eventController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    eventController = CalendarControllerProvider.of<T>(context).controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScheduleViewPage(eventController: eventController),
    );
  }
}

class DayWidget<T> extends StatelessWidget {
  const DayWidget({Key? key, required this.data}) : super(key: key);

  final Map<DateTime, List<CalendarEventData<T>>> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: Text("${data.keys.first.day}"),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(10),
                height: 20,
                width: MediaQuery.of(context).size.width - 10,
                color: Colors.indigoAccent,
                child: Text(data.values.first[index].title),
              ),
              itemCount: data.values.first.length,
            ),
          ),
        ],
      ),
    );
  }
}
