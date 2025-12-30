import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../constants.dart';
import '../extension.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';
import 'date_time_selector.dart';

class AddOrEditEventForm extends StatefulWidget {
  final void Function(CalendarEventData)? onEventAdd;
  final CalendarEventData? event;

  const AddOrEditEventForm({super.key, this.onEventAdd, this.event});

  @override
  _AddOrEditEventFormState createState() => _AddOrEditEventFormState();
}

class _AddOrEditEventFormState extends State<AddOrEditEventForm> {
  late DateTime _startDate = DateTime.now().withoutTime;
  late DateTime _endDate = DateTime.now().withoutTime;
  late AppLocalizations translate;
  DateTime? _recurrenceEndDate;

  DateTime? _startTime;
  DateTime? _endTime;
  List<bool> _selectedDays = List.filled(7, false);
  RepeatFrequency? _selectedFrequency = RepeatFrequency.doNotRepeat;
  RecurrenceEnd? _selectedRecurrenceEnd = RecurrenceEnd.never;
  bool _isRecurring = false;

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
    final color = Theme.of(context).colorScheme;
    translate = context.translate;

    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: translate.eventTitle,
              labelStyle: TextStyle(color: color.onSurfaceVariant),
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
            style: TextStyle(color: color.onSurface, fontSize: 17.0),
            validator: (value) {
              final title = value?.trim();

              if (title == null || title == "") {
                return translate.pleaseEnterEventTitle;
              }

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                translate.recurringEvent,
                style: TextStyle(color: color.onSurface, fontSize: 16),
              ),
              SizedBox(width: 20),
              Switch(
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                    if (_isRecurring) {
                      // If recurring is turned on, set end date same as start date
                      _endDate = _startDate;
                      if (mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
                      }
                      _selectedFrequency =
                          RepeatFrequency.daily; // Default to daily
                    } else {
                      _selectedFrequency = RepeatFrequency.doNotRepeat;
                    }
                  });
                },
                activeThumbColor: color.surface,
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: InputDecoration(
                    labelText: translate.startDate,
                    labelStyle: TextStyle(color: color.onSurfaceVariant),
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  initialDateTime: _startDate,
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime.isAfter(
                      _endDate.withoutTime,
                    )) {
                      _endDate = date.withoutTime;
                    }

                    _startDate = date.withoutTime;
                    if (_isRecurring) {
                      _endDate = _startDate;

                      if (mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
                      }
                    }
                    updateWeekdaysSelection();

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return translate.pleaseSelectStartDate;
                    }

                    return null;
                  },
                  textStyle: TextStyle(color: color.onSurface, fontSize: 17.0),
                  onSave: (date) => _startDate = date ?? _startDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  initialDateTime: _endDate,
                  decoration: InputDecoration(
                    labelText: translate.endDate,
                    labelStyle: TextStyle(color: color.onSurfaceVariant),
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime.isBefore(
                      _startDate.withoutTime,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(translate.endDateBeforeStartDate),
                        ),
                      );
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
                      return translate.pleaseSelectEndDate;
                    }

                    return null;
                  },
                  textStyle: TextStyle(
                    color: _isRecurring ? Colors.grey : AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) =>
                      _endDate = _isRecurring ? _startDate : (date ?? _endDate),
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
                  decoration: InputDecoration(
                    labelText: translate.startTime,
                    labelStyle: TextStyle(color: color.onSurfaceVariant),
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
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
                  textStyle: TextStyle(color: color.onSurface, fontSize: 17.0),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: InputDecoration(
                    labelText: translate.endTime,
                    labelStyle: TextStyle(color: color.onSurfaceVariant),
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  initialDateTime: _endTime,
                  onSelect: (date) {
                    // If start and end dates are different, any end time is valid
                    // Only validate time if both events are on the same day
                    if (_startTime != null &&
                        _startDate.year == _endDate.year &&
                        _startDate.month == _endDate.month &&
                        _startDate.day == _endDate.day &&
                        date.getTotalMinutes < _startTime!.getTotalMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(translate.endTimeLessThanStartTime),
                        ),
                      );
                    } else {
                      _endTime = date;
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _endTime = date,
                  textStyle: TextStyle(color: color.onSurface, fontSize: 17.0),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionNode,
            style: TextStyle(color: color.onSurface, fontSize: 17.0),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "") {
                return translate.pleaseEnterEventDescription;
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: translate.eventDescription,
              counterStyle: TextStyle(color: color.onSurfaceVariant),
            ).applyDefaults(Theme.of(context).inputDecorationTheme),
          ),
          // Only show repeat settings if the event is recurring
          if (_isRecurring) ...[
            RadioGroup(
              onChanged: (value) {
                setState(() => _selectedFrequency = value);
              },
              groupValue: _selectedFrequency,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      translate.repeat,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(value: RepeatFrequency.daily),
                      Text(
                        translate.daily,
                        style: TextStyle(color: AppColors.black, fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: RepeatFrequency.weekly),
                      Text(
                        translate.weekly,
                        style: TextStyle(color: AppColors.black, fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: RepeatFrequency.monthly),
                      Text(
                        translate.monthly,
                        style: TextStyle(color: AppColors.black, fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: RepeatFrequency.yearly),
                      Text(
                        translate.yearly,
                        style: TextStyle(color: AppColors.black, fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_selectedFrequency == RepeatFrequency.weekly) ...[
              Wrap(
                children: List.generate(AppConstants.weekTitles.length, (
                  index,
                ) {
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
              RadioGroup(
                groupValue: _selectedRecurrenceEnd,
                onChanged: (value) =>
                    setState(() => _selectedRecurrenceEnd = value),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate.reoccurrenceEndsOn,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      children: [
                        Radio(value: RecurrenceEnd.never),
                        Text(
                          translate.never,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: RecurrenceEnd.onDate),
                        Text(
                          translate.on,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: RecurrenceEnd.after),
                        Text(
                          translate.after,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: 15),
            if (_selectedRecurrenceEnd == RecurrenceEnd.onDate)
              DateTimeSelectorFormField(
                initialDateTime: _recurrenceEndDate,
                decoration: AppConstants.inputDecoration.copyWith(
                  labelText: translate.endsOn,
                ),
                onSelect: (date) {
                  if (date.withoutTime.isBefore(_endDate.withoutTime)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(translate.recurrenceEndsAfterEndDate),
                      ),
                    );
                  } else {
                    _recurrenceEndDate = date.withoutTime;
                  }

                  if (mounted) {
                    setState(() {});
                  }
                },
                validator: (value) {
                  if (value == null || value == "") {
                    return translate.pleaseSelectEndDate;
                  }

                  // TODO(Shubham): Add validation of end occurrence >= end date
                  return null;
                },
                textStyle: TextStyle(color: AppColors.black, fontSize: 17.0),
                onSave: (date) =>
                    _recurrenceEndDate = date ?? _recurrenceEndDate,
                type: DateTimeSelectionType.date,
              ),
            if (_selectedRecurrenceEnd == RecurrenceEnd.after)
              TextFormField(
                controller: _occurrenceController,
                style: TextStyle(color: AppColors.black, fontSize: 17.0),
                keyboardType: TextInputType.number,
                minLines: 1,
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.trim() == '') {
                    return translate.pleaseSpecifyOccurrences;
                  }

                  return null;
                },
                decoration: AppConstants.inputDecoration.copyWith(
                  hintText: '30',
                  suffixText: translate.occurrences,
                  counterText: '',
                ),
              ),
          ],
          SizedBox(height: 15.0),
          Row(
            children: [
              Text(
                translate.eventColor,
                style: TextStyle(color: color.onSurface, fontSize: 17),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(radius: 15, backgroundColor: _color),
              ),
            ],
          ),
          SizedBox(height: 15),
          CustomButton(
            onTap: _createEvent,
            title: widget.event == null
                ? translate.addEvent
                : translate.updateEvent,
          ),
        ],
      ),
    );
  }

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    DateTime? combinedStartTime;
    DateTime? combinedEndTime;

    if (_startTime != null) {
      // Create a proper DateTime that combines the start date with start time
      combinedStartTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime!.hour,
        _startTime!.minute,
      );
    }

    if (_endTime != null) {
      // Create a proper DateTime that combines the end date with end time
      combinedEndTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }

    // Only create recurrence settings if not using the default "Do not repeat" option
    RecurrenceSettings? recurrence;
    if (_selectedFrequency != null &&
        _selectedFrequency != RepeatFrequency.doNotRepeat) {
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

      recurrence = RecurrenceSettings.withCalculatedEndDate(
        startDate: _startDate,
        endDate: endDate,
        frequency: _selectedFrequency ?? RepeatFrequency.daily,
        weekdays: _toWeekdayInIndices,
        occurrences: occurrences,
        recurrenceEndOn: _selectedRecurrenceEnd ?? RecurrenceEnd.never,
      );
    }

    // Determine the appropriate endDate based on whether this is a recurring event
    final DateTime eventEndDate =
        (_selectedFrequency == RepeatFrequency.doNotRepeat)
        ? _endDate
        : _endDate.isAtSameMomentAs(_startDate)
        ? _startDate
        : _endDate;

    final event = CalendarEventData(
      date: _startDate,
      endDate: eventEndDate,
      endTime: combinedEndTime,
      startTime: combinedStartTime,
      color: _color,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      recurrenceSettings: recurrence,
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
    _color = event.color; // Set the event color

    // Handle recurrence settings
    if (event.recurrenceSettings != null &&
        event.recurrenceSettings!.frequency != RepeatFrequency.doNotRepeat) {
      _isRecurring = true;
      _selectedFrequency = event.recurrenceSettings!.frequency;
      _selectedRecurrenceEnd = event.recurrenceSettings!.recurrenceEndOn;
      _recurrenceEndDate = event.recurrenceSettings!.endDate ?? _startDate;

      // Handle occurrences for "After" recurrence end type
      if (_selectedRecurrenceEnd == RecurrenceEnd.after) {
        _occurrenceController.text =
            (event.recurrenceSettings!.occurrences ?? 1).toString();
      }

      // Clear weekdays selection and then set the selected days
      _selectedDays = List.filled(7, false);
      event.recurrenceSettings!.weekdays.forEach(
        (index) => _selectedDays[index] = true,
      );
    } else {
      _isRecurring = false;
      _selectedFrequency = RepeatFrequency.doNotRepeat;
      updateWeekdaysSelection();
    }
  }

  void _resetForm() {
    _form.currentState?.reset();

    _titleController.text = '';
    _descriptionController.text = '';
    _occurrenceController.text = '';

    _startDate = DateTime.now().withoutTime;
    _endDate = DateTime.now().withoutTime;
    _startTime = null;
    _endTime = null;
    _color = Colors.blue;
    _recurrenceEndDate = null;
    _selectedDays.fillRange(0, _selectedDays.length, true);
    _selectedFrequency = RepeatFrequency.doNotRepeat;
    _selectedRecurrenceEnd = RecurrenceEnd.never;
    _isRecurring = false;

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
            translate.selectEventColor,
            style: TextStyle(color: AppColors.black, fontSize: 25.0),
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
                title: translate.select,
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
