import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';

typedef Validator = String? Function(String? value);

enum DateTimeSelectionType { date, time }

class DateTimeSelectorFormField extends StatefulWidget {
  final Function(DateTime?)? onSelect;
  final DateTimeSelectionType? type;
  final FocusNode? focusNode;
  final DateTime? minimumDateTime;
  final Validator? validator;
  final bool displayDefault;
  final TextStyle? textStyle;
  final void Function(DateTime date)? onSave;
  final InputDecoration? decoration;
  final TextEditingController controller;

  const DateTimeSelectorFormField({
    this.onSelect,
    this.type,
    this.onSave,
    this.decoration,
    this.focusNode,
    this.minimumDateTime,
    this.validator,
    this.displayDefault = false,
    this.textStyle,
    required this.controller,
  });

  @override
  _DateTimeSelectorFormFieldState createState() =>
      _DateTimeSelectorFormFieldState();
}

class _DateTimeSelectorFormFieldState extends State<DateTimeSelectorFormField> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _textEditingController = widget.controller;
    _focusNode = FocusNode();

    _selectedDate = widget.minimumDateTime ?? DateTime.now();

    if (widget.displayDefault && widget.minimumDateTime != null) {
      if (widget.type == DateTimeSelectionType.date) {
        _textEditingController.text = widget.minimumDateTime
                ?.dateToStringWithFormat(format: "dd/MM/yyyy") ??
            "";
      } else {
        _textEditingController.text =
            widget.minimumDateTime?.getTimeInFormat(TimeStampFormat.parse_12) ??
                "";
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _showSelector() async {
    DateTime? date;

    if (widget.type == DateTimeSelectionType.date) {
      date = await _showDateSelector();
      _textEditingController.text =
          (date ?? _selectedDate).dateToStringWithFormat(format: "dd/MM/yyyy");
    } else {
      date = await _showTimeSelector();
      _textEditingController.text =
          (date ?? _selectedDate).getTimeInFormat(TimeStampFormat.parse_12);
    }

    _selectedDate = date ?? DateTime.now();

    if (mounted) {
      setState(() {});
    }

    widget.onSelect?.call(date);
  }

  Future<DateTime?> _showDateSelector() async {
    final now = widget.minimumDateTime ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: widget.minimumDateTime ?? now,
      lastDate: CalendarConstants.maxDate,
    );

    if (date == null) return null;

    return date;
  }

  Future<DateTime?> _showTimeSelector() async {
    final now = widget.minimumDateTime ?? DateTime.now();
    final time = await showTimePicker(
      context: context,
      builder: (context, widget) {
        return widget ?? Container();
      },
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );

    if (time == null) return null;

    final date = now.copyWith(
      hour: time.hour,
      minute: time.minute,
    );

    if (widget.minimumDateTime == null) return date;

    return date;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSelector,
      child: TextFormField(
        style: widget.textStyle,
        controller: _textEditingController,
        validator: widget.validator,
        minLines: 1,
        onSaved: (value) => widget.onSave?.call(_selectedDate),
        enabled: false,
        decoration: widget.decoration,
      ),
    );
  }
}
