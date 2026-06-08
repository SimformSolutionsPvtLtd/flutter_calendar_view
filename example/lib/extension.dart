import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'enumerations.dart';
import 'event_types.dart';
import 'l10n/app_localizations.dart';
import 'localization/locale_controller.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme_extension.dart';

enum TimeStampFormat { parse_12, parse_24 }

extension NavigatorExtention on BuildContext {
  Future<T?> pushRoute<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (context) => page));

  void pop([dynamic value]) => Navigator.of(this).pop(value);

  void showSnackBarWithText(
    String text, {
    Duration duration = const Duration(seconds: 3),
  }) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: duration));
}

// TODO(Lavi): Refactor this as a getter of [Months] after upgrading dart version
extension MonthHeaderImageExtension on Months {
  /// Returns the asset path for this month's header image.
  String get imagePath {
    const paths = [
      'assets/images/january_header.jpg',
      'assets/images/february_header.jpg',
      'assets/images/march_header.jpg',
      'assets/images/april_header.jpg',
      'assets/images/may_header.jpg',
      'assets/images/june_header.jpg',
      'assets/images/july_header.jpg',
      'assets/images/august_header.jpg',
      'assets/images/september_header.jpg',
      'assets/images/october_header.jpg',
      'assets/images/november_header.jpg',
      'assets/images/december_header.jpg',
    ];
    return paths[index];
  }
}

/// Reads the [EventType] back off an event's generic payload.
///
/// Returns `null` when the event carries no [EventMetadata] (e.g. events
/// created before this feature, or seeded without a type).
extension EventTypeAccess<T> on CalendarEventData<T> {
  EventType? get eventType {
    final payload = event;
    return payload is EventMetadata ? payload.type : null;
  }
}

// TODO(Lavi): Refactor this as a getter to [EventType] after upgrading dart version
/// Localized display label for each type, mirroring the example's
/// `context.translate.<key>` pattern.
extension EventTypeLabel on EventType {
  String label(AppLocalizations translate) {
    switch (this) {
      case EventType.event:
        return translate.eventTypeEvent;
      case EventType.birthday:
        return translate.eventTypeBirthday;
      case EventType.task:
        return translate.eventTypeTask;
      case EventType.outOfOffice:
        return translate.eventTypeOutOfOffice;
      case EventType.meeting:
        return translate.eventTypeMeeting;
      case EventType.reminder:
        return translate.eventTypeReminder;
    }
  }

  /// A realistic default description prefilled on the create-event form when
  /// this type is selected. [EventType.event] carries no preset, so it returns
  /// `null` and leaves the description field empty.
  String? description(AppLocalizations translate) {
    switch (this) {
      case EventType.event:
        return null;
      case EventType.birthday:
        return translate.eventTypeBirthdayDescription;
      case EventType.task:
        return translate.eventTypeTaskDescription;
      case EventType.outOfOffice:
        return translate.eventTypeOutOfOfficeDescription;
      case EventType.meeting:
        return translate.eventTypeMeetingDescription;
      case EventType.reminder:
        return translate.eventTypeReminderDescription;
    }
  }
}

extension DateUtils on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) => DateTime(
    year ?? this.year,
    month ?? this.month,
    day ?? this.day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  String dateToStringWithFormat({String format = 'y-M-d'}) {
    // Localize the digits of the formatted date so non-Latin locales
    // (Arabic, Hindi, …) render their own numerals instead of `0-9`.
    return PackageStrings.localizeNumberString(DateFormat(format).format(this));
  }

  /// Formats the time component, delegating to [TimeOfDayExtension] so both
  /// the digits and the AM/PM marker follow the current package locale.
  String getTimeInFormat(TimeStampFormat format) =>
      TimeOfDay.fromDateTime(this).getTimeInFormat(format);
}

extension ColorExtension on Color {
  /// TODO(Shubham): Update this getter as it uses `computeLuminance()`
  /// which is computationally expensive
  Color get accentColor {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return brightness == Brightness.light ? AppColors.black : AppColors.white;
  }
}

extension TimeOfDayExtension on TimeOfDay {
  /// Formats the time as a localized string (e.g., "2:30 p. m." or "14:30").
  ///
  /// Digits are localized via [PackageStrings.localizeNumberString] and the
  /// AM/PM marker via the current locale's [CalendarLocalizations], so both
  /// follow the locale set through [PackageStrings.setLocale].
  String getTimeInFormat(TimeStampFormat format) {
    final locale = PackageStrings.currentLocale;
    if (format == TimeStampFormat.parse_12) {
      final period = hour >= 12 ? locale.pm : locale.am;
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final minuteStr = minute.toString().padLeft(2, '0');
      // Localize the whole "h:mm" chunk at once to keep the leading zero.
      final time = PackageStrings.localizeNumberString(
        '$displayHour:$minuteStr',
      );
      return '$time $period';
    } else {
      final hourStr = hour.toString().padLeft(2, '0');
      final minuteStr = minute.toString().padLeft(2, '0');
      return PackageStrings.localizeNumberString('$hourStr:$minuteStr');
    }
  }
}

extension BuildContextExtension on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>() ??
      AppThemeExtension.light();
}

extension LocalizedDateExtension on DateTime {
  /// Returns the day-of-month as a localized string, rebuilding the widget
  /// whenever the locale changes via [LocaleController].
  String localizedDay(BuildContext context) {
    LocaleController.of(context);
    return PackageStrings.localizeNumber(day);
  }

  /// Returns the date formatted as a localized short date (e.g. "6/4/2026")
  /// using the current Flutter locale from [context].
  ///
  /// `intl` provides the locale-aware field order and separators (e.g. the
  /// RTL layout for Arabic), but its generic `ar` data carries no native
  /// digits, so the digits are localized afterwards through
  /// [PackageStrings.localizeNumberString] to stay consistent with
  /// [localizedDay].
  String localizedShortDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return PackageStrings.localizeNumberString(
      DateFormat.yMd(locale).format(this),
    );
  }
}

extension Translate on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
