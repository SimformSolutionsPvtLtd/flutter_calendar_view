// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

// Note: Do not change sequence of this enumeration if not necessary
// this can change behaviour of month and week view.
/// Defines day of week
enum WeekDays {
  /// Monday: 0
  monday,

  /// Tuesday: 1
  tuesday,

  /// Wednesday: 2
  wednesday,

  /// Thursday: 3
  thursday,

  /// Friday: 4
  friday,

  /// Saturday: 5
  saturday,

  /// Sunday: 6
  sunday,
}

/// Defines different minute slot sizes.
enum MinuteSlotSize {
  /// Slot size: 15 minutes
  minutes15,

  /// Slot size: 30 minutes
  minutes30,

  /// Slot size: 60 minutes
  minutes60,
}

/// Defines different line styles
enum LineStyle {
  /// Solid line
  solid,

  /// Dashed line
  dashed,
}

/// Defines reoccurrence of event: Daily, weekly, monthly or yearly
enum RepeatFrequency {
  doNotRepeat,
  daily,
  weekly,
  monthly,
  yearly,
}

/// Defines reoccurrence event ends on:
/// `never` to repeat without any end date specified,
/// `onDate` to repeat till date specified
/// `after` repeat till defined number of occurrence.
enum RecurrenceEnd {
  never,
  onDate,
  after,
}

/// Specifies the scope of deletion for recurring events in a calendar.
///
/// This enum is used to determine which instances of a recurring event
/// should be deleted when a deletion action is performed.
///
/// - [DeleteEvent.all] - Deletes all instances of the recurring event.
/// - [DeleteEvent.current] - Deletes only the currently selected instance
/// of the event.
/// - [DeleteEvent.following] - Deletes the current and all future instances
///   of the recurring event.
enum DeleteEvent {
  all,
  current,
  following,
}
