// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A [ScrollController] that eliminates zoom-flicker by applying a
/// pre-calculated scroll offset **during layout** rather than in a
/// post-frame callback.
///
/// Call [prepareZoomJump] with the desired offset before the widget rebuilds
/// (e.g. inside [State.didUpdateWidget]).  On the very next layout pass the
/// viewport invokes [applyContentDimensions]; at that point the pending offset
/// is applied via [ScrollPosition.correctPixels], which sets the pixel value
/// *before* the frame is painted.  The result is that both the new content
/// height and the corrected scroll position land in the same rendered frame —
/// zero flicker.
class ZoomScrollController extends ScrollController {
  ZoomScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) : super(
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
          debugLabel: debugLabel,
        );

  double? _pendingOffset;

  /// Schedule a scroll-position correction that will be applied atomically
  /// with the next layout pass.  Replaces any previously scheduled offset.
  void prepareZoomJump(double offset) {
    _pendingOffset = offset;
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _ZoomScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
      controller: this,
    );
  }
}

class _ZoomScrollPosition extends ScrollPositionWithSingleContext {
  _ZoomScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    double? initialPixels,
    bool keepScrollOffset = true,
    ScrollPosition? oldPosition,
    String? debugLabel,
    required this.controller,
  }) : super(
          physics: physics,
          context: context,
          initialPixels: initialPixels,
          keepScrollOffset: keepScrollOffset,
          oldPosition: oldPosition,
          debugLabel: debugLabel,
        );

  final ZoomScrollController controller;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final pending = controller._pendingOffset;
    if (pending != null) {
      controller._pendingOffset = null;
      // Fix: scroll controller exception on PageView page change.
      //
      // The previous implementation called correctPixels + returned false,
      // which bypassed super and skipped applyNewDimensions().  That method
      // is responsible for updating the scroll activity's AnimationController.
      // Skipping it left the controller in a stale state: when the PageView's
      // own AnimationController fired reverse() during a page swipe, its
      // status listener called _validateInteractions →
      // _debugCheckHasValidScrollPosition → exception.
      //
      // Fix: set the corrected pixel value via correctPixels (safe during
      // layout, no notifications) and then ALWAYS call super so that
      // applyNewDimensions() runs and all activities/animations stay valid.
      // Because the clamped value is guaranteed to be within [min, max],
      // super will not override it and will return true — so there is no
      // second layout pass and no flicker.
      correctPixels(pending.clamp(minScrollExtent, maxScrollExtent));
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent);
  }
}
