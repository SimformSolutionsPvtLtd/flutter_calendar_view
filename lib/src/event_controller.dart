// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/material.dart';

import '../calendar_view.dart';

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
  /// Deletes a recurring event based on the specified deletion type.
  ///
  /// This method handles the deletion of recurring events by determining the
  /// type of deletion
  /// requested (all events, the current event, or following events) and
  /// performing the appropriate action.
  ///
  /// Takes the following parameters:
  /// - [date]: The date of the event to be deleted.
  /// - [event]: The event data to be deleted.
  /// - [deleteEventType]: The `DeleteEventType` of deletion to perform
  /// (all events, the current event, or following events).
  ///
  /// The method performs the following actions based on the [deleteEventType]:
  /// - [DeleteEvent.all]: Removes the entire series of events.
  /// - [DeleteEvent.current]: Deletes only the current event.
  /// - [DeleteEvent.following]: Deletes the current event and
  /// all subsequent events.
  void deleteRecurrenceEvent({
    required DateTime date,
    required CalendarEventData<T> event,
    required DeleteEvent deleteEventType,
  }) {
    switch (deleteEventType) {
      case DeleteEvent.all:
        remove(event);
        break;
      case DeleteEvent.current:
        _deleteCurrentEvent(date, event);
        break;
      case DeleteEvent.following:
        _deleteFollowingEvents(date, event);
        break;
    }
  }

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

  void clear() {
    _calendarData.clear();

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

  /// Returns repeated events on given date.
  List<CalendarEventData<T>> getRecurringEventsOnDay(DateTime date) =>
      _calendarData.getRecurringEventsOnDay(date);

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

//#region Private Methods
  void _deleteCurrentEvent(DateTime date, CalendarEventData<T> event) {
    final excludeDates = event.recurrenceSettings?.excludeDates ?? []
      ..add(date);
    final updatedRecurrenceSettings =
        event.recurrenceSettings?.copyWith(excludeDates: excludeDates);
    final updatedEvent =
        event.copyWith(recurrenceSettings: updatedRecurrenceSettings);
    update(event, updatedEvent);
  }

  /// If the selected date to delete the event is the same as the event's start date, delete all recurrences.
  /// Otherwise, delete the event on the selected date and all subsequent recurrences.
  void _deleteFollowingEvents(DateTime date, CalendarEventData<T> event) {
    final newEndDate = date.subtract(
      const Duration(days: 1),
    );
    final updatedRecurrenceSettings = event.recurrenceSettings?.copyWith(
      endDate: newEndDate,
    );
    if (date == event.date) {
      remove(event);
    } else {
      final updatedEvent =
          event.copyWith(recurrenceSettings: updatedRecurrenceSettings);
      update(event, updatedEvent);
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

  /// Stores all recurring events
  final _recurringEventsList = <CalendarEventData<T>>[];
  //#endregion

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

    if (event.isRecurringEvent) {
      _eventList.add(event);
      _recurringEventsList.add(event);
      return;
    }

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
    if (event.isRecurringEvent) {
      _eventList.remove(event);
      _recurringEventsList.remove(event);
      return;
    }

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

  //#region Helper Methods
  // Event is not recurring. So, no need to handle recurrence.
  // This method checks for the event whether it should exclude
  // or not on given date.
  // Event is excluded:
  // - If given date is of before event start date
  // - If given date is after recurrence end date
  // - If given date is in excluded list of events.
  // On returning true it excludes event and on false it won't exclude.
  bool _isExcluded(RecurrenceSettings settings, DateTime date) {
    final recurrenceEndDate = settings.endDate;
    return (recurrenceEndDate != null && date.isAfter(recurrenceEndDate)) ||
        (settings.excludeDates?.contains(date) ?? false);
  }

  /// Determines whether the given date should be included as a recurring event
  /// for daily recurrence settings.
  ///
  /// Returns `true` if the event should repeat on the given `currentDate`,
  /// otherwise returns `false`.
  /// `endDate` may change, such as when handling deletions or updates.
  ///
  /// - If `recurrenceEndDate` is not specified, the event repeats indefinitely
  ///   and this method returns `true`.
  /// - If `recurrenceEndDate` is specified:
  ///   - The event is included if the `currentDate` is before
  ///   the `recurrenceEndDate`.
  ///   - The event is also included on the exact `recurrenceEndDate`
  ///     (checked using `isAtSameMomentAs`), allowing the event to occur
  ///     on the last day.
  bool _isDailyRecurrence({
    required DateTime currentDate,
    required RecurrenceSettings recurrenceSettings,
  }) {
    final recurrenceEndDate = recurrenceSettings.endDate;
    return recurrenceEndDate == null ||
        (currentDate.isBefore(recurrenceEndDate) ||
            currentDate.isAtSameMomentAs(recurrenceEndDate));
  }

  /// If the weekday matches with `recurrenceSettings` and there is no end date,
  /// the recurrence is infinite
  ///
  ///
  /// If the weekday matches and there is an end date, check if the current date
  /// is before or on the end date
  /// This ensures the recurrence continues until the specified end date
  ///
  /// Recurrence endDate may change if event is deleted.
  bool _isWeeklyRecurrence({
    required DateTime currentDate,
    required RecurrenceSettings recurrenceSettings,
  }) {
    // Adjust weekday to zero-based indexing and
    // check if date’s weekday is in the recurrence weekdays
    final isMatchingWeekday =
        recurrenceSettings.weekdays.contains(currentDate.weekday - 1);
    final recurrenceEndDate = recurrenceSettings.endDate;

    if (!isMatchingWeekday) {
      return false;
    }

    // If no end date is specified, repeat infinitely
    return recurrenceEndDate == null ||
        (currentDate.isBefore(recurrenceEndDate) ||
            currentDate.isAtSameMomentAs(recurrenceEndDate));
  }

  // Repeat event on same day
  // Returns true if event should repeat on the given date otherwise false.
  // For monthly repetition of event event start date & given date should match.
  // repetition will include the recurrence end date.
  bool _isMonthlyRecurrence({
    required DateTime currentDate,
    required DateTime startDate,
    required RecurrenceSettings recurrenceSettings,
  }) {
    // Exclude if day is different
    if (currentDate.day != startDate.day) {
      return false;
    }

    // Continues if day is same
    final recurrenceEndDate = recurrenceSettings.endDate;

    return recurrenceEndDate == null ||
        (currentDate.isBefore(recurrenceEndDate) ||
            currentDate.isAtSameMomentAs(recurrenceEndDate));
  }

  // If end date is not mentioned repeat infinitely
  // If end date is mentioned repeat till end date including last date
  // End date will change in case of "Following events" are deleted
  bool _isYearlyRecurrence({
    required DateTime currentDate,
    required DateTime startDate,
    required RecurrenceSettings recurrenceSettings,
  }) {
    if (currentDate.month != startDate.month ||
        currentDate.day != startDate.day) {
      return false;
    }

    final recurrenceEndDate = recurrenceSettings.endDate;
    return recurrenceEndDate == null ||
        (currentDate.isBefore(recurrenceEndDate) ||
            currentDate.isAtSameMomentAs(recurrenceEndDate));
  }

  bool _handleRecurrence({
    required DateTime currentDate,
    required DateTime eventStartDate,
    required DateTime eventEndDate,
    required RecurrenceSettings recurrenceSettings,
  }) {
    switch (recurrenceSettings.frequency) {
      case RepeatFrequency.doNotRepeat:
        return currentDate.isAtSameMomentAs(eventStartDate);
      case RepeatFrequency.daily:
        return _isDailyRecurrence(
          currentDate: currentDate,
          recurrenceSettings: recurrenceSettings,
        );
      case RepeatFrequency.weekly:
        return _isWeeklyRecurrence(
          currentDate: currentDate,
          recurrenceSettings: recurrenceSettings,
        );
      case RepeatFrequency.monthly:
        return _isMonthlyRecurrence(
          currentDate: currentDate,
          startDate: eventStartDate,
          recurrenceSettings: recurrenceSettings,
        );
      case RepeatFrequency.yearly:
        return _isYearlyRecurrence(
            currentDate: currentDate,
            startDate: eventStartDate,
            recurrenceSettings: recurrenceSettings);
    }
  }

  //#endregion

  //#region Data Fetch Methods
  List<CalendarEventData<T>> getEventsOnDay(DateTime date,
      {bool includeFullDayEvents = true}) {
    final events = <CalendarEventData<T>>[];

    if (_singleDayEvents[date] != null) {
      events.addAll(_singleDayEvents[date]!);
    }

    // TODO(Shubham): Add recurrence support for ranging events
    for (final rangingEvent in _rangingEventList) {
      if (rangingEvent.occursOnDate(date)) {
        events.add(rangingEvent);
      }
    }

    if (includeFullDayEvents) {
      events.addAll(getFullDayEvent(date));
    }

    // Add single day recurring events
    final recurringEvents = getRecurringEventsOnDay(date)
        .where((event) => (!event.isFullDayEvent && !event.isRangingEvent))
        .toList();
    events.addAll(recurringEvents);
    return events;
  }

  /// Returns repeated events on given date.
  List<CalendarEventData<T>> getRecurringEventsOnDay(DateTime date) {
    final events = <CalendarEventData<T>>[];

    //  Iterate through all repeated events and skips
    //  if the given date is before start date of repeating event
    //  or if the date is in excluded list of dates.
    //  We do not need to handle Recurrence for it.
    for (final event in _recurringEventsList) {
      // recurrenceSettings is force casted because events in
      // _recurringEventsList are added only if recurrenceSettings exists
      final recurrenceSettings = event.recurrenceSettings!;

      if (date.isBefore(event.date) || _isExcluded(recurrenceSettings, date)) {
        continue;
      }

      final isRecurrence = _handleRecurrence(
        currentDate: date,
        eventStartDate: event.date,
        eventEndDate: event.endDate,
        recurrenceSettings: recurrenceSettings,
      );

      if (isRecurrence) {
        events.add(event);
      }
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

    // Add full day recurring event
    final recurringEvents = getRecurringEventsOnDay(date)
        .where((event) => event.isFullDayEvent)
        .toList();
    events.addAll(recurringEvents);
    return events;
  }

  /// Remove all events from the controller.
  void clear() {
    _fullDayEventList.clear();
    _rangingEventList.clear();
    _singleDayEvents.clear();
    _eventList.clear();
    _recurringEventsList.clear();
  }
  //#endregion
}
