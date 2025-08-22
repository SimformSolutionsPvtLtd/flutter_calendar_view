import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

import '../widgets/responsive_widget.dart';
import 'mobile/mobile_home_page.dart';
import 'web/web_home_page.dart';

DateTime get _now => DateTime.now();

class HomePage extends StatelessWidget {
  const HomePage({this.onChangeTheme, super.key});

  /// Return true for dark mode
  /// false for light mode
  final void Function(bool)? onChangeTheme;

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    List<CalendarEventData> _events = [
      CalendarEventData(
        date: _now,
        title: translate.projectMeetingTitle,
        description: translate.projectMeetingDesc,
        startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
        endTime: DateTime(_now.year, _now.month, _now.day, 22),
      ),
      CalendarEventData(
        date: _now.subtract(Duration(days: 3)),
        recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
          startDate: _now.subtract(Duration(days: 3)),
        ),
        title: translate.leetcodeContestTitle,
        description: translate.leetcodeContestDesc,
      ),
      CalendarEventData(
        date: _now.subtract(Duration(days: 3)),
        recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
          startDate: _now.subtract(Duration(days: 3)),
          frequency: RepeatFrequency.daily,
          recurrenceEndOn: RecurrenceEnd.after,
          occurrences: 5,
        ),
        title: translate.physicsTestTitle,
        description: translate.physicsTestDesc,
      ),
      CalendarEventData(
        date: _now.add(Duration(days: 1)),
        startTime: DateTime(_now.year, _now.month, _now.day, 18),
        endTime: DateTime(_now.year, _now.month, _now.day, 19),
        recurrenceSettings: RecurrenceSettings(
          startDate: _now,
          endDate: _now.add(Duration(days: 5)),
          frequency: RepeatFrequency.daily,
          recurrenceEndOn: RecurrenceEnd.after,
          occurrences: 5,
        ),
        title: translate.weddingAnniversaryTitle,
        description: translate.weddingAnniversaryDesc,
      ),
      CalendarEventData(
        date: _now,
        startTime: DateTime(_now.year, _now.month, _now.day, 14),
        endTime: DateTime(_now.year, _now.month, _now.day, 17),
        title: translate.footballTournamentTitle,
        description: translate.footballTournamentDesc,
      ),
      CalendarEventData(
        date: _now.add(Duration(days: 3)),
        startTime: DateTime(
            _now.add(Duration(days: 3)).year,
            _now.add(Duration(days: 3)).month,
            _now.add(Duration(days: 3)).day,
            10),
        endTime: DateTime(
            _now.add(Duration(days: 3)).year,
            _now.add(Duration(days: 3)).month,
            _now.add(Duration(days: 3)).day,
            14),
        title: translate.sprintMeetingTitle,
        description: translate.sprintMeetingDesc,
      ),
      CalendarEventData(
        date: _now.subtract(Duration(days: 2)),
        startTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            14),
        endTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            16),
        title: translate.teamMeetingTitle,
        description: translate.teamMeetingDesc,
      ),
      CalendarEventData(
        date: _now.subtract(Duration(days: 2)),
        startTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            10),
        endTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            12),
        title: translate.chemistryVivaTitle,
        description: translate.chemistryVivaDesc,
      ),
    ];

    final eventController = CalendarControllerProvider.of(context).controller;
    eventController.addAll(_events);

    return ResponsiveWidget(
      mobileWidget: MobileHomePage(onChangeTheme: onChangeTheme),
      webWidget: WebHomePage(onThemeChange: onChangeTheme),
    );
  }
}
