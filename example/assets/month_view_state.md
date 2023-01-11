# MonthViewState

State class for [MonthView](month_view.md) widget. This class provides methods to change page or jump to a specific page. You can access those methods by providing `GlobalKey` to [MonthView](month_view.md) widget.

ex,

```dart

// Initialize key.
final key = GlobalKey<MonthViewState>();

// Assign it to month view.
MonthView(
  key: key,
);

// access state methods.

key.currentState!.nextPage(); // this will change month view page.

```

## Properties

### controller -> [EventController](event_controller.md)

Returns controller object assigned to current view. This will throw Assertion error if it it is accessed before `MonthViewState` is initialized.

### currentDate -> DateTime

Returns date that is currently visible in [MonthView](month_view.md)

### currentPage -> int

Returns index of current active page.

## Methods

### nextPage

Syntax:

```dart
void nextPage({Duration? duration, Curve? curve});
```

Animate to next page. Arguments `duration` and `curve` will override default values provided as [MonthView.pageTransitionDuration](month_view.md) and [MonthView.pageTransitionCurve](month_view.md) respectively.

### previousPage

Syntax:

```dart
void previousPage({Duration? duration, Curve? curve});
```

Animate to previous page. Arguments `duration` and `curve` will override default values provided as [MonthView.pageTransitionDuration](month_view.md) and [MonthView.pageTransitionCurve](month_view.md) respectively.

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

Animates to page index defines by `page`. Arguments `duration` and `curve` will override default values provided as [MonthView.pageTransitionDuration](month_view.md) and [MonthView.pageTransitionCurve](month_view.md) respectively.

### jumpToMonth

Syntax:

```dart
void jumpToMonth(DateTime month);
```

Jumps to page that has calendar for given `month`.

### animateToMonth

Syntax:

```dart
Future<void> animateToMonth(DateTime month, {Duration? duration, Curve? curve});
```

Animates to page that has calendar for given `month`. Arguments `duration` and `curve` will override default values provided as [MonthView.pageTransitionDuration](month_view.md) and [MonthView.pageTransitionCurve](month_view.md) respectively.
