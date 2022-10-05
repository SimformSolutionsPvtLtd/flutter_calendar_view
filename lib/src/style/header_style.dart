import 'package:flutter/material.dart';

import '../constants.dart';

/// Class for styling Calendar's header.
class HeaderStyle {
  /// Provide text style for calendar's header.
  final TextStyle? headerTextStyle;

  /// Widget used for left icon.
  ///
  /// Tapping on it will navigate to previous calendar page.
  final Widget leftIcon;

  /// Widget used for right icon.
  ///
  /// Tapping on it will navigate to next calendar page.
  final Widget rightIcon;

  /// Determines left icon visibility.
  final bool leftIconVisible;

  /// Determines right icon visibility.
  final bool rightIconVisible;

  /// Internal padding of the whole header.
  final EdgeInsets headerPadding;

  /// External margin of the whole header.
  final EdgeInsets headerMargin;

  /// Internal padding of left icon.
  final EdgeInsets leftIconPadding;

  /// Internal padding of right icon.
  final EdgeInsets rightIconPadding;

  /// Define Alignment of header text.
  final TextAlign titleAlign;

  /// Decoration of whole header.
  final BoxDecoration decoration;

  /// Create a `HeaderStyle` of calendar view
  const HeaderStyle({
    this.headerTextStyle,
    this.leftIcon = const Icon(Icons.chevron_left, size: 30),
    this.rightIcon = const Icon(Icons.chevron_right, size: 30),
    this.leftIconVisible = true,
    this.rightIconVisible = true,
    this.headerMargin = EdgeInsets.zero,
    this.headerPadding = EdgeInsets.zero,
    this.leftIconPadding = const EdgeInsets.all(10),
    this.rightIconPadding = const EdgeInsets.all(10),
    this.titleAlign = TextAlign.center,
    this.decoration = const BoxDecoration(color: Constants.headerBackground),
  });
}
