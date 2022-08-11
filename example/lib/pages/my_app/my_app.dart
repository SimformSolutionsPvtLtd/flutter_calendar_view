import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../datasets/events.dart';
import '../../enumerations.dart';
import '../../widgets/responsive_widget.dart';
import '../calendar_settings/calendar_settings_provider.dart';
import '../mobile/mobile_home_page.dart';
import '../web/web_home_page.dart';

part 'my_app_backend.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with MyAppBackend {
  @override
  Widget build(BuildContext context) {
    return CalendarSettingsProvider(
      minDate: _minDate,
      maxDate: _maxDate,
      initialDate: _initialDate,
      animationCurve: _animationCurve,
      child: CalendarControllerProvider<String>(
        controller: controller,
        child: MaterialApp(
          title: 'Flutter Calendar Page Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          scrollBehavior: ScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.trackpad,
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
          home: ResponsiveWidget(
            mobileWidget: MobileHomePage(),
            webWidget: WebHomePage(),
          ),
        ),
      ),
    );
  }
}
