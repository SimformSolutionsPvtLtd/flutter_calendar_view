import 'package:flutter/material.dart';

import '../../calendar_view.dart';

/// Use this widget if you want interaction with Event Tiles in your Day View.
class InteractiveDayViewEventTile<T extends Object?> extends StatefulWidget {
  final DateTime date;
  final List<CalendarEventData<T>> events;
  final Rect boundary;
  final DateTime startDuration;
  final DateTime endDuration;

  /// The controller is required to make changes to the eventDatas.
  final EventController<T>? controller;

  /// This is the height of each minute in the day view.
  /// - Required to make sure the gestures and the event tile sizing are in sync.
  final double heightPerMinute;

  /// Called when the user finishes editing the event.
  /// - Use this if you want to do any operation after user finishes editing the event.
  final Function(CalendarEventData<T> evenData)? editComplete;

  const InteractiveDayViewEventTile({
    required this.controller,
    required this.date,
    required this.events,
    required this.boundary,
    required this.startDuration,
    required this.endDuration,
    this.heightPerMinute = 0.7,
    this.editComplete,
  });

  @override
  State<InteractiveDayViewEventTile<T>> createState() =>
      _InteractiveDayViewEventTileState<T>();
}

class _InteractiveDayViewEventTileState<T extends Object?>
    extends State<InteractiveDayViewEventTile<T>> {
  EventController<T>? _controller;

  late VoidCallback _reloadCallback;

  late DateTime date;

  late List<CalendarEventData<T>> events;

  late Rect boundary;

  late DateTime startDuration;

  late DateTime endDuration;

  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _reloadCallback = _reload;
    date = widget.date;
    events = widget.events;
    boundary = widget.boundary;
    startDuration = widget.startDuration;
    endDuration = widget.endDuration;
    _isSelected = _controller?.selectedEventData == events[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = widget.controller;
    if (newController != _controller) {
      _controller = newController;

      _controller!
        // Removes existing callback.
        ..removeListener(_reloadCallback)

        // Reloads the view if there is any change in controller or
        // user adds new events.
        ..addListener(_reloadCallback);
    }
  }

  @override
  void didUpdateWidget(InteractiveDayViewEventTile<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller.
    final newController = widget.controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    if (oldWidget.date != widget.date) {
      date = widget.date;
    }

    if (oldWidget.events != widget.events) {
      events = widget.events;
    }

    if (oldWidget.boundary != widget.boundary) {
      boundary = widget.boundary;
    }

    if (oldWidget.startDuration != widget.startDuration) {
      startDuration = widget.startDuration;
    }

    if (oldWidget.endDuration != widget.endDuration) {
      endDuration = widget.endDuration;
    }

    if (oldWidget.events != widget.events) {
      events = widget.events;
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);
    super.dispose();
  }

  /// Reloads page.
  ///
  void _reload() {
    if (mounted) {
      _isSelected =
          _controller?.selectedEventData?.compareWithoutTime(events[0]) ??
              false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveRoundedEventTile(
      borderRadius: BorderRadius.circular(10.0),
      title: events[0].title,
      totalEvents: events.length - 1,
      description: events[0].description,
      padding: EdgeInsets.all(10.0),
      backgroundColor: events[0].color,
      margin: EdgeInsets.all(2.0),
      titleStyle: events[0].titleStyle,
      descriptionStyle: events[0].descriptionStyle,
      selectedOutlineColor: Theme.of(context).colorScheme.onSurface,
      handleColor: Theme.of(context).colorScheme.onSurface,
      isSelected: _isSelected,
      onTap: () {
        _controller?.handleEventDataTap(events[0]);
      },
      changeStartTime: (primaryDelta) {
        final newEventData =
            _controller?.selectedEventData?.updateEventStartTime(
          primaryDelta: primaryDelta,
          heightPerMinute: widget.heightPerMinute,
        );

        if (newEventData == null) return;
        _controller?.replace(newEventData);
      },
      changeEndTime: (primaryDelta) {
        final newEventData = _controller?.selectedEventData?.updateEventEndTime(
          primaryDelta: primaryDelta,
          heightPerMinute: widget.heightPerMinute,
        );

        if (newEventData == null) return;
        _controller?.replace(newEventData);
      },
      reschedule: (primaryDelta) {
        final newEventData = _controller?.selectedEventData?.rescheduleEvent(
          primaryDelta: primaryDelta,
          heightPerMinute: widget.heightPerMinute,
        );

        if (newEventData == null) return;
        _controller?.replace(newEventData);
      },
      editComplete: () {
        if (widget.editComplete != null &&
            _controller?.selectedEventData != null) {
          widget.editComplete!(_controller!.selectedEventData!);
        }
      },
    );
  }
}
