import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/week_view_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({super.key});

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  double _heightPerMinute = 1.0;

  static const double _minHeight = 0.4;
  static const double _maxHeight = 4.0;
  static const double _zoomStep = 0.2;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.appColors;

    return ResponsiveWidget(
      webWidget: WebHomePage(selectedView: CalendarView.week),
      mobileWidget: Scaffold(
        primary: false,
        appBar: AppBar(leading: const SizedBox.shrink()),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'zoom_in',
              tooltip: 'Zoom in',
              onPressed: _heightPerMinute < _maxHeight
                  ? () => setState(
                      () => _heightPerMinute = (_heightPerMinute + _zoomStep)
                          .clamp(_minHeight, _maxHeight),
                    )
                  : null,
              child: const Icon(Icons.zoom_in),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: 'zoom_out',
              tooltip: 'Zoom out',
              onPressed: _heightPerMinute > _minHeight
                  ? () => setState(
                      () => _heightPerMinute = (_heightPerMinute - _zoomStep)
                          .clamp(_minHeight, _maxHeight),
                    )
                  : null,
              child: const Icon(Icons.zoom_out),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'add_event',
              child: Icon(Icons.add, color: themeColors.onPrimary),
              elevation: 8,
              onPressed: () => context.pushRoute(CreateEventPage()),
            ),
          ],
        ),
        body: WeekViewWidget(heightPerMinute: _heightPerMinute),
      ),
    );
  }
}
