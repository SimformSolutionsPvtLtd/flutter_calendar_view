import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../theme/app_colors.dart';
import 'add_event_form.dart';

class CalendarConfig extends StatefulWidget {
  final void Function(CalendarView view) onViewChange;
  final void Function(bool)? onThemeChange;
  final CalendarView currentView;

  const CalendarConfig({
    super.key,
    required this.onViewChange,
    this.onThemeChange,
    this.currentView = CalendarView.month,
  });

  @override
  State<CalendarConfig> createState() => _CalendarConfigState();
}

class _CalendarConfigState extends State<CalendarConfig> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Flutter Calendar Page",
            style: TextStyle(
              color: color.onSurface,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Dark mode: ',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: color.onSurface,
                      ),
                    ),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() => isDarkMode = value);
                        if (widget.onThemeChange != null) {
                          widget.onThemeChange!(isDarkMode);
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  "Active View:",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Wrap(
                  children: List.generate(
                    CalendarView.values.length,
                    (index) {
                      final view = CalendarView.values[index];
                      return GestureDetector(
                        onTap: () => widget.onViewChange(view),
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
                            color: view == widget.currentView
                                ? AppColors.navyBlue
                                : AppColors.bluishGrey,
                          ),
                          child: Text(
                            view.name.capitalized,
                            style: TextStyle(
                              color: view == widget.currentView
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
                    color: color.onSurface,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AddOrEditEventForm(
                  onEventAdd: (event) {
                    CalendarControllerProvider.of(context)
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
