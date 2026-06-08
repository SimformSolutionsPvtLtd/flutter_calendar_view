import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import 'enumerations.dart';

/// The parameters a non-default [EventType] preconfigures on the form.
class EventTypeConfig {
  /// Default event color for this type.
  final Color color;

  /// Whether the type defaults to a whole-day event (no start/end time).
  final bool isWholeDay;

  /// Default duration applied when the type is timed (`!isWholeDay`).
  final Duration defaultDuration;

  /// Default recurrence frequency; [RepeatFrequency.doNotRepeat] means none.
  final RepeatFrequency recurrence;

  /// Default event background image path for [ScheduleView]
  final String? imagePath;

  const EventTypeConfig({
    required this.color,
    this.isWholeDay = false,
    this.defaultDuration = const Duration(hours: 1),
    this.recurrence = RepeatFrequency.doNotRepeat,
    this.imagePath,
  });
}

/// Presets for every type except [EventType.event] (which intentionally has no
/// preset — selecting it resets the form to its neutral defaults).
const Map<EventType, EventTypeConfig> kEventTypeConfigs = {
  EventType.birthday: EventTypeConfig(
    color: Colors.pink,
    isWholeDay: true,
    recurrence: RepeatFrequency.yearly,
    imagePath: 'assets/images/birthday_background.jpg',
  ),
  EventType.task: EventTypeConfig(
    color: Colors.green,
    defaultDuration: Duration(minutes: 30),
    imagePath: 'assets/images/task_background.jpg',
  ),
  EventType.outOfOffice: EventTypeConfig(
    color: Colors.orange,
    isWholeDay: true,
    imagePath: 'assets/images/out_of_office_background.jpg',
  ),
  EventType.meeting: EventTypeConfig(
    color: Colors.indigo,
    imagePath: 'assets/images/meeting_background.jpg',
  ),
  EventType.reminder: EventTypeConfig(
    color: Colors.teal,
    defaultDuration: Duration(minutes: 15),
    imagePath: 'assets/images/reminder_background.jpg',
  ),
};

/// The payload stored on [CalendarEventData.event] so the chosen type travels
/// with the event (e.g. to display it on the details page) without changing
/// the package API.
class EventMetadata {
  final EventType type;

  const EventMetadata(this.type);
}
