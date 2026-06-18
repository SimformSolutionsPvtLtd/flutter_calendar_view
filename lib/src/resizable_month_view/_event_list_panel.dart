// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';

/// Internal event-list panel rendered below the calendar grid in
/// [ResizableMonthView].
///
/// Shows all events for [selectedDate] from [controller].
/// If [builders.eventListBuilder] is provided it delegates entirely to that.
/// Otherwise a default scrollable card list is shown with an optional
/// per-item override via [builders.eventListItemBuilder].
class EventListPanel<T extends Object?> extends StatelessWidget {
  const EventListPanel({
    Key? key,
    required this.selectedDate,
    required this.controller,
    required this.builders,
    required this.padding,
    required this.separatorHeight,
  }) : super(key: key);

  /// The date whose events are displayed.
  final DateTime selectedDate;

  /// Event controller.
  final EventController<T> controller;

  /// Builders config (may include [eventListBuilder] or
  /// [eventListItemBuilder]).
  final ResizableMonthViewBuilders<T> builders;

  /// Padding applied around the entire list area.
  final EdgeInsets padding;

  /// Height of the gap between the calendar grid and this panel.
  final double separatorHeight;

  /// Builds the event list as a [Sliver] suitable for inclusion in a
  /// [CustomScrollView].
  ///
  /// **Layout structure** (top → bottom):
  /// 1. A date-label header showing which date the events belong to
  ///    (Samsung calendar style).
  /// 2. The event list itself, or a "No events" placeholder.
  ///
  /// **Delegation order**:
  /// 1. If [builders.eventListBuilder] is provided, the entire list
  ///    rendering is delegated to it (full custom layout).
  /// 2. If no events exist for [selectedDate], a lightweight
  ///    [_EmptyEventsPlaceholder] is shown.
  /// 3. Otherwise a [SliverList] is built with interleaved 8-px spacing
  ///    gaps (odd indices) and event tiles (even indices). Per-item
  ///    rendering can be customised via [builders.eventListItemBuilder];
  ///    without it, [_DefaultEventTile] is used.
  @override
  Widget build(BuildContext context) {
    final events = controller.getEventsOnDay(selectedDate);

    // Custom whole-list builder takes priority.
    final customList = builders.eventListBuilder?.call(events, selectedDate);
    if (customList != null) {
      return SliverPadding(
        padding: padding.copyWith(top: padding.top + separatorHeight),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DateLabelHeader(date: selectedDate),
              customList,
            ],
          ),
        ),
      );
    }

    // Empty state: no events for the selected date.
    if (events.isEmpty) {
      return SliverPadding(
        padding: padding.copyWith(top: padding.top + separatorHeight),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DateLabelHeader(date: selectedDate),
              _EmptyEventsPlaceholder(),
            ],
          ),
        ),
      );
    }

    // Default list: date header + alternating event tiles and spacing gaps.
    // childCount = events.length * 2 accounts for the interleaved gaps
    // (first item at index 0 is the date header).
    return SliverPadding(
      padding: padding.copyWith(top: padding.top + separatorHeight),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // First item is the date header.
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DateLabelHeader(date: selectedDate),
              );
            }

            // Adjust index to account for the header.
            final adjustedIndex = index - 1;

            // Odd adjusted indices are spacing gaps between tiles.
            if (adjustedIndex.isOdd) return const SizedBox(height: 8);

            final itemIndex = adjustedIndex ~/ 2;
            final event = events[itemIndex];

            // Per-item custom builder.
            if (builders.eventListItemBuilder != null) {
              return _maybeWrapDismissible(
                event: event,
                child: builders.eventListItemBuilder!(
                  event,
                  selectedDate,
                ),
              );
            }

            return _maybeWrapDismissible(
              event: event,
              child: _DefaultEventTile<T>(
                event: event,
                date: selectedDate,
                onTap: builders.onEventTap,
                onLongTap: builders.onEventLongTap,
                onDoubleTap: builders.onEventDoubleTap,
              ),
            );
          },
          // +1 for the date header at index 0
          childCount: events.length * 2, // header + (events + gaps)
        ),
      ),
    );
  }

  /// Wraps [child] in a [Dismissible] if [builders.onEventDismissed]
  /// is provided, enabling swipe-to-delete on event tiles.
  Widget _maybeWrapDismissible({
    required CalendarEventData<T> event,
    required Widget child,
  }) {
    if (builders.onEventDismissed == null) return child;

    return Dismissible(
      key: ValueKey('dismiss_${event.hashCode}_${selectedDate.hashCode}'),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        builders.onEventDismissed!(event, selectedDate, direction);
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: child,
    );
  }
}

// ─── Date label header (Samsung-style) ────────────────────────────────────────

/// Shows the date whose events are currently displayed, giving context
/// when the user navigates to another month without selecting a date there.
///
/// Format: "Wednesday, June 11" — matching the Samsung Calendar style.
class _DateLabelHeader extends StatelessWidget {
  const _DateLabelHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().withoutTime;
    final isToday = date.compareWithoutTime(now);
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    String label;
    if (isToday) {
      label = 'Today';
    } else if (date.compareWithoutTime(yesterday)) {
      label = 'Yesterday';
    } else if (date.compareWithoutTime(tomorrow)) {
      label = 'Tomorrow';
    } else {
      label = _formatDate(date);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
        ),
      ),
    );
  }

  /// Formats [date] as "Weekday, Month Day" (e.g. "Wednesday, June 11").
  static String _formatDate(DateTime date) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday', //
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December', //
    ];
    return '${weekdays[date.weekday - 1]}, '
        '${months[date.month - 1]} ${date.day}';
  }
}

// ─── Default tile ─────────────────────────────────────────────────────────────

/// Fallback event tile rendered when no custom
/// [ResizableMonthViewBuilders.eventListItemBuilder] is supplied.
///
/// Displays a colour-accented left border, a colour dot (matching
/// [CalendarEventData.color]) and the event title inside a rounded,
/// lightly shadowed container. When the event has a custom colour, a
/// subtle tint of that colour is blended into the tile background so
/// that events like "VIP Client Meeting" (Colors.black) render with
/// proper contrast. Supports tap, long-press, and double-tap gestures
/// via the optional [TileTapCallback]s.
class _DefaultEventTile<T extends Object?> extends StatelessWidget {
  const _DefaultEventTile({
    required this.event,
    required this.date,
    this.onTap,
    this.onLongTap,
    this.onDoubleTap,
  });

  final CalendarEventData<T> event;
  final DateTime date;
  final TileTapCallback<T>? onTap;
  final TileTapCallback<T>? onLongTap;
  final TileTapCallback<T>? onDoubleTap;

  /// Builds the tile widget with a coloured-dot + title row inside a
  /// themed rounded container, wired to gesture callbacks.
  @override
  Widget build(BuildContext context) {
    final theme = context.resizableMonthViewColors;

    // Blend a subtle tint of the event's colour into the tile background
    // so that custom-coloured events (e.g. black, dark colours) get a
    // distinguishable tile background rather than the plain theme colour.
    final tintedBackground = Color.alphaBlend(
      event.color.withAlpha(25),
      theme.eventListItemColor,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap.safeVoidCall(event, date),
      onLongPress: onLongTap.safeVoidCall(event, date),
      onDoubleTap: onDoubleTap.safeVoidCall(event, date),
      child: Container(
        decoration: BoxDecoration(
          color: tintedBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: event.color, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Colour indicator dot matching the event's colour.
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: event.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            // Event title, truncated to 2 lines.
            Expanded(
              child: Text(
                event.title,
                style: event.titleStyle ??
                    TextStyle(
                      color: theme.eventListItemTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty placeholder ────────────────────────────────────────────────────────

/// Placeholder shown when no events exist for the currently selected date.
///
/// Renders a centred "No events" label using the theme's `onSurface` colour
/// with reduced opacity to ensure visibility in both light and dark mode.
class _EmptyEventsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 24),
      child: Text(
        'No events',
        style: TextStyle(
          // Use the theme's onSurface colour with reduced opacity to
          // guarantee visibility in dark mode (the previous theme-extension
          // colour could be invisible against certain scaffold backgrounds).
          color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          fontSize: 14,
        ),
      ),
    );
  }
}
