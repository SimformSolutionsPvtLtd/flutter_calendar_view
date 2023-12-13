import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';

typedef Validator = String? Function(String? value);

enum DateTimeSelectionType { date, time }

class DateTimeSelectorFormField extends StatefulWidget {
  /// Called when date is selected.
  final Function(DateTime)? onSelect;

  /// Selection time, date or time.
  final DateTimeSelectionType type;

  final FocusNode? focusNode;

  /// Minimum date that can be selected.
  final DateTime? minimumDateTime;

  final Validator? validator;

  final TextStyle? textStyle;
  final void Function(DateTime? date)? onSave;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final DateTime? initialDateTime;

  const DateTimeSelectorFormField({
    this.onSelect,
    this.type = DateTimeSelectionType.time,
    this.onSave,
    this.decoration,
    this.focusNode,
    this.minimumDateTime,
    this.validator,
    this.textStyle,
    this.controller,
    this.initialDateTime,
  });

  @override
  _DateTimeSelectorFormFieldState createState() =>
      _DateTimeSelectorFormFieldState();
}

class _DateTimeSelectorFormFieldState extends State<DateTimeSelectorFormField> {
  late var _minimumDate = CalendarConstants.minDate.withoutTime;

  late var _textEditingController =
      widget.controller ?? TextEditingController();
  late var _focusNode = _getFocusNode();

  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    _setDates();
  }

  @override
  void didUpdateWidget(covariant DateTimeSelectorFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.dispose();
      _focusNode = _getFocusNode();
    }

    if (widget.controller != oldWidget.controller) {
      _textEditingController.dispose();
      _textEditingController = widget.controller ?? TextEditingController();
    }

    if (_selectedDate != oldWidget.initialDateTime ||
        widget.minimumDateTime != oldWidget.minimumDateTime) {
      _setDates();
    }
  }

  FocusNode _getFocusNode() {
    final node = widget.focusNode ?? FocusNode();

    // node.addListener(() {
    //   if (node.hasFocus) {
    //     _showSelector();
    //   }
    // });

    return node;
  }

  @override
  void dispose() {
    if (widget.controller == null) _textEditingController.dispose();
    if (widget.focusNode == null) _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSelector,
      child: TextFormField(
        focusNode: _focusNode,
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

  Future<void> _showSelector() async {
    DateTime? date;

    if (widget.type == DateTimeSelectionType.date) {
      date = await _showDateSelector();

      _textEditingController.text = (date ?? _selectedDate)
              ?.dateToStringWithFormat(format: "dd/MM/yyyy") ??
          '';
    } else {
      date = await _showTimeSelector();

      _textEditingController.text =
          (date ?? _selectedDate)?.getTimeInFormat(TimeStampFormat.parse_12) ??
              '';
    }

    _selectedDate = date ?? _selectedDate;

    if (mounted) {
      setState(() {});
    }

    if (date != null) {
      widget.onSelect?.call(date);
    }
  }

  Future<DateTime?> _showDateSelector() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.minimumDateTime ?? CalendarConstants.minDate,
      lastDate: CalendarConstants.maxDate,
    );

    return date;
  }

  Future<DateTime?> _showTimeSelector() async {
    final now = _selectedDate ?? DateTime.now();

    final time = await showTimePicker(
      context: context,
      builder: (context, widget) {
        return widget ?? SizedBox.shrink();
      },
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (time == null) return null;

    final date = now.copyWith(
      hour: time.hour,
      minute: time.minute,
    );

    return date;
  }

  void _setDates() {
    _minimumDate = widget.minimumDateTime ?? CalendarConstants.minDate;
    _selectedDate = widget.initialDateTime;

    switch (widget.type) {
      case DateTimeSelectionType.date:
        if (_selectedDate?.withoutTime.isBefore(_minimumDate.withoutTime) ??
            false) {
          throw 'InitialDate is smaller than Minimum date';
        }

        // We are adding this to avoid internal error while
        // rebuilding the widget.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _textEditingController.text =
              _selectedDate?.dateToStringWithFormat(format: "dd/MM/yyyy") ?? '';
        });

        break;

      case DateTimeSelectionType.time:
        if (_selectedDate != null &&
            _selectedDate!.getTotalMinutes < _minimumDate.getTotalMinutes) {
          throw 'InitialDate is smaller than Minimum date';
        }

        // We are adding this to avoid internal error while
        // rebuilding the widget.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _textEditingController.text =
              _selectedDate?.getTimeInFormat(TimeStampFormat.parse_12) ?? '';
        });

        break;
    }
  }
}
