import 'package:flutter/material.dart';

class ThemeController extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  ThemeController({
    required Widget child,
    required ValueNotifier<ThemeMode> notifier,
    Key? key,
  }) : super(key: key, child: child, notifier: notifier);

  static ThemeController of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<ThemeController>();
    assert(result != null, 'No ThemeController found in context');
    return result!;
  }

  ThemeMode get themeMode => notifier!.value;

  void setThemeMode(ThemeMode mode) => notifier!.value = mode;
}
