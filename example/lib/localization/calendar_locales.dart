import 'package:calendar_view/calendar_view.dart';

/// Provides localization data for the calendar package
///
/// This example shows how to use built-in localizations from PackageStrings.
/// The package includes built-in support for: English, Spanish, Arabic, French,
/// German, Hindi, Chinese, and Japanese.
class CalendarLocales {
  /// Override built-in Spanish with full weekday names
  static CalendarLocalizations get spanish => CalendarLocalizations(
    am: PackageStrings.spanish.am,
    pm: PackageStrings.spanish.pm,
    more: 'Ver más',
    weekdays: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
  );

  /// Initialize and register calendar localizations
  ///
  /// This example demonstrates overriding built-in localizations
  static void initialize() {
    // Override built-in Spanish with full weekday names
    PackageStrings.addLocaleObject('es', spanish);

    // You can also add completely new languages:
    // PackageStrings.addLocaleObject('pt', portugueseLocale);

    // Set the initial locale (optional, defaults to 'en')
    PackageStrings.setLocale(PackageStrings.selectedLocale);
  }
}
