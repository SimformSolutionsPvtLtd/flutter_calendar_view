import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'dark_app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    this.primary = AppColors.primary,
    this.onPrimary = AppColors.onPrimary,
    this.outlineVariant = AppColors.outlineVariant,
    this.transparent = AppColors.transparent,
    this.backgroundColor = AppColors.background,
    this.surface = AppColors.surface,
    this.onSurface = AppColors.onSurface,
    this.onSurfaceVariant = AppColors.onSurfaceVariant,
  });

  // Light theme constructor
  AppThemeExtension.light()
    : primary = AppColors.primary,
      onPrimary = AppColors.onPrimary,
      outlineVariant = AppColors.outlineVariant,
      transparent = AppColors.transparent,
      backgroundColor = AppColors.background,
      surface = AppColors.surface,
      onSurface = AppColors.onSurface,
      onSurfaceVariant = AppColors.onSurfaceVariant;

  // Dark theme constructor
  AppThemeExtension.dark()
    : primary = DarkAppColors.primary,
      onPrimary = DarkAppColors.onPrimary,
      outlineVariant = DarkAppColors.outlineVariant,
      transparent = DarkAppColors.transparent,
      backgroundColor = DarkAppColors.background,
      surface = DarkAppColors.surface,
      onSurface = DarkAppColors.onSurface,
      onSurfaceVariant = DarkAppColors.onSurfaceVariant;

  final Color primary;
  final Color onPrimary;
  final Color outlineVariant;
  final Color transparent;
  final Color backgroundColor;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? outlineVariant,
    Color? transparent,
    Color? backgroundColor,
    Color? surface,
    Color? onSurface,
    Color? onSurfaceVariant,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      transparent: transparent ?? this.transparent,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
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
      transparent: Color.lerp(transparent, other.transparent, t) ?? transparent,
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t) ??
          onSurfaceVariant,
    );
  }
}
