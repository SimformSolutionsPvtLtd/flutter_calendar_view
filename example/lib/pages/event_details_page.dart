import 'package:calendar_view/calendar_view.dart';
import 'package:example/widgets/delete_event_dialog.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import 'create_event_page.dart';

class DetailsPage extends StatelessWidget {
  final CalendarEventData event;
  final DateTime date;

  const DetailsPage({
    required this.event,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: event.color,
        elevation: 0,
        centerTitle: false,
        title: Text(
          event.title,
          style: TextStyle(
            color: event.color.accentColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: event.color.accentColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            "Date: ${event.date.dateToStringWithFormat(format: "dd/MM/yyyy")}",
          ),
          SizedBox(
            height: 15.0,
          ),
          if (event.startTime != null && event.endTime != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From"),
                      Text(
                        event.startTime
                                ?.getTimeInFormat(TimeStampFormat.parse_12) ??
                            "",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To"),
                      Text(
                        event.endTime
                                ?.getTimeInFormat(TimeStampFormat.parse_12) ??
                            "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
          if (event.description?.isNotEmpty ?? false) ...[
            Divider(),
            Text("Description"),
            SizedBox(
              height: 10.0,
            ),
            Text(event.description!)
          ],
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _handleDeleteEvent(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete Event'),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CreateEventPage(
                          event: event,
                        ),
                      ),
                    );

                    if (result != null) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Edit Event'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handles the deletion of an event, showing a dialog for repeating events.
  ///
  /// This method checks if the event is a repeating event. If it is, it shows
  /// a dialog to the user to choose the deletion type (e.g., delete this
  /// event, delete following events, delete all events).
  /// If the event is not repeating, it defaults to deleting all occurrences
  /// of the event.
  Future<void> _handleDeleteEvent(BuildContext context) async {
    DeleteEvent? result;

    if (event.isRecurringEvent) {
      result = await showDialog(
        context: context,
        builder: (_) => DeleteEventDialog(),
      );
    } else {
      result = DeleteEvent.all;
    }
    if (result != null) {
      CalendarControllerProvider.of(context).controller.deleteRecurrenceEvent(
            date: date,
            event: event,
            deleteEventType: result,
          );
    }
  }
}
