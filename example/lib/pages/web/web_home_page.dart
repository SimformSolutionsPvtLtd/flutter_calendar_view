import 'package:flutter/material.dart';

import '../../enumerations.dart';
import '../../widgets/calendar_configs.dart';
import '../../widgets/calendar_views.dart';

class WebHomePage extends StatefulWidget {
  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  CalendarView _selectedView = CalendarView.month;

  void _setView(CalendarView view) {
    if (view != _selectedView && mounted) {
      setState(() {
        _selectedView = view;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: CalendarConfig(
              onViewChange: _setView,
              currentView: _selectedView,
            ),
          ),
          Expanded(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: Size(MediaQuery.of(context).size.width / 2,
                    MediaQuery.of(context).size.height),
              ),
              child: CalendarViews(
                key: ValueKey(MediaQuery.of(context).size.width),
                view: _selectedView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
