import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class LocaleController extends InheritedNotifier<ValueNotifier<String>> {
  LocaleController({
    required Widget child,
    required String initialLocale,
    Key? key,
  }) : super(
         key: key,
         child: child,
         notifier: ValueNotifier<String>(initialLocale),
       );

  static LocaleController of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<LocaleController>();
    assert(result != null, 'No LocaleController found in context');
    return result!;
  }

  String get currentLocale => notifier!.value;

  void setLocale(String locale) {
    PackageStrings.setLocale(locale);
    notifier!.value = locale;
  }
}
