// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import 'calendar_event_data.dart';

class EventController<T> extends ChangeNotifier {
  /// This method will provide list of events on particular date.
  ///
  /// This method is use full when you have recurring events.
  /// As of now this library does not support recurring events.
  /// You can implement same behaviour in this function.
  /// This function will overwrite default behaviour of [getEventsOnDay] function
  /// which will be used to display events on given day in [MonthView], [DayView] and [WeekView].
  ///
  final EventFilter<T>? eventFilter;

  /// Calendar controller to control all the events related operations like, adding event, removing event, etc.
  EventController({
    this.eventFilter,
  });

  List<_YearEvent<T>> _events = [];

  List<CalendarEventData<T>> _eventList = [];

  /// Returns list of [CalendarEventData<T>] stored in this controller.
  List<CalendarEventData<T>> get events => _eventList.toList(growable: false);

  /// Add all the events in the list
  /// If there is an event with same date then
  void addAll(List<CalendarEventData<T>> events) {
    for (CalendarEventData<T> event in events) {
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
    for (var e in _events) {
      if (e.year == event.date.year) {
        e.removeEvent(event);
        notifyListeners();
        break;
      }
    }
  }

  void _addEvent(CalendarEventData<T> event) {
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].year == event.date.year) {
        if (_events[i].addEvent(event)) {
          _eventList.add(event);
        }
        return;
      }
    }

    _YearEvent<T> newEvent = _YearEvent(year: event.date.year);
    if (newEvent.addEvent(event)) {
      _events.add(newEvent);
      _eventList.add(event);
    }
  }

  /// Returns events on given day.
  ///
  /// To overwrite default behaviour of this function,
  /// provide [eventFilter] argument in [EventController] constructor.
  List<CalendarEventData<T>> getEventsOnDay(DateTime date) {
    if (eventFilter != null) return eventFilter!.call(date, this.events);

    List<CalendarEventData<T>> events = [];

    // Iterate through all year events
    for (int i = 0; i < _events.length; i++) {
      // If year is matched.
      if (_events[i].year == date.year) {
        // Get list of months in year
        List<_MonthEvent<T>> monthEvents = _events[i]._months;

        // Iterate through all months
        for (int j = 0; j < monthEvents.length; j++) {
          // If month is matched
          if (monthEvents[j].month == date.month) {
            // Get list of events in month
            List<CalendarEventData<T>> calendarEvents = monthEvents[j]._events;

            // Iterate through all events
            for (int k = 0; k < calendarEvents.length; k++) {
              // If day of event is matched
              if (calendarEvents[k].date.day == date.day)
                // return event
                events.add(calendarEvents[k]);
            }
          }
        }
      }
    }

    return events;
  }
}

class _YearEvent<T> {
  int year;
  List<_MonthEvent<T>> _months = [];

  List<_MonthEvent<T>> get months => _months.toList(growable: false);

  _YearEvent({required this.year});

  int hasMonth(int month) {
    for (int i = 0; i < _months.length; i++) {
      if (_months[i].month == month) return i;
    }
    return -1;
  }

  bool addEvent(CalendarEventData<T> event) {
    for (int i = 0; i < _months.length; i++) {
      if (_months[i].month == event.date.month) {
        return _months[i].addEvent(event);
      }
    }
    _MonthEvent<T> newEvent = _MonthEvent(month: event.date.month);
    newEvent.addEvent(event);
    _months.add(newEvent);
    return true;
  }

  List<CalendarEventData<T>> getAllEvents() {
    List<CalendarEventData<T>> totalEvents = [];
    for (int i = 0; i < _months.length; i++) {
      totalEvents.addAll(_months[i].events);
    }
    return totalEvents;
  }

  void removeEvent(CalendarEventData<T> event) {
    for (var e in _months) {
      if (e.month == event.date.month) {
        e.removeEvent(event);
      }
    }
  }
}

class _MonthEvent<T> {
  int month;
  List<CalendarEventData<T>> _events = [];

  List<CalendarEventData<T>> get events => _events.toList(growable: false);

  _MonthEvent({required this.month});

  int hasDay(int day) {
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].date.day == day) return i;
    }
    return -1;
  }

  bool addEvent(CalendarEventData<T> event) {
    if (!_events.contains(event)) {
      _events.add(event);
      return true;
    }
    return false;
  }

  void removeEvent(CalendarEventData<T> event) {
    for (var e in _events) {
      if (e == event) {
        _events.remove(e);
      }
    }
  }
}
