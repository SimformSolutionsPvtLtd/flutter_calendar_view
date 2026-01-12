import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

import '../widgets/responsive_widget.dart';
import 'mobile/mobile_home_page.dart';
import 'web/web_home_page.dart';

DateTime get _now => DateTime.now();

class HomePage extends StatefulWidget {
  const HomePage({this.onChangeTheme, super.key});

  /// Return true for dark mode
  /// false for light mode
  final void Function(bool)? onChangeTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = CalendarControllerProvider.of(context).controller;

    // Initialize events only when controller is first accessed
    if (_controller != controller) {
      _controller = controller;

      final translate = context.translate;
      final events = [
        // Example of timeRanged event - for events with specific start/end times on a single day
        CalendarEventData.timeRanged(
          title: translate.projectMeetingTitle,
          description: translate.projectMeetingDesc,
          date: _now,
          startTime: const TimeOfDay(hour: 18, minute: 30),
          endTime: const TimeOfDay(hour: 22, minute: 0),
        ),
        // Example of wholeDay event with recurrence - for all-day events
        CalendarEventData.wholeDay(
          title: translate.leetcodeContestTitle,
          description: translate.leetcodeContestDesc,
          date: _now.subtract(const Duration(days: 3)),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(const Duration(days: 3)),
          ),
        ),
        // Example of wholeDay event with daily recurrence
        CalendarEventData.wholeDay(
          title: translate.physicsTestTitle,
          description: translate.physicsTestDesc,
          date: _now.subtract(const Duration(days: 3)),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(const Duration(days: 3)),
            frequency: RepeatFrequency.daily,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 5,
          ),
        ),
        // Example of timeRanged event with recurrence
        CalendarEventData.timeRanged(
          title: translate.weddingAnniversaryTitle,
          description: translate.weddingAnniversaryDesc,
          date: _now.add(const Duration(days: 1)),
          startTime: const TimeOfDay(hour: 18, minute: 0),
          endTime: const TimeOfDay(hour: 19, minute: 0),
          recurrenceSettings: RecurrenceSettings(
            startDate: _now,
            endDate: _now.add(const Duration(days: 5)),
            frequency: RepeatFrequency.daily,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 5,
          ),
        ),
        // Example of timeRanged event - afternoon tournament
        CalendarEventData.timeRanged(
          title: translate.footballTournamentTitle,
          description: translate.footballTournamentDesc,
          date: _now,
          startTime: const TimeOfDay(hour: 14, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
        // Example of timeRanged event - morning meeting
        CalendarEventData.timeRanged(
          title: translate.sprintMeetingTitle,
          description: translate.sprintMeetingDesc,
          date: _now.add(const Duration(days: 3)),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 14, minute: 0),
        ),
        // Example of timeRanged event - 2 hour meeting
        CalendarEventData.timeRanged(
          title: translate.teamMeetingTitle,
          description: translate.teamMeetingDesc,
          date: _now.subtract(const Duration(days: 2)),
          startTime: const TimeOfDay(hour: 14, minute: 0),
          endTime: const TimeOfDay(hour: 16, minute: 0),
        ),
        // Example of timeRanged event - chemistry viva
        CalendarEventData.timeRanged(
          title: translate.chemistryVivaTitle,
          description: translate.chemistryVivaDesc,
          date: _now.subtract(const Duration(days: 2)),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 12, minute: 0),
        ),
        // Example of multiDay event - spanning multiple days without specific times
        CalendarEventData.multiDay(
          title: translate.annualTechConferenceTitle,
          description: translate.annualTechConferenceDesc,
          startDate: _now.add(const Duration(days: 5)),
          endDate: _now.add(const Duration(days: 7)),
        ),
        // Example of multiDay event with specific times - workshop spanning multiple days
        CalendarEventData.multiDay(
          title: translate.extendedWorkshopTitle,
          description: translate.extendedWorkshopDesc,
          startDate: _now.add(const Duration(days: 10)),
          endDate: _now.add(const Duration(days: 12)),
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      ];
      _controller!.addAll(events);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileWidget: MobileHomePage(onChangeTheme: widget.onChangeTheme),
      webWidget: WebHomePage(onThemeChange: widget.onChangeTheme),
    );
  }
}
