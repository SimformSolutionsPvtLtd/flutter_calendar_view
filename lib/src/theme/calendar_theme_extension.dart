import 'package:flutter/material.dart';

import 'dark_app_colors.dart';
import 'light_app_colors.dart';

/// Contains global colors which applies to month-view, day-view & week-view components.
class CalendarThemeExtension extends ThemeExtension<CalendarThemeExtension> {
  CalendarThemeExtension({
    required this.timelineText,
  });

  final Color timelineText;

  // Light theme constructor
  CalendarThemeExtension.light() : timelineText = LightAppColors.onSurface;

  // Dark theme constructor
  CalendarThemeExtension.dark() : timelineText = DarkAppColors.onSurface;

  @override
  ThemeExtension<CalendarThemeExtension> copyWith({
    Color? timelineText,
  }) {
    return CalendarThemeExtension(
      timelineText: timelineText ?? this.timelineText,
    );
  }

  @override
  ThemeExtension<CalendarThemeExtension> lerp(
    covariant ThemeExtension<CalendarThemeExtension>? other,
    double t,
  ) {
    if (other is! CalendarThemeExtension) {
      return this;
    }
    return CalendarThemeExtension(
      timelineText:
          Color.lerp(timelineText, other.timelineText, t) ?? timelineText,
    );
  }
}
