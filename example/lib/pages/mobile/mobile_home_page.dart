import 'package:flutter/material.dart';

import '../../extension.dart';
import '../day_view_page.dart';
import '../month_view_page.dart';
import '../multi_day_view_page.dart';
import '../week_view_page.dart';

class MobileHomePage extends StatefulWidget {
  MobileHomePage({
    this.onChangeTheme,
    super.key,
  });

  final void Function(bool)? onChangeTheme;

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Calendar Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => context.pushRoute(MonthViewPageDemo()),
              child: Text("Month View"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(DayViewPageDemo()),
              child: Text("Day View"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(WeekViewDemo()),
              child: Text("Week View"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(MultiDayViewDemo()),
              child: Text("Multi-Day View"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.dark_mode,
          color: context.appColors.onPrimary,
        ),
        onPressed: () {
          isDarkMode = !isDarkMode;
          if (widget.onChangeTheme != null) {
            widget.onChangeTheme!(isDarkMode);
          }
          setState(() {});
        },
      ),
    );
  }
}
