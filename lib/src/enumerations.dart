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
