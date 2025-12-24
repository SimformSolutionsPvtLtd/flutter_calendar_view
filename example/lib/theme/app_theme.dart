import 'package:calendar_view/calendar_view.dart';
import 'package:example/constants.dart';
import 'package:example/theme/app_colors.dart';
import 'package:example/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'dark_app_colors.dart';

class AppTheme {
  // Base InputDecorationTheme
  static final baseInputDecorationTheme = InputDecorationTheme(
    border: AppConstants.inputBorder,
    disabledBorder: AppConstants.inputBorder,
    errorBorder: AppConstants.inputBorder.copyWith(
      borderSide: const BorderSide(width: 2, color: AppColors.red),
    ),
    enabledBorder: AppConstants.inputBorder,
    focusedBorder: AppConstants.inputBorder.copyWith(
      borderSide: const BorderSide(width: 2, color: AppColors.outline),
    ),
    focusedErrorBorder: AppConstants.inputBorder,
    hintStyle: const TextStyle(color: AppColors.black, fontSize: 17),
    labelStyle: const TextStyle(color: AppColors.black, fontSize: 17),
    helperStyle: const TextStyle(color: AppColors.black, fontSize: 17),
    errorStyle: const TextStyle(color: AppColors.red, fontSize: 12),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  );

  // Light colors
  static final _dayViewTheme = DayViewThemeData.light();
  static final _weekViewTheme = WeekViewThemeData.light();
  static final _multiDayViewTheme = MultiDayViewThemeData.light();

  // Dark colors
  static final _appDarkTheme = AppThemeExtension.dark();
  static final _monthViewDarkTheme = MonthViewThemeData.dark();
  static final _dayViewDarkTheme = DayViewThemeData.dark();
  static final _weekViewDarkTheme = WeekViewThemeData.dark();
  static final _multiDayViewDarkTheme = MultiDayViewThemeData.dark();

  // Light theme
  static final light = ThemeData.light().copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),
    inputDecorationTheme: baseInputDecorationTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((_) => AppColors.primary),
    ),
    extensions: [_dayViewTheme, _weekViewTheme, _multiDayViewTheme],
  );

  // Dark theme
  static final dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkAppColors.primary,
      foregroundColor: DarkAppColors.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkAppColors.primary,
        foregroundColor: DarkAppColors.onPrimary,
      ),
    ),
    inputDecorationTheme: baseInputDecorationTheme.copyWith(
      disabledBorder: AppConstants.inputBorder.copyWith(
        borderSide: const BorderSide(
          width: 2,
          color: DarkAppColors.outlineVariant,
        ),
      ),
      enabledBorder: AppConstants.inputBorder.copyWith(
        borderSide: const BorderSide(
          width: 2,
          color: DarkAppColors.outlineVariant,
        ),
      ),
      focusedBorder: AppConstants.inputBorder.copyWith(
        borderSide: const BorderSide(width: 2, color: DarkAppColors.outline),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DarkAppColors.primary,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((_) => DarkAppColors.primary),
    ),
    // TODO(Shubham): Test dark theme update
    extensions: [
      _appDarkTheme,
      _monthViewDarkTheme,
      _dayViewDarkTheme,
      _weekViewDarkTheme,
      _multiDayViewDarkTheme,
    ],
  );
}
