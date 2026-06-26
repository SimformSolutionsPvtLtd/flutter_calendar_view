import 'package:calendar_view/calendar_view.dart';
import 'package:example/constants.dart';
import 'package:example/theme/app_colors.dart';
import 'package:example/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

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
      borderSide: BorderSide(width: 2, color: AppColors.light.outline),
    ),
    focusedErrorBorder: AppConstants.inputBorder,
    hintStyle: const TextStyle(color: AppColors.black, fontSize: 17),
    labelStyle: const TextStyle(color: AppColors.black, fontSize: 17),
    helperStyle: const TextStyle(color: AppColors.black, fontSize: 17),
    errorStyle: const TextStyle(color: AppColors.red, fontSize: 12),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  );

  // Light colors — calendar view themes are wired from AppColors.light so the
  // brand/header colors stay in sync with the app chrome (single source).
  static final _appLightTheme = AppThemeExtension.light();
  static final _monthViewTheme = MonthViewThemeData.light().copyWith(
    headerBackgroundColor: AppColors.light.primary,
    cellHighlightColor: AppColors.light.primary,
    headerIconColor: AppColors.light.onPrimary,
    headerTextColor: AppColors.light.onPrimary,
  );
  static final _dayViewTheme = DayViewThemeData.light().copyWith(
    liveIndicatorColor: AppColors.light.primary,
    hourLineColor: AppColors.light.primary,
    headerBackgroundColor: AppColors.light.primary,
    headerIconColor: AppColors.light.onPrimary,
    headerTextColor: AppColors.light.onPrimary,
  );
  static final _weekViewTheme = WeekViewThemeData.light().copyWith(
    liveIndicatorColor: AppColors.light.primary,
    headerBackgroundColor: AppColors.light.primary,
    headerIconColor: AppColors.light.onPrimary,
    headerTextColor: AppColors.light.onPrimary,
  );
  static final _multiDayViewTheme = MultiDayViewThemeData.light().copyWith(
    liveIndicatorColor: AppColors.light.primary,
    headerBackgroundColor: AppColors.light.primary,
    headerIconColor: AppColors.light.onPrimary,
    headerTextColor: AppColors.light.onPrimary,
  );
  static final _scheduleViewTheme = ScheduleViewThemeData.light().copyWith(
    todayHighlightColor: AppColors.light.primary,
    todayTextColor: AppColors.light.onPrimary,
  );

  // Dark colors — same wiring, from AppColors.dark.
  static final _appDarkTheme = AppThemeExtension.dark();
  static final _monthViewDarkTheme = MonthViewThemeData.dark().copyWith(
    headerBackgroundColor: AppColors.dark.primary,
    cellHighlightColor: AppColors.dark.primary,
    headerIconColor: AppColors.dark.onPrimary,
    headerTextColor: AppColors.dark.onPrimary,
  );
  static final _dayViewDarkTheme = DayViewThemeData.dark().copyWith(
    liveIndicatorColor: AppColors.dark.primary,
    hourLineColor: AppColors.dark.primary,
    headerBackgroundColor: AppColors.dark.primary,
    headerIconColor: AppColors.dark.onPrimary,
    headerTextColor: AppColors.dark.onPrimary,
  );
  static final _weekViewDarkTheme = WeekViewThemeData.dark().copyWith(
    liveIndicatorColor: AppColors.dark.primary,
    headerBackgroundColor: AppColors.dark.primary,
    headerIconColor: AppColors.dark.onPrimary,
    headerTextColor: AppColors.dark.onPrimary,
  );
  static final _multiDayViewDarkTheme = MultiDayViewThemeData.dark().copyWith(
    liveIndicatorColor: AppColors.dark.primary,
    headerBackgroundColor: AppColors.dark.primary,
    headerIconColor: AppColors.dark.onPrimary,
    headerTextColor: AppColors.dark.onPrimary,
  );
  static final _scheduleViewDarkTheme = ScheduleViewThemeData.dark().copyWith(
    todayHighlightColor: AppColors.dark.primary,
    todayTextColor: AppColors.dark.onPrimary,
  );

  // Light theme
  static final light = ThemeData.light().copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.light.primary,
        foregroundColor: AppColors.light.onPrimary,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.light.primary,
    ),
    inputDecorationTheme: baseInputDecorationTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light.primary,
      foregroundColor: AppColors.light.onPrimary,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((_) => AppColors.light.primary),
    ),
    extensions: [
      _appLightTheme,
      _scheduleViewTheme,
      _monthViewTheme,
      _dayViewTheme,
      _weekViewTheme,
      _multiDayViewTheme,
    ],
  );

  // Dark theme
  static final dark = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark.primary,
      foregroundColor: AppColors.dark.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dark.primary,
        foregroundColor: AppColors.dark.onPrimary,
      ),
    ),
    inputDecorationTheme: baseInputDecorationTheme.copyWith(
      border: AppConstants.inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: AppColors.dark.outlineVariant),
      ),
      disabledBorder: AppConstants.inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: AppColors.dark.outlineVariant),
      ),
      enabledBorder: AppConstants.inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: AppColors.dark.outlineVariant),
      ),
      focusedBorder: AppConstants.inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: AppColors.dark.outline),
      ),
      focusedErrorBorder: AppConstants.inputBorder.copyWith(
        borderSide: BorderSide(width: 2, color: AppColors.red),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.dark.primary,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((_) => AppColors.dark.primary),
    ),

    extensions: [
      _appDarkTheme,
      _monthViewDarkTheme,
      _dayViewDarkTheme,
      _weekViewDarkTheme,
      _multiDayViewDarkTheme,
      _scheduleViewDarkTheme,
    ],
  );
}
