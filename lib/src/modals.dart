// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';

/// Settings for hour lines
class HourIndicatorSettings {
  final double height;
  final Color color;
  final double offset;
  final LineStyle lineStyle;
  final double dashWidth;
  final double dashSpaceWidth;
  final int startHour;

  /// Settings for hour lines
  const HourIndicatorSettings(
      {this.height = 1.0,
      this.offset = 0.0,
      this.color = Colors.grey,
      this.lineStyle = LineStyle.solid,
      this.dashWidth = 4,
      this.dashSpaceWidth = 4,
      this.startHour = 0})
      : assert(height >= 0, "Height must be greater than or equal to 0.");

  factory HourIndicatorSettings.none() => HourIndicatorSettings(
        color: Colors.transparent,
        height: 0.0,
      );
}

/// Settings for live time line
class LiveTimeIndicatorSettings {
  /// Color of time indicator.
  final Color color;

  /// Height of time indicator.
  final double height;

  /// offset of time indicator.
  final double offset;

  /// StringProvider for time string
  final StringProvider? timeStringBuilder;

  /// Flag to show bullet at left side or not.
  final bool showBullet;

  /// Flag to show time on live time line.
  final bool showTime;

  /// Flag to show time backgroud view.
  final bool showTimeBackgroundView;

  /// Radius of bullet.
  final double bulletRadius;

  /// Width of time backgroud view.
  final double timeBackgroundViewWidth;

  /// Settings for live time line
  const LiveTimeIndicatorSettings({
    this.height = 1.0,
    this.offset = 5.0,
    this.color = Colors.grey,
    this.timeStringBuilder,
    this.showBullet = true,
    this.showTime = false,
    this.showTimeBackgroundView = false,
    this.bulletRadius = 5.0,
    this.timeBackgroundViewWidth = 60.0,
  }) : assert(height >= 0, "Height must be greater than or equal to 0.");

  factory LiveTimeIndicatorSettings.none() => LiveTimeIndicatorSettings(
        color: Colors.transparent,
        height: 0.0,
        offset: 0.0,
        showBullet: false,
      );
}

/// Set `frequency = RepeatFrequency.daily` to repeat every day
/// starting from event date (Inclusive).
///
/// Set `frequency = RepeatFrequency.weekly` & provide list of weekdays
/// to repeat on.
///
/// [startDate]: Defines start date of repeating events.
/// [endDate]: Defines end date of repeating events.
/// [occurrence]: Defines repetition of an event for the given number of
/// occurrences.
///
/// [frequency]: Defines mode of repetition like repeat daily, weekly, monthly
/// or yearly.
///
/// [weekdays]: Contains list of weekdays to repeat starting from 0 index.
/// By default selected weekday is the start date of an event.
///
/// Note: Use constructor .withCalculatedEndDate to calculate
/// end date of recurring event automatically.
class RecurrenceSettings {
  RecurrenceSettings({
    required this.startDate,
    this.endDate,
    this.occurrences,
    this.frequency = RepeatFrequency.doNotRepeat,
    this.recurrenceEndOn = RecurrenceEnd.never,
    this.excludeDates,
    List<int>? weekdays,
  }) : weekdays = weekdays ?? [startDate.weekday];

  /// If recurrence event does not have an end date it will calculate end date
  /// from the start date.
  ///
  /// Specify `endDate` to end an event on specific date.
  ///
  /// End date for Repeat Frequency - daily.
  /// Ex. If event start date is 11-11-24 and interval is 5 then new end date
  /// will be 15-11-24.
  ///
  /// End date for Repeat Frequency - weekly
  /// Ex. If event start date is 1-11-24 and interval is 5 then new end date
  /// will be 29-11-24.
  RecurrenceSettings.withCalculatedEndDate({
    required this.startDate,
    DateTime? endDate,
    this.occurrences,
    this.frequency = RepeatFrequency.doNotRepeat,
    this.recurrenceEndOn = RecurrenceEnd.never,
    this.excludeDates,
    List<int>? weekdays,
  }) : weekdays = weekdays ?? [startDate.weekday] {
    this.endDate = endDate ?? _getEndDate(startDate);
  }

  final DateTime startDate;
  late DateTime? endDate;
  final int? occurrences;
  final RepeatFrequency frequency;
  final RecurrenceEnd recurrenceEndOn;
  final List<int> weekdays;
  final List<DateTime>? excludeDates;

  // For recurrence patterns other than weekly, where the event may not repeat
  // on the start date.
  // Excludes one occurrence since the event is already counted
  // for the start date.
  int get _occurrences => (occurrences ?? 1) - 1;

  /// Calculates the end date for a monthly recurring event
  /// based on the start date and the number of occurrences.
  ///
  /// If the next month does not have the event date and the recurrence
  /// is still set to repeat for the given number of occurrences,
  /// it will keep looking for a valid date in the following month.
  ///
  /// Example: If the start date is 29-01-25 and the recurrence ends
  /// after 2 occurrences,
  /// the end date will be 29-03-25 because February does not have a 29th date.
  /// Similarly for 30/31 date as well.
  DateTime get _endDateMonthly {
    var repetition = _occurrences;
    var nextDate = startDate;

    while (repetition > 0) {
      nextDate = DateTime(
        nextDate.year,
        nextDate.month + 1,
        nextDate.day,
      );

      // Adjust the date if the resulting month does not have the same day
      // as the start date
      // Example: DateTime(2024, 10 + 1, 31) gives 2024-12-01
      if (nextDate.day != startDate.day) {
        nextDate = DateTime(
          nextDate.year,
          nextDate.month,
          startDate.day,
        );
      }
      repetition--;
    }
    return nextDate;
  }

  /// Returns the calculated end date for the selected weekdays and occurrences,
  /// or null if the conditions are not met.
  ///
  /// If the weekday of event start date is not in list of selected weekdays
  /// then it will find for the next valid weekdays to repeat on.
  ///
  /// Example: If the start date is 12-11-24 (Tuesday), and the selected
  /// weekdays are [Tuesday, Wednesday] for 3 occurrences,
  /// the event will repeat on 12-11-24, 13-11-24, and 19-11-24.
  ///
  /// Example:  If the start date is 26-11-24 (Tuesday),
  /// if all weeks are selected but the number of occurrences is 1,
  /// the event will only be shown on the start date.
  DateTime? get _endDateWeekly {
    if (weekdays.isEmpty) {
      return null;
    }

    // Contains the recurring weekdays in sorted order
    final sortedWeekdays = weekdays..sort();
    var remainingOccurrences = occurrences ?? 1;
    var currentDate = startDate;

    // Check if the start date is one of the recurring weekdays
    if (sortedWeekdays.contains(startDate.weekday - 1)) {
      remainingOccurrences--;
    }

    while (remainingOccurrences > 0) {
      // Find the next valid weekday
      final nextWeekday = sortedWeekdays.firstWhere(
        (day) => day > currentDate.weekday - 1,
        orElse: () => sortedWeekdays.first,
      );

      // Calculate the days to the next occurrence
      final daysToAdd = (nextWeekday - (currentDate.weekday - 1) + 7) % 7;

      // Move the current date to the next occurrence
      currentDate = currentDate.add(Duration(days: daysToAdd));

      if (daysToAdd == 0 && nextWeekday == sortedWeekdays.first) {
        currentDate = currentDate.add(const Duration(days: 7));
      }
      remainingOccurrences--;
    }
    return currentDate;
  }

  /// Calculate end date for yearly recurring event
  DateTime get _endDateYearly {
    var repetition = _occurrences;
    var nextDate = startDate;

    // If the start date is not 29th Feb, we can directly calculate last year.
    if (startDate.day != 29 && startDate.month != DateTime.february) {
      return DateTime(
        nextDate.year + repetition,
        startDate.month,
        startDate.day,
      );
    }
    // TODO(Shubham): Optimize for larger recurrences if required
    while (repetition > 0) {
      final newDate = DateTime(
        nextDate.year + 1,
        startDate.month,
        startDate.day,
      );

      // If month changes that means that date does not exist in given year
      if (newDate.month != startDate.month) {
        nextDate = DateTime(
          newDate.year,
        );
        continue;
      }
      nextDate = newDate;
      repetition--;
    }
    return nextDate;
  }

  /// Determines the end date for a recurring event based on the
  /// `RepeatFrequency` & `RecurrenceEnd`.
  ///
  /// Returns null if the end date is not applicable.
  /// For example: An event that "does not repeat" and event that "never ends".
  DateTime? _getEndDate(DateTime endDate) {
    if (frequency == RepeatFrequency.doNotRepeat ||
        recurrenceEndOn == RecurrenceEnd.never) {
      return null;
    } else if (recurrenceEndOn == RecurrenceEnd.onDate) {
      return endDate;
    } else if (recurrenceEndOn == RecurrenceEnd.after) {
      return _handleOccurrence(endDate);
    } else {
      return null;
    }
  }

  /// Returns the end date for a recurring event based on the specified
  /// number of occurrences.
  ///
  /// This method requires at least one occurrence to process the recurrence.
  /// The recurrence starts from the event's start date.
  DateTime? _handleOccurrence(DateTime endDate) {
    if ((occurrences ?? 0) < 1) {
      return endDate;
    }
    switch (frequency) {
      case RepeatFrequency.doNotRepeat:
        return null;
      case RepeatFrequency.daily:
        return endDate.add(Duration(days: _occurrences));
      case RepeatFrequency.weekly:
        return _endDateWeekly ?? endDate;
      case RepeatFrequency.monthly:
        return _endDateMonthly;
      case RepeatFrequency.yearly:
        return _endDateYearly;
    }
  }

  @override
  String toString() {
    return 'start date: $startDate, '
        'end date: $endDate, '
        'interval: $occurrences, '
        'frequency: $frequency '
        'weekdays: $weekdays'
        'recurrence Ends on: $recurrenceEndOn'
        'exclude dates: $excludeDates';
  }

  RecurrenceSettings copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? occurrences,
    RepeatFrequency? frequency,
    RecurrenceEnd? recurrenceEndOn,
    List<int>? weekdays,
    List<DateTime>? excludeDates,
  }) {
    return RecurrenceSettings(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      occurrences: occurrences ?? this.occurrences,
      frequency: frequency ?? this.frequency,
      recurrenceEndOn: recurrenceEndOn ?? this.recurrenceEndOn,
      weekdays: weekdays ?? this.weekdays,
      excludeDates: excludeDates ?? this.excludeDates,
    );
  }
}
