import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:example/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'localization/calendar_locales.dart';
import 'localization/locale_controller.dart';
import 'pages/home_page.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String initialLocale = 'en';

  /// Created once and kept stable for the app's lifetime so theme/locale
  /// changes never recreate the controller (which would re-seed all events).
  final _controller = EventController();
  final _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  @override
  void initState() {
    super.initState();
    CalendarLocales.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _themeMode.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _controller,
      child: ThemeController(
        notifier: _themeMode,
        child: LocaleController(
          initialLocale: PackageStrings.selectedLocale,
          child: Builder(
            builder: (context) {
              final localeController = LocaleController.of(context);
              final themeController = ThemeController.of(context);
              return MaterialApp(
                title: 'Flutter Calendar Page Demo',
                debugShowCheckedModeBanner: false,
                locale: Locale(localeController.currentLocale),
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeController.themeMode,
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
                home: const HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
