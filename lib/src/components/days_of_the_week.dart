import 'package:flutter/material.dart';

import '../cell_calendar.dart';

/// Days of the week
///
// TODO: Internationalize the days of the week
const List<String> _DaysOfTheWeek = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fry',
  'Sat'
];

/// Show the row of text from [_DaysOfTheWeek]
class DaysOfTheWeek extends StatelessWidget {
  const DaysOfTheWeek(this.daysOfTheWeekBuilder);

  final DaysBuilder? daysOfTheWeekBuilder;

  Widget defaultLabels(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        _DaysOfTheWeek[index],
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        7,
        (index) {
          return Expanded(
            child: daysOfTheWeekBuilder?.call(index) ?? defaultLabels(index),
          );
        },
      ),
    );
  }
}
