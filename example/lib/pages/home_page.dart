import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../widgets/calendar_views.dart';
import 'create_event_page.dart';
import 'markdown_documentation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedView = 0;

  bool _showDocumentationFlag = false;

  void _updateView() {
    if (mounted) {
      setState(() {
        _selectedView = (_selectedView + 1) % CalendarView.values.length;
      });
    }
  }

  void _showDocumentation() {
    if (mounted) {
      setState(() {
        _showDocumentationFlag = true;
      });
    }
  }

  void _hideDocumentation() {
    if (mounted) {
      setState(() {
        _showDocumentationFlag = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final halfSize = Size(
      width / 2,
      MediaQuery.of(context).size.height,
    );

    final documentationPosition =
        width.isWeb || _showDocumentationFlag ? 0.0 : -width;

    return Scaffold(
      floatingActionButton: _showDocumentationFlag
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!width.isWeb) ...[
                  FloatingActionButton(
                    heroTag: "documentation",
                    onPressed: _showDocumentation,
                    child: Icon(Icons.library_books_rounded),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
                FloatingActionButton(
                  heroTag: "view",
                  onPressed: _updateView,
                  child: Icon(CalendarView.values[_selectedView].icon),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  heroTag: "create event",
                  child: Icon(Icons.add),
                  elevation: 8,
                  onPressed: () => _addEvent(width.isWeb),
                )
              ],
            ),
      body: Stack(
        children: [
          Positioned(
            left: width.isWeb ? width / 2 : 0,
            right: 0,
            child: CalendarViews(
              key: ValueKey(width),
              view: CalendarView.values[_selectedView],
            ),
          ),
          AnimatedPositioned(
            left: documentationPosition,
            right: width.isWeb
                ? width / 2
                : _showDocumentationFlag
                    ? 0
                    : width,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: MediaQuery(
              data: width.isWeb
                  ? MediaQuery.of(context).copyWith(
                      size: halfSize,
                    )
                  : MediaQuery.of(context),
              child: SizedBox.fromSize(
                size: width.isWeb ? halfSize : MediaQuery.of(context).size,
                child: Navigator(
                  key: ValueKey(CalendarView.values[_selectedView]),
                  onPopPage: (_, __) => true,
                  pages: [
                    MaterialPage(
                      child: MarkdownDocumentation(
                        isInitial: true,
                        isFullScreen: !width.isWeb,
                        onInitialPop: _hideDocumentation,
                        markdownFile: CalendarView.values[_selectedView] ==
                                CalendarView.month
                            ? getDocumentationFile("month_view.md")
                            : CalendarView.values[_selectedView] ==
                                    CalendarView.day
                                ? getDocumentationFile("day_view.md")
                                : getDocumentationFile("week_view.md"),
                      ),
                      fullscreenDialog: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addEvent(bool inDialog) async {
    final event = await (inDialog
        ? context.showDefaultDialog(CreateEventDialog())
        : context.pushRoute<CalendarEventData>(
            CreateEventPage(),
          ));
    if (event == null) return;
    CalendarControllerProvider.of(context).controller.add(event);
  }
}
