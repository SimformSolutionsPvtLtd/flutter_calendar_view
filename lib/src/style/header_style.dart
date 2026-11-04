import 'package:flutter/material.dart';

/// Class for styling Calendar's header.
class HeaderStyle {
  /// Provide text style for calendar's header.
  final TextStyle? headerTextStyle;

  /// Internal padding of the whole header.
  final EdgeInsets headerPadding;

  /// External margin of the whole header.
  final EdgeInsets headerMargin;

  /// Define Alignment of header text.
  final TextAlign titleAlign;

  /// Decoration of whole header.
  final BoxDecoration? decoration;

  /// Defines the alignment between components of header.
  final MainAxisAlignment mainAxisAlignment;

  /// Defines how the header should expand horizontally.
  ///
  /// [MainAxisSize.min] -> Shrinks header to the size of it's children.
  /// [MainAxisSize.max] -> Expands header to available horizontal space.
  ///
  /// Defaults to [MainAxisSize.max]
  final MainAxisSize mainAxisSize;

  /// Provides icon style for default left Icon.
  ///
  final IconDataConfig? leftIconConfig;

  /// Provides icon style for default right Icon.
  ///
  final IconDataConfig? rightIconConfig;

  /// Create a `HeaderStyle` of calendar view
  const HeaderStyle({
    this.headerTextStyle,
    this.headerMargin = EdgeInsets.zero,
    this.headerPadding = EdgeInsets.zero,
    this.titleAlign = TextAlign.center,
    this.decoration,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.leftIconConfig = const IconDataConfig(),
    this.rightIconConfig = const IconDataConfig(),
    this.mainAxisSize = MainAxisSize.max,
  });

  /// Create a `HeaderStyle` of calendar view
  ///
  /// Used when you need to use same configs for left and right icons.
  const HeaderStyle.withSameIcons({
    this.headerTextStyle,
    this.headerMargin = EdgeInsets.zero,
    this.headerPadding = EdgeInsets.zero,
    this.titleAlign = TextAlign.center,
    this.decoration,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    IconDataConfig iconConfig = const IconDataConfig(),
    this.mainAxisSize = MainAxisSize.max,
  })  : leftIconConfig = iconConfig,
        rightIconConfig = iconConfig;
}

/// Defines the data for icons used in calendar_view.
class IconDataConfig {
  /// Color of the Icon.
  final Color? color;

  /// Size of the default Icon.
  final double size;

  /// Padding for default icon.
  final EdgeInsets padding;

  // NOTE(parth): We are using builder here. Because in future we are planning
  // To add an `of` static method for CalendarViews.
  // If user is providing this custom icon, developers can call,
  // for ex, MonthView.of(context) using context provided by WidgetBuilder to
  // access the nearest ancestor and call methods exposed by
  // MonthViewState.
  //
  /// Custom icon widget. Keep this null to use default icon if
  /// it's set by package.
  ///
  /// If this icon is passed, it will remove the tap on default icon if set.
  ///
  /// You can still manually implement the functionality provided by default
  /// Icon.
  final WidgetBuilder? icon;

  /// Defines the data for icons used in calendar_view.
  const IconDataConfig({
    this.color,
    this.size = 30,
    this.padding = const EdgeInsets.all(10),
    this.icon,
  });
}
