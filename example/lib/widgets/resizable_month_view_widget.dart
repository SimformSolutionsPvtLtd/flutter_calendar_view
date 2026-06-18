import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

import '../pages/event_details_page.dart';

/// Example widget showcasing [ResizableMonthView].
///
/// Demonstrates:
/// * All three display modes (Full, Compact, Minimal) via the built-in
///   mode-toggle pill in the header.
/// * Custom theme colours – a deep-purple/indigo accent matching the
///   existing example-app palette.
/// * Tapping a cell navigates to the event details page.
/// * A floating "create event" FAB is injected by the parent page.
class ResizableMonthViewWidget extends StatefulWidget {
  final GlobalKey<ResizableMonthViewState>? state;
  final double? width;

  const ResizableMonthViewWidget({super.key, this.state, this.width});

  @override
  State<ResizableMonthViewWidget> createState() =>
      _ResizableMonthViewWidgetState();
}

class _ResizableMonthViewWidgetState extends State<ResizableMonthViewWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().withoutTime;
  }

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;

    return ResizableMonthView(
      key: widget.state,
      style: ResizableMonthViewStyle(
        // ── Resizable-specific ──────────────────────────────────────
        initialMode: ResizableMonthViewMode.monthly,
        showModeToggle: true,
        enableDragToSwitchMode: true,
        modeToggleActiveColor: Colors.deepPurple,
        modeToggleTextColor: Colors.white,
        modeToggleBorderRadius: 18,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOutCubic,
        eventListPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        eventListSeparatorHeight: 6,
        // ── Shared month-view settings ──────────────────────────────
        showBorder: true,
        hideDaysNotInMonth: false,
        cellAspectRatio: 1.0,
        startDay: WeekDays.monday,
        minMonth: DateTime(2020, 1, 1),
        maxMonth: DateTime(2027, 12, 31),
      ),
      themeSettings: ResizableMonthViewThemeSettings(
        // Highlight today's cell
        cellsInMonthHighlightColor: Colors.indigo,
        cellsInMonthHighlightedTitleColor: Colors.white,
        // Selected date gets a deep-purple circle
        selectedHighlightColor: Colors.deepPurple,
        selectedTitleColor: Colors.white,
        selectedHighlightRadius: 12,
        // Cells outside the current month are faded
        cellsNotInMonthHighlightedTitleColor: Colors.white,
      ),
      builders: ResizableMonthViewBuilders(
        // ── Navigation boundary feedback ───────────────────────────
        onHasReachedEnd: (date, page) {
          context.showSnackBarWithText(translate.reachedTheEndPage);
        },
        onHasReachedStart: (date, page) {
          context.showSnackBarWithText(translate.reachedTheStartPage);
        },
        // ── Mode change feedback ────────────────────────────────────
        onModeChanged: (mode) {
          final label = switch (mode) {
            ResizableMonthViewMode.monthly => 'Monthly',
            ResizableMonthViewMode.biWeekly => 'Bi-weekly',
            ResizableMonthViewMode.weekly => 'Weekly',
            ResizableMonthViewMode.monthlyScrollable => 'Monthly Scrollable',
          };
          context.showSnackBarWithText('Mode: $label');
        },
        // ── Cell tap → update selection ─────────────────────────────
        onCellTap: (events, date) {
          setState(() => _selectedDate = date.withoutTime);
          context.showSnackBarWithText(
            'Tapped ${date.dateToStringWithFormat(format: 'y-MM-dd')}',
          );
        },
        // ── Event tap → open event details ──────────────────────────
        onEventTap: (event, date) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailsPage(event: event, date: date),
            ),
          );
        },
        onEventLongTap: (event, date) =>
            context.showSnackBarWithText('Long tapped: ${event.title}'),
        // ── Custom event list item ──────────────────────────────────
        eventListItemBuilder: (event, date) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailsPage(event: event, date: date),
            ),
          ),
          child: _EventListItem(event: event, date: date),
        ),
      ),
      selectedDate: _selectedDate,
      width: widget.width,
    );
  }
}

// ─── Custom event tile for the event list ────────────────────────────────────

class _EventListItem extends StatelessWidget {
  const _EventListItem({required this.event, required this.date});

  final CalendarEventData event;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: event.color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Color dot
          CircleAvatar(backgroundColor: event.color, radius: 5),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.title,
                  style:
                      event.titleStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (event.startTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      _timeRange(event),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  String _timeRange(CalendarEventData event) {
    String fmt(DateTime? dt) {
      if (dt == null) return '';
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    final start = fmt(event.startTime);
    final end = fmt(event.endTime);
    if (start.isEmpty && end.isEmpty) return '';
    if (end.isEmpty) return start;
    return '$start – $end';
  }
}
