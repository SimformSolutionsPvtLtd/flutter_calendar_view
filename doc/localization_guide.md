# Localization Guide

This guide explains how to enable and configure localization in the `calendar_view` package to support multiple languages in your Flutter application.

## Overview

The package provides a flexible localization system that allows you to:

- Display calendar strings (AM/PM, weekday names, etc.) in different languages
- Support right-to-left (RTL) layouts for languages like Arabic and Hebrew
- Customize number formatting for different locales
- Dynamically switch between languages at runtime

## Built-in Language Support

The package includes **8 pre-configured languages** out of the box:

| Language | Code | RTL | Localized Numbers |
|----------|------|-----|-------------------|
| English | `en` | No | No |
| Spanish (Español) | `es` | No | No |
| Arabic (العربية) | `ar` | Yes | Yes (٠-٩) |
| French (Français) | `fr` | No | No |
| German (Deutsch) | `de` | No | No |
| Hindi (हिन्दी) | `hi` | No | Yes (०-९) |
| Chinese (简体中文) | `zh` | No | No |
| Japanese (日本語) | `ja` | No | No |

You can use these built-in languages directly without any configuration!

## Quick Start

### Using Built-in Languages

```dart
import 'package:calendar_view/calendar_view.dart';

void main() {
  // Switch to Spanish
  PackageStrings.setLocale('es');

  // Switch to Arabic (includes RTL and Arabic numerals)
  PackageStrings.setLocale('ar');

  // Switch to Hindi (includes Devanagari numerals)
  PackageStrings.setLocale('hi');

  runApp(MyApp());
}
```

### Adding Custom Languages

If you need a language that isn't built-in, you can easily add it:

```dart
import 'package:calendar_view/calendar_view.dart';

void main() {
  // Add Portuguese
  PackageStrings.addLocaleObject(
    'pt',
    CalendarLocalizations(
      am: 'AM',
      pm: 'PM',
      more: 'Mais',
      weekdays: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'],
    ),
  );

  // Add Russian
  PackageStrings.addLocaleObject(
    'ru',
    CalendarLocalizations(
      am: 'ДП',
      pm: 'ПП',
      more: 'Ещё',
      weekdays: ['П', 'В', 'С', 'Ч', 'П', 'С', 'В'],
    ),
  );

  // Switch to custom language
  PackageStrings.setLocale('pt');

  runApp(MyApp());
}
```

### Overriding Built-in Languages

You can override any built-in language with custom values:

```dart
// Override the built-in Spanish with full weekday names
PackageStrings.addLocaleObject(
  'es',
  CalendarLocalizations(
    am: 'a. m.',
    pm: 'p. m.',
    more: 'Ver más',
    weekdays: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
  ),
);

PackageStrings.setLocale('es');
```

### Accessing Built-in Localizations

You can access built-in localizations directly from `PackageStrings`:

```dart
CalendarLocalizations spanish = PackageStrings.spanish;
CalendarLocalizations arabic = PackageStrings.arabic;
CalendarLocalizations french = PackageStrings.french;
CalendarLocalizations german = PackageStrings.german;
CalendarLocalizations hindi = PackageStrings.hindi;
CalendarLocalizations chinese = PackageStrings.chinese;
CalendarLocalizations japanese = PackageStrings.japanese;

// Use them directly or customize them
PackageStrings.addLocaleObject('es-custom', spanish);
```

```dart
// Set to Spanish
PackageStrings.setLocale('es');

// Set to Arabic
PackageStrings.setLocale('ar');

// Set back to English (default)
PackageStrings.setLocale('en');
```

## API Reference

### CalendarLocalizations

A class that holds all localizable strings for the calendar.

#### Constructor

```dart
const CalendarLocalizations({
  required String am,             // AM suffix (e.g., 'am', 'a. m.')
  required String pm,             // PM suffix (e.g., 'pm', 'p. m.')
  required String more,           // "More" text for additional events
  required List<String> weekdays, // Weekday abbreviations [Mon-Sun]
  List<String>? numbers,          // Localized numbers 0-60 (61 elements)
  bool isRTL = false,             // Right-to-left layout
});
```

**Note:** If you provide a `numbers` array, it must contain exactly **61 elements** (representing numbers 0 through 60) for calendar usage (dates, hours, minutes).

#### Factory Constructor

You can also create localizations from a Map (useful for loading from JSON/ARB files):

```dart
factory CalendarLocalizations.fromMap(Map<String, dynamic> map)
```

#### Built-in Locales

The package includes a built-in English locale:

```dart
CalendarLocalizations.en // English (default)
```

### PackageStrings

A static class for managing calendar localizations at runtime.

#### Methods

| Method | Description |
|--------|-------------|
| `addLocaleObject(String locale, CalendarLocalizations localeObj)` | Register a new locale |
| `setLocale(String locale)` | Set the active locale |
| `localizeNumber(int number)` | Convert a number to localized string |

#### Properties

| Property | Description |
|----------|-------------|
| `currentLocale` | Get the current `CalendarLocalizations` object |
| `selectedLocale` | Get the current locale code (e.g., 'en', 'es') |

## Complete Integration Example

Here's a complete example showing how to integrate localization with Flutter's built-in localization system:

```dart
import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLocale = 'en';

  @override
  void initState() {
    super.initState();
    // Initialize calendar localizations
    _initializeCalendarLocales();
  }

  void _initializeCalendarLocales() {
    // Register Spanish
    PackageStrings.addLocaleObject(
      'es',
      CalendarLocalizations(
        am: 'a. m.',
        pm: 'p. m.',
        more: 'Más',
        weekdays: ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
      ),
    );

    // Register Arabic with RTL
    PackageStrings.addLocaleObject(
      'ar',
      CalendarLocalizations.fromMap({
        'am': 'ص',
        'pm': 'م',
        'more': 'المزيد',
        'weekdays': ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'],
        'numbers': ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
        'isRTL': true,
      }),
    );
  }

  void _changeLocale(String locale) {
    setState(() {
      _currentLocale = locale;
      PackageStrings.setLocale(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        locale: Locale(_currentLocale),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('es', ''),
          Locale('ar', ''),
        ],
        home: Scaffold(
          appBar: AppBar(
            title: Text('Calendar Localization Demo'),
            actions: [
              PopupMenuButton<String>(
                onSelected: _changeLocale,
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'en', child: Text('English')),
                  PopupMenuItem(value: 'es', child: Text('Español')),
                  PopupMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
            ],
          ),
          body: MonthView(),
        ),
      ),
    );
  }
}
```