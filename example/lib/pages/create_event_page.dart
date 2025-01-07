import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../widgets/add_event_form.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key, this.event});

  final CalendarEventData? event;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.surfaceContainerHigh,
        centerTitle: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: color.onSurface,
          ),
        ),
        title: Text(
          event == null ? "Create New Event" : "Update Event",
          style: TextStyle(
            color: color.onSurface,
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
