// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'enumerations.dart';
import 'typedefs.dart';

/// Settings for hour lines
class HourIndicatorSettings {
  final double height;
  final Color color;
  final double offset;
  final LineStyle lineStyle;
  final double dashWidth;
  final double dashSpaceWidth;
  final int startHour;

  /// Settings for hour lines
  const HourIndicatorSettings(
      {this.height = 1.0,
      this.offset = 0.0,
      this.color = Colors.grey,
      this.lineStyle = LineStyle.solid,
      this.dashWidth = 4,
      this.dashSpaceWidth = 4,
      this.startHour = 0})
      : assert(height >= 0, "Height must be greater than or equal to 0.");

  factory HourIndicatorSettings.none() => HourIndicatorSettings(
        color: Colors.transparent,
        height: 0.0,
      );
}

/// Settings for live time line
class LiveTimeIndicatorSettings {
  /// Color of time indicator.
  final Color color;

  /// Height of time indicator.
  final double height;

  /// offset of time indicator.
  final double offset;

  /// StringProvider for time string
  final StringProvider? timeStringBuilder;

  /// Flag to show bullet at left side or not.
  final bool showBullet;

  /// Flag to show time on live time line.
  final bool showTime;

  /// Flag to show time backgroud view.
  final bool showTimeBackgroundView;

  /// Radius of bullet.
  final double bulletRadius;

  /// Width of time backgroud view.
  final double timeBackgroundViewWidth;

  /// Settings for live time line
  const LiveTimeIndicatorSettings({
    this.height = 1.0,
    this.offset = 5.0,
    this.color = Colors.grey,
    this.timeStringBuilder,
    this.showBullet = true,
    this.showTime = false,
    this.showTimeBackgroundView = false,
    this.bulletRadius = 5.0,
    this.timeBackgroundViewWidth = 60.0,
  }) : assert(height >= 0, "Height must be greater than or equal to 0.");

  factory LiveTimeIndicatorSettings.none() => LiveTimeIndicatorSettings(
        color: Colors.transparent,
        height: 0.0,
        offset: 0.0,
        showBullet: false,
      );
}
