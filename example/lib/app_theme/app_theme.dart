import 'package:calendar_view/src/app_colors_extension.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme =
      ThemeData.light().copyWith(extensions: [_lightThemeExtension]);
  static final darkTheme =
      ThemeData.light().copyWith(extensions: [_darkThemeExtension]);

  static final _lightThemeExtension = AppColorsExtension(
    primaryColor: const Color(0xff555a92),
    onPrimaryColor: const Color(0xff10144b),
    surfaceColor: const Color(0xfffbf8ff),
    onSurfaceColor: const Color(0xff1b1b21),
  );

  static final _darkThemeExtension = AppColorsExtension(
    primaryColor: const Color(0xffbec2ff),
    onPrimaryColor: const Color(0xff272b60),
    surfaceColor: const Color(0xff131318),
    onSurfaceColor: const Color(0xffe4e1e9),
  );
}
