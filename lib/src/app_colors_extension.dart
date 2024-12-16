import 'package:flutter/material.dart';

// Define all required colors
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  final Color primaryColor;
  final Color onPrimaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primaryColor,
    Color? onPrimaryColor,
    Color? surfaceColor,
    Color? onSurfaceColor,
  }) {
    return AppColorsExtension(
      primaryColor: primaryColor ?? this.primaryColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<ThemeExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      onPrimaryColor: Color.lerp(onPrimaryColor, other.onPrimaryColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
    );
  }
}
