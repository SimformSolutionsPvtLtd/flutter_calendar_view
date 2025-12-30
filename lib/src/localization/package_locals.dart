import '../../calendar_view.dart';

class PackageStrings {
  static final Map<String, CalendarLocalizations> _localeObjects = {
    'en': CalendarLocalizations.en,
    'es': spanish,
    'ar': arabic,
    'fr': french,
    'de': german,
    'hi': hindi,
    'zh': chinese,
    'ja': japanese,
  };

  static String _currentLocale = 'en';

  // Common language localizations

  /// Spanish (Español) localizations
  static CalendarLocalizations get spanish => CalendarLocalizations(
        am: 'a. m.',
        pm: 'p. m.',
        more: 'Más',
        weekdays: ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
      );

  /// Arabic (العربية) localizations with RTL support
  static CalendarLocalizations get arabic => CalendarLocalizations(
        am: 'ص',
        pm: 'م',
        more: 'المزيد',
        weekdays: ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'],
        numbers: [
          '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩', // 0-9
          '١٠', '١١', '١٢', '١٣', '١٤', '١٥', '١٦', '١٧', '١٨', '١٩', // 10-19
          '٢٠', '٢١', '٢٢', '٢٣', '٢٤', '٢٥', '٢٦', '٢٧', '٢٨', '٢٩', // 20-29
          '٣٠', '٣١', '٣٢', '٣٣', '٣٤', '٣٥', '٣٦', '٣٧', '٣٨', '٣٩', // 30-39
          '٤٠', '٤١', '٤٢', '٤٣', '٤٤', '٤٥', '٤٦', '٤٧', '٤٨', '٤٩', // 40-49
          '٥٠', '٥١', '٥٢', '٥٣', '٥٤', '٥٥', '٥٦', '٥٧', '٥٨', '٥٩', // 50-59
          '٦٠', // 60
        ],
        isRTL: true,
      );

  /// French (Français) localizations
  static CalendarLocalizations get french => CalendarLocalizations(
        am: 'AM',
        pm: 'PM',
        more: 'Plus',
        weekdays: ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
      );

  /// German (Deutsch) localizations
  static CalendarLocalizations get german => CalendarLocalizations(
        am: 'AM',
        pm: 'PM',
        more: 'Mehr',
        weekdays: ['M', 'D', 'M', 'D', 'F', 'S', 'S'],
      );

  /// Hindi (हिन्दी) localizations with Devanagari numbers
  static CalendarLocalizations get hindi => CalendarLocalizations(
        am: 'पूर्वाह्न',
        pm: 'अपराह्न',
        more: 'अधिक',
        weekdays: ['सो', 'मं', 'बु', 'गु', 'शु', 'श', 'र'],
        numbers: [
          '०', '१', '२', '३', '४', '५', '६', '७', '८', '९', // 0-9
          '१०', '११', '१२', '१३', '१४', '१५', '१६', '१७', '१८', '१९', // 10-19
          '२०', '२१', '२२', '२३', '२४', '२५', '२६', '२७', '२८', '२९', // 20-29
          '३०', '३१', '३२', '३३', '३४', '३५', '३६', '३७', '३८', '३९', // 30-39
          '४०', '४१', '४२', '४३', '४४', '४५', '४६', '४७', '४८', '४९', // 40-49
          '५०', '५१', '५२', '५३', '५४', '५५', '५६', '५७', '५८', '५९', // 50-59
          '६०', // 60
        ],
      );

  /// Chinese Simplified (简体中文) localizations
  static CalendarLocalizations get chinese => CalendarLocalizations(
        am: '上午',
        pm: '下午',
        more: '更多',
        weekdays: ['一', '二', '三', '四', '五', '六', '日'],
      );

  /// Japanese (日本語) localizations
  static CalendarLocalizations get japanese => CalendarLocalizations(
        am: '午前',
        pm: '午後',
        more: 'もっと',
        weekdays: ['月', '火', '水', '木', '金', '土', '日'],
      );

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

  /// Converts any integer (0-60) to a localized string using current locale's numbers.
  ///
  /// If the locale has a numbers array with at least 61 elements (0-60),
  /// it will return the localized representation directly from the array.
  /// Otherwise, it returns the number as a string.
  static String localizeNumber(int number) {
    final numbers = currentLocale.numbers;

    // Check if numbers array is available and has enough elements
    if (numbers == null || numbers.length < 61) {
      return number.toString();
    }

    // Validate range (0-60 for calendar usage)
    if (number < 0 || number > 60) {
      return number.toString();
    }

    // Return the localized number directly from the array
    return numbers[number];
  }
}
