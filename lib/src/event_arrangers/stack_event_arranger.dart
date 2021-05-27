part of 'event_arrangers.dart';

class StackEventArranger<T> extends EventArranger<T> {
  final double leftOffset;
  final double topOffset;

  /// This class will provide method that wil arrange all the events on each other.
  ///
  const StackEventArranger({this.leftOffset = 5, this.topOffset = 10})
      : assert(topOffset > 0, "Top offset must be grater than 0.");

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    List<OrganizedCalendarEventData<T>> arrangedEvents = [];

    // TODO: Add logic to arrange events

    return arrangedEvents;
  }
}
