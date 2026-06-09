import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    required this.primary,
    required this.onPrimary,
    required this.outlineVariant,
    required this.transparent,
    required this.backgroundColor,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
  });

  // Light theme constructor
  AppThemeExtension.light()
    : primary = AppColors.light.primary,
      onPrimary = AppColors.light.onPrimary,
      outlineVariant = AppColors.light.outlineVariant,
      transparent = AppColors.transparent,
      backgroundColor = AppColors.light.background,
      surface = AppColors.light.surface,
      onSurface = AppColors.light.onSurface,
      onSurfaceVariant = AppColors.light.onSurfaceVariant;

  // Dark theme constructor
  AppThemeExtension.dark()
    : primary = AppColors.dark.primary,
      onPrimary = AppColors.dark.onPrimary,
      outlineVariant = AppColors.dark.outlineVariant,
      transparent = AppColors.transparent,
      backgroundColor = AppColors.dark.background,
      surface = AppColors.dark.surface,
      onSurface = AppColors.dark.onSurface,
      onSurfaceVariant = AppColors.dark.onSurfaceVariant;

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
