// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'calendar_event_data.dart';
import 'extensions.dart';
import 'typedefs.dart';

class EventController<T extends Object?> extends ChangeNotifier {
  /// Calendar controller to control all the events related operations like,
  /// adding event, removing event, etc.
  EventController({
    /// This method will provide list of events on particular date.
    ///
    /// This method is use full when you have recurring events.
    /// As of now this library does not support recurring events.
    /// You can implement same behaviour in this function.
    /// This function will overwrite default behaviour of [getEventsOnDay]
    /// function which will be used to display events on given day in
    /// [MonthView], [DayView] and [WeekView].
    ///
    EventFilter<T>? eventFilter,
  }) : _eventFilter = eventFilter;

  //#region Private Fields
  EventFilter<T>? _eventFilter;

  // Stores events that occurs only once in a map.
  final _events = <DateTime, List<CalendarEventData<T>>>{};

  // Stores all the events in a list.
  final _eventList = <CalendarEventData<T>>[];

  // Stores all the ranging events in a list.
  final _rangingEventList = <CalendarEventData<T>>[];

  //#endregion

  //#region Public Fields
  /// Returns list of [CalendarEventData<T>] stored in this controller.
  List<CalendarEventData<T>> get events => _eventList.toList(growable: false);

  /// This method will provide list of events on particular date.
  ///
  /// This method is use full when you have recurring events.
  /// As of now this library does not support recurring events.
  /// You can implement same behaviour in this function.
  /// This function will overwrite default behaviour of [getEventsOnDay]
  /// function which will be used to display events on given day in
  /// [MonthView], [DayView] and [WeekView].
  ///
  EventFilter<T>? get eventFilter => _eventFilter;

  //#endregion

  //#region Public Methods
  /// Add all the events in the list
  /// If there is an event with same date then
  void addAll(List<CalendarEventData<T>> events) {
    for (final event in events) {
      _addEvent(event);
    }

    notifyListeners();
  }

  /// Adds a single event in [_events]
  void add(CalendarEventData<T> event) {
    _addEvent(event);

    notifyListeners();
  }

  /// Removes [event] from this controller.
  void remove(CalendarEventData<T> event) {
    final date = event.date.withoutTime;

    // Removes the event from single event map.
    if (_events[date] != null) {
      _events[date]?.remove(event);
      _eventList.remove(event);
      notifyListeners();
      return;
    }

    // Removes the event from ranging event.
    for (final e in _rangingEventList) {
      if (e == event) {
        _rangingEventList.remove(event);
        _eventList.remove(event);
        notifyListeners();
        return;
      }
    }
  }

  /// Returns events on given day.
  ///
  /// To overwrite default behaviour of this function,
  /// provide [_eventFilter] argument in [EventController] constructor.
  List<CalendarEventData<T>> getEventsOnDay(DateTime date) {
    if (_eventFilter != null) return _eventFilter!.call(date, this.events);

    final events = <CalendarEventData<T>>[];

    if (_events[date] != null) {
      events.addAll(_events[date]!);
    }

    final daysFromRange = <DateTime>[];
    for (final rangingEvent in _rangingEventList) {
      for (var i = 0;
          i <= rangingEvent.endDate.difference(rangingEvent.date).inDays;
          i++) {
        daysFromRange.add(rangingEvent.date.add(Duration(days: i)));
      }
      if (rangingEvent.date.isBefore(rangingEvent.endDate)) {
        for (final eventDay in daysFromRange) {
          if (eventDay.year == date.year &&
              eventDay.month == date.month &&
              eventDay.day == date.day) {
            events.add(rangingEvent);
          }
        }
      }
    }

    return events;
  }

  void updateFilter({required EventFilter<T> newFilter}) {
    if (newFilter != _eventFilter) {
      _eventFilter = newFilter;
      notifyListeners();
    }
  }

  //#endregion

  //#region Private Methods
  void _addEvent(CalendarEventData<T> event) {
    assert(event.endDate.difference(event.date).inDays >= 0,
        'The end date must be greater or equal to the start date');

    if (event.endDate.difference(event.date).inDays > 0) {
      _rangingEventList.add(event);
    } else {
      final date = event.date.withoutTime;

      if (_events[date] == null) {
        _events.addAll({
          date: [event],
        });
      } else {
        _events[date]!.add(event);
      }
    }

    _eventList.add(event);

    notifyListeners();
  }

  //#endregion
}
