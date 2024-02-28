// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:collection';

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

    /// This allows for custom sorting of events.
    /// By default, events are sorted in a start time wise order.
    EventSorter<T>? eventSorter,
  })  : _eventFilter = eventFilter,
        _calendarData = CalendarData(eventSorter: eventSorter);

  //#region Private Fields
  EventFilter<T>? _eventFilter;

  /// Store all calendar event data
  final CalendarData<T> _calendarData;

  //#endregion

  //#region Public Fields

  // TODO: change the type from List<CalendarEventData>
  //  to UnmodifiableListView provided in dart:collection.

  // Note: Do not use this getter inside of EventController class.
  // use _eventList instead.
  /// Returns list of [CalendarEventData<T>] stored in this controller.
  @Deprecated('This is deprecated and will be removed in next major release. '
      'Use allEvents instead.')

  /// Lists all the events that are added in the Controller.
  ///
  /// NOTE: This field is deprecated. use [allEvents] instead.
  List<CalendarEventData<T>> get events =>
      _calendarData.events.toList(growable: false);

  /// Lists all the events that are added in the Controller.
  UnmodifiableListView<CalendarEventData<T>> get allEvents =>
      _calendarData.events;

  /// Defines which events should be displayed on given date.
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
      _calendarData.addEvent(event);
    }
    notifyListeners();
  }

  /// Adds a single event in [_events]
  void add(CalendarEventData<T> event) {
    _calendarData.addEvent(event);
    notifyListeners();
  }

  /// Removes [event] from this controller.
  void remove(CalendarEventData<T> event) {
    _calendarData.removeEvent(event);
    notifyListeners();
  }

  /// Updates the [event] to have the data from [updated] event.
  ///
  /// If [event] is not found in the controller, it will add the [updated]
  /// event in the controller.
  ///
  void update(CalendarEventData<T> event, CalendarEventData<T> updated) {
    _calendarData.updateEvent(event, updated);
    notifyListeners();
  }

  /// Removes all the [events] from this controller.
  void removeAll(List<CalendarEventData<T>> events) {
    for (final event in events) {
      _calendarData.removeEvent(event);
    }
    notifyListeners();
  }

  /// Removes multiple [event] from this controller.
  void removeWhere(TestPredicate<CalendarEventData<T>> test) {
    _calendarData.removeWhere(test);
    notifyListeners();
  }

  /// Returns events on given day.
  ///
  /// To overwrite default behaviour of this function,
  /// provide [eventFilter] argument in [EventController] constructor.
  ///
  /// if [includeFullDayEvents] is true, it will include full day events
  /// as well else, it will exclude full day events.
  ///
  /// NOTE: If [eventFilter] is set i.e, not null, [includeFullDayEvents] will
  /// have no effect. As what events to be included will be decided
  /// by the [eventFilter].
  ///
  /// To get full day events exclusively, check [getFullDayEvent] method.
  ///
  List<CalendarEventData<T>> getEventsOnDay(DateTime date,
      {bool includeFullDayEvents = true}) {
    //ignore: deprecated_member_use_from_same_package
    if (_eventFilter != null) return _eventFilter!.call(date, this.events);

    return _calendarData.getEventsOnDay(date.withoutTime,
        includeFullDayEvents: includeFullDayEvents);
  }

  /// Returns full day events on given day.
  List<CalendarEventData<T>> getFullDayEvent(DateTime date) {
    return _calendarData.getFullDayEvent(date.withoutTime);
  }

  /// Updates the [eventFilter].
  ///
  /// This will also refresh the UI to reflect the latest event filter.
  void updateFilter({required EventFilter<T> newFilter}) {
    if (newFilter != _eventFilter) {
      _eventFilter = newFilter;
      notifyListeners();
    }
  }
  //#endregion
}

/// Stores the list of the calendar events.
///
/// Provides basic data structure to store the events.
///
/// Exposes methods to manipulate stored data.
///
///
class CalendarData<T extends Object?> {
  /// Creates a new instance of [CalendarData].
  CalendarData({
    EventSorter<T>? eventSorter,
  }) : _eventSorter = eventSorter;

  //#region Private Fields
  final EventSorter<T>? _eventSorter;

  /// Stores all the events in a list(all the items in below 3 list will be
  /// available in this list as global itemList of all events).
  final _eventList = <CalendarEventData<T>>[];

  UnmodifiableListView<CalendarEventData<T>> get events =>
      UnmodifiableListView(_eventList);

  /// Stores events that occurs only once in a map, Here the key will a day
  /// and along to the day as key we will store all the events of that day as
  /// list as value
  final _singleDayEvents = <DateTime, List<CalendarEventData<T>>>{};

  UnmodifiableMapView<DateTime, UnmodifiableListView<CalendarEventData<T>>>
      get singleDayEvents => UnmodifiableMapView(
            Map.fromIterable(
              _singleDayEvents.keys.map((key) {
                return MapEntry(
                    key,
                    UnmodifiableListView(
                      _singleDayEvents[key] ?? [],
                    ));
              }),
            ),
          );

  /// Stores all the ranging events in a list
  ///
  /// Events that occurs on multiple day from startDate to endDate.
  ///
  final _rangingEventList = <CalendarEventData<T>>[];
  UnmodifiableListView<CalendarEventData<T>> get rangingEventList =>
      UnmodifiableListView(_rangingEventList);

  /// Stores all full day events(24hr event).
  ///
  /// This includes all full day events that are recurring day events as well.
  ///
  ///
  final _fullDayEventList = <CalendarEventData<T>>[];
  UnmodifiableListView<CalendarEventData<T>> get fullDayEventList =>
      UnmodifiableListView(_fullDayEventList);

  //#region Data Manipulation Methods
  void addFullDayEvent(CalendarEventData<T> event) {
    // TODO: add separate logic for adding full day event and ranging event.
    _fullDayEventList.addEventInSortedManner(event, _eventSorter);
    _eventList.add(event);
  }

  void addRangingEvent(CalendarEventData<T> event) {
    _rangingEventList.addEventInSortedManner(event, _eventSorter);
    _eventList.add(event);
  }

  void addSingleDayEvent(CalendarEventData<T> event) {
    final date = event.date;

    if (_singleDayEvents[date] == null) {
      _singleDayEvents.addAll({
        date: [event],
      });
    } else {
      _singleDayEvents[date]!.addEventInSortedManner(event, _eventSorter);
    }

    _eventList.add(event);
  }

  void addEvent(CalendarEventData<T> event) {
    assert(event.endDate.difference(event.date).inDays >= 0,
        'The end date must be greater or equal to the start date');

    // TODO: improve this...
    if (_eventList.contains(event)) return;

    if (event.isFullDayEvent) {
      addFullDayEvent(event);
    } else if (event.isRangingEvent) {
      addRangingEvent(event);
    } else {
      addSingleDayEvent(event);
    }
  }

  void removeFullDayEvent(CalendarEventData<T> event) {
    if (_fullDayEventList.remove(event)) {
      _eventList.remove(event);
    }
  }

  void removeRangingEvent(CalendarEventData<T> event) {
    if (_rangingEventList.remove(event)) {
      _eventList.remove(event);
    }
  }

  void removeSingleDayEvent(CalendarEventData<T> event) {
    if (_singleDayEvents[event.date]?.remove(event) ?? false) {
      _eventList.remove(event);
    }
  }

  void removeEvent(CalendarEventData<T> event) {
    if (event.isFullDayEvent) {
      removeFullDayEvent(event);
    } else if (event.isRangingEvent) {
      removeRangingEvent(event);
    } else {
      removeSingleDayEvent(event);
    }
  }

  void removeWhere(TestPredicate<CalendarEventData<T>> test) {
    final _predicates = <CalendarEventData<T>, bool>{};

    bool wrappedPredicate(CalendarEventData<T> event) {
      return _predicates[event] = test(event);
    }

    for (final e in _singleDayEvents.values) {
      e.removeWhere(wrappedPredicate);
    }

    _rangingEventList.removeWhere(wrappedPredicate);
    _fullDayEventList.removeWhere(wrappedPredicate);

    _eventList.removeWhere((event) => _predicates[event] ?? false);
  }

  void updateEvent(
      CalendarEventData<T> oldEvent, CalendarEventData<T> newEvent) {
    removeEvent(oldEvent);
    addEvent(newEvent);
  }
  //#endregion

  //#region Data Fetch Methods
  List<CalendarEventData<T>> getEventsOnDay(DateTime date,
      {bool includeFullDayEvents = true}) {
    final events = <CalendarEventData<T>>[];

    if (_singleDayEvents[date] != null) {
      events.addAll(_singleDayEvents[date]!);
    }

    for (final rangingEvent in _rangingEventList) {
      if (rangingEvent.occursOnDate(date)) {
        events.add(rangingEvent);
      }
    }

    if (includeFullDayEvents) {
      events.addAll(getFullDayEvent(date));
    }

    return events;
  }

  /// Returns full day events on given day.
  List<CalendarEventData<T>> getFullDayEvent(DateTime date) {
    final events = <CalendarEventData<T>>[];

    for (final event in fullDayEventList) {
      if (event.occursOnDate(date)) {
        events.add(event);
      }
    }
    return events;
  }
  //#endregion
}
