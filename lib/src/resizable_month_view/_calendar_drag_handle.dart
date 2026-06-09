// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A drag-handle widget rendered at the bottom of [ResizableMonthView].
///
/// Detects vertical drag gestures and fires [onDragUp] / [onDragDown]
/// whenever the cumulative drag delta exceeds [threshold] pixels.
/// The accumulator is reset after each crossing and on drag end, so
/// every [threshold]-sized segment triggers exactly one mode switch —
/// no mode steps are ever skipped.
///
/// The visible handle is a small pill-shaped indicator centred inside a
/// taller invisible hit area so the minimum touch target size is always
/// at least [touchTargetHeight] pixels (≥ 44 px by default).
///
/// This widget is private to the resizable_month_view directory and must
/// not be imported by any other package file.
class CalendarDragHandle extends StatefulWidget {
  const CalendarDragHandle({
    Key? key,
    required this.onDragUp,
    required this.onDragDown,
    this.threshold = 40.0,
    this.handleColor,
    this.handleWidth = 48.0,
    this.handleHeight = 4.0,
    this.touchTargetHeight = 44.0,
  }) : super(key: key);

  /// Called when the user drags upward past [threshold] pixels.
  final VoidCallback onDragUp;

  /// Called when the user drags downward past [threshold] pixels.
  final VoidCallback onDragDown;

  /// Cumulative pixel delta required to fire a mode-switch callback.
  ///
  /// Defaults to 40.0 px.
  final double threshold;

  /// Color of the visible pill indicator.
  ///
  /// If null, falls back to `Colors.grey.shade400` (or the inverse of
  /// the current theme's canvas color for dark/light adaptation).
  final Color? handleColor;

  /// Visual width of the pill bar in logical pixels. Defaults to 48.
  final double handleWidth;

  /// Visual height (thickness) of the pill bar in logical pixels. Defaults to 4.
  final double handleHeight;

  /// Height of the invisible touch-target wrapper. Must be ≥ 44 to meet
  /// minimum accessibility requirements. Defaults to 44.
  final double touchTargetHeight;

  @override
  State<CalendarDragHandle> createState() => _CalendarDragHandleState();
}

class _CalendarDragHandleState extends State<CalendarDragHandle> {
  /// Running sum of vertical drag deltas since the last threshold crossing
  /// or the start of the current drag gesture.
  double _accumulator = 0.0;

  /// Whether a drag gesture is currently in progress — drives a subtle
  /// opacity animation on the pill to signal interactivity.
  bool _isDragging = false;

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) {
      setState(() => _isDragging = true);
    }

    _accumulator += details.delta.dy;

    if (_accumulator > widget.threshold) {
      // Downward drag threshold crossed → move to the next lower mode.
      _accumulator = 0.0;
      widget.onDragDown();
    } else if (_accumulator < -widget.threshold) {
      // Upward drag threshold crossed → move to the next higher mode.
      _accumulator = 0.0;
      widget.onDragUp();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    // Reset both the accumulator and the dragging visual state.
    setState(() {
      _accumulator = 0.0;
      _isDragging = false;
    });
  }

  void _onDragCancel() {
    setState(() {
      _accumulator = 0.0;
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final defaultHandleColor = brightness == Brightness.dark
        ? Colors.grey.shade600
        : Colors.grey.shade400;
    final pillColor = widget.handleColor ?? defaultHandleColor;

    return GestureDetector(
      // Consume vertical drags so parent scroll views don't intercept them.
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      onVerticalDragCancel: _onDragCancel,
      child: SizedBox(
        width: double.infinity,
        height: widget.touchTargetHeight,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.handleWidth,
            height: widget.handleHeight,
            decoration: BoxDecoration(
              color: pillColor.withAlpha(_isDragging ? 255 : 178),
              borderRadius: BorderRadius.circular(widget.handleHeight / 2),
            ),
          ),
        ),
      ),
    );
  }
}
