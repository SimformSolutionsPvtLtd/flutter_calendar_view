import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/responsive_widget.dart';
import '../widgets/schedule_view/schedule_view_settings.dart';
import '../widgets/schedule_view/schedule_view_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';

class ScheduleViewPageDemo extends StatefulWidget {
  @override
  _ScheduleViewPageDemoState createState() => _ScheduleViewPageDemoState();
}

class _ScheduleViewPageDemoState extends State<ScheduleViewPageDemo> {
  DateTime _focusDate = DateTime.now();
  int _jumpKey = 0;

  final ValueNotifier<ScheduleViewConfig> _config = ValueNotifier(
    const ScheduleViewConfig(),
  );

  @override
  void dispose() {
    _config.dispose();
    super.dispose();
  }

  void _jumpToToday() {
    setState(() {
      _focusDate = DateTime.now();
      _jumpKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final translate = context.translate;

    return ResponsiveWidget(
      webWidget: WebHomePage(selectedView: CalendarView.schedule),
      mobileWidget: Scaffold(
        appBar: AppBar(
          title: Text(translate.scheduleView),
          centerTitle: true,
          actions: [ScheduleSettingsButton(config: _config)],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: 'jump_to_today_schedule_view',
              backgroundColor: appColors.primary,
              onPressed: _jumpToToday,
              tooltip: translate.today,
              child: Icon(Icons.today, color: appColors.onPrimary),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'add_event_schedule_view',
              backgroundColor: appColors.primary,
              child: Icon(Icons.add, color: appColors.onPrimary),
              elevation: 8,
              onPressed: () => context.pushRoute(CreateEventPage()),
            ),
          ],
        ),
        body: ValueListenableBuilder<ScheduleViewConfig>(
          valueListenable: _config,
          builder: (context, config, _) => ScheduleViewWidget(
            initialDay: _focusDate,
            jumpKey: _jumpKey,
            scheduleViewConfig: config,
          ),
        ),
      ),
    );
  }
}
