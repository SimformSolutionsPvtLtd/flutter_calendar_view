import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../enumerations.dart';
import '../extension.dart';
import '../model/event.dart';
import 'add_event_widget.dart';

class CalendarConfig extends StatelessWidget {
  final void Function(CalendarView view) onViewChange;
  final CalendarView currentView;

  const CalendarConfig({
    Key? key,
    required this.onViewChange,
    this.currentView = CalendarView.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Flutter Calendar Page",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 30,
            ),
          ),
        ),
        Divider(
          color: AppColors.lightNavyBlue,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Active View:",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.black,
                  ),
                ),
                Wrap(
                  children: List.generate(
                    CalendarView.values.length,
                    (index) {
                      final view = CalendarView.values[index];
                      return GestureDetector(
                        onTap: () => onViewChange(view),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 40,
                          ),
                          margin: EdgeInsets.only(
                            right: 20,
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: view == currentView
                                ? AppColors.navyBlue
                                : AppColors.bluishGrey,
                          ),
                          child: Text(
                            view.name.capitalized,
                            style: TextStyle(
                              color: view == currentView
                                  ? AppColors.white
                                  : AppColors.black,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Add Event: ",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AddEventWidget(
                  onEventAdd: (event) {
                    CalendarControllerProvider.of<Event>(context)
                        .controller
                        .add(event);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
