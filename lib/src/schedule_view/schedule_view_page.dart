import 'dart:async';

import 'package:flutter/material.dart';

import '../../calendar_view.dart';

class ScheduleViewPage<T extends Object?> extends StatefulWidget {
  const ScheduleViewPage({
    Key? key,
    required this.eventController,
  }) : super(key: key);

  final EventController<T> eventController;

  @override
  State<ScheduleViewPage<T>> createState() => _ScheduleViewPageState<T>();
}

class _ScheduleViewPageState<T extends Object?>
    extends State<ScheduleViewPage<T>> {
  final List<Map<DateTime, List<CalendarEventData<T>>>> dataList = [];
  //final List<Map<DateTime, List<CalendarEventData<T>>>> bottomDataList = [];

  StreamController<List<Map<DateTime, List<CalendarEventData<T>>>>>
      _streamController =
      StreamController<List<Map<DateTime, List<CalendarEventData<T>>>>>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadInitialCalendar();
    scrollController.addListener(onScrollPagination);
  }

  void loadInitialCalendar() {
    final date = DateTime.now();
    for (var i = 0; i < 15; i++) {
      final currentDate = date.add(Duration(days: i)).dateYMD;
      final events = widget.eventController.getEventsOnDay(currentDate);
      _streamController.add([
        {currentDate: events}
      ]);
    }
    for (var i = 15; i < 30; i++) {
      final currentDate = date.add(Duration(days: i)).dateYMD;
      final events = widget.eventController.getEventsOnDay(currentDate);
      _streamController.add([
        {currentDate: events}
      ]);
    }
  }

  void onScrollPagination() {
    // if (scrollController.position.pixels ==
    //     scrollController.position.minScrollExtent) {
    //   final firstDate = dataList.first.keys.last;
    //   for (var i = 1; i < 20; i++) {
    //     final currentDate = firstDate.subtract(Duration(days: i)).dateYMD;
    //     final events = widget.eventController.getEventsOnDay(currentDate);
    //     _streamController.
    //     _streamController.add(0, {currentDate: events});
    //   }
    // }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final lastDate = dataList.last.keys.last;
      for (var i = 1; i < 20; i++) {
        final currentDate = lastDate.add(Duration(days: i)).dateYMD;
        final events = widget.eventController.getEventsOnDay(currentDate);
        _streamController.add([
          {currentDate: events}
        ]);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return CustomScrollView(
    //   controller: scrollController,
    //   slivers: <Widget>[
    //     SliverList(
    //       delegate: SliverChildBuilderDelegate((context, index) {
    //         return DayWidget(data: dataList[index]);
    //       }),
    //     ),
    //     // SliverList(
    //     //   delegate: SliverChildBuilderDelegate((context, index) {
    //     //     return DayWidget(data: bottomDataList[index]);
    //     //   }),
    //     // ),
    //   ],
    // );
    return StreamBuilder<List<Map<DateTime, List<CalendarEventData<T>>>>>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        return ListView.separated(
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return DayWidget(data: snapshot.data![index]);
          },
          itemCount: dataList.length,
          separatorBuilder: (context, index) => Divider(),
        );
      },
    );
  }
}
