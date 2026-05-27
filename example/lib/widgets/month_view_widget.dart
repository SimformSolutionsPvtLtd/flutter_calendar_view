import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

class MonthViewWidget extends StatefulWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({super.key, this.state, this.width});

  @override
  State<MonthViewWidget> createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<MonthViewWidget> {
  DateTime? _multiSelectionStartDate;
  Set<DateTime> _multiSelectedDateRange = <DateTime>{};

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    return Stack(
      children: [
        MonthView(
          key: widget.state,
          width: widget.width,
          multiDateSelectionRange: _multiSelectedDateRange,
          multiDateSelectionColor: Colors.blue.withValues(alpha: 0.1),
          monthViewThemeSettings: MonthViewThemeSettings(
            cellsInMonthHighlightColor: Colors.blue,
          ),
          monthViewStyle: MonthViewStyle(
            startDay: WeekDays.friday,
            useAvailableVerticalSpace: true,
            hideDaysNotInMonth: true,
            // Define the range of months to display
            maxMonth: DateTime(2027, 12, 31),
            minMonth: DateTime(2020, 1, 1),
            pagePhysics: NeverScrollableScrollPhysics(),
          ),
          monthViewBuilders: MonthViewBuilders(
            //When user tries to scroll beyond the max month or min month
            // these callbacks will be triggered.
            onHasReachedEnd: (date, page) {
              context.showSnackBarWithText(translate.reachedTheEndPage);
            },
            onHasReachedStart: (date, page) {
              context.showSnackBarWithText(translate.reachedTheStartPage);
            },
            onDateLongPress: (date) {
              _multiSelectionStartDate = _normalizeDate(date);
              _setSelectedRange(
                _multiSelectionStartDate!,
                _multiSelectionStartDate!,
              );
              context.showSnackBarWithText(
                "Multiple dates selection started: " +
                    date.dateToStringWithFormat(format: 'y-MM-dd'),
              );
            },
            onDateLongPressMoveUpdate: (date, details) {
              final startDate = _multiSelectionStartDate;
              if (startDate == null) return;
              _setSelectedRange(startDate, _normalizeDate(date));
            },
            onCellTap: (events, date) {
              final normalizedDate = _normalizeDate(date);
              if (_multiSelectedDateRange.isNotEmpty) {
                if (_multiSelectedDateRange.contains(normalizedDate)) {
                  context.showSnackBarWithText(
                    '${_multiSelectedDateRange.length} date${_multiSelectedDateRange.length == 1 ? '' : 's'} selected',
                  );
                } else {
                  // Tapping any non-selected date clears the selection.
                  setState(() {
                    _multiSelectionStartDate = null;
                    _multiSelectedDateRange = <DateTime>{};
                  });
                }
                return;
              }
              context.showSnackBarWithText(
                "Tapped " + date.dateToStringWithFormat(format: 'y-MM-dd'),
              );
            },
            onEventTap: (event, date) {
              // If a selection is active, any event tap clears it instead of
              // opening the event.
              if (_multiSelectedDateRange.isNotEmpty) {
                setState(() {
                  _multiSelectionStartDate = null;
                  _multiSelectedDateRange = <DateTime>{};
                });
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailsPage(event: event, date: date),
                ),
              );
            },
            onEventLongTap: (event, date) =>
                context.showSnackBarWithText("on LongTap"),
          ),
        ),
        // Cancel button - rolls out from right center
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          right: _multiSelectedDateRange.isNotEmpty ? 10 : -80,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton.small(
              heroTag: 'clear_selection',
              onPressed: _clearSelection,
              child: Icon(Icons.close, color: context.appColors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  void _setSelectedRange(DateTime start, DateTime end) {
    final range = <DateTime>{};
    final first = start.isBefore(end) ? start : end;
    final last = start.isBefore(end) ? end : start;

    for (
      var date = first;
      !date.isAfter(last);
      date = date.add(const Duration(days: 1))
    ) {
      range.add(_normalizeDate(date));
    }

    if (setEquals(range, _multiSelectedDateRange)) return;

    setState(() {
      _multiSelectedDateRange = range;
    });
  }

  /// Clears all selected dates and resets the selection state
  void _clearSelection() {
    setState(() {
      _multiSelectionStartDate = null;
      _multiSelectedDateRange = <DateTime>{};
    });
  }
}
