import 'package:flutter/material.dart';

import '../../extension.dart';
import '../day_view_page.dart';
import '../month_view_page.dart';
import '../week_view_page.dart';

class MobileHomePage extends StatefulWidget {
  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  bool isRtl = false;

  TextDirection get directionality =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Calendar Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Enable RTL ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: isRtl,
                  onChanged: (value) {
                    setState(
                      () => isRtl = value,
                    );
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.pushRoute(
                    MonthViewPageDemo(
                      directionality: directionality,
                    ),
                  ),
                  child: Text("Month View"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => context.pushRoute(
                    DayViewPageDemo(
                      directionality: directionality,
                    ),
                  ),
                  child: Text("Day View"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => context.pushRoute(
                    WeekViewDemo(
                      directionality: directionality,
                    ),
                  ),
                  child: Text("Week View"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
