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
        months: [
          'Enero',
          'Febrero',
          'Marzo',
          'Abril',
          'Mayo',
          'Junio',
          'Julio',
          'Agosto',
          'Septiembre',
          'Octubre',
          'Noviembre',
          'Diciembre',
        ],
        monthsAbbr: [
          'Ene',
          'Feb',
          'Mar',
          'Abr',
          'May',
          'Jun',
          'Jul',
          'Ago',
          'Sep',
          'Oct',
          'Nov',
          'Dic',
        ],
      );

  /// Arabic (العربية) localizations with RTL support
  static CalendarLocalizations get arabic => CalendarLocalizations(
        am: 'ص',
        pm: 'م',
        more: 'المزيد',
        weekdays: ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'],
        months: [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ],
        monthsAbbr: [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ],
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
        months: [
          'Janvier',
          'Février',
          'Mars',
          'Avril',
          'Mai',
          'Juin',
          'Juillet',
          'Août',
          'Septembre',
          'Octobre',
          'Novembre',
          'Décembre',
        ],
        monthsAbbr: [
          'Jan',
          'Fév',
          'Mar',
          'Avr',
          'Mai',
          'Jun',
          'Jul',
          'Aoû',
          'Sep',
          'Oct',
          'Nov',
          'Déc',
        ],
      );

  /// German (Deutsch) localizations
  static CalendarLocalizations get german => CalendarLocalizations(
        am: 'AM',
        pm: 'PM',
        more: 'Mehr',
        weekdays: ['M', 'D', 'M', 'D', 'F', 'S', 'S'],
        months: [
          'Januar',
          'Februar',
          'März',
          'April',
          'Mai',
          'Juni',
          'Juli',
          'August',
          'September',
          'Oktober',
          'November',
          'Dezember',
        ],
        monthsAbbr: [
          'Jan',
          'Feb',
          'Mär',
          'Apr',
          'Mai',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Okt',
          'Nov',
          'Dez',
        ],
      );

  /// Hindi (हिन्दी) localizations with Devanagari numbers
  static CalendarLocalizations get hindi => CalendarLocalizations(
        am: 'पूर्वाह्न',
        pm: 'अपराह्न',
        more: 'अधिक',
        weekdays: ['सो', 'मं', 'बु', 'गु', 'शु', 'श', 'र'],
        months: [
          'जनवरी',
          'फरवरी',
          'मार्च',
          'अप्रैल',
          'मई',
          'जून',
          'जुलाई',
          'अगस्त',
          'सितंबर',
          'अक्टूबर',
          'नवंबर',
          'दिसंबर',
        ],
        monthsAbbr: [
          'जन',
          'फर',
          'मार्च',
          'अप्रै',
          'मई',
          'जून',
          'जुला',
          'अग',
          'सित',
          'अक्टू',
          'नव',
          'दिस',
        ],
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
        months: [
          '一月',
          '二月',
          '三月',
          '四月',
          '五月',
          '六月',
          '七月',
          '八月',
          '九月',
          '十月',
          '十一月',
          '十二月',
        ],
        monthsAbbr: [
          '1月',
          '2月',
          '3月',
          '4月',
          '5月',
          '6月',
          '7月',
          '8月',
          '9月',
          '10月',
          '11月',
          '12月',
        ],
      );

  /// Japanese (日本語) localizations
  static CalendarLocalizations get japanese => CalendarLocalizations(
        am: '午前',
        pm: '午後',
        more: 'もっと',
        weekdays: ['月', '火', '水', '木', '金', '土', '日'],
        months: [
          '1月',
          '2月',
          '3月',
          '4月',
          '5月',
          '6月',
          '7月',
          '8月',
          '9月',
          '10月',
          '11月',
          '12月',
        ],
        monthsAbbr: [
          '1月',
          '2月',
          '3月',
          '4月',
          '5月',
          '6月',
          '7月',
          '8月',
          '9月',
          '10月',
          '11月',
          '12月',
        ],
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

  /// Converts [number] to a string using the current locale's localized
  /// digits.
  ///
  /// Works for integers of any magnitude — days, months, hours and large
  /// values such as years are all localized (e.g. `2026` -> `"٢٠٢٦"` for the
  /// Arabic locale). Delegates to [localizeNumberString].
  static String localizeNumber(int number) =>
      localizeNumberString(number.toString());

  /// Replaces every Western digit (`0`-`9`) in [input] with the current
  /// locale's localized digit, taken from [CalendarLocalizations.numbers].
  ///
  /// All other characters — separators (`/`, `:`, `-`), directionality marks,
  /// AM/PM markers and letters — are preserved untouched, so already-formatted
  /// strings (e.g. the output of `intl`'s `DateFormat`) can be localized in
  /// place. When the current locale does not define a digit set (i.e. it uses
  /// Western digits, like English), [input] is returned unchanged.
  ///
  /// This is the single source of truth for digit localization across the
  /// package and is unaffected by the magnitude of the number, unlike a fixed
  /// lookup table.
  static String localizeNumberString(String input) {
    final numbers = currentLocale.numbers;

    // Locale uses Western digits (or defines no digit set) — nothing to map.
    if (numbers == null || numbers.length < 10) {
      return input;
    }

    return input.replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => numbers[int.parse(match[0]!)],
    );
  }
}
