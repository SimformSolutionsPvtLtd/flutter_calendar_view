import 'package:flutter/material.dart';

/// Settings for hour lines
class HourIndicatorSettings {
  final double height;
  final Color color;
  final double offset;

  /// Settings for hour lines
  const HourIndicatorSettings({
    this.height = 1.0,
    this.offset = 0.0,
    this.color = Colors.grey,
  }) : assert(height >= 0, "Height must be greater than or equal to 0.");

  factory HourIndicatorSettings.none() => HourIndicatorSettings(
        color: Colors.transparent,
        height: 0.0,
      );
}
