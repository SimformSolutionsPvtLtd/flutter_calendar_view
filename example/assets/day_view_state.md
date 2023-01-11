# DayViewState

State class for [DayView](day_view.md) widget. This class provides methods to change page or jump to a specific page. You can access those methods by providing `GlobalKey` to [DayView](day_view.md) widget.

ex,

```dart

// Initialize key.
final key = GlobalKey<DayViewState>();

// Assign it to day view.
DayView(
  key: key,
);

// access state methods.

key.currentState!.nextPage(); // this will change day view page.

```

## Properties

### controller -> [EventController](event_controller.md)

Returns controller object assigned to current view. This will throw Assertion error if it it is accessed before `DayViewState` is initialized.

### currentDate -> DateTime

Returns date that is currently visible in [DayView](day_view.md)

### currentPage -> int

Returns index of current active page.

## Methods

### nextPage

Syntax:

```dart
void nextPage({Duration? duration, Curve? curve});
```

Animate to next page. Arguments `duration` and `curve` will override default values provided as [DayView.pageTransitionDuration](day_view.md) and [DayView.pageTransitionCurve](day_view.md) respectively.

### previousPage

Syntax:

```dart
void previousPage({Duration? duration, Curve? curve});
```

Animate to previous page. Arguments `duration` and `curve` will override default values provided as [DayView.pageTransitionDuration](day_view.md) and [DayView.pageTransitionCurve](day_view.md) respectively.

### jumpToPage

Syntax:

```dart
void jumpToPage(int page);
```

Jumps to page index defined by `page`. No animation will happen when user calls this method.

### animateToPage

Syntax:

```dart
Future<void> animateToPage(int page, {Duration? duration, Curve? curve});
```

Animates to page index defines by `page`. Arguments `duration` and `curve` will override default values provided as [DayView.pageTransitionDuration](day_view.md) and [DayView.pageTransitionCurve](day_view.md) respectively.

### jumpToDate

Syntax:

```dart
void jumpToDate(DateTime date);
```

Jumps to page that has calendar for given `date`.

### animateToDate

Syntax:

```dart
Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve});
```

Animates to page that has calendar for given `date`. Arguments `duration` and `curve` will override default values provided as [DayView.pageTransitionDuration](day_view.md) and [DayView.pageTransitionCurve](day_view.md) respectively.
