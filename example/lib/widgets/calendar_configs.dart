import 'package:calendar_view/calendar_view.dart';
import 'package:example/constants.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../enumerations.dart';
import '../extension.dart';
import 'add_event_form.dart';

class CalendarConfig extends StatefulWidget {
  final void Function(CalendarView view) onViewChange;
  final void Function(TextDirection directionality) onDirectionalityChange;
  final CalendarView currentView;

  const CalendarConfig({
    super.key,
    required this.onViewChange,
    required this.onDirectionalityChange,
    this.currentView = CalendarView.month,
  });

  @override
  State<CalendarConfig> createState() => _CalendarConfigState();
}

class _CalendarConfigState extends State<CalendarConfig> {
  bool isRtl = false;

  TextDirection get directionality =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: directionality,
      child: Column(
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
                  Row(
                    children: [
                      Text(
                        'Enable RTL ',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: AppColors.black,
                        ),
                      ),
                      Switch(
                        value: isRtl,
                        onChanged: (value) {
                          setState(() => isRtl = value);
                          widget.onDirectionalityChange(directionality);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${AppConstants.ltr}Active View:",
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
                    "${AppConstants.ltr}Add Event: ",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.black,
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
      ),
    );
  }
}
