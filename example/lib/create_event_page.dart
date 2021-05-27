import 'package:example/constants.dart';
import 'package:example/date_time_selector.dart';
import 'package:example/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'extension.dart';

class CreateEventPage extends StatefulWidget {
  final bool withDuration;

  const CreateEventPage({Key? key, this.withDuration = false})
      : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  GlobalKey<FormState> _formKey = GlobalKey();

  late DateTime _date;
  DateTime? _startTime;
  DateTime? _endTime;
  String _title = "";
  String _description = "";
  Color _color = Colors.blue;

  late FocusNode _titleNode;
  late FocusNode _descriptionNode;
  late FocusNode _dateNode;

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();

    super.dispose();
  }

  void _displayColorPicker() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => Dialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: Constants.defaultBorderColor,
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Event Color",
                style: TextStyle(
                  color: Constants.defaultBorderColor.withOpacity(1),
                  fontSize: 20.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Constants.defaultBorderColor,
              ),
              ColorPicker(
                displayThumbColor: true,
                enableAlpha: false,
                showLabel: true,
                paletteType: PaletteType.hsv,
                pickerColor: _color,
                onColorChanged: (color) {
                  _color = color;
                  if (mounted) setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: context.popRoute,
          icon: Icon(
            Icons.arrow_back,
            color: AppConstants.black,
          ),
        ),
        title: Text(
          "Create New Event",
          style: TextStyle(
            color: AppConstants.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            TextFormField(
              focusNode: _titleNode,
              style: TextStyle(
                color: AppConstants.black,
                fontSize: 17.0,
              ),
              decoration: InputDecoration(
                labelText: "Title",
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim() == "") return "Invalid Title";
                return null;
              },
              onSaved: (value) => _title = value ?? "",
            ),
            SizedBox(
              height: 15.0,
            ),
            DateTimeSelectorFormField(
              decoration: InputDecoration(
                labelText: "Select Date",
              ),
              onSave: (date) => _date = date,
              textStyle: TextStyle(
                color: AppConstants.black,
                fontSize: 17.0,
              ),
              type: DateTimeSelectionType.date,
            ),
            SizedBox(
              height: 15.0,
            ),
            if (widget.withDuration) ...[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: DateTimeSelectorFormField(
                      decoration: InputDecoration(
                        labelText: "Start Time",
                      ),
                      textStyle: TextStyle(
                        color: AppConstants.black,
                        fontSize: 17.0,
                      ),
                      onSave: (date) => _startTime = date,
                      type: DateTimeSelectionType.time,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: DateTimeSelectorFormField(
                      decoration: InputDecoration(
                        labelText: "End Time",
                      ),
                      textStyle: TextStyle(
                        color: AppConstants.black,
                        fontSize: 17.0,
                      ),
                      onSave: (date) => _endTime = date,
                      type: DateTimeSelectionType.time,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
            TextFormField(
              focusNode: _descriptionNode,
              style: TextStyle(
                color: AppConstants.black,
                fontSize: 17.0,
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              selectionControls: MaterialTextSelectionControls(),
              minLines: 1,
              maxLines: 10,
              maxLength: 1000,
              validator: (value) {
                if (value == null || value.trim() == "")
                  return "Invalid Description";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Description",
              ),
              onSaved: (value) => _description = value ?? "",
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Event Color: "),
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
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  CalendarEventData<Event> event = CalendarEventData<Event>(
                    date: _date,
                    event: Event(title: _title),
                    title: _title,
                    description: _description,
                    startTime: _startTime,
                    endTime: _endTime,
                    eventColor: _color,
                  );
                  context.popRoute(event);
                }
              },
              child: Text(
                "Create",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: AppConstants.white),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(8),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
