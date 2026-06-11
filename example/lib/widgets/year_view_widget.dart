import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import 'month_view_for_year_page.dart';

class YearViewWidget extends StatefulWidget {
  final double? width;

  const YearViewWidget({super.key, this.width});

  @override
  State<YearViewWidget> createState() => _YearViewWidgetState();
}

class _YearViewWidgetState extends State<YearViewWidget> {
  final GlobalKey<YearViewState> _yearViewKey = GlobalKey<YearViewState>();
  YearViewDisplayMode _displayMode = YearViewDisplayMode.miniCalendarGrid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode toggle bar
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Display mode:'),
              const SizedBox(width: 12),
              SegmentedButton<YearViewDisplayMode>(
                segments: const [
                  ButtonSegment(
                    value: YearViewDisplayMode.miniCalendarGrid,
                    label: Text('Mini Calendar'),
                    icon: Icon(Icons.calendar_view_month),
                  ),
                  ButtonSegment(
                    value: YearViewDisplayMode.titleGrid,
                    label: Text('Title Grid'),
                    icon: Icon(Icons.grid_view),
                  ),
                ],
                selected: {_displayMode},
                onSelectionChanged: (selected) {
                  setState(() => _displayMode = selected.first);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: YearView(
            key: _yearViewKey,
            width: widget.width,
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
                context.pushRoute(
                  MonthViewForYearPage(
                    initialMonth: DateTime(date.year, date.month),
                  ),
                );
              },
              onPageChange: (date, page) {
                debugPrint('YearView → Year: ${date.year}');
              },
            ),
            yearViewThemeSettings: YearViewThemeSettings(
              currentDateHighlightColor: Theme.of(context).colorScheme.primary,
              currentMonthHighlightColor:
                  Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
