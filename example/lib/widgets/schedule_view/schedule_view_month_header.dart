import 'package:calendar_view/calendar_view.dart';
import 'package:example/enumerations.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

class ScheduleViewMonthHeader extends StatelessWidget {
  const ScheduleViewMonthHeader({
    super.key,
    required this.date,
    this.showNoEventsTile = false,
  });

  final DateTime date;
  final bool showNoEventsTile;

  @override
  Widget build(BuildContext context) {
    const headerHeight = 160.0;
    final colors = context.scheduleViewColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Image.asset(
                Months.values[date.month - 1].imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.monthHeaderGradientStartColor,
                    colors.monthHeaderGradientEndColor,
                  ],
                ),
              ),
              height: headerHeight,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    date.getMonthYear(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.monthHeaderTextColor,
                      letterSpacing: 0.3,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: colors.monthHeaderTextShadowColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showNoEventsTile) ...[
          _NoEventsInMonthTile(),
          Divider(height: 1, thickness: 1, color: colors.dateDividerColor),
        ],
      ],
    );
  }
}

class _NoEventsInMonthTile extends StatelessWidget {
  const _NoEventsInMonthTile();

  @override
  Widget build(BuildContext context) {
    final colors = context.scheduleViewColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: colors.emptyContentColor,
          ),
          Text(
            context.translate.scheduleNoEventsThisMonth,
            style: TextStyle(
              fontSize: 14,
              color: colors.emptyContentColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
