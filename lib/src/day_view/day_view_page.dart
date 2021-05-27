// Note: this is implementation for single page of day view.
// As we are not going in include it in initial release of plugin this is marked as commented.
// TODO: We will continue work on this once week view is completely implemented and we have more time else remove this file before releasing plugin.

// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_page/flutter_calendar_page.dart';
// import 'package:flutter_calendar_page/src/day_view/_internal_day_view_page.dart';
// import 'package:flutter_calendar_page/src/extensions.dart';
//
// import 'modals.dart';
//
// export 'modals.dart';
//
// class DayViewPage<T> extends StatelessWidget {
//   final double? width;
//   final DateTime date;
//   final EventTileBuilder<T> eventTileBuilder;
//   final EventArranger<T>? eventArranger;
//   final CalendarController<T> controller;
//   final DateWidgetBuilder? timeLineBuilder;
//   final HourIndicatorSettings? hourIndicatorSettings;
//   final bool showLiveLine;
//   final HourIndicatorSettings? liveTimeIndicatorSettings;
//   final double heightPerMinute;
//   final double? timeLineWidth;
//   final double timeLineOffset;
//   final bool showVerticalLine;
//   final double verticalLineOffset;
//
//   const DayViewPage({
//     Key? key,
//     this.width,
//     required this.date,
//     required this.controller,
//     required this.eventTileBuilder,
//     this.timeLineBuilder,
//     this.hourIndicatorSettings,
//     this.showLiveLine = true,
//     this.liveTimeIndicatorSettings,
//     this.heightPerMinute = 1,
//     this.timeLineWidth,
//     this.timeLineOffset = 0,
//     this.eventArranger,
//     this.showVerticalLine = true,
//     this.verticalLineOffset = 10,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double hourHeight = heightPerMinute * 60;
//     double height = hourHeight * 24;
//     double width = this.width ?? MediaQuery.of(context).size.width;
//
//     return InternalDayViewPage<T>(
//       timeLineWidth: timeLineWidth??0,
//       timeLineOffset: timeLineOffset,
//       showLiveLine: showLiveLine,
//       date: date,
//       hourIndicatorSettings: hourIndicatorSettings??HourIndicatorSettings.none(),
//       heightPerMinute: heightPerMinute,
//       eventTileBuilder: eventTileBuilder,
//       timeLineBuilder: timeLineBuilder,
//       liveTimeIndicatorSettings: liveTimeIndicatorSettings,
//       height: height,
//       width: width,
//       controller: controller,
//       hourHeight: hourHeight,
//       eventArranger: SideEventArranger<T>(),
//       showVerticalLine: showVerticalLine,
//       verticalLineOffset: verticalLineOffset,
//     );
//   }
// }
