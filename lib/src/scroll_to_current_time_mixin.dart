// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'zoom_scroll_controller.dart';

/// Provides scroll-to-current-time functionality shared by DayView, WeekView,
/// and MultiDayView state classes.
mixin ScrollToCurrentTimeMixin<W extends StatefulWidget> on State<W> {
  // --- Abstract interface (implemented by the host state) ---

  /// Returns the [currentTimeProvider] from the view's
  /// [LiveTimeIndicatorSettings], or null to use [DateTime.now].
  DateTime Function()? get currentTimeProvider;

  /// First hour shown in the timeline (0–23).
  int get viewStartHour;

  /// Last hour shown in the timeline (1–24).
  int get viewEndHour;

  /// Pixels per minute used to calculate scroll offsets.
  double get viewHeightPerMinute;

  /// Currently active scroll controller, or null if not yet attached.
  ZoomScrollController? get activeScrollController;

  /// Called by [jumpToCurrentTime] so the host can persist the new offset
  /// (e.g. update _lastScrollOffset and _pageOffsets[_currentIndex]).
  void onCurrentTimeJumped(double offset);

  // --- Shared implementation ---

  int _currentTimeScrollAttempts = 0;

  /// Current time, honoring [currentTimeProvider] when provided.
  DateTime get currentTime => currentTimeProvider?.call() ?? DateTime.now();

  /// Top-aligned pixel offset of [time] within the visible timeline range.
  ///
  /// Accounts for [viewStartHour]/[viewEndHour] and clamps the result so that
  /// times outside the range map to the nearest edge.
  double offsetForTime(DateTime time) {
    final minutesFromStart = (time.hour - viewStartHour) * 60 + time.minute;
    final visibleMinutes = (viewEndHour - viewStartHour) * 60;
    // Guard against an inverted range (endHour < startHour). Asserts that are
    // meant to prevent this are stripped in release builds, and clamp() throws
    // when its lower bound exceeds the upper bound, so fail gracefully instead.
    if (visibleMinutes <= 0) return 0;
    final clampedMinutes = minutesFromStart.clamp(0, visibleMinutes);
    return viewHeightPerMinute * clampedMinutes;
  }

  double? _currentTimeScrollOffset({required bool center}) {
    final controller = activeScrollController;
    if (controller == null || !controller.hasClients) return null;
    final position = controller.position;
    var offset = offsetForTime(currentTime);
    if (center) offset -= position.viewportDimension / 2;
    return offset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
  }

  /// Centers the current time once the scrollable is ready.
  ///
  /// Retries for a few frames if the controller is not attached yet, then
  /// gives up to avoid an endless frame-scheduling loop.
  void scrollToCurrentTimeAfterLayout() {
    if (!mounted) return;
    final controller = activeScrollController;
    if (controller == null || !controller.hasClients) {
      if (_currentTimeScrollAttempts++ >= 5) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollToCurrentTimeAfterLayout(),
      );
      return;
    }
    jumpToCurrentTime();
  }

  /// Instantly positions the timeline so the current time is visible.
  ///
  /// When [center] is true (default) the current time is placed at the
  /// vertical center of the viewport; otherwise it aligns to the top.
  /// Does nothing if the scrollable is not yet attached.
  void jumpToCurrentTime({bool center = true}) {
    final offset = _currentTimeScrollOffset(center: center);
    if (offset == null) return;
    onCurrentTimeJumped(offset);
    activeScrollController?.jumpTo(offset);
  }

  /// Animates the timeline so that the current time becomes visible.
  ///
  /// When [center] is true (default) the current time is positioned at the
  /// vertical center of the viewport; otherwise it aligns to the top. The
  /// target is clamped to the scrollable range. Does nothing if the view has
  /// not been laid out yet.
  Future<void> animateToCurrentTime({
    bool center = true,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) async {
    final offset = _currentTimeScrollOffset(center: center);
    if (offset == null) return;
    final controller = activeScrollController;
    if (controller == null || !controller.hasClients) return;
    // Persist the target so a rebuild mid-animation (which seeds the page from
    // the stored offset) doesn't reset the position, matching jumpToCurrentTime.
    onCurrentTimeJumped(offset);
    await controller.animateTo(offset, duration: duration, curve: curve);
  }
}
