// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../extensions.dart';

/// Internal header widget for [ResizableMonthView].
///
/// Renders the navigation arrows, the month–year title, and the mode-toggle
/// pill button. Tapping the pill cycles through [ResizableMonthViewMode]
/// values: full → compact → minimal → full.
///
/// This widget is private to the resizable_month_view directory and must not
/// be imported by any other package file.
class ResizableMonthViewHeader extends StatelessWidget {
  const ResizableMonthViewHeader({
    Key? key,
    required this.currentDate,
    required this.currentMode,
    required this.onPrevious,
    required this.onNext,
    required this.onModeTap,
    required this.showPreviousIcon,
    required this.showNextIcon,
    required this.showModeToggle,
    required this.headerStyle,
    required this.modeToggleActiveColor,
    required this.modeToggleTextColor,
    required this.modeToggleBorderRadius,
    this.dateStringBuilder,
    this.onTitleTap,
  }) : super(key: key);

  /// The date whose month/year is displayed in the title.
  final DateTime currentDate;

  /// Currently active display mode.
  final ResizableMonthViewMode currentMode;

  /// Called when the previous arrow is tapped.
  final VoidCallback onPrevious;

  /// Called when the next arrow is tapped.
  final VoidCallback onNext;

  /// Called when the mode-toggle pill is tapped.
  final VoidCallback onModeTap;

  /// Whether to show the previous-navigation arrow.
  final bool showPreviousIcon;

  /// Whether to show the next-navigation arrow.
  final bool showNextIcon;

  /// Whether to render the mode-toggle pill.
  final bool showModeToggle;

  /// Header styling (colors, padding, text style …).
  final HeaderStyle headerStyle;

  /// Background color of the mode-toggle pill.
  final Color modeToggleActiveColor;

  /// Text color inside the mode-toggle pill.
  final Color modeToggleTextColor;

  /// Corner radius of the mode-toggle pill.
  final double modeToggleBorderRadius;

  /// Custom string builder for the date shown in the header title.
  final StringProvider? dateStringBuilder;

  /// Optional tap handler for the header title (e.g. open a date picker).
  final AsyncCallback? onTitleTap;

  // ─── helpers ────────────────────────────────────────────────────────

  /// Returns a human-readable label for the current mode, displayed
  /// inside the toggle pill ("Full", "Compact", or "Minimal").
  String get _modeLabel {
    switch (currentMode) {
      case ResizableMonthViewMode.monthly:
        return 'Monthly';
      case ResizableMonthViewMode.biWeekly:
        return 'Bi-weekly';
      case ResizableMonthViewMode.weekly:
        return 'Weekly';
      case ResizableMonthViewMode.monthlyScrollable:
        return 'Monthly Scrollable';
    }
  }

  /// Formats [date] for the header title.
  ///
  /// Delegates to the optional [dateStringBuilder]; otherwise falls back
  /// to a simple "month - year" numeric format, localised via
  /// [PackageStrings.localizeNumber].
  String _buildDateString(DateTime date) {
    if (dateStringBuilder != null) return dateStringBuilder!(date);
    return '${PackageStrings.localizeNumber(date.month)} - '
        '${PackageStrings.localizeNumber(date.year)}';
  }

  // ─── build ───────────────────────────────────────────────────────────

  /// Builds the header row containing (left to right):
  /// 1. Previous-navigation arrow (or equal-width spacer if hidden).
  /// 2. Tappable month–year title.
  /// 3. Mode-toggle pill (if [showModeToggle] is `true`).
  /// 4. Next-navigation arrow (or equal-width spacer if hidden).
  ///
  /// The spacers ensure the title stays centred even when one or both
  /// arrows are hidden at the date-range boundaries.
  @override
  Widget build(BuildContext context) {
    final textColor = headerStyle.headerTextStyle?.color ?? Colors.white;
    final arrowColor = headerStyle.leftIconConfig?.color ?? Colors.white;

    return Container(
      decoration: headerStyle.decoration ??
          BoxDecoration(
            color: context.resizableMonthViewColors.headerBackgroundColor,
          ),
      child: Padding(
        padding: headerStyle.headerPadding,
        child: Row(
          mainAxisAlignment: headerStyle.mainAxisAlignment,
          children: [
            // ── Previous arrow ───────────────────────────────────────
            if (showPreviousIcon)
              _ArrowButton(
                icon: Icons.chevron_left,
                color: arrowColor,
                padding: headerStyle.leftIconConfig?.padding ??
                    const EdgeInsets.all(10),
                size: headerStyle.leftIconConfig?.size ?? 30,
                onTap: onPrevious,
              )
            else
              SizedBox(
                width: (headerStyle.leftIconConfig?.size ?? 30) +
                    (headerStyle.leftIconConfig?.padding.horizontal ?? 20),
              ),

            // ── Title ─────────────────────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: onTitleTap != null ? () => onTitleTap!() : null,
                child: Text(
                  _buildDateString(currentDate),
                  textAlign: headerStyle.titleAlign,
                  style: headerStyle.headerTextStyle ??
                      TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
              ),
            ),

            // ── Mode-toggle pill ─────────────────────────────────────
            if (showModeToggle)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: onModeTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: modeToggleActiveColor,
                      borderRadius:
                          BorderRadius.circular(modeToggleBorderRadius),
                    ),
                    child: Text(
                      _modeLabel,
                      style: TextStyle(
                        color: modeToggleTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

            // ── Next arrow ───────────────────────────────────────────
            if (showNextIcon)
              _ArrowButton(
                icon: Icons.chevron_right,
                color: arrowColor,
                padding: headerStyle.rightIconConfig?.padding ??
                    const EdgeInsets.all(10),
                size: headerStyle.rightIconConfig?.size ?? 30,
                onTap: onNext,
              )
            else
              SizedBox(
                width: (headerStyle.rightIconConfig?.size ?? 30) +
                    (headerStyle.rightIconConfig?.padding.horizontal ?? 20),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Private helper ───────────────────────────────────────────────────────

/// Minimal wrapper around [IconButton] used for the previous / next
/// navigation arrows in [ResizableMonthViewHeader].
class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.color,
    required this.padding,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final EdgeInsets padding;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      color: color,
      iconSize: size,
      padding: padding,
      splashRadius: size,
      constraints: const BoxConstraints(),
    );
  }
}
