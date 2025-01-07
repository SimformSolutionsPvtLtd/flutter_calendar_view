import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../widgets/add_event_form.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key, this.event});

  final CalendarEventData? event;

  @override
  Widget build(BuildContext context) {
    final themeColor = context.appColors;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: themeColor.onPrimary,
          ),
        ),
        title: Text(
          event == null ? "Create New Event" : "Update Event",
          style: TextStyle(
            color: themeColor.onPrimary,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: AddOrEditEventForm(
            onEventAdd: (newEvent) {
              if (this.event != null) {
                CalendarControllerProvider.of(context)
                    .controller
                    .update(this.event!, newEvent);
              } else {
                CalendarControllerProvider.of(context).controller.add(newEvent);
              }

              context.pop(true);
            },
            event: event,
          ),
        ),
      ),
    );
  }
}
