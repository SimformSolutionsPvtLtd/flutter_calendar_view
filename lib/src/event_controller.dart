import 'package:flutter/material.dart';

import 'calendar_event_data.dart';

class EventController<T> extends ChangeNotifier {
  /// Calendar controller to control all the events related operations like, adding event, removing event, etc.
  EventController();

  List<_YearEvent<T>> _events = [];

  List<CalendarEventData<T>> get events {
    List<CalendarEventData<T>> totalEvents = [];

    for (int i = 0; i < _events.length; i++) {
      totalEvents.addAll(_events[i].getAllEvents());
    }

    return totalEvents;
  }

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
    if (event.startTime != null &&
        event.endTime != null &&
        event.startTime!.isAfter(event.endTime!)) {
      throw "Start time should not exceed end time.";
    }

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
        _events[i].addEvent(event);
        return;
      }
    }

    _YearEvent<T> newEvent = _YearEvent(year: event.date.year);
    newEvent.addEvent(event);
    _events.add(newEvent);
  }

  /// Returns event on given day
  List<CalendarEventData<T>> getEventsOnDay(DateTime date) {
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

  void addEvent(CalendarEventData<T> event) {
    for (int i = 0; i < _months.length; i++) {
      if (_months[i].month == event.date.month) {
        _months[i].addEvent(event);
        return;
      }
    }
    _MonthEvent<T> newEvent = _MonthEvent(month: event.date.month);
    newEvent.addEvent(event);
    _months.add(newEvent);
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

  void addEvent(CalendarEventData<T> event) {
    if (!_events.contains(event)) {
      _events.add(event);
    }
  }

  void removeEvent(CalendarEventData<T> event) {
    for (var e in _events) {
      if (e == event) {
        _events.remove(e);
      }
    }
  }
}
