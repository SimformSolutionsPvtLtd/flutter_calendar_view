---
name: calendar-view-theming
description: >-
  Style and translate calendar_view widgets: dark mode and colors through
  ThemeData extensions (MonthViewThemeData, DayViewThemeData, WeekViewThemeData,
  MultiDayViewThemeData, ScheduleViewThemeData), header styling (HeaderStyle,
  IconDataConfig), and localization with PackageStrings and
  CalendarLocalizations including month names. Use when a calendar ignores the
  dark theme, when changing colors, header icons or titles, when adding a
  language, or when headers show numbers instead of month names.
---

# calendar_view: theming, headers and localization

For the widgets themselves use `calendar-view-views`. For events use
`calendar-view-events`.

## Workflow

1. **Inspect the project first.** Find the app's `ThemeData`, its dark theme,
   and how it handles locales (`intl`, `flutter_localizations`).
2. Put the calendar theme data in `ThemeData.extensions` (below). Don't
   hard-code colors in widgets.
3. Run `flutter analyze` and check the calendar in light and dark mode.

## Theme

```dart
MaterialApp(
  theme: ThemeData(extensions: [
    MonthViewThemeData.light(),
    DayViewThemeData.light(),
    WeekViewThemeData.light(),
    MultiDayViewThemeData.light(),
    ScheduleViewThemeData.light(),
  ]),
  darkTheme: ThemeData(brightness: Brightness.dark, extensions: [
    MonthViewThemeData.dark(),
    DayViewThemeData.dark(),
    WeekViewThemeData.dark(),
    MultiDayViewThemeData.dark(),
    ScheduleViewThemeData.dark(),
  ]),
);
```

- Views read only `Theme.of(context).extension<XxxViewThemeData>()`. Without
  the extension, `MonthView`, `DayView` and `WeekView` fall back to the light
  data even in a dark app. `MultiDayView` and `ScheduleView` fall back to dark
  or light by `Theme.brightness`. Add the extensions for the views you use.
- **`CalendarThemeProvider` does not theme the views.** Nothing in the views
  reads it, so wrapping the app in it leaves the calendar light. Use
  `ThemeData.extensions`.
- Tweak with `copyWith`: `MonthViewThemeData.light().copyWith(...)`. It returns
  `ThemeExtension<MonthViewThemeData>`: fine inside `extensions:`, but cast
  (`as MonthViewThemeData`) when you store it in a typed variable.
- Page background: `pageBackgroundColor` in the view's theme data. The views
  have no `backgroundColor` argument.
- Week day title color in `WeekView` and `MultiDayView`: `weekDayTileColor` in
  the theme data.
- Selected-cell colors in `MonthView`:
  `MonthView(monthViewThemeSettings: MonthViewThemeSettings(selectedHighlightColor: ...))`.

## Headers

- Day, Week and MultiDay views take `headerStyle: HeaderStyle(...)`:
  `HeaderStyle(decoration: ..., leftIconConfig: IconDataConfig(...), rightIconConfig: ...)`.
  `leftIconConfig: null` hides the icon.
- **`MonthView` ignores `MonthViewStyle.headerStyle`.** Pass
  `monthViewThemeSettings: MonthViewThemeSettings(headerStyle: ...)`. It replaces
  the themed default header style entirely.
- Hide a header by passing a hidden builder (they are builder functions, not
  flags; there is no `header:` argument):
  `MonthView(monthViewBuilders: MonthViewBuilders(headerBuilder: MonthHeader.hidden))`,
  `DayView(dayTitleBuilder: DayHeader.hidden)`,
  `WeekView(weekPageHeaderBuilder: WeekHeader.hidden)`. `MultiDayView` takes
  `weekPageHeaderBuilder` too: pass `WeekHeader.hidden`.
- Deprecated, don't use: `HeaderStyle(leftIcon:, leftIconVisible:,
  rightIcon:, rightIconVisible:)` (use `leftIconConfig` / `rightIconConfig`)
  and `MonthPageHeader(backgroundColor:, iconColor:)` (use
  `headerStyle: HeaderStyle(decoration: ...)`).
- `onHeaderTitleTap` and a custom header builder are mutually exclusive:
  `MonthViewBuilders` (`headerBuilder`), `DayView` (`dayTitleBuilder`),
  `WeekView` and `MultiDayView` (`weekPageHeaderBuilder`).

## Localization

```dart
PackageStrings.addLocaleObject(
  'pt',
  const CalendarLocalizations(
    am: 'AM',
    pm: 'PM',
    more: 'Mais',
    weekdays: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'], // Monday first
    months: [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ],
  ),
);
setState(() => PackageStrings.setLocale('pt')); // does not rebuild by itself
```

`setState` stands for the `State` of the widget that owns the language choice.

- Calendar labels come only from `PackageStrings`, not Flutter `Localizations`.
  Built-in locales: `en`, `es`, `ar` (RTL), `fr`, `de`, `hi`, `zh`, `ja`. An
  unknown locale asserts.
- `CalendarLocalizations` holds am/pm, "more", weekday letters, `numbers`
  (digits), `isRTL`, `months` and `monthsAbbr`. A custom locale without
  `months` falls back to English month names.
- `date.getMonthName({abbreviated})` and `date.getMonthYear()` return the
  localized month name and month with year.
- **Default headers of `MonthView`, `DayView`, `WeekView` and `MultiDayView`
  show numbers** (for example `11 - 2026`), not month names. Only
  `ScheduleView` uses month names by default. Set the header text yourself:
  `MonthViewBuilders(headerStringBuilder: (date, {secondaryDate}) => date.getMonthYear())`,
  `DayView(dateStringBuilder: ...)`, or `headerStringBuilder` on `WeekView` and
  `MultiDayView`. With `intl`: `DateFormat.yMMMM('pt').format(date)`.
- Digits are localized one by one from `numbers`, so days, hours and years all
  use them (`2026` becomes `٢٠٢٦` in `ar`). `numbers` needs the 10 digits `0`
  to `9`; a shorter list leaves Western digits. Leave `numbers` out for Latin
  digits.

## Symptom to fix

| Symptom | Fix |
| --- | --- |
| Dark theme not applied to the calendar | Put `XxxViewThemeData.dark()` in `ThemeData(extensions:)`, not `CalendarThemeProvider`. |
| `The named parameter 'backgroundColor' isn't defined` | Use `pageBackgroundColor` in the view's theme data. |
| Month header ignores `MonthViewStyle.headerStyle` | Use `MonthViewThemeSettings(headerStyle: ...)`. |
| Header shows `11 - 2026` | Pass a header string builder that uses `getMonthYear()`. |
| Locale change not visible | Rebuild after `PackageStrings.setLocale`. |
| Assertion for an unknown locale | Call `addLocaleObject` before `setLocale`. |
