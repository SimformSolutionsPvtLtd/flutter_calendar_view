import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import 'custom_button.dart';
import 'date_time_selector.dart';

class AddOrEditEventForm extends StatefulWidget {
  final void Function(CalendarEventData)? onEventAdd;
  final CalendarEventData? event;

  const AddOrEditEventForm({
    super.key,
    this.onEventAdd,
    this.event,
  });

  @override
  _AddOrEditEventFormState createState() => _AddOrEditEventFormState();
}

class _AddOrEditEventFormState extends State<AddOrEditEventForm> {
  late DateTime _startDate = DateTime.now().withoutTime;
  late DateTime _endDate = DateTime.now().withoutTime;
  DateTime? _recurrenceEndDate;

  DateTime? _startTime;
  DateTime? _endTime;
  List<bool> _selectedDays = List.filled(7, false);
  RepeatFrequency? _selectedFrequency = RepeatFrequency.doNotRepeat;
  RecurrenceEnd? _selectedRecurrenceEnd = RecurrenceEnd.never;

  Color _color = Colors.blue;

  final _form = GlobalKey<FormState>();

  late final _descriptionController = TextEditingController();
  late final _occurrenceController = TextEditingController();
  late final _titleController = TextEditingController();
  late final _titleNode = FocusNode();
  late final _descriptionNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _setDefaults();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();

    _descriptionController.dispose();
    _titleController.dispose();
    _occurrenceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "Event Title",
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            validator: (value) {
              final title = value?.trim();

              if (title == null || title == "") {
                return "Please enter event title.";
              }

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Date",
                  ),
                  initialDateTime: _startDate,
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime
                        .isAfter(_endDate.withoutTime)) {
                      _endDate = date.withoutTime;
                    }

                    _startDate = date.withoutTime;
                    updateWeekdaysSelection();

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please select start date.";
                    }

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _startDate = date ?? _startDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  initialDateTime: _endDate,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Date",
                  ),
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime
                        .isBefore(_startDate.withoutTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('End date occurs before start date.'),
                      ));
                    } else {
                      _endDate = date.withoutTime;
                      _recurrenceEndDate = _endDate;
                      updateWeekdaysSelection();
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please select end date.";
                    }

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _endDate = date ?? _endDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Time",
                  ),
                  initialDateTime: _startTime,
                  minimumDateTime: CalendarConstants.epochDate,
                  onSelect: (date) {
                    if (_endTime != null &&
                        date.getTotalMinutes > _endTime!.getTotalMinutes) {
                      _endTime = date.add(Duration(minutes: 1));
                    }
                    _startTime = date;

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _startTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Time",
                  ),
                  initialDateTime: _endTime,
                  onSelect: (date) {
                    if (_startTime != null &&
                        date.getTotalMinutes < _startTime!.getTotalMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('End time is less then start time.'),
                      ));
                    } else {
                      _endTime = date;
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _endTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "") {
                return "Please enter event description.";
              }

              return null;
            },
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Event Description",
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Repeat',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
          Row(
            children: [
              Radio(
                value: RepeatFrequency.doNotRepeat,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(
                    () => _selectedFrequency = value,
                  );
                },
              ),
              Text(
                'Do not repeat',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: RepeatFrequency.daily,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(
                    () => _selectedFrequency = value,
                  );
                },
              ),
              Text(
                'Daily',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              )
            ],
          ),
          Row(
            children: [
              Radio(
                value: RepeatFrequency.weekly,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(
                    () => _selectedFrequency = value,
                  );
                },
              ),
              Text(
                'Weekly',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: RepeatFrequency.monthly,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(
                    () => _selectedFrequency = value,
                  );
                },
              ),
              Text(
                'Monthly',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: RepeatFrequency.yearly,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(
                    () => _selectedFrequency = value,
                  );
                },
              ),
              Text(
                'Yearly',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          if (_selectedFrequency == RepeatFrequency.weekly) ...[
            Wrap(
              children: List.generate(AppConstants.weekTitles.length, (index) {
                return ChoiceChip(
                  label: Text(AppConstants.weekTitles[index]),
                  showCheckmark: false,
                  selected: _selectedDays[index],
                  onSelected: (selected) {
                    setState(() {
                      _selectedDays[index] = selected;
                      if (!_selectedDays.contains(true)) {
                        _selectedDays[_startDate.weekday - 1] = true;
                      }
                    });
                  },
                  shape: CircleBorder(),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 15),
          if (_selectedFrequency != RepeatFrequency.doNotRepeat)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reoccurrence ends on: ',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: RecurrenceEnd.never,
                      groupValue: _selectedRecurrenceEnd,
                      onChanged: (value) => setState(
                        () => _selectedRecurrenceEnd = value,
                      ),
                    ),
                    Text(
                      'Never',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: RecurrenceEnd.onDate,
                      groupValue: _selectedRecurrenceEnd,
                      onChanged: (value) => setState(
                        () => _selectedRecurrenceEnd = value,
                      ),
                    ),
                    Text(
                      'On',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: RecurrenceEnd.after,
                      groupValue: _selectedRecurrenceEnd,
                      onChanged: (value) => setState(
                        () => _selectedRecurrenceEnd = value,
                      ),
                    ),
                    Text(
                      'After',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(height: 15),
          if (_selectedRecurrenceEnd == RecurrenceEnd.onDate)
            DateTimeSelectorFormField(
              initialDateTime: _recurrenceEndDate,
              decoration: AppConstants.inputDecoration.copyWith(
                labelText: 'Ends on',
              ),
              onSelect: (date) {
                if (date.withoutTime.isBefore(_endDate.withoutTime)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Recurrence ends after end date'),
                  ));
                } else {
                  _recurrenceEndDate = date.withoutTime;
                }

                if (mounted) {
                  setState(() {});
                }
              },
              validator: (value) {
                if (value == null || value == "") {
                  return 'Please select end date.';
                }

                // TODO(Shubham): Add validation of end occurrence >= end date
                return null;
              },
              textStyle: TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              onSave: (date) => _recurrenceEndDate = date ?? _recurrenceEndDate,
              type: DateTimeSelectionType.date,
            ),
          if (_selectedRecurrenceEnd == RecurrenceEnd.after)
            TextFormField(
              controller: _occurrenceController,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 17.0,
              ),
              keyboardType: TextInputType.number,
              minLines: 1,
              maxLength: 3,
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Please specify occurrences';
                }

                return null;
              },
              decoration: AppConstants.inputDecoration.copyWith(
                hintText: '30',
                suffixText: 'Occurrences',
                counterText: '',
              ),
            ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Text(
                "Event Color: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: _color,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: _createEvent,
            title: widget.event == null ? "Add Event" : "Update Event",
          ),
        ],
      ),
    );
  }

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();
    var occurrences = int.tryParse(_occurrenceController.text);
    DateTime? endDate;

    // On event edit recurrence end is selected "Never"
    // Remove any previous end date & occurrences stored.
    if (_selectedRecurrenceEnd == RecurrenceEnd.never) {
      endDate = null;
      occurrences = null;
    }

    if (_selectedRecurrenceEnd == RecurrenceEnd.onDate) {
      endDate = _recurrenceEndDate;
    }

    final recurrenceSettings = RecurrenceSettings.withCalculatedEndDate(
      startDate: _startDate,
      endDate: endDate,
      frequency: _selectedFrequency ?? RepeatFrequency.daily,
      weekdays: _toWeekdayInIndices,
      occurrences: occurrences,
      recurrenceEndOn: _selectedRecurrenceEnd ?? RecurrenceEnd.never,
    );

    final event = CalendarEventData(
      date: _startDate,
      endTime: _endTime,
      startTime: _startTime,
      endDate: _endDate,
      color: _color,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      recurrenceSettings: recurrenceSettings,
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  /// Get list of weekdays in indices from the selected days
  List<int> get _toWeekdayInIndices {
    List<int> selectedIndexes = [];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i] == true) {
        selectedIndexes.add(i);
      }
    }
    return selectedIndexes;
  }

  void updateWeekdaysSelection() {
    _selectedDays.fillRange(0, _selectedDays.length, false);
    if (_endDate.difference(_startDate).inDays >= 7) {
      _selectedDays.fillRange(0, _selectedDays.length, true);
    }
    DateTime current = _startDate;
    while (current.isBefore(_endDate) || current.isAtSameMomentAs(_endDate)) {
      _selectedDays[current.weekday - 1] = true;
      current = current.add(Duration(days: 1));
    }
  }

  /// Set initial selected week to start date
  void _setInitialWeekday() {
    final currentWeekday = DateTime.now().weekday - 1;
    _selectedDays[currentWeekday] = true;
  }

  void _setDefaults() {
    if (widget.event == null) {
      _setInitialWeekday();
      return;
    }

    final event = widget.event!;

    _startDate = event.date;
    _endDate = event.endDate;
    _startTime = event.startTime ?? _startTime;
    _endTime = event.endTime ?? _endTime;
    _titleController.text = event.title;
    _descriptionController.text = event.description ?? '';
    _selectedFrequency = event.recurrenceSettings?.frequency;
    _selectedRecurrenceEnd =
        event.recurrenceSettings?.recurrenceEndOn ?? RecurrenceEnd.never;
    _recurrenceEndDate = event.recurrenceSettings?.endDate ?? _startDate;
    _occurrenceController.text =
        (event.recurrenceSettings?.occurrences ?? 0).toString();
    event.recurrenceSettings?.weekdays
        .forEach((index) => _selectedDays[index] = true);
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDate = DateTime.now().withoutTime;
    _endDate = DateTime.now().withoutTime;
    _startTime = null;
    _endTime = null;
    _color = Colors.blue;
    _recurrenceEndDate = null;
    _selectedDays.fillRange(0, _selectedDays.length, true);
    _selectedFrequency = RepeatFrequency.doNotRepeat;
    _selectedRecurrenceEnd = RecurrenceEnd.never;

    if (mounted) {
      setState(() {});
    }
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Select event color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _color = color;
                    });
                  }
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
