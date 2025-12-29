import 'package:calendar_view/calendar_view.dart';

/// Provides localization data for the calendar package
class CalendarLocales {
  /// Spanish (es) localizations
  static CalendarLocalizations get spanish => CalendarLocalizations(
        am: 'a. m.',
        pm: 'p. m.',
        more: 'Más',
        weekdays: ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
      );

  /// Arabic (ar) localizations
  static CalendarLocalizations get arabic => CalendarLocalizations.fromMap({
        'am': 'ص',
        'pm': 'م',
        'more': 'المزيد',
        'weekdays': [
          'الاثنين',
          'الثلاثاء',
          'الأربعاء',
          'الخميس',
          'الجمعة',
          'السبت',
          'الأحد'
        ],
        'numbers': ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
        'isRTL': true,
      });

  /// Initialize and register all supported calendar localizations
  static void initialize() {
    // Register all custom localizations
    PackageStrings.addLocaleObject('es', spanish);
    PackageStrings.addLocaleObject('ar', arabic);

    // Set the initial locale
    PackageStrings.setLocale(PackageStrings.selectedLocale);
  }
}
