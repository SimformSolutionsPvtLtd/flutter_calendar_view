import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'dark_app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    this.primary = AppColors.primary,
    this.onPrimary = AppColors.onPrimary,
    this.outlineVariant = AppColors.outlineVariant,
  });

  // Light theme constructor
  AppThemeExtension.light()
      : primary = AppColors.primary,
        onPrimary = AppColors.onPrimary,
        outlineVariant = AppColors.outlineVariant;

  // Dark theme constructor
  AppThemeExtension.dark()
      : primary = DarkAppColors.primary,
        onPrimary = DarkAppColors.onPrimary,
        outlineVariant = DarkAppColors.outlineVariant;

  final Color primary;
  final Color onPrimary;
  final Color outlineVariant;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? outlineVariant,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      outlineVariant: outlineVariant ?? this.outlineVariant,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      outlineVariant:
          Color.lerp(outlineVariant, other.outlineVariant, t) ?? outlineVariant,
    );
  }
}
