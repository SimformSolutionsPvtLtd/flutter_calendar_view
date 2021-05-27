part of 'event_arrangers.dart';

class MergeEventArranger<T> extends EventArranger<T> {
  /// This class will provide method that will merge all the simultaneous events. and that will act like one single event.
  /// [OrganizedCalendarEventData.events] will gives list of all the combined events.
  ///
  ///
  const MergeEventArranger();

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    List<OrganizedCalendarEventData<T>> arrangedEvents = [];

    List<CalendarEventData<T>> skippedEvents = [];

    for (CalendarEventData<T> event in events) {
      DateTime startTime = event.startTime ?? DateTime.now();
      DateTime endTime = event.endTime ?? startTime;
      // If event has null start time or null end time or end time is earlier than start time or end time and tart time is same.
      // Skip that event.
      //
      if (endTime.getTotalMinutes <= startTime.getTotalMinutes) {
        skippedEvents.add(event);
        continue;
      }
      int eventStart = startTime.getTotalMinutes;
      int eventEnd = endTime.getTotalMinutes;

      int arrangeEventLen = arrangedEvents.length;

      int eventIndex = -1;

      for (int i = 0; i < arrangeEventLen; i++) {
        int arrangedEventStart =
            arrangedEvents[i].startDuration?.getTotalMinutes ?? 0;
        int arrangedEventEnd =
            arrangedEvents[i].endDuration?.getTotalMinutes ?? 0;

        if ((arrangedEventStart >= eventStart &&
                arrangedEventStart <= eventEnd) ||
            (arrangedEventEnd >= eventStart && arrangedEventEnd <= eventEnd) ||
            (eventStart >= arrangedEventStart &&
                eventStart <= arrangedEventEnd) ||
            (eventEnd >= arrangedEventStart && eventEnd <= arrangedEventEnd)) {
          eventIndex = i;
          break;
        }
      }

      if (eventIndex == -1) {
        double top = eventStart * heightPerMinute;
        double left = 0;
        double right = 0;
        double bottom = height - eventEnd * heightPerMinute;

        OrganizedCalendarEventData<T> newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          startDuration: startTime.copyFromMinutes(eventStart),
          endDuration: endTime.copyFromMinutes(eventEnd),
          events: [event],
        );

        arrangedEvents.add(newEvent);
      } else {
        OrganizedCalendarEventData<T> arrangedEventData =
            arrangedEvents[eventIndex];

        int arrangedEventStart =
            arrangedEventData.startDuration?.getTotalMinutes ?? 0;
        int arrangedEventEnd =
            arrangedEventData.endDuration?.getTotalMinutes ?? 0;

        int startDuration = math.min(eventStart, arrangedEventStart);
        int endDuration = math.max(eventEnd, arrangedEventEnd);

        double top = startDuration * heightPerMinute;
        double left = 0;
        double right = 0;
        double bottom = height - endDuration * heightPerMinute;

        OrganizedCalendarEventData<T> newEvent = OrganizedCalendarEventData<T>(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          startDuration:
              arrangedEventData.startDuration?.copyFromMinutes(startDuration),
          endDuration:
              arrangedEventData.endDuration?.copyFromMinutes(endDuration),
          events: arrangedEventData.events..add(event),
        );

        arrangedEvents[eventIndex] = newEvent;
      }
    }

    print("Skipped Event... Total: ${skippedEvents.length}");
    print(skippedEvents);
    print("End Skipped Event....");

    return arrangedEvents;
  }
}
