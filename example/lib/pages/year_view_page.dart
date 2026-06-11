import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../widgets/month_view_for_year_page.dart';

class YearViewPageDemo extends StatefulWidget {
  const YearViewPageDemo({super.key});

  @override
  State<YearViewPageDemo> createState() => _YearViewPageDemoState();
}

class _YearViewPageDemoState extends State<YearViewPageDemo> {
  final GlobalKey<YearViewState> _yearViewKey = GlobalKey<YearViewState>();
  YearViewDisplayMode _displayMode = YearViewDisplayMode.miniCalendarGrid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Year View'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Toggle display mode',
            icon: Icon(
              _displayMode == YearViewDisplayMode.miniCalendarGrid
                  ? Icons.grid_view
                  : Icons.calendar_month,
            ),
            onPressed: () {
              setState(() {
                _displayMode =
                    _displayMode == YearViewDisplayMode.miniCalendarGrid
                        ? YearViewDisplayMode.titleGrid
                        : YearViewDisplayMode.miniCalendarGrid;
              });
            },
          ),
        ],
      ),
      body: YearView(
        key: _yearViewKey,
        yearViewStyle: YearViewStyle(
          displayMode: _displayMode,
          columnCount: 3,
          initialYear: DateTime.now(),
          minYear: DateTime(2000),
          maxYear: DateTime(2100),
        ),
        yearViewBuilders: YearViewBuilders(
          onMonthTap: (month) {
            context.pushRoute(MonthViewForYearPage(initialMonth: month));
          },
          onDateTap: (events, date) {
            // Navigate to the month that contains the tapped date
            context.pushRoute(
              MonthViewForYearPage(initialMonth: DateTime(date.year, date.month)),
            );
          },
          onPageChange: (date, page) {
            debugPrint('Year changed to: ${date.year}');
          },
        ),
        yearViewThemeSettings: const YearViewThemeSettings(
          currentDateHighlightColor: Colors.blue,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _yearViewKey.currentState?.previousPage(),
              icon: const Icon(Icons.chevron_left),
              label: const Text('Prev'),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  _yearViewKey.currentState?.jumpToYear(DateTime.now().year),
              icon: const Icon(Icons.today),
              label: const Text('Today'),
            ),
            ElevatedButton.icon(
              onPressed: () => _yearViewKey.currentState?.nextPage(),
              icon: const Icon(Icons.chevron_right),
              label: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
