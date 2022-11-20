import 'package:calendar_view/calendar_view.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';

class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayView<String>(
      key: state,
      width: width,
      eventTileBuilder: (date, events, area, start, end) {
        return ContextMenuRegion(
          contextMenu: LinkContextMenu(url: 'http://flutter.dev'),
          child: Container(
            color: events[0].color,
            child: Text(
              events[0].title,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        );
      },
    );
  }
}
