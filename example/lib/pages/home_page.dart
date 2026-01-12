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
        // ========== EDGE CASE 1: Midnight boundary events ==========
        // Event that spans across midnight (23:00 to 01:00 next day)
        CalendarEventData.timeRanged(
          title: translate.midnightShiftTitle,
          description: translate.midnightShiftDesc,
          date: _now,
          startTime: TimeOfDay(hour: 23, minute: 0),
          endTime: TimeOfDay(hour: 23, minute: 59),
          color: Colors.purple,
        ),

        // ========== EDGE CASE 2: Early morning event (00:00 - 00:30) ==========
        CalendarEventData.timeRanged(
          title: translate.earlyBirdMeetingTitle,
          description: translate.earlyBirdMeetingDesc,
          date: _now,
          startTime: TimeOfDay(hour: 0, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 30),
          color: Colors.indigo,
        ),

        // ========== EDGE CASE 3: Full day event (all day) ==========
        CalendarEventData.wholeDay(
          title: translate.allDayConferenceTitle,
          description: translate.allDayConferenceDesc,
          date: _now,
          color: Colors.teal,
        ),

        // ========== EDGE CASE 4: Multi-day spanning event ==========
        CalendarEventData.multiDay(
          title: translate.threeDayWorkshopTitle,
          description: translate.threeDayWorkshopDesc,
          date: _now.subtract(Duration(days: 1)),
          endDate: _now.add(Duration(days: 1)),
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
          color: Colors.deepOrange,
        ),

        // ========== EDGE CASE 5: Very short event (1 minute) ==========
        CalendarEventData.timeRanged(
          title: translate.quickStandupTitle,
          description: translate.quickStandupDesc,
          date: _now,
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 9, minute: 1),
          color: Colors.amber,
        ),

        // ========== EDGE CASE 6: Very long event (12+ hours) ==========
        CalendarEventData.timeRanged(
          title: translate.marathonCodingSessionTitle,
          description: translate.marathonCodingSessionDesc,
          date: _now,
          startTime: TimeOfDay(hour: 8, minute: 0),
          endTime: TimeOfDay(hour: 22, minute: 0),
          color: Colors.red,
        ),

        // ========== EDGE CASE 7: Overlapping events (same time slot) ==========
        CalendarEventData.timeRanged(
          title: translate.projectMeetingTitle,
          description: translate.projectMeetingDesc,
          date: _now,
          startTime: TimeOfDay(hour: 14, minute: 0),
          endTime: TimeOfDay(hour: 15, minute: 0),
          color: Colors.blue,
        ),
        CalendarEventData.timeRanged(
          title: translate.designReviewOverlappingTitle,
          description: translate.designReviewOverlappingDesc,
          date: _now,
          startTime: TimeOfDay(hour: 14, minute: 30),
          endTime: TimeOfDay(hour: 15, minute: 30),
          color: Colors.cyan,
        ),
        CalendarEventData.timeRanged(
          title: translate.codeReviewTripleOverlapTitle,
          description: translate.codeReviewTripleOverlapDesc,
          date: _now,
          startTime: TimeOfDay(hour: 14, minute: 15),
          endTime: TimeOfDay(hour: 15, minute: 15),
          color: Colors.lightBlue,
        ),

        // ========== EDGE CASE 8: Back-to-back events (no gap) ==========
        // NOTE: These events also overlap with Marathon Coding Session (8:00-22:00)
        // So they should be arranged side-by-side with it in Day/Week views
        CalendarEventData.timeRanged(
          title: translate.morningSyncTitle,
          description: translate.morningSyncDesc,
          date: _now,
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 11, minute: 0),
          color: Colors.green,
        ),
        CalendarEventData.timeRanged(
          title: translate.teamPlanningTitle,
          description: translate.teamPlanningDesc,
          date: _now,
          startTime: TimeOfDay(hour: 11, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
          color: Colors.lightGreen,
        ),

        // ========== EDGE CASE 8b: Explicit overlap with long event ==========
        // This event explicitly tests that shorter events are arranged
        // side-by-side with the Marathon Coding Session
        CalendarEventData.timeRanged(
          title: translate.lunchBreakTitle,
          description: translate.lunchBreakDesc,
          date: _now,
          startTime: TimeOfDay(hour: 12, minute: 0),
          endTime: TimeOfDay(hour: 13, minute: 0),
          color: Colors.orange,
        ),

        // ========== EDGE CASE 8c: Early overlap with long event ==========
        CalendarEventData.timeRanged(
          title: translate.morningCoffeeTitle,
          description: translate.morningCoffeeDesc,
          date: _now,
          startTime: TimeOfDay(hour: 8, minute: 30),
          endTime: TimeOfDay(hour: 9, minute: 0),
          color: Colors.brown[300]!,
        ),

        // ========== EDGE CASE 8d: Late overlap with long event ==========
        CalendarEventData.timeRanged(
          title: translate.eveningWrapUpTitle,
          description: translate.eveningWrapUpDesc,
          date: _now,
          startTime: TimeOfDay(hour: 21, minute: 0),
          endTime: TimeOfDay(hour: 21, minute: 30),
          color: Colors.purple[300]!,
        ),

        // ========== EDGE CASE 9: Weekly recurring event ==========
        CalendarEventData.timeRanged(
          title: translate.weeklyStandupTitle,
          description: translate.weeklyStandupDesc,
          date: _now.subtract(Duration(days: 7)),
          startTime: TimeOfDay(hour: 9, minute: 30),
          endTime: TimeOfDay(hour: 10, minute: 0),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(Duration(days: 7)),
            frequency: RepeatFrequency.weekly,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 10,
            weekdays: [
              WeekDays.values[_now.subtract(Duration(days: 7)).weekday - 1],
            ],
          ),
          color: Colors.orange,
        ),

        // ========== EDGE CASE 10: Daily recurring with specific weekdays ==========
        CalendarEventData.wholeDay(
          title: translate.leetcodeContestTitle,
          description: translate.leetcodeContestDesc,
          date: _now.subtract(Duration(days: 3)),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(Duration(days: 3)),
            frequency: RepeatFrequency.daily,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 5,
          ),
          color: Colors.deepPurple,
        ),

        // ========== EDGE CASE 11: Monthly recurring event ==========
        CalendarEventData.timeRanged(
          title: translate.monthlyReviewTitle,
          description: translate.monthlyReviewDesc,
          date: _now,
          startTime: TimeOfDay(hour: 15, minute: 0),
          endTime: TimeOfDay(hour: 16, minute: 0),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now,
            frequency: RepeatFrequency.monthly,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 6,
          ),
          color: Colors.pink,
        ),

        // ========== EDGE CASE 12: Event with custom styles ==========
        CalendarEventData.timeRanged(
          title: translate.vipClientMeetingTitle,
          description: translate.vipClientMeetingDesc,
          date: _now.add(Duration(days: 1)),
          startTime: TimeOfDay(hour: 16, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 30),
          color: Colors.black,
          titleStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          descriptionStyle: TextStyle(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),

        // ========== EDGE CASE 13: Events at odd minutes (15, 45) ==========
        CalendarEventData.timeRanged(
          title: translate.oddTimeMeetingTitle,
          description: translate.oddTimeMeetingDesc,
          date: _now,
          startTime: TimeOfDay(hour: 13, minute: 15),
          endTime: TimeOfDay(hour: 13, minute: 45),
          color: Colors.brown,
        ),

        // ========== EDGE CASE 14: Multiple events on same day ==========
        CalendarEventData.timeRanged(
          title: translate.footballTournamentTitle,
          description: translate.footballTournamentDesc,
          date: _now,
          startTime: TimeOfDay(hour: 18, minute: 30),
          endTime: TimeOfDay(hour: 20, minute: 0),
          color: Colors.blueGrey,
        ),

        // ========== EDGE CASE 15: Past recurring events ==========
        CalendarEventData.timeRanged(
          title: translate.pastDailyScrumTitle,
          description: translate.pastDailyScrumDesc,
          date: _now.subtract(Duration(days: 10)),
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 9, minute: 15),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(Duration(days: 10)),
            frequency: RepeatFrequency.daily,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 8,
          ),
          color: Colors.grey,
        ),

        // ========== EDGE CASE 16: Future events ==========
        CalendarEventData.timeRanged(
          title: translate.futureSprintPlanningTitle,
          description: translate.futureSprintPlanningDesc,
          date: _now.add(Duration(days: 5)),
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
          color: Colors.lime,
        ),

        // ========== EDGE CASE 17: Weekend events ==========
        CalendarEventData.timeRanged(
          title: translate.weekendHackathonTitle,
          description: translate.weekendHackathonDesc,
          date: _now.add(Duration(days: 6 - _now.weekday)),
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 18, minute: 0),
          color: Colors.cyan,
        ),

        // ========== EDGE CASE 18: Very long title ==========
        CalendarEventData.timeRanged(
          title: translate.veryLongTitle,
          description: translate.veryLongDesc,
          date: _now.add(Duration(days: 2)),
          startTime: TimeOfDay(hour: 11, minute: 0),
          endTime: TimeOfDay(hour: 12, minute: 0),
          color: Colors.deepOrange,
        ),

        // ========== EDGE CASE 19: Event ending at 23:59 ==========
        CalendarEventData.timeRanged(
          title: translate.lateNightWorkTitle,
          description: translate.lateNightWorkDesc,
          date: _now.add(Duration(days: 1)),
          startTime: TimeOfDay(hour: 22, minute: 0),
          endTime: TimeOfDay(hour: 23, minute: 59),
          color: Colors.indigo,
        ),

        // ========== EDGE CASE 20: Multi-day all-day event ==========
        CalendarEventData.multiDay(
          title: translate.companyRetreatTitle,
          description: translate.companyRetreatDesc,
          date: _now.add(Duration(days: 7)),
          endDate: _now.add(Duration(days: 9)),
          color: Colors.green,
        ),

        // ===== EDGE CASE 21: Multi-day event with end time before start time =====
        CalendarEventData.multiDay(
          title: translate.extendedWorkshopTitle,
          description: translate.extendedWorkshopDesc,
          date: _now.add(const Duration(days: 10)),
          endDate: _now.add(const Duration(days: 12)),
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 8, minute: 0),
        ),

        // ========== Additional original events for variety ==========
        CalendarEventData.timeRanged(
          title: translate.sprintMeetingTitle,
          description: translate.sprintMeetingDesc,
          date: _now.add(Duration(days: 3)),
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 14, minute: 0),
          color: Colors.teal,
        ),
        CalendarEventData.timeRanged(
          title: translate.teamMeetingTitle,
          description: translate.teamMeetingDesc,
          color: Colors.blue,
          date: _now.subtract(Duration(days: 2)),
          startTime: TimeOfDay(hour: 14, minute: 0),
          endTime: TimeOfDay(hour: 16, minute: 0),
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
