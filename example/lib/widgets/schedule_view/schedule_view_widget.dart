import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:example/pages/create_event_page.dart';
import 'package:example/pages/event_details_page.dart';
import 'package:example/widgets/schedule_view/empty_text_widget.dart';
import 'package:example/widgets/schedule_view/schedule_view_day_detector.dart';
import 'package:example/widgets/schedule_view/schedule_view_event_tile.dart';
import 'package:example/widgets/schedule_view/schedule_view_month_header.dart';
import 'package:example/widgets/schedule_view/schedule_view_settings.dart';
import 'package:flutter/material.dart';

/// Displays a [ScheduleView] calendar with events.
class ScheduleViewWidget extends StatefulWidget {
  const ScheduleViewWidget({
    this.scheduleViewConfig = const ScheduleViewConfig(),
    this.width,
    this.initialDay,
    this.jumpKey = 0,
    super.key,
  });

  final ScheduleViewConfig scheduleViewConfig;
  final double? width;
  final DateTime? initialDay;
  final int jumpKey;

  @override
  State<ScheduleViewWidget> createState() => _ScheduleViewWidgetState();
}

class _ScheduleViewWidgetState extends State<ScheduleViewWidget> {
  // Drives the view via [ScheduleViewState.jumpToDate] instead of recreating it
  // with a ValueKey, so scroll state survives unrelated rebuilds.
  final GlobalKey<ScheduleViewState> _scheduleKey =
      GlobalKey<ScheduleViewState>();

  // Boundary snack bars should only appear once the user has actually dragged
  // to an edge — not on the first build, when short content already fills the
  // viewport and the boundary callbacks fire immediately.
  bool _userHasScrolled = false;

  @override
  void didUpdateWidget(ScheduleViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent bumps [jumpKey] every time it wants to re-anchor (e.g. the
    // "jump to today" button), even when [initialDay] is unchanged.
    if (widget.jumpKey != oldWidget.jumpKey) {
      _scheduleKey.currentState?.jumpToDate(
        widget.initialDay ?? DateTime.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleColors = context.scheduleViewColors;
    final backgroundColor = context.appColors.backgroundColor;
    final translate = context.translate;

    return NotificationListener<ScrollStartNotification>(
      // Only count user-initiated drags, not programmatic jumpTo() scrolls.
      onNotification: (notification) {
        if (notification.dragDetails != null) _userHasScrolled = true;
        return false;
      },
      child: ScheduleView(
        key: _scheduleKey,
        width: widget.width,
        initialDay: widget.initialDay ?? DateTime.now(),
        backgroundColor: backgroundColor,

        // ── Custom event sort: by start time, then alphabetically by title ─
        eventSorter: (a, b) {
          final ta = a.startTime;
          final tb = b.startTime;
          if (ta != null && tb != null) {
            final diff =
                (ta.hour * 60 + ta.minute) - (tb.hour * 60 + tb.minute);
            if (diff != 0) return diff;
          } else if (ta != null) {
            return -1;
          } else if (tb != null) {
            return 1;
          }
          return a.title.compareTo(b.title);
        },

        // ------------ Empty month with header + "no events" row ------------
        showEmptyMonths: widget.scheduleViewConfig.showEmptyMonths,
        emptyMonthBuilder: (date) =>
            ScheduleViewMonthHeader(date: date, showNoEventsTile: true),

        // ----------- Month and year with background image ------------
        monthHeaderBuilder: (date) => ScheduleViewMonthHeader(date: date),

        // ---------- Date indicator with today's date highlighted ----------
        dayDetectorBuilder: (date, events, layout) =>
            ScheduleViewDayDetector(date: date, events: events, layout: layout),

        // ----------------- Event Tile -------------------
        dateLayout: widget.scheduleViewConfig.dateLayout,
        eventTileBuilder: (event, date) =>
            ScheduleViewEventTile(event: event, date: date),

        // ---------- Empty Text PlaceHolder ----------
        showDaysWithoutEvents: widget.scheduleViewConfig.showDaysWithoutEvents,
        emptyTextWidget: widget.scheduleViewConfig.showDaysWithoutEvents
            ? InkWell(
                onTap: () => context.pushRoute(CreateEventPage()),
                borderRadius: BorderRadius.circular(8),
                child: EmptyTextWidget(),
              )
            : null,

        // ---------- Today — No Events PlaceHolder ----------
        todayEmptyWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(
            translate.scheduleTodayNoEvents,
            style: TextStyle(
              fontSize: 14,
              color: scheduleColors.emptyContentColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // ------------- Floating Month Header --------------
        floatingMonthHeaderBuilder: (context, month) {
          final headerColors = context.appColors;
          return Material(
            elevation: 2,
            color: headerColors.surface,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: scheduleColors.dateDividerColor),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Text(
                month.getMonthYear(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: headerColors.onSurface,
                ),
              ),
            ),
          );
        },

        // ------------- Boundary Callbacks --------------
        // Suppressed until the user has scrolled, so the snack bars don't pop
        // on open when short content already reaches a boundary on first build.
        onHasReachedStart: () {
          if (!_userHasScrolled) return;
          context.showSnackBarWithText(translate.reachedTheStartPage);
        },
        onHasReachedEnd: () {
          if (!_userHasScrolled) return;
          context.showSnackBarWithText(translate.reachedTheEndPage);
        },

        // ---------------Event Callbacks--------------
        onEventTap: (events, date) =>
            context.pushRoute(DetailsPage(event: events.first, date: date)),
        onEventDoubleTap: (events, date) =>
            context.pushRoute(CreateEventPage(event: events.first)),
        onEventLongTap: (events, date) => context.showSnackBarWithText(
          '${translate.scheduleLongPressed} ${events.first.title}',
        ),
      ),
    );
  }
}
