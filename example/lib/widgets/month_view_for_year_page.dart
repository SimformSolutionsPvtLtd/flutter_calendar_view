import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../pages/create_event_page.dart';
import '../extension.dart';

/// A dedicated page that opens [MonthView] pre-scrolled to [initialMonth].
/// Pushed from [YearViewPageDemo] or [YearViewWidget] when a month is tapped.
class MonthViewForYearPage extends StatefulWidget {
  final DateTime initialMonth;

  const MonthViewForYearPage({super.key, required this.initialMonth});

  @override
  State<MonthViewForYearPage> createState() => _MonthViewForYearPageState();
}

class _MonthViewForYearPageState extends State<MonthViewForYearPage> {
  final GlobalKey<MonthViewState> _monthViewKey = GlobalKey<MonthViewState>();
  late DateTime _selectedDate;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialMonth;
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel =
        '${_monthNames[widget.initialMonth.month - 1]} ${widget.initialMonth.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(monthLabel),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add event',
            onPressed: () => context.pushRoute(CreateEventPage()),
          ),
        ],
      ),
      body: MonthView(
        key: _monthViewKey,
        selectedDate: _selectedDate,
        monthViewStyle: MonthViewStyle(
          initialMonth: widget.initialMonth,
          minMonth: DateTime(widget.initialMonth.year - 1),
          maxMonth: DateTime(widget.initialMonth.year + 1),
          useAvailableVerticalSpace: true,
          hideDaysNotInMonth: true,
        ),
        monthViewThemeSettings: MonthViewThemeSettings(
          cellsInMonthHighlightColor: Theme.of(context).colorScheme.primary,
          selectedHighlightColor: Theme.of(context).colorScheme.secondary,
        ),
        monthViewBuilders: MonthViewBuilders(
          onCellTap: (events, date) {
            setState(() => _selectedDate = date);
            context.showSnackBarWithText(
              'Tapped: ${date.day} ${_monthNames[date.month - 1]} ${date.year}'
              '${events.isNotEmpty ? ' · ${events.length} event(s)' : ''}',
            );
          },
          onEventTap: (event, date) {
            context.showSnackBarWithText('Event: ${event.title}');
          },
        ),
      ),
    );
  }
}
