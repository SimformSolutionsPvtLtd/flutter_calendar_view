import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

/// Comprehensive test data for SideEventArranger algorithm testing
/// Covers all edge cases, scenarios, and algorithm paths
class SideEventArrangerTestData {
  
  /// Test date for all scenarios
  static final DateTime testDate = DateTime(2025, 9, 18);
  
  // ✅ Passed
  /// **Test Case 1: Basic Overlapping Events**
  /// Tests the core column assignment algorithm
  static List<CalendarEventData<String>> get basicOverlappingEvents => [
    CalendarEventData(
      title: "Meeting A",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 9, 0),   // 9:00-10:00 AM
      endTime: DateTime(2025, 9, 15, 10, 0),
      color: Colors.red,
      event: "meeting_a",
    ),
    CalendarEventData(
      title: "Meeting B", 
      date: testDate,
      startTime: DateTime(2025, 9, 15, 9, 30),  // 9:30-11:00 AM (overlaps A)
      endTime: DateTime(2025, 9, 15, 11, 0),
      color: Colors.blue,
      event: "meeting_b",
    ),
    CalendarEventData(
      title: "Meeting C",
      date: testDate, 
      startTime: DateTime(2025, 9, 15, 10, 30), // 10:30-12:00 PM (fits after A)
      endTime: DateTime(2025, 9, 15, 12, 0),
      color: Colors.green,
      event: "meeting_c",
    ),
  ];

  // ✅ Passed
  /// **Test Case 2: Edge Touching Events**
  /// Tests includeEdges parameter behavior
  static List<CalendarEventData<String>> get edgeTouchingEvents => [
    CalendarEventData(
      title: "Event 1",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 14, 0),  // 2:00-3:00 PM
      endTime: DateTime(2025, 9, 15, 15, 0),
      color: Colors.orange,
      event: "edge_1",
    ),
    CalendarEventData(
      title: "Event 2",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 15, 0),  // 3:00-4:00 PM (touches edge)
      endTime: DateTime(2025, 9, 15, 16, 0),
      color: Colors.purple,
      event: "edge_2",
    ),
  ];

  // ✅ Passed
  /// **Test Case 3: All Events Overlapping (Worst Case)**
  /// Tests maximum column creation scenario
  static List<CalendarEventData<String>> get allOverlappingEvents => [
    CalendarEventData(
      title: "Overlap 1",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 0),  // 10:00-11:00 AM
      endTime: DateTime(2025, 9, 15, 11, 0),
      color: Colors.red,
      event: "overlap_1",
    ),
    CalendarEventData(
      title: "Overlap 2",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 15), // 10:15-11:15 AM
      endTime: DateTime(2025, 9, 15, 11, 15),
      color: Colors.blue,
      event: "overlap_2",
    ),
    CalendarEventData(
      title: "Overlap 3",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 30), // 10:30-11:30 AM
      endTime: DateTime(2025, 9, 15, 11, 30),
      color: Colors.green,
      event: "overlap_3",
    ),
    CalendarEventData(
      title: "Overlap 4",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 45), // 10:45-11:45 AM
      endTime: DateTime(2025, 9, 15, 11, 45),
      color: Colors.yellow,
      event: "overlap_4",
    ),
  ];

  // ✅ Passed
  /// **Test Case 4: Sequential Non-overlapping Events (Best Case)**
  /// Tests single column optimization
  static List<CalendarEventData<String>> get sequentialEvents => [
    CalendarEventData(
      title: "Sequential 1",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 8, 0),   // 8:00-9:00 AM
      endTime: DateTime(2025, 9, 15, 9, 0),
      color: Colors.teal,
      event: "seq_1",
    ),
    CalendarEventData(
      title: "Sequential 2",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 9, 0),   // 9:00-10:00 AM
      endTime: DateTime(2025, 9, 15, 10, 0),
      color: Colors.cyan,
      event: "seq_2",
    ),
    CalendarEventData(
      title: "Sequential 3",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 0),  // 10:00-11:00 AM
      endTime: DateTime(2025, 9, 15, 11, 0),
      color: Colors.indigo,
      event: "seq_3",
    ),
  ];

  // ✅ Passed
  /// **Test Case 5: Multi-day Events**
  /// Tests event normalization for different multi-day scenarios
  static List<CalendarEventData<String>> get multiDayEvents => [
    // Event starting on test date, ending later
    CalendarEventData(
      title: "Multi Start",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 16, 0),  // 4:00 PM on Jan 15
      endTime: DateTime(2025, 9, 15, 10, 0),    // 10:00 AM on Jan 15
      endDate: DateTime(2025, 9, 20),
      color: Colors.deepOrange,
      event: "multi_start",
    ),
    // Event started earlier, ending on test date
    CalendarEventData(
      title: "Multi End",
      date: DateTime(2025, 9, 13),
      startTime: DateTime(2025, 9, 13, 14, 0),  // 2:00 PM on Jan 13
      endTime: DateTime(2025, 9, 13, 11, 0),    // 11:00 AM on Jan 13
      endDate: testDate,
      color: Colors.brown,
      event: "multi_end",
    ),
    // Event spanning across test date (middle day)
    CalendarEventData(
      title: "Multi Middle",
      date: DateTime(2025, 9, 14),
      startTime: DateTime(2025, 9, 14, 9, 0),   // 9:00 AM on Jan 14
      endTime: DateTime(2025, 9, 14, 17, 0),    // 5:00 PM on Jan 14
      endDate: DateTime(2025, 9, 16),
      color: Colors.grey,
      event: "multi_middle",
    ),
  ];

  // ✅ Passed
  /// **Test Case 6: Full Day Events**
  /// Tests full day event handling
  static List<CalendarEventData<String>> get fullDayEvents => [
    CalendarEventData(
      title: "Full Day Event",
      date: testDate,
      color: Colors.amber,
      event: "full_day",
      // No startTime/endTime = full day
    ),
    CalendarEventData(
      title: "Explicit Full Day",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 0, 0),   // Midnight start
      endTime: DateTime(2025, 9, 15, 0, 0),     // Midnight end
      color: Colors.lime,
      event: "explicit_full_day",
    ),
  ];

  // ✅ Passed
  /// **Test Case 7: Zero Duration Events**
  /// Tests point-in-time events
  static List<CalendarEventData<String>> get zeroDurationEvents => [
    CalendarEventData(
      title: "Zero Duration 1",
      date: testDate,
      startTime: DateTime(2025, 9, 18, 12, 0),  // 12:00 PM
      endTime: DateTime(2025, 9, 18, 12, 0),    // 12:00 PM (same time)
      color: Colors.pink,
      event: "zero_1",
    ),
    CalendarEventData(
      title: "Zero Duration 2", 
      date: testDate,
      startTime: DateTime(2025, 9, 15, 12, 30), // 12:30 PM
      endTime: DateTime(2025, 9, 15, 12, 30),   // 12:30 PM (same time)
      color: Colors.deepPurple,
      event: "zero_2",
    ),
  ];
  
  // ✅ Passed
  /// **Test Case 8: Events Outside Visible Range**
  /// Tests filtering logic (assuming startHour = 8)
  static List<CalendarEventData<String>> get eventsOutsideRange => [
    CalendarEventData(
      title: "Early Morning",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 5, 0),   // 5:00-7:00 AM (before visible)
      endTime: DateTime(2025, 9, 15, 7, 0),
      color: Colors.blueGrey,
      event: "early",
    ),
    CalendarEventData(
      title: "Late Night",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 23, 30), // 11:30 PM-Midnight (visible)
      endTime: DateTime(2025, 9, 15, 23, 59),
      color: Colors.black,
      event: "late",
    ),
  ];

  // ✅ Passed
  /// **Test Case 9: Complex Overlapping Pattern**
  /// Tests advanced column assignment and width calculation
  static List<CalendarEventData<String>> get complexOverlapPattern => [
    CalendarEventData(
      title: "Base Event",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 9, 0),   // 9:00-12:00 PM (3 hours)
      endTime: DateTime(2025, 9, 15, 12, 0),
      color: Colors.red,
      event: "base",
    ),
    CalendarEventData(
      title: "Short Overlap 1",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 9, 30),  // 9:30-10:00 AM
      endTime: DateTime(2025, 9, 15, 10, 0),
      color: Colors.blue,
      event: "short_1",
    ),
    CalendarEventData(
      title: "Short Overlap 2",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 30), // 10:30-11:00 AM
      endTime: DateTime(2025, 9, 15, 11, 0),
      color: Colors.green,
      event: "short_2",
    ),
    CalendarEventData(
      title: "Late Overlap",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 11, 30), // 11:30-13:00 PM
      endTime: DateTime(2025, 9, 15, 13, 0),
      color: Colors.orange,
      event: "late_overlap",
    ),
  ];

  // ✅ Passed
  /// **Test Case 10: Different Duration Events**
  /// Tests width allocation for varying event lengths
  static List<CalendarEventData<String>> get variableDurationEvents => [
    CalendarEventData(
      title: "15 min event",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 14, 0),  // 2:00-2:15 PM
      endTime: DateTime(2025, 9, 15, 14, 15),
      color: Colors.red,
      event: "short_15",
    ),
    CalendarEventData(
      title: "30 min event",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 14, 5),  // 2:05-2:35 PM (overlaps)
      endTime: DateTime(2025, 9, 15, 14, 35),
      color: Colors.blue,
      event: "medium_30",
    ),
    CalendarEventData(
      title: "2 hour event",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 15, 0),  // 3:00-5:00 PM
      endTime: DateTime(2025, 9, 15, 17, 0),
      color: Colors.green,
      event: "long_120",
    ),
  ];

  // ✅ Passed
  /// **Test Case 11: Events with Null Times**
  /// Tests null safety and filtering
  static List<CalendarEventData<String>> get eventsWithNullTimes => [
    CalendarEventData(
      title: "Null Start",
      date: testDate,
      startTime: null,                           // Should be filtered out
      endTime: DateTime(2025, 9, 15, 10, 0),
      color: Colors.grey,
      event: "null_start",
    ),
    CalendarEventData(
      title: "Null End",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 9, 0),
      endTime: null,                             // Should be filtered out
      color: Colors.grey,
      event: "null_end",
    ),
    CalendarEventData(
      title: "Valid Event",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 11, 0),  // Should be included
      endTime: DateTime(2025, 9, 15, 12, 0),
      color: Colors.blue,
      event: "valid",
    ),
  ];

  // ✅ Passed
  /// **Test Case 12: Stress Test - Many Events**
  /// Tests performance with larger datasets
  static List<CalendarEventData<String>> get stressTestEvents {
    final events = <CalendarEventData<String>>[];
    
    // Create 20 events with various overlapping patterns
    for (int i = 0; i < 20; i++) {
      final startHour = 8 + (i * 0.5).floor();
      final startMinute = ((i * 30) % 60);
      final durationMinutes = 30 + (i * 15) % 90; // 30-120 min durations
      
      events.add(CalendarEventData(
        title: "Stress Event $i",
        date: testDate,
        startTime: DateTime(2025, 9, 15, startHour, startMinute),
        endTime: DateTime(2025, 9, 15, startHour, startMinute)
            .add(Duration(minutes: durationMinutes)),
        color: Color.fromARGB(255, (i * 50) % 255, (i * 80) % 255, (i * 120) % 255),
        event: "stress_$i",
      ));
    }
    
    return events;
  }

  // ✅ Passed
  /// **Test Case 13: Edge Case - Same Start Times**
  /// Tests sorting stability and column assignment for identical start times
  static List<CalendarEventData<String>> get sameStartTimeEvents => [
    CalendarEventData(
      title: "Same Start A",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 0),  // All start at 10:00 AM
      endTime: DateTime(2025, 9, 15, 11, 0),    // End at 11:00 AM
      color: Colors.red,
      event: "same_a",
    ),
    CalendarEventData(
      title: "Same Start B",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 0),  // All start at 10:00 AM  
      endTime: DateTime(2025, 9, 15, 11, 30),   // End at 11:30 AM
      color: Colors.blue,
      event: "same_b",
    ),
    CalendarEventData(
      title: "Same Start C",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 0),  // All start at 10:00 AM
      endTime: DateTime(2025, 9, 15, 10, 30),   // End at 10:30 AM
      color: Colors.green,
      event: "same_c",
    ),
  ];

  // ✅ Passed
  /// **Comprehensive Test Suite**
  /// Returns all test cases combined for thorough testing
  static Map<String, List<CalendarEventData<String>>> get allTestCases => {
    'basicOverlapping': basicOverlappingEvents,
    'edgeTouching': edgeTouchingEvents,
    'allOverlapping': allOverlappingEvents,
    'sequential': sequentialEvents,
    'multiDay': multiDayEvents,
    'fullDay': fullDayEvents,
    'zeroDuration': zeroDurationEvents,
    'outsideRange': eventsOutsideRange,
    'complexOverlap': complexOverlapPattern,
    'variableDuration': variableDurationEvents,
    'nullTimes': eventsWithNullTimes,
    'stressTest': stressTestEvents,
    'sameStartTime': sameStartTimeEvents,
  };

  /// Empty events list for edge case testing
  static List<CalendarEventData<String>> get emptyEvents => [];
  
  /// Single event for basic functionality testing
  static List<CalendarEventData<String>> get singleEvent => [
    CalendarEventData(
      title: "Single Event",
      date: testDate,
      startTime: DateTime(2025, 9, 15, 10, 0),
      endTime: DateTime(2025, 9, 15, 11, 0),
      color: Colors.blue,
      event: "single",
    ),
  ];
}

/// Test configuration for different algorithm parameters
class TestConfiguration {
  final double width;
  final double height;
  final double heightPerMinute;
  final int startHour;
  final DateTime calendarViewDate;
  final double? maxWidth;
  final bool includeEdges;

  const TestConfiguration({
    this.width = 300.0,
    this.height = 600.0,
    this.heightPerMinute = 1.0,
    this.startHour = 8,
    required this.calendarViewDate,
    this.maxWidth,
    this.includeEdges = false,
  });
  
  /// Default configuration for standard testing
  static TestConfiguration get standard => TestConfiguration(
    calendarViewDate: SideEventArrangerTestData.testDate,
  );
  
  /// Configuration with maxWidth constraint
  static TestConfiguration get withMaxWidth => TestConfiguration(
    calendarViewDate: SideEventArrangerTestData.testDate,
    maxWidth: 150.0,
  );
  
  /// Configuration with edge inclusion
  static TestConfiguration get withEdges => TestConfiguration(
    calendarViewDate: SideEventArrangerTestData.testDate,
    includeEdges: true,
  );
  
  /// Configuration for narrow view (mobile)
  static TestConfiguration get narrow => TestConfiguration(
    calendarViewDate: SideEventArrangerTestData.testDate,
    width: 200.0,
    maxWidth: 80.0,
  );
  
  /// Configuration for wide view (desktop)
  static TestConfiguration get wide => TestConfiguration(
    calendarViewDate: SideEventArrangerTestData.testDate,
    width: 800.0,
  );
}