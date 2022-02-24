import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../calendar_event.dart';
import '../date_extension.dart';

/// Controller to call functions from argument like [onPageChanged] and [onCellTapped]
class CalendarStateController extends ChangeNotifier {
  CalendarStateController({
    required this.events,
    required this.onPageChangedFromUserArgument,
    required this.onCellTappedFromUserArgument,
  }) {
    this._initialize();
  }

  final List<CalendarEvent> events;

  final Function(DateTime firstDate, DateTime lastDate)?
      onPageChangedFromUserArgument;

  final void Function(DateTime)? onCellTappedFromUserArgument;

  DateTime? currentDateTime;

  void _initialize() {
    currentDateTime = DateTime.now();
    notifyListeners();
  }

  void onPageChanged(int index) {
    currentDateTime = index.visibleDateTime;
    if (onPageChangedFromUserArgument != null) {
      final currentFirstDate = _getFirstDay(currentDateTime!);
      onPageChangedFromUserArgument!(
          currentFirstDate, currentFirstDate.add(Duration(days: 41)));
    }
    notifyListeners();
  }

  DateTime _getFirstDay(DateTime dateTime) {
    final firstDayOfTheMonth = DateTime(dateTime.year, dateTime.month, 1);
    return firstDayOfTheMonth.add(firstDayOfTheMonth.weekday.daysDuration);
  }

  List<CalendarEvent> eventsOnTheDay(DateTime date) {
    final res = events
        .where((event) =>
            event.eventDate.year == date.year &&
            event.eventDate.month == date.month &&
            event.eventDate.day == date.day)
        .toList();
    return res;
  }

  void onCellTapped(DateTime date) {
    if (onCellTappedFromUserArgument != null) {
      onCellTappedFromUserArgument!(date);
    }
  }
}
