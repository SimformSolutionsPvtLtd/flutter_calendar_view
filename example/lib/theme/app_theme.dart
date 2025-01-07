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
      borderSide: const BorderSide(
        width: 2,
        color: AppColors.red,
      ),
    ),
    enabledBorder: AppConstants.inputBorder,
    focusedBorder: AppConstants.inputBorder.copyWith(
      borderSide: const BorderSide(
        width: 2,
        color: AppColors.outline,
      ),
    ),
    focusedErrorBorder: AppConstants.inputBorder,
    hintStyle: const TextStyle(
      color: AppColors.black,
      fontSize: 17,
    ),
    labelStyle: const TextStyle(
      color: AppColors.black,
      fontSize: 17,
    ),
    helperStyle: const TextStyle(
      color: AppColors.black,
      fontSize: 17,
    ),
    errorStyle: const TextStyle(
      color: AppColors.red,
      fontSize: 12,
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 20,
    ),
  );

  // Light colors
  static final _lightAppColors = CalendarThemeExtension.light();
  static final _dayViewTheme = DayViewTheme.light().copyWith(
    halfHourLine: Colors.red,
  );
  static final _appTheme = AppThemeExtension.light();

  // Dark colors
  static final _appDarkTheme = AppThemeExtension.dark();
  static final _calendarDarkTheme = CalendarThemeExtension.dark();
  static final _monthViewDarkTheme = MonthViewTheme.dark();
  static final _dayViewDarkTheme = DayViewTheme.dark();
  static final _weekViewDarkTheme = WeekViewTheme.dark();

  // Light theme
  static final light = CalendarTheme.light.copyWith(
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
      fillColor: WidgetStateColor.resolveWith(
        (_) => AppColors.primary,
      ),
    ),
    extensions: [
      _appTheme,
      _lightAppColors,
      _dayViewTheme,
    ],
  );

  // Dark theme
  static final dark = CalendarTheme.dark.copyWith(
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
        borderSide: const BorderSide(
          width: 2,
          color: DarkAppColors.outline,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DarkAppColors.primary,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith(
        (_) => DarkAppColors.primary,
      ),
    ),
    // TODO(Shubham): Test dark theme update
    // extensions:
    extensions: [
      _appDarkTheme,
      _calendarDarkTheme,
      _monthViewDarkTheme,
      _dayViewDarkTheme,
      _weekViewDarkTheme,
    ],
  );
}
