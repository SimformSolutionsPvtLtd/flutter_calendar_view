import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

class EmptyTextWidget extends StatelessWidget {
  const EmptyTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleColors = context.scheduleViewColors;
    final translate = context.translate;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheduleColors.emptyContentColor),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 14,
            color: scheduleColors.emptyContentColor,
          ),
          Text(
            translate.scheduleNoEvents,
            style: TextStyle(
              fontSize: 14,
              color: scheduleColors.emptyContentColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
