import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../constants.dart';
import '../../enumerations.dart';
import '../../extension.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/date_time_selector.dart';
import '../../widgets/settings_section.dart';
import 'calendar_settings_provider.dart';

part 'calendar_settings_dialog_backend.dart';

class CalendarSettingsDialog extends StatefulWidget {
  const CalendarSettingsDialog({Key? key}) : super(key: key);

  @override
  State<CalendarSettingsDialog> createState() => _CalendarSettingsDialogState();

  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (_) => this,
    );
  }
}

class _CalendarSettingsDialogState extends State<CalendarSettingsDialog>
    with CalendarSettingsDialogBackend {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: screenWidth * 0.1,
      ),
      child: ClipRect(
        clipBehavior: Clip.antiAlias,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Calendar Settings",
                              style: TextStyle(
                                color: AppColors.navyBlue,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: context.pop,
                            icon: Icon(
                              Icons.close,
                              color: AppColors.black,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      const CustomDivider(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SettingsSection(
                                title: "Date Settings",
                                children: [
                                  GridView(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          screenWidth > BreakPoints.web ? 2 : 1,
                                      mainAxisExtent: 70,
                                      crossAxisSpacing: 40,
                                    ),
                                    children: [
                                      DateTimeSelectorFormField(
                                        controller: _startDateController,
                                        decoration: AppConstants.inputDecoration
                                            .copyWith(
                                          labelText: "Minimum Date",
                                        ),
                                        validator: (value) {
                                          if (value == null || value == "")
                                            return "Please select date.";

                                          return null;
                                        },
                                        textStyle: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 17.0,
                                        ),
                                        onSave: (date) => _minDate = date,
                                        initialDateTime: _minDate,
                                        type: DateTimeSelectionType.date,
                                      ),
                                      DateTimeSelectorFormField(
                                        controller: _endDateController,
                                        decoration: AppConstants.inputDecoration
                                            .copyWith(
                                          labelText: "Maximum Date",
                                        ),
                                        validator: (value) {
                                          if (value == null || value == "")
                                            return "Please select date.";

                                          return null;
                                        },
                                        textStyle: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 17.0,
                                        ),
                                        onSave: (date) => _maxDate = date,
                                        initialDateTime: _maxDate,
                                        type: DateTimeSelectionType.date,
                                      ),
                                      DateTimeSelectorFormField(
                                        controller: _initialDateController,
                                        decoration: AppConstants.inputDecoration
                                            .copyWith(
                                          labelText: "Initial Date",
                                        ),
                                        validator: (value) {
                                          if (value == null || value == "")
                                            return "Please select date.";

                                          return null;
                                        },
                                        textStyle: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 17.0,
                                        ),
                                        onSave: (date) => _initialDate = date,
                                        initialDateTime: _initialDate,
                                        type: DateTimeSelectionType.date,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SettingsSection(
                                  title: "Animation Settings",
                                  children: [
                                    CustomDropDown<CurveTypes>(
                                      initialValue: _animationCurve,
                                      label: "Curve",
                                      length: CurveTypes.values.length,
                                      builder: (context, index, curve) {
                                        return Text(curve.name);
                                      },
                                      valueBuilder: (index) =>
                                          CurveTypes.values[index],
                                      onValueChanged: (curve) =>
                                          _animationCurve = curve,
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, -4),
                      spreadRadius: 10,
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      onTap: _saveSettings,
                      title: "Save",
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
