import 'package:flutter/material.dart';

import '../extension.dart';
import '../widgets/resizable_month_view_widget.dart';
import '../widgets/responsive_widget.dart';
import 'create_event_page.dart';
import 'web/web_home_page.dart';
import '../enumerations.dart';

/// Full-screen demo page for [ResizableMonthViewWidget].
///
/// On mobile it renders a [Scaffold] with an AppBar and a FAB to create
/// events. On web/desktop it delegates to [WebHomePage] with the
/// [CalendarView.resizableMonth] view pre-selected.
class ResizableMonthViewPageDemo extends StatefulWidget {
  const ResizableMonthViewPageDemo({super.key});

  @override
  State<ResizableMonthViewPageDemo> createState() =>
      _ResizableMonthViewPageDemoState();
}

class _ResizableMonthViewPageDemoState
    extends State<ResizableMonthViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ResponsiveWidget(
      webWidget: WebHomePage(selectedView: CalendarView.resizableMonth),
      mobileWidget: Scaffold(
        primary: false,
        appBar: AppBar(leading: const SizedBox.shrink()),
        floatingActionButton: FloatingActionButton(
          heroTag: 'add_event_resizable_month_view',
          child: Icon(Icons.add, color: appColors.onPrimary),
          elevation: 8,
          onPressed: () => context.pushRoute(CreateEventPage()),
        ),
        body: ResizableMonthViewWidget(),
      ),
    );
  }
}
