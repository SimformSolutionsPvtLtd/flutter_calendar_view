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
        CalendarEventData(
          date: _now,
          title: "Midnight Shift",
          description: "Tests midnight boundary handling",
          startTime: DateTime(_now.year, _now.month, _now.day, 23, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 23, 59, 59),
          color: Colors.purple,
        ),

        // ========== EDGE CASE 2: Early morning event (00:00 - 00:30) ==========
        CalendarEventData(
          date: _now,
          title: "Early Bird Meeting",
          description: "Tests day start boundary",
          startTime: DateTime(_now.year, _now.month, _now.day, 0, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 0, 30),
          color: Colors.indigo,
        ),

        // ========== EDGE CASE 3: Full day event (all day) ==========
        CalendarEventData(
          date: _now,
          title: "All Day Conference",
          description:
              "Tests full day event rendering without startTime/endTime",
          color: Colors.teal,
        ),

        // ========== EDGE CASE 4: Multi-day spanning event ==========
        CalendarEventData(
          date: _now.subtract(Duration(days: 1)),
          title: "3-Day Workshop",
          description: "Tests multi-day event spanning",
          startTime: DateTime(
            _now.subtract(Duration(days: 1)).year,
            _now.subtract(Duration(days: 1)).month,
            _now.subtract(Duration(days: 1)).day,
            9,
            0,
          ),
          endTime: DateTime(
            _now.subtract(Duration(days: 1)).year,
            _now.subtract(Duration(days: 1)).month,
            _now.subtract(Duration(days: 1)).day,
            17,
            0,
          ),
          endDate: _now.add(Duration(days: 1)),
          color: Colors.deepOrange,
        ),

        // ========== EDGE CASE 5: Very short event (1 minute) ==========
        CalendarEventData(
          date: _now,
          title: "Quick Standup",
          description: "Tests minimum duration rendering",
          startTime: DateTime(_now.year, _now.month, _now.day, 9, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 9, 1),
          color: Colors.amber,
        ),

        // ========== EDGE CASE 6: Very long event (12+ hours) ==========
        CalendarEventData(
          date: _now,
          title: "Marathon Coding Session",
          description: "Tests long duration event",
          startTime: DateTime(_now.year, _now.month, _now.day, 8, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 22, 0),
          color: Colors.red,
        ),

        // ========== EDGE CASE 7: Overlapping events (same time slot) ==========
        CalendarEventData(
          date: _now,
          title: translate.projectMeetingTitle,
          description: translate.projectMeetingDesc,
          startTime: DateTime(_now.year, _now.month, _now.day, 14, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 15, 0),
          color: Colors.blue,
        ),
        CalendarEventData(
          date: _now,
          title: "Design Review (Overlapping)",
          description: "Tests overlapping event rendering",
          startTime: DateTime(_now.year, _now.month, _now.day, 14, 30),
          endTime: DateTime(_now.year, _now.month, _now.day, 15, 30),
          color: Colors.cyan,
        ),
        CalendarEventData(
          date: _now,
          title: "Code Review (Triple Overlap)",
          description: "Tests multiple overlapping events",
          startTime: DateTime(_now.year, _now.month, _now.day, 14, 15),
          endTime: DateTime(_now.year, _now.month, _now.day, 15, 15),
          color: Colors.lightBlue,
        ),

        // ========== EDGE CASE 8: Back-to-back events (no gap) ==========
        // NOTE: These events also overlap with Marathon Coding Session (8:00-22:00)
        // So they should be arranged side-by-side with it in Day/Week views
        CalendarEventData(
          date: _now,
          title: "Morning Sync",
          description: "Tests consecutive events + overlaps with long event",
          startTime: DateTime(_now.year, _now.month, _now.day, 10, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 11, 0),
          color: Colors.green,
        ),
        CalendarEventData(
          date: _now,
          title: "Team Planning",
          description: "Back-to-back with previous + overlaps with long event",
          startTime: DateTime(_now.year, _now.month, _now.day, 11, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 12, 0),
          color: Colors.lightGreen,
        ),

        // ========== EDGE CASE 8b: Explicit overlap with long event ==========
        // This event explicitly tests that shorter events are arranged
        // side-by-side with the Marathon Coding Session
        CalendarEventData(
          date: _now,
          title: "Lunch Break",
          description: "Tests side-by-side arrangement with long event",
          startTime: DateTime(_now.year, _now.month, _now.day, 12, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 13, 0),
          color: Colors.orange,
        ),

        // ========== EDGE CASE 8c: Early overlap with long event ==========
        CalendarEventData(
          date: _now,
          title: "Morning Coffee",
          description: "Early event overlapping with long event (8:30-9:00)",
          startTime: DateTime(_now.year, _now.month, _now.day, 8, 30),
          endTime: DateTime(_now.year, _now.month, _now.day, 9, 0),
          color: Colors.brown[300]!,
        ),

        // ========== EDGE CASE 8d: Late overlap with long event ==========
        CalendarEventData(
          date: _now,
          title: "Evening Wrap-up",
          description: "Late event overlapping with long event (21:00-21:30)",
          startTime: DateTime(_now.year, _now.month, _now.day, 21, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 21, 30),
          color: Colors.purple[300]!,
        ),

        // ========== EDGE CASE 9: Weekly recurring event ==========
        CalendarEventData(
          date: _now.subtract(Duration(days: 7)),
          title: "Weekly Standup",
          description: "Tests weekly recurrence",
          startTime: DateTime(
            _now.subtract(Duration(days: 7)).year,
            _now.subtract(Duration(days: 7)).month,
            _now.subtract(Duration(days: 7)).day,
            9,
            30,
          ),
          endTime: DateTime(
            _now.subtract(Duration(days: 7)).year,
            _now.subtract(Duration(days: 7)).month,
            _now.subtract(Duration(days: 7)).day,
            10,
            0,
          ),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(Duration(days: 7)),
            frequency: RepeatFrequency.weekly,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 10,
            weekdays: [_now.subtract(Duration(days: 7)).weekday - 1],
          ),
          color: Colors.orange,
        ),

        // ========== EDGE CASE 10: Daily recurring with specific weekdays ==========
        CalendarEventData(
          date: _now.subtract(Duration(days: 3)),
          title: translate.leetcodeContestTitle,
          description: translate.leetcodeContestDesc,
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(Duration(days: 3)),
            frequency: RepeatFrequency.daily,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 5,
          ),
          color: Colors.deepPurple,
        ),

        // ========== EDGE CASE 11: Monthly recurring event ==========
        CalendarEventData(
          date: _now,
          title: "Monthly Review",
          description: "Tests monthly recurrence across month boundaries",
          startTime: DateTime(_now.year, _now.month, _now.day, 15, 0),
          endTime: DateTime(_now.year, _now.month, _now.day, 16, 0),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now,
            frequency: RepeatFrequency.monthly,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 6,
          ),
          color: Colors.pink,
        ),

        // ========== EDGE CASE 12: Event with custom styles ==========
        CalendarEventData(
          date: _now.add(Duration(days: 1)),
          title: "VIP Client Meeting",
          description: "Tests custom title and description styles",
          startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            16,
            0,
          ),
          endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            17,
            30,
          ),
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
        CalendarEventData(
          date: _now,
          title: "Odd Time Meeting",
          description: "Tests non-standard time slots",
          startTime: DateTime(_now.year, _now.month, _now.day, 13, 15),
          endTime: DateTime(_now.year, _now.month, _now.day, 13, 45),
          color: Colors.brown,
        ),

        // ========== EDGE CASE 14: Multiple events on same day ==========
        CalendarEventData(
          date: _now,
          title: translate.footballTournamentTitle,
          description: translate.footballTournamentDesc,
          startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
          endTime: DateTime(_now.year, _now.month, _now.day, 20, 0),
          color: Colors.blueGrey,
        ),

        // ========== EDGE CASE 15: Past recurring events ==========
        CalendarEventData(
          date: _now.subtract(Duration(days: 10)),
          title: "Past Daily Scrum",
          description: "Tests past recurring events",
          startTime: DateTime(
            _now.subtract(Duration(days: 10)).year,
            _now.subtract(Duration(days: 10)).month,
            _now.subtract(Duration(days: 10)).day,
            9,
            0,
          ),
          endTime: DateTime(
            _now.subtract(Duration(days: 10)).year,
            _now.subtract(Duration(days: 10)).month,
            _now.subtract(Duration(days: 10)).day,
            9,
            15,
          ),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
            startDate: _now.subtract(Duration(days: 10)),
            frequency: RepeatFrequency.daily,
            recurrenceEndOn: RecurrenceEnd.after,
            occurrences: 8,
          ),
          color: Colors.grey,
        ),

        // ========== EDGE CASE 16: Future events ==========
        CalendarEventData(
          date: _now.add(Duration(days: 5)),
          title: "Future Sprint Planning",
          description: "Tests future event rendering",
          startTime: DateTime(
            _now.add(Duration(days: 5)).year,
            _now.add(Duration(days: 5)).month,
            _now.add(Duration(days: 5)).day,
            10,
            0,
          ),
          endTime: DateTime(
            _now.add(Duration(days: 5)).year,
            _now.add(Duration(days: 5)).month,
            _now.add(Duration(days: 5)).day,
            12,
            0,
          ),
          color: Colors.lime,
        ),

        // ========== EDGE CASE 17: Weekend events ==========
        CalendarEventData(
          date: _now.add(Duration(days: 6 - _now.weekday)),
          title: "Weekend Hackathon",
          description: "Tests weekend event handling",
          startTime: DateTime(
            _now.add(Duration(days: 6 - _now.weekday)).year,
            _now.add(Duration(days: 6 - _now.weekday)).month,
            _now.add(Duration(days: 6 - _now.weekday)).day,
            10,
            0,
          ),
          endTime: DateTime(
            _now.add(Duration(days: 6 - _now.weekday)).year,
            _now.add(Duration(days: 6 - _now.weekday)).month,
            _now.add(Duration(days: 6 - _now.weekday)).day,
            18,
            0,
          ),
          color: Colors.cyan,
        ),

        // ========== EDGE CASE 18: Very long title ==========
        CalendarEventData(
          date: _now.add(Duration(days: 2)),
          title:
              "This is a very long event title to test text overflow and wrapping in different calendar views including month, week, and day views",
          description: "Tests long text handling and overflow",
          startTime: DateTime(
            _now.add(Duration(days: 2)).year,
            _now.add(Duration(days: 2)).month,
            _now.add(Duration(days: 2)).day,
            11,
            0,
          ),
          endTime: DateTime(
            _now.add(Duration(days: 2)).year,
            _now.add(Duration(days: 2)).month,
            _now.add(Duration(days: 2)).day,
            12,
            0,
          ),
          color: Colors.deepOrange,
        ),

        // ========== EDGE CASE 19: Event ending at 23:59 ==========
        CalendarEventData(
          date: _now.add(Duration(days: 1)),
          title: "Late Night Work",
          description: "Tests end of day boundary",
          startTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            22,
            0,
          ),
          endTime: DateTime(
            _now.add(Duration(days: 1)).year,
            _now.add(Duration(days: 1)).month,
            _now.add(Duration(days: 1)).day,
            23,
            59,
          ),
          color: Colors.indigo,
        ),

        // ========== EDGE CASE 20: Multi-day all-day event ==========
        CalendarEventData(
          date: _now.add(Duration(days: 7)),
          title: "Company Retreat",
          description: "Tests multi-day all-day event",
          endDate: _now.add(Duration(days: 9)),
          color: Colors.green,
        ),

        // ========== Additional original events for variety ==========
        CalendarEventData(
          date: _now.add(Duration(days: 3)),
          startTime: DateTime(
            _now.add(Duration(days: 3)).year,
            _now.add(Duration(days: 3)).month,
            _now.add(Duration(days: 3)).day,
            10,
          ),
          endTime: DateTime(
            _now.add(Duration(days: 3)).year,
            _now.add(Duration(days: 3)).month,
            _now.add(Duration(days: 3)).day,
            14,
          ),
          title: translate.sprintMeetingTitle,
          description: translate.sprintMeetingDesc,
          color: Colors.teal,
        ),
        CalendarEventData(
          date: _now.subtract(Duration(days: 2)),
          startTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            14,
          ),
          endTime: DateTime(
            _now.subtract(Duration(days: 2)).year,
            _now.subtract(Duration(days: 2)).month,
            _now.subtract(Duration(days: 2)).day,
            16,
          ),
          title: translate.teamMeetingTitle,
          description: translate.teamMeetingDesc,
          color: Colors.blue,
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
