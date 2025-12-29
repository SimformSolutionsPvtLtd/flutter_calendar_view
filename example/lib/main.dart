import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:example/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'localization/calendar_locales.dart';
import 'localization/locale_controller.dart';
import 'pages/home_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  final String initialLocale = 'en';

  @override
  void initState() {
    super.initState();
    CalendarLocales.initialize();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LocaleController(
      initialLocale: PackageStrings.selectedLocale,
      child: Builder(builder: (context) {
        final localeController = LocaleController.of(context);
        return CalendarThemeProvider(
          calendarTheme: CalendarThemeData(
            monthViewTheme: isDarkMode
                ? MonthViewThemeData.dark()
                : MonthViewThemeData.light(),
            dayViewTheme: isDarkMode
                ? DayViewThemeData.dark()
                : DayViewThemeData.light().copyWith(
                    hourLineColor: AppColors.primary) as DayViewThemeData,
            weekViewTheme: isDarkMode
                ? WeekViewThemeData.dark()
                : WeekViewThemeData.light(),
            multiDayViewTheme: isDarkMode
                ? MultiDayViewThemeData.dark()
                : MultiDayViewThemeData.light(),
          ),
          child: CalendarControllerProvider(
            controller: EventController(),
            child: MaterialApp(
              title: 'Flutter Calendar Page Demo',
              debugShowCheckedModeBanner: false,
              locale: Locale(localeController.currentLocale),
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', ''),
                Locale('es', ''),
                Locale('ar', ''),
              ],
              scrollBehavior: ScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
              home: HomePage(
                onChangeTheme: (isDark) => setState(() => isDarkMode = isDark),
              ),
            ),
          ),
        );
      }),
    );
  }
}
