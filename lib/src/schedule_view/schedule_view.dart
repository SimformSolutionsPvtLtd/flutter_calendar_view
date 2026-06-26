// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../calendar_view.dart';
import '_internal_schedule_view_page.dart';

/// A scrollable agenda-style calendar that displays events grouped by day and month.
///
/// Events are provided by an [EventController], either through [controller]
/// or the nearest [CalendarControllerProvider]. Each day with events (or every
/// day when [showDaysWithoutEvents] is `true`) is shown as a row, with the date
/// displayed beside or above the events depending on [dateLayout].
///
/// Use a [GlobalKey] and [ScheduleViewState.jumpToDate] to programmatically
/// navigate to a specific date.
///
/// Visual styling is resolved from the nearest [ScheduleViewThemeData]
/// extension on [ThemeData], typically registered via
/// [ThemeData.extensions].
///
/// ## Scrolling model
///
/// Months are built lazily, one section at a time, as they scroll into view —
/// only the sections needed to fill the viewport are ever constructed. The
/// view is anchored at [initialDay] (pinned to the top of the viewport);
/// earlier days scroll up and later days scroll down, both within the limits
/// defined by [minDay] and [maxDay].
///
/// When [showEmptyMonths] is `false` (sparse mode), the scrollable range is
/// additionally bounded by the actual events held by the [controller], so that
/// long stretches of empty months are never traversed. This keeps the view
/// responsive even when [minDay]/[maxDay] span decades but events are sparse.
///
/// See also:
/// - [ScheduleViewState] for navigation APIs.
/// - [CalendarControllerProvider] for sharing an [EventController].
/// - [ScheduleViewThemeData] registered via [ThemeData.extensions] for styling.
class ScheduleView<T extends Object?> extends StatefulWidget {
  /// The event controller that provides events to this view.
  ///
  /// When `null`, the view looks up the nearest [CalendarControllerProvider]
  /// ancestor. Provide this explicitly when you need multiple independent
  /// schedule views with different data sources.
  final EventController<T>? controller;

  /// The date the view is initially anchored to.
  ///
  /// The scroll position starts at this exact date, pinned to the top of the
  /// viewport. Earlier days of the same month (and the month header) are
  /// rendered above and become visible by scrolling up; later days and future
  /// months are below. Defaults to [DateTime.now] when `null`.
  final DateTime? initialDay;

  /// The earliest date the view will ever display.
  ///
  /// Months before this date are never loaded, and scrolling stops at the
  /// month containing this date. Defaults to [CalendarConstants.epochDate]
  /// when `null`.
  final DateTime? minDay;

  /// The latest date the view will ever display.
  ///
  /// Months after this date are never loaded, and scrolling stops at the
  /// month containing this date. Defaults to [CalendarConstants.maxDate]
  /// when `null`.
  final DateTime? maxDay;

  /// Builds a custom header widget for each month section.
  ///
  /// Receives the first day of the month. When `null`, a default text header
  /// is rendered using [ScheduleViewThemeData] styles.
  ///
  /// Example — bold month name with a divider below:
  /// ```dart
  /// monthHeaderBuilder: (date) => Column(
  ///   children: [
  ///     Text(DateFormat.yMMMM().format(date),
  ///         style: const TextStyle(fontWeight: FontWeight.bold)),
  ///     const Divider(),
  ///   ],
  /// ),
  /// ```
  final ScheduleMonthHeaderBuilder? monthHeaderBuilder;

  /// Builds a custom widget for the date indicator of each day row.
  ///
  /// If you supply this builder alongside [onDateTap] or
  /// [onDateLongPress], those callbacks are still wrapped around the returned
  /// widget automatically.
  ///
  /// To take full control of gesture handling too, use [dayDetectorBuilder]
  /// instead.
  final ScheduleDateWidgetBuilder? dateHeaderBuilder;

  /// Replaces the entire date indicator widget — including its gesture
  /// detection.
  ///
  /// When set, [onDateTap] and [onDateLongPress] are **not** applied
  /// automatically; the builder is fully responsible for all interactions.
  /// Use this when you need non-standard hit-testing or custom gesture
  /// recognisers on the date area.
  ///
  /// Prefer [dateHeaderBuilder] when you only want to change the visual
  /// appearance and are happy to keep the default tap/long-press behaviour.
  final ScheduleDateWidgetBuilder? dayDetectorBuilder;

  /// Builds a custom event tile for a single event on a given date.
  ///
  /// When `null`, the default tile shows the event color and title.
  ///
  /// Example:
  /// ```dart
  /// eventTileBuilder: (event, date) => ListTile(
  ///   leading: CircleAvatar(backgroundColor: event.color),
  ///   title: Text(event.title),
  /// ),
  /// ```
  final ScheduleEventTileBuilder<T>? eventTileBuilder;

  /// Widget displayed in the events area when a day has no events.
  ///
  /// Only relevant when [showDaysWithoutEvents] is `true` (otherwise empty
  /// days are not rendered at all). For today specifically,
  /// [todayEmptyWidget] takes precedence when provided.
  ///
  /// Defaults to a full length [Divider] when `null`.
  final Widget? emptyTextWidget;

  /// Called when the user taps the date circle / left column of a day row.
  ///
  /// Receives the tapped [DateTime] (time component zeroed). Not called when
  /// [dayDetectorBuilder] is provided, since that builder owns all gesture
  /// handling.
  final DateTapCallback? onDateTap;

  /// Called when the user long-presses the date circle / left column of a
  /// day row.
  ///
  /// Receives the pressed [DateTime] (time component zeroed). Not called when
  /// [dayDetectorBuilder] is provided.
  final DatePressCallback? onDateLongPress;

  /// Called when the user taps an event tile.
  ///
  /// Receives a single-element list containing the tapped event, plus the
  /// date the tile was rendered for. The list wrapper matches the signature
  /// used by other calendar view callbacks.
  final CellTapCallback<T>? onEventTap;

  /// Called when the user long-presses an event tile.
  ///
  /// Same signature as [onEventTap].
  final CellTapCallback<T>? onEventLongTap;

  /// Called when the user double-taps an event tile.
  ///
  /// Same signature as [onEventTap].
  final CellTapCallback<T>? onEventDoubleTap;

  /// Returns a custom formatted string for the month header label.
  ///
  /// Use this for i18n or custom date formatting without replacing
  /// the entire header widget.
  ///
  /// Only used by the default header renderer; has no effect when
  /// [monthHeaderBuilder] is provided.
  final StringProvider? dateStringBuilder;

  /// Returns a custom weekday abbreviation for a given weekday number.
  ///
  /// The integer follows Dart's [DateTime.weekday] convention:
  /// 1 = Monday … 7 = Sunday.
  ///
  /// Example — single-letter abbreviations:
  /// ```dart
  /// weekDayStringBuilder: (wd) =>
  ///     ['M','T','W','T','F','S','S'][wd - 1],
  /// ```
  ///
  /// Only used by the default date badge renderer; has no effect when
  /// [dateHeaderBuilder] or [dayDetectorBuilder] is provided.
  final String Function(int weekday)? weekDayStringBuilder;

  /// Whether to render months that contain no visible day rows.
  ///
  /// When `false`, any month that would produce zero day rows is completely
  /// omitted from the scroll list, and the scrollable range is bounded by the
  /// actual events in the [controller] (plus today). This keeps long, sparse
  /// date ranges responsive.
  ///
  /// When `true` (the default), every month in the [minDay]–[maxDay] range is
  /// always shown; the optional [emptyMonthBuilder] can customise the
  /// appearance of empty months.
  final bool showEmptyMonths;

  /// Builds a replacement widget for months that have no events.
  ///
  /// When provided and a month has no visible day rows, this builder replaces
  /// the entire month block (header + day rows). Only relevant when
  /// [showEmptyMonths] is `true`.
  ///
  /// When `null` and the month is empty, only the month header is rendered
  /// with no day rows beneath it.
  ///
  /// The returned widget **must have a non-zero height**. A zero-height widget
  /// can never fill the viewport, which forces the lazy list to keep building
  /// further months and degrades performance.
  final ScheduleMonthHeaderBuilder? emptyMonthBuilder;

  /// Whether to show day rows for days that have no events.
  ///
  /// When `false` (the default), only days with at least one event, and
  /// today, produce a visible row. When `true`, every day in the loaded date
  /// range is rendered and [emptyTextWidget] (or [todayEmptyWidget] for today)
  /// fills the events area on empty days.
  ///
  /// Enabling this implies every month has content, so it behaves like
  /// [showEmptyMonths] for the purpose of which months are rendered.
  final bool showDaysWithoutEvents;

  /// Background color of the schedule scroll view.
  ///
  /// When `null`, the view is transparent and inherits the background from
  /// its parent widget.
  final Color? backgroundColor;

  /// Explicit width for the schedule view.
  ///
  /// When `null` (the default), the view expands to fill all available
  /// horizontal space.
  final double? width;

  /// Scroll physics to apply to the agenda list.
  ///
  /// Defaults to the platform default when `null` (bouncing on iOS,
  /// clamping on Android).
  final ScrollPhysics? scrollPhysics;

  /// Called once when the earliest available month has been reached.
  ///
  /// Fires when the view has built up to the earliest month that can contain
  /// content — either [minDay] or, in sparse mode, the month of the earliest
  /// event. Use this to show a UI cue or trigger a data fetch.
  final VoidCallback? onHasReachedStart;

  /// Called once when the latest available month has been reached.
  ///
  /// Fires when the view has built up to the latest month that can contain
  /// content — either [maxDay] or, in sparse mode, the month of the latest
  /// event. When an event recurs without an end date the future extent is
  /// clamped to [maxDay], so this fires only once the user reaches [maxDay]
  /// (effectively never in practice for an end-less recurrence). Use this to
  /// show a UI cue or trigger a data fetch.
  final VoidCallback? onHasReachedEnd;

  /// Custom comparator used to sort events within a single day.
  ///
  /// When `null`, events are sorted by start time only (ascending), using
  /// [defaultEventSorter]; events that share a start time keep their existing
  /// relative order.
  ///
  /// Example — sort by title alphabetically:
  /// ```dart
  /// eventSorter: (a, b) => a.title.compareTo(b.title),
  /// ```
  final EventSorter<T>? eventSorter;

  /// Builds the widget shown above all past content once the earliest
  /// available month has been reached.
  ///
  /// Rendered only when the past scroll limit has been reached. When `null`,
  /// no sentinel is shown.
  final WidgetBuilder? pastSentinelBuilder;

  /// Builds the widget shown below all future content once the latest
  /// available month has been reached.
  ///
  /// Rendered only when the future scroll limit has been reached. When `null`,
  /// no sentinel is shown.
  final WidgetBuilder? futureSentinelBuilder;

  /// Controls the position of the date indicator relative to the event list.
  ///
  /// - [ScheduleDateLayout.left] (default) — classic two-column layout with
  ///   the date badge on the left and events stacked on the right.
  /// - [ScheduleDateLayout.top] — renders the date as a full-width header
  ///   above the event list for each day. Useful on narrow screens or when
  ///   more horizontal space is needed for event content.
  final ScheduleDateLayout dateLayout;

  /// Styling for the divider drawn beneath the **default** date header in
  /// [ScheduleDateLayout.top].
  ///
  /// When `null`, a divider is drawn using [ScheduleViewThemeData.dateDividerColor].
  /// Pass [DividerSettings.none] to remove it, or your own [DividerSettings]
  /// to customise thickness, height, color, and indents.
  ///
  /// Has no effect in [ScheduleDateLayout.left], nor when a custom
  /// [dateHeaderBuilder] or [dayDetectorBuilder] is supplied — those builders
  /// own the entire date indicator, divider included.
  final DividerSettings? defaultDateHeaderDividerSettings;

  /// Widget shown in the events area specifically when **today** has no
  /// events.
  ///
  /// Takes precedence over [emptyTextWidget] for today's row only. When
  /// `null`, [emptyTextWidget] (or the built-in fallback) is used for all
  /// empty days including today.
  final Widget? todayEmptyWidget;

  /// Builds a pinned header showing the month currently at the top of the
  /// viewport.
  ///
  /// Rendered **above** the scroll view (not overlaid), so content is never
  /// hidden. Receives the first day of the visible month; rebuilds only when
  /// the month changes. When `null`, no header is shown.
  ///
  /// Use [onVisibleMonthChanged] to drive an external title bar instead.
  ///
  /// ```dart
  /// floatingMonthHeaderBuilder: (context, month) => Material(
  ///   elevation: 2,
  ///   child: Padding(
  ///     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ///     child: Text(month.getMonthYear(),
  ///         style: const TextStyle(fontWeight: FontWeight.bold)),
  ///   ),
  /// ),
  /// ```
  final ScheduleFloatingHeaderBuilder? floatingMonthHeaderBuilder;

  /// Called whenever the month visible at the top of the viewport changes.
  ///
  /// Receives the first day of the newly-visible month. Useful for updating
  /// external UI (e.g. a title bar outside the widget tree) without needing
  /// to supply [floatingMonthHeaderBuilder].
  final void Function(DateTime month)? onVisibleMonthChanged;

  /// Creates a new [ScheduleView].
  const ScheduleView({
    Key? key,
    this.controller,
    this.initialDay,
    this.minDay,
    this.maxDay,
    this.monthHeaderBuilder,
    this.dateHeaderBuilder,
    this.dayDetectorBuilder,
    this.eventTileBuilder,
    this.emptyTextWidget,
    this.onDateTap,
    this.onDateLongPress,
    this.onEventTap,
    this.onEventLongTap,
    this.onEventDoubleTap,
    this.dateStringBuilder,
    this.weekDayStringBuilder,
    this.showEmptyMonths = true,
    this.emptyMonthBuilder,
    this.showDaysWithoutEvents = false,
    this.backgroundColor,
    this.width,
    this.scrollPhysics,
    this.onHasReachedStart,
    this.onHasReachedEnd,
    this.eventSorter,
    this.pastSentinelBuilder,
    this.futureSentinelBuilder,
    this.dateLayout = ScheduleDateLayout.left,
    this.defaultDateHeaderDividerSettings,
    this.todayEmptyWidget,
    this.floatingMonthHeaderBuilder,
    this.onVisibleMonthChanged,
  })  : assert(
          dayDetectorBuilder == null || dateHeaderBuilder == null,
          'dayDetectorBuilder takes full control of the date column — '
          'dateHeaderBuilder will be ignored.',
        ),
        assert(
          dayDetectorBuilder == null ||
              (onDateTap == null && onDateLongPress == null),
          'dayDetectorBuilder owns gesture handling — '
          'onDateTap and onDateLongPress will be ignored.',
        ),
        assert(
          monthHeaderBuilder == null || dateStringBuilder == null,
          'dateStringBuilder has no effect when monthHeaderBuilder is provided.',
        ),
        assert(
          emptyTextWidget == null || showDaysWithoutEvents,
          'emptyTextWidget has no visible effect when showDaysWithoutEvents is '
          'false — empty non-today days are never rendered in that mode. '
          'Set showDaysWithoutEvents: true, or use todayEmptyWidget to '
          'customise the empty state for today specifically.',
        ),
        super(key: key);

  @override
  ScheduleViewState<T> createState() => ScheduleViewState<T>();
}

/// State class for [ScheduleView].
///
/// Obtain a reference via a [GlobalKey] to call [jumpToDate] from outside
/// the widget tree:
///
/// ```dart
/// final key = GlobalKey<ScheduleViewState>();
/// ScheduleView(key: key, ...);
/// key.currentState?.jumpToDate(DateTime(2025, 12, 1));
/// ```
///
/// ## Implementation
///
/// The view is a center-anchored [CustomScrollView] with two [SliverList]s:
/// the future list (the center sliver) grows downward from [_anchorMonth],
/// and the past list grows upward. Each list builds its month sections
/// **lazily by index** — [SliverList] only asks for the sections needed to
/// fill the viewport, so no manual prefetching or pagination is required.
///
/// Month sections are produced on demand by [_growFuture] / [_growPast], which
/// step month-by-month from the anchor and (in sparse mode) skip months with
/// no visible content. The stepping is bounded by [_pastBoundMonth] and
/// [_futureBoundMonth]: in dense mode these are the [minDay]/[maxDay] months,
/// and in sparse mode they are clamped to the actual event extent so empty
/// spans are never walked.
class ScheduleViewState<T extends Object?> extends State<ScheduleView<T>> {
  late EventController<T> _controller;

  // The controller currently being listened to, used to detect controller
  // swaps without re-subscribing on every dependency change.
  EventController<T>? _activeController;

  late DateTime _initialDay;
  late DateTime _minDay;
  late DateTime _maxDay;

  final ScrollController _scrollController = ScrollController();

  // The center key identifies the sliver that anchors the scroll at the top
  // of the viewport. Slivers before it (past months) grow upward; slivers
  // after it (future months) grow downward.
  final GlobalKey _centerKey = GlobalKey();

  // Identifies the scroll view's render object so the visible-month detection
  // can measure the viewport's top edge directly. With a floating month header
  // the scroll view is laid out below the header, so the State's own render box
  // no longer starts at the viewport top.
  final GlobalKey _viewportKey = GlobalKey();

  // Memoised event lookups: cleared on every reset so stale results are never
  // served after an event is added/removed.
  final Map<DateTime, List<CalendarEventData<T>>> _eventCache = {};

  // `dense` is true when every month in range is rendered (showEmptyMonths or
  // showDaysWithoutEvents). In that case bounds span the whole [minDay, maxDay]
  // range. Otherwise (sparse) the bounds are clamped to the months that can
  // actually contain content, derived from the controller's events.
  late bool _dense;
  late DateTime _anchorMonth;
  late DateTime _pastBoundMonth;
  late DateTime _futureBoundMonth;

  // True when the anchor month is split into a header-bearing head piece
  // (days before the anchor, rendered in the past list) and the anchor piece
  // (anchor day onward, in the future list). Only set when the anchor date is
  // past the 1st AND that head range actually has content — otherwise an empty
  // head would render a lone month header with no rows in sparse mode.
  late bool _hasAnchorHead;

  // Month sections built so far, in display order. Future entries start at the
  // anchor month and go forward; past entries start one month before the
  // anchor and go backward (index 0 = nearest to the anchor).
  final List<ScheduleMonthSection> _futureEntries = [];
  final List<ScheduleMonthSection> _pastEntries = [];

  // Next month offset (relative to the anchor month) each direction will
  // examine when grown. Future starts at the anchor (0); past starts one month
  // back (1), since the anchor month itself belongs to the future list.
  int _futureCursor = 0;
  int _pastCursor = 1;

  // True once a direction has been walked to its bound and no further sections
  // can be produced.
  bool _futureFinished = false;
  bool _pastFinished = false;

  // One-shot guards so the boundary callbacks fire at most once per reset.
  bool _reachedStartFired = false;
  bool _reachedEndFired = false;

  // True while a deferred reload is already pending, so a burst of controller
  // notifications during a single frame schedules only one rebuild.
  bool _reloadScheduled = false;

  // True while a visible-month check is already pending for this frame, so a
  // burst of scroll notifications schedules only one _checkVisibleMonth call.
  bool _visibleCheckScheduled = false;

  // Tracks the month currently visible at the top of the viewport, used to
  // drive the optional floating header overlay and onVisibleMonthChanged.
  late ValueNotifier<DateTime> _visibleMonthNotifier;

  // GlobalKey per built month page, used by _checkVisibleMonth to locate each
  // section's RenderBox. The split anchor month's head piece uses _anchorHeadKey
  // instead — reusing the month key for both pieces would mount the same
  // GlobalKey twice and corrupt the tree.
  final Map<DateTime, GlobalKey> _monthPageKeys = {};
  final GlobalKey _anchorHeadKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Bounds first: _clampToDayBounds reads _minDay/_maxDay.
    _minDay = widget.minDay ?? CalendarConstants.epochDate;
    _maxDay = widget.maxDay ?? CalendarConstants.maxDate;
    _initialDay =
        _clampToDayBounds((widget.initialDay ?? DateTime.now()).withoutTime);
    _visibleMonthNotifier =
        ValueNotifier(DateTime(_initialDay.year, _initialDay.month, 1));
    _scrollController.addListener(_scheduleVisibleMonthCheck);
  }

  /// Clamps [day] into `[minDay, maxDay]` at day granularity.
  ///
  /// Asserts (debug only) when [day] falls outside the range so callers learn
  /// they passed an out-of-range [initialDay] / [jumpToDate] target; release
  /// builds clamp silently so the view always has a renderable anchor.
  DateTime _clampToDayBounds(DateTime day) {
    final minDay = _minDay.withoutTime;
    final maxDay = _maxDay.withoutTime;
    assert(
      !day.isBefore(minDay) && !day.isAfter(maxDay),
      'ScheduleView: $day is outside [minDay, maxDay] = [$minDay, $maxDay]; '
      'it will be clamped into range.',
    );
    if (day.isBefore(minDay)) return minDay;
    if (day.isAfter(maxDay)) return maxDay;
    return day;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resolveController()) _rebuildSections();
  }

  /// Resolves the active controller from [ScheduleView.controller] or the
  /// nearest [CalendarControllerProvider], swapping the listener subscription
  /// when it changed. Returns `true` when the controller was swapped.
  bool _resolveController() {
    final resolved = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;
    if (identical(resolved, _activeController)) return false;
    _activeController?.removeListener(_reload);
    _controller = resolved;
    _activeController = resolved;
    _controller.addListener(_reload);
    return true;
  }

  @override
  void didUpdateWidget(ScheduleView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    var resetScroll = false;
    var needsRebuild = false;

    // Re-resolve whenever the explicit `controller` parameter changes —
    // including the non-null -> null transition, where the view must fall back
    // to the nearest CalendarControllerProvider instead of staying subscribed
    // to the stale explicit controller.
    if (widget.controller != oldWidget.controller) {
      if (_resolveController()) needsRebuild = true;
    }

    if (widget.minDay != oldWidget.minDay) {
      _minDay = widget.minDay ?? CalendarConstants.epochDate;
      needsRebuild = true;
    }
    if (widget.maxDay != oldWidget.maxDay) {
      _maxDay = widget.maxDay ?? CalendarConstants.maxDate;
      needsRebuild = true;
    }

    // Compare at day granularity against the stored (normalized) anchor: a
    // caller passing `initialDay: DateTime.now()` inline yields a new
    // now()-with-time on every parent rebuild, which would otherwise always
    // be `!=` and reset the scroll position on each rebuild.
    final newInitial =
        _clampToDayBounds((widget.initialDay ?? DateTime.now()).withoutTime);
    if (newInitial != _initialDay) {
      _initialDay = newInitial;
      needsRebuild = true;
      resetScroll = true;
    }

    if (widget.showEmptyMonths != oldWidget.showEmptyMonths ||
        widget.showDaysWithoutEvents != oldWidget.showDaysWithoutEvents) {
      needsRebuild = true;
    }

    if (needsRebuild) {
      _rebuildSections();
      if (resetScroll) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _activeController?.removeListener(_reload);
    _scrollController.removeListener(_scheduleVisibleMonthCheck);
    _scrollController.dispose();
    _visibleMonthNotifier.dispose();
    super.dispose();
  }

  /// Resets all section state and triggers a rebuild in response to a
  /// controller mutation (event added, removed, or updated).
  ///
  /// When the controller notifies its listeners while the framework is already
  /// building — e.g. another widget mutates the controller from its own
  /// `didChangeDependencies`/`build` — calling [setState] synchronously would
  /// throw "setState() called during build". In that case the rebuild is
  /// deferred to the end of the current frame.
  void _reload() {
    if (!mounted) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_reloadScheduled) return;
      _reloadScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _reloadScheduled = false;
        if (mounted) setState(_rebuildSections);
      });
    } else {
      setState(_rebuildSections);
    }
  }

  /// Resets the view so that [date] becomes the new anchor and scrolls so that
  /// [date] sits at the top of the viewport (earlier days of its month remain
  /// reachable by scrolling up).
  ///
  /// All built sections, caches, and cursors are reset; the bounds are
  /// recomputed for the new anchor.
  ///
  /// Example:
  /// ```dart
  /// final key = GlobalKey<ScheduleViewState>();
  /// // …
  /// key.currentState?.jumpToDate(DateTime(2026, 1, 1));
  /// ```
  void jumpToDate(DateTime date) {
    if (!mounted) return;
    setState(() {
      _initialDay = _clampToDayBounds(date.withoutTime);
      _rebuildSections();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) _scrollController.jumpTo(0);
    });
  }

  /// Recomputes the anchor and scroll bounds, then discards every built
  /// section so the lazy lists rebuild from scratch.
  ///
  /// In sparse mode ([showEmptyMonths] == false and [showDaysWithoutEvents] ==
  /// false) the bounds are clamped to the months that can actually contain
  /// content, derived from the controller's events plus today. This is what
  /// prevents the view from walking the entire [minDay]–[maxDay] span — which
  /// can be thousands of empty months — when events are sparse.
  void _rebuildSections() {
    _dense = widget.showEmptyMonths || widget.showDaysWithoutEvents;
    _anchorMonth = DateTime(_initialDay.year, _initialDay.month, 1);

    final minMonth = DateTime(_minDay.year, _minDay.month, 1);
    final maxMonth = DateTime(_maxDay.year, _maxDay.month, 1);

    if (_dense) {
      _pastBoundMonth = minMonth;
      _futureBoundMonth = maxMonth;
    } else {
      final today = DateTime.now().withoutTime;
      var earliest = today;
      var latest = today;
      var unbounded = false;

      // The anchor (initialDay / jumpToDate target) must always fall within the
      // scroll bounds, even when it lands outside the event range and after
      // today — otherwise the anchor month is clamped away, onHasReachedEnd
      // fires prematurely, and the navigated-to date renders blank.
      if (_initialDay.isBefore(earliest)) earliest = _initialDay;
      if (_initialDay.isAfter(latest)) latest = _initialDay;

      for (final event in _controller.allEvents) {
        final start = event.date.withoutTime;
        if (start.isBefore(earliest)) earliest = start;

        if (event.isRecurringEvent) {
          // A recurrence with no end date repeats forever, so content can
          // extend all the way to [maxDay].
          final end = event.recurrenceSettings?.endDate?.withoutTime;
          if (end == null) {
            unbounded = true;
          } else if (end.isAfter(latest)) {
            latest = end;
          }
        } else {
          final end = event.endDate.withoutTime;
          if (end.isAfter(latest)) latest = end;
        }
      }

      final earliestMonth = DateTime(earliest.year, earliest.month, 1);
      final latestMonth =
          unbounded ? maxMonth : DateTime(latest.year, latest.month, 1);

      _pastBoundMonth =
          earliestMonth.isAfter(minMonth) ? earliestMonth : minMonth;
      _futureBoundMonth =
          latestMonth.isBefore(maxMonth) ? latestMonth : maxMonth;
    }

    _eventCache.clear();
    _futureEntries.clear();
    _pastEntries.clear();
    _monthPageKeys.clear();
    _futureCursor = 0;
    _pastCursor = 1;
    _futureFinished = false;
    _pastFinished = false;
    _reachedStartFired = false;
    _reachedEndFired = false;
    // Drives both the floating header (via the notifier) and an external title
    // bar (via onVisibleMonthChanged), so a programmatic jump/rebuild keeps the
    // latter in sync — _checkVisibleMonth otherwise only fires it on scroll.
    _updateVisibleMonth(_anchorMonth);

    // Split the anchor month only when the anchor date is past the 1st and the
    // preceding day range (1 … _initialDay.day - 1) has content. In sparse mode
    // an empty head range is suppressed so it can't render a lone month header
    // with no rows; the anchor piece in the future list then carries the
    // header instead (see _growFuture).
    _hasAnchorHead = _initialDay.day > 1 &&
        (_dense ||
            _monthHasContent(_anchorMonth,
                startDay: 1, endDay: _initialDay.day - 1));
  }

  /// Returns the future section at [index], growing the list as needed.
  ///
  /// Returns `null` when [index] lies past the last future section (the future
  /// direction has been walked to its bound).
  ScheduleMonthSection? _futureEntryAt(int index) {
    while (_futureEntries.length <= index && !_futureFinished) {
      _growFuture();
    }
    return index < _futureEntries.length ? _futureEntries[index] : null;
  }

  /// Appends the next future section, stepping past empty months in sparse
  /// mode, or marks the future direction finished once [_futureBoundMonth] is
  /// passed.
  void _growFuture() {
    while (true) {
      final monthDate =
          DateTime(_anchorMonth.year, _anchorMonth.month + _futureCursor, 1);

      if (monthDate.isAfter(_futureBoundMonth)) {
        _futureFinished = true;
        _fireReachedEnd();
        return;
      }

      // The anchor month's center piece starts at _initialDay.day so the
      // anchor date sits at the top of the viewport. When the anchor has a head
      // piece (see _hasAnchorHead), the days before it and the header are
      // rendered above in the past list, so the header is suppressed here.
      // Otherwise — anchor on the 1st, or an empty head range in sparse mode —
      // this anchor piece carries the header itself.
      final isAnchor = _futureCursor == 0;
      final startDay = isAnchor ? _initialDay.day : 1;
      final showHeader = isAnchor ? !_hasAnchorHead : true;
      _futureCursor++;

      if (_dense || _monthHasContent(monthDate, startDay: startDay)) {
        _futureEntries.add(
            ScheduleMonthSection(monthDate, startDay, showHeader: showHeader));
        return;
      }
    }
  }

  /// Returns the past section at [index] (0 = nearest to the anchor), growing
  /// the list as needed.
  ///
  /// Returns `null` when [index] lies past the oldest section (the past
  /// direction has been walked to its bound).
  ScheduleMonthSection? _pastEntryAt(int index) {
    while (_pastEntries.length <= index && !_pastFinished) {
      _growPast();
    }
    return index < _pastEntries.length ? _pastEntries[index] : null;
  }

  /// Appends the next past section, stepping past empty months in sparse mode,
  /// or marks the past direction finished once [_pastBoundMonth] is passed.
  void _growPast() {
    while (true) {
      final monthDate =
          DateTime(_anchorMonth.year, _anchorMonth.month - _pastCursor, 1);

      if (monthDate.isBefore(_pastBoundMonth)) {
        _pastFinished = true;
        _fireReachedStart();
        return;
      }
      _pastCursor++;

      if (_dense || _monthHasContent(monthDate, startDay: 1)) {
        _pastEntries.add(ScheduleMonthSection(monthDate, 1, showHeader: true));
        return;
      }
    }
  }

  /// Returns `true` when the day range [startDay] … [endDay] (inclusive) of
  /// [monthDate] contains at least one day row that would be rendered: a day
  /// with events, or today. When [endDay] is `null`, the range extends to the
  /// end of the month.
  ///
  /// Only consulted in sparse mode (dense mode renders every month
  /// unconditionally). Uses [_eventCache] so each date is queried from the
  /// controller at most once between resets.
  bool _monthHasContent(DateTime monthDate,
      {required int startDay, int? endDay}) {
    final today = DateTime.now().withoutTime;
    final minDay = _minDay.withoutTime;
    final maxDay = _maxDay.withoutTime;
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final lastDay = endDay ?? daysInMonth;

    for (int day = startDay; day <= lastDay; day++) {
      final date = DateTime(monthDate.year, monthDate.month, day);
      if (date.isBefore(minDay) || date.isAfter(maxDay)) continue;
      if (date == today) return true;

      final events = _eventCache.putIfAbsent(
        date,
        () => _controller.getEventsOnDay(date),
      );
      if (events.isNotEmpty) return true;
    }
    return false;
  }

  /// Schedules a single [_checkVisibleMonth] call for the end of the current
  /// frame. Batches rapid scroll ticks so at most one check runs per frame.
  void _scheduleVisibleMonthCheck() {
    if (widget.floatingMonthHeaderBuilder == null &&
        widget.onVisibleMonthChanged == null) {
      return;
    }
    // Dedupe within a frame: many scroll notifications can fire before the
    // post-frame callback runs, so without this guard each would register its
    // own callback and run _checkVisibleMonth N times for the same frame.
    if (_visibleCheckScheduled) return;
    _visibleCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibleCheckScheduled = false;
      _checkVisibleMonth();
    });
  }

  /// Sets the visible-month notifier (driving the floating header) and notifies
  /// [ScheduleView.onVisibleMonthChanged] for the same month.
  ///
  /// The callback is invoked after the current frame so listeners may safely
  /// call `setState`. Used by the rebuild/jump path; [_checkVisibleMonth]
  /// fires the callback directly on scroll, where it already runs post-frame.
  void _updateVisibleMonth(DateTime month) {
    _visibleMonthNotifier.value = month;
    final callback = widget.onVisibleMonthChanged;
    if (callback == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback(month);
    });
  }

  /// The stable [GlobalKey] for the month page rendering [month], created on
  /// first use. The split anchor month's head piece uses [_anchorHeadKey]
  /// instead (see [_monthPageKeys]).
  GlobalKey _keyForMonth(DateTime month) =>
      _monthPageKeys.putIfAbsent(month, GlobalKey.new);

  /// Walks all built month sections and finds the one whose [RenderBox]
  /// straddles the viewport's top edge. Updates [_visibleMonthNotifier] and
  /// fires [ScheduleView.onVisibleMonthChanged] when the month changes.
  void _checkVisibleMonth() {
    if (!mounted) return;
    // Measure the scroll view itself rather than the State's render object:
    // with a floating month header the scroll view is laid out below the
    // header, so the State's box top no longer coincides with the viewport top.
    final scrollBox =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (scrollBox == null || !scrollBox.attached) return;

    final viewportTop = scrollBox.localToGlobal(Offset.zero).dy;

    // (key, month) for every built section. Sections are stacked vertically
    // and never overlap, so at most one straddles the top edge — order is
    // irrelevant. The split anchor head is tracked under its own key so its
    // month still resolves while it sits at the top.
    final sections = <MapEntry<GlobalKey, DateTime>>[
      if (_hasAnchorHead) MapEntry(_anchorHeadKey, _anchorMonth),
      for (final e in _futureEntries) MapEntry(_keyForMonth(e.date), e.date),
      for (final e in _pastEntries) MapEntry(_keyForMonth(e.date), e.date),
    ];

    for (final section in sections) {
      final rb = section.key.currentContext?.findRenderObject() as RenderBox?;
      if (rb == null || !rb.attached) continue;

      final sectionTop = rb.localToGlobal(Offset.zero).dy;
      final sectionBottom = sectionTop + rb.size.height;

      if (sectionTop <= viewportTop && sectionBottom > viewportTop) {
        if (section.value != _visibleMonthNotifier.value) {
          _visibleMonthNotifier.value = section.value;
          widget.onVisibleMonthChanged?.call(section.value);
        }
        return;
      }
    }
  }

  /// Fires [ScheduleView.onHasReachedStart] once, after the current frame so
  /// callbacks may safely call `setState`.
  void _fireReachedStart() {
    if (_reachedStartFired) return;
    _reachedStartFired = true;
    final callback = widget.onHasReachedStart;
    if (callback == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  /// Fires [ScheduleView.onHasReachedEnd] once, after the current frame so
  /// callbacks may safely call `setState`.
  void _fireReachedEnd() {
    if (_reachedEndFired) return;
    _reachedEndFired = true;
    final callback = widget.onHasReachedEnd;
    if (callback == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The anchor month is split when it has a head piece (see _hasAnchorHead):
    // its leading days and the header render in the past list so the anchor
    // date stays pinned to the top of the viewport.
    final hasAnchorHead = _hasAnchorHead;

    Widget child = CustomScrollView(
      key: _viewportKey,
      controller: _scrollController,
      physics: widget.scrollPhysics,
      // The center sliver anchors at the top of the viewport. Slivers listed
      // before it render above (past) and grow upward as the user scrolls up;
      // slivers listed after it grow downward (future).
      center: _centerKey,
      slivers: [
        // ------------- Past months (grow upward) --------------
        // Index 0 is rendered ADJACENT to the center and higher indices go
        // further back in time. Sections are built lazily on demand; a `null`
        // return signals the start of available content.
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _buildPastSliverChild(context, index, hasAnchorHead),
          ),
        ),

        // ── Anchor month + future months (center anchor, grow downward) ────
        SliverList(
          key: _centerKey,
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildFutureSliverChild(context, index),
          ),
        ),
      ],
    );

    if (widget.backgroundColor != null) {
      child = ColoredBox(color: widget.backgroundColor!, child: child);
    }

    if (widget.floatingMonthHeaderBuilder != null) {
      // The header reserves its own height above the scroll view instead of
      // overlaying it, so the anchor row (on first build) and the topmost row
      // (at the past boundary) are never hidden behind it. Only the header
      // rebuilds when the visible month changes; the scroll content is left
      // untouched.
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _visibleMonthNotifier,
            builder: (ctx, month, _) =>
                widget.floatingMonthHeaderBuilder!(ctx, month),
          ),
          Expanded(child: child),
        ],
      );
    }

    if (widget.width != null) {
      child = SizedBox(width: widget.width, child: child);
    }

    return child;
  }

  /// Builds a child of the future (center) sliver: the lazily-grown future
  /// month at [index], or the future sentinel once the end is reached.
  Widget? _buildFutureSliverChild(BuildContext context, int index) {
    final entry = _futureEntryAt(index);
    if (entry != null) {
      return _buildMonthPage(
        entry.date,
        key: _keyForMonth(entry.date),
        startDay: entry.startDay,
        showHeader: entry.showHeader,
      );
    }
    // First slot past the last future month: optionally show the sentinel.
    if (_futureFinished &&
        index == _futureEntries.length &&
        widget.futureSentinelBuilder != null) {
      return widget.futureSentinelBuilder!(context);
    }
    return null;
  }

  /// Builds a child of the past sliver: the anchor head piece at index 0 (when
  /// the anchor date is past the 1st), then lazily-grown earlier months, then
  /// the past sentinel once the start is reached.
  Widget? _buildPastSliverChild(
      BuildContext context, int index, bool hasAnchorHead) {
    if (hasAnchorHead && index == 0) {
      // The header-bearing leading piece of the anchor month, covering the
      // days that precede the anchor date (1 … _initialDay.day - 1). It uses a
      // dedicated key so it never collides with the anchor piece's month key.
      return _buildMonthPage(
        _anchorMonth,
        key: _anchorHeadKey,
        startDay: 1,
        endDay: _initialDay.day - 1,
        showHeader: true,
      );
    }

    final pastIndex = hasAnchorHead ? index - 1 : index;
    final entry = _pastEntryAt(pastIndex);
    if (entry != null) {
      return _buildMonthPage(entry.date,
          key: _keyForMonth(entry.date),
          startDay: entry.startDay,
          showHeader: entry.showHeader);
    }
    // First slot past the oldest month: optionally show the sentinel.
    if (_pastFinished &&
        pastIndex == _pastEntries.length &&
        widget.pastSentinelBuilder != null) {
      return widget.pastSentinelBuilder!(context);
    }
    return null;
  }

  /// Builds the [InternalScheduleViewPage] for a single month, forwarding all
  /// widget-level configuration properties.
  ///
  /// [key] is supplied by the caller so the split anchor month's two pieces
  /// never share a [GlobalKey]; see [_monthPageKeys].
  Widget _buildMonthPage(
    DateTime monthDate, {
    required Key key,
    int startDay = 1,
    int? endDay,
    bool showHeader = true,
  }) {
    return InternalScheduleViewPage<T>(
      key: key,
      monthDate: monthDate,
      startDay: startDay,
      endDay: endDay,
      showHeader: showHeader,
      minDay: _minDay,
      maxDay: _maxDay,
      showDaysWithoutEvents: widget.showDaysWithoutEvents,
      eventsForDay: (date) => _eventCache.putIfAbsent(
        date,
        () => _controller.getEventsOnDay(date),
      ),
      monthHeaderBuilder: widget.monthHeaderBuilder,
      dateHeaderBuilder: widget.dateHeaderBuilder,
      dayDetectorBuilder: widget.dayDetectorBuilder,
      eventTileBuilder: widget.eventTileBuilder,
      emptyTextWidget: widget.emptyTextWidget,
      onDateTap: widget.onDateTap,
      onDateLongPress: widget.onDateLongPress,
      onEventTap: widget.onEventTap,
      onEventLongTap: widget.onEventLongTap,
      onEventDoubleTap: widget.onEventDoubleTap,
      dateStringBuilder: widget.dateStringBuilder,
      weekDayStringBuilder: widget.weekDayStringBuilder,
      emptyMonthBuilder: widget.emptyMonthBuilder,
      eventSorter: widget.eventSorter,
      dateLayout: widget.dateLayout,
      dividerSettings: widget.defaultDateHeaderDividerSettings,
      todayEmptyWidget: widget.todayEmptyWidget,
    );
  }
}
