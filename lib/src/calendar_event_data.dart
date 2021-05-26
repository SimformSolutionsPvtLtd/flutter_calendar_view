import 'package:flutter/cupertino.dart';

import 'extensions.dart';

/// Stores all the events on [date]
@immutable
class CalendarEventData<T> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// List of events on [CalendarEventData.date].
  final T event;

  /// Stores all the events on [date]
  CalendarEventData({
    @required this.date,
    @required this.event,
  });

  @override
  String toString() {
    return <String, dynamic>{
      "date": date,
      "events": event,
    }.toString();
  }

  @override
  bool operator ==(Object other) {
    if (this.runtimeType != other.runtimeType) return false;
    CalendarEventData<T> obj = other;
    return this.date.compareWithoutTime(obj.date) && this.event == obj.event;
  }

  @override
  int get hashCode => super.hashCode;
}
