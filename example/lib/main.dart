import 'package:example/model/event.dart';
import 'package:example/pages/mobile/mobile_home_page.dart';
import 'package:example/pages/web/web_home_page.dart';
import 'package:example/widgets/event_provider.dart';
import 'package:example/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DataProvider(
      controller: CalendarController<Event>(),
      child: MaterialApp(
        title: 'Flutter Calendar Page Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: ResponsiveWidget(
          mobileWidget: MobileHomePage(),
          webWidget: WebHomePage(),
        ),
      ),
    );
  }
}
