import '../../calendar_view.dart';

class PackageStrings {
  static final Map<String, CalendarLocalizations> _localeObjects = {
    'en': CalendarLocalizations.en,
  };

  static String _currentLocale = 'en';

  /// Set the current locale for the package strings (e.g., 'en', 'es').
  static void setLocale(String locale) {
    assert(_localeObjects.containsKey(locale),
        'Locale "$locale" not found. Please add it using PackageStrings.addLocaleObject("$locale", CalendarLocalizations(...)) before setting.');
    if (_localeObjects.containsKey(locale)) {
      _currentLocale = locale;
    }
  }

  /// Allow developers to add or override locales at runtime using a class
  static void addLocaleObject(String locale, CalendarLocalizations localeObj) {
    _localeObjects[locale] = localeObj;
  }

  static CalendarLocalizations get currentLocale =>
      _localeObjects[_currentLocale] ?? CalendarLocalizations.en;

  static String get selectedLocale => _currentLocale;

  /// Converts any integer to a localized string using current locale's numbers.
  static String localizeNumber(int number) {
    final numbers = currentLocale.numbers;
    final str = number.toString();
    if (numbers == null || numbers.length < 10) return str;
    return str.split('').map((d) {
      final idx = int.tryParse(d);
      return idx != null ? numbers[idx] : d;
    }).join();
  }
}
