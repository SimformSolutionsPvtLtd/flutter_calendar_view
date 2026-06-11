// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'zoom_scroll_controller.dart';

/// Scrolls a view's timeline to the current time.
///
/// Shared by the `DayView`, `WeekView` and `MultiDayView` states, which each
/// hold one in a private field and expose only `animateToCurrentTime` and
/// `jumpToCurrentTime`. Internal only: this file is not exported from the
/// package, so none of these members become public API.
///
/// Every input is read through a callback so the latest widget configuration
/// and active page controller are used on each call.
class CurrentTimeScroller {
  CurrentTimeScroller({
    required this.isMounted,
    required this.currentTimeProvider,
    required this.startHour,
    required this.endHour,
    required this.heightPerMinute,
    required this.activeController,
    required this.onOffsetChanged,
  });

  /// Whether the owning state is still mounted.
  final bool Function() isMounted;

  /// The view's `LiveTimeIndicatorSettings.currentTimeProvider`, or null to
  /// use [DateTime.now].
  final DateTime Function()? Function() currentTimeProvider;

  /// First hour shown in the timeline (0–23).
  final int Function() startHour;

  /// Last hour shown in the timeline (1–24).
  final int Function() endHour;

  /// Pixels per minute used to calculate scroll offsets.
  final double Function() heightPerMinute;

  /// Scroll controller of the visible page, or null if none is attached.
  final ZoomScrollController? Function() activeController;

  /// Called with the target offset before scrolling, so the owning state can
  /// persist it (e.g. its last offset and the current page's cached offset).
  final void Function(double offset) onOffsetChanged;

  /// Maximum number of frames to wait for a page to attach in
  /// [scrollAfterLayout] before giving up.
  static const _maxAttachAttempts = 5;

  int _attachAttempts = 0;

  /// Current time, honoring [currentTimeProvider] when provided.
  DateTime get currentTime => currentTimeProvider()?.call() ?? DateTime.now();

  /// Top-aligned offset of the current time within the visible timeline.
  double get currentTimeOffset => offsetForTime(currentTime);

  /// Top-aligned pixel offset of [time] within the visible timeline range.
  ///
  /// Uses the same formula as the live time indicator, and clamps times
  /// outside [startHour]/[endHour] to the nearest edge.
  double offsetForTime(DateTime time) {
    final start = startHour();
    final minutesFromStart = (time.hour - start) * 60 + time.minute;
    final visibleMinutes = (endHour() - start) * 60;
    // Guard against an inverted range (endHour < startHour). Asserts that are
    // meant to prevent this are stripped in release builds, and clamp() throws
    // when its lower bound exceeds the upper bound, so fail gracefully instead.
    if (visibleMinutes <= 0) return 0;
    final clampedMinutes = minutesFromStart.clamp(0, visibleMinutes);
    return heightPerMinute() * clampedMinutes;
  }

  /// Target offset for the current time, clamped to the scrollable range, or
  /// null if no page is attached.
  double? _targetOffset({required bool center}) {
    final controller = activeController();
    if (controller == null || !controller.hasClients) return null;
    final position = controller.position;
    var offset = currentTimeOffset;
    if (center) offset -= position.viewportDimension / 2;
    return offset
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
  }

  /// Centers the current time once a page is attached.
  ///
  /// Retries on the next few frames if no page is attached yet, then gives up
  /// to avoid an endless frame-scheduling loop.
  void scrollAfterLayout() {
    if (!isMounted()) return;
    final controller = activeController();
    if (controller == null || !controller.hasClients) {
      if (_attachAttempts++ >= _maxAttachAttempts) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollAfterLayout(),
      );
      return;
    }
    _attachAttempts = 0;
    jump();
  }

  /// Instantly scrolls so the current time is visible. See
  /// `DayViewState.jumpToCurrentTime`.
  void jump({bool center = true}) {
    final offset = _targetOffset(center: center);
    if (offset == null) return;
    onOffsetChanged(offset);
    activeController()?.jumpTo(offset);
  }

  /// Animates so the current time is visible. See
  /// `DayViewState.animateToCurrentTime`.
  Future<void> animate({
    bool center = true,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) async {
    final offset = _targetOffset(center: center);
    final controller = activeController();
    if (offset == null || controller == null) return;
    // Persist the target so a rebuild mid-animation (which seeds the page from
    // the stored offset) doesn't reset the position, matching [jump].
    onOffsetChanged(offset);
    await controller.animateTo(offset, duration: duration, curve: curve);
  }
}
