# Typedefs

## Function definitions

### CellBuilder

Value:

```dart
Widget Function(
    DateTime date,
    List<CalendarEventData> event,
    bool isToday,
    bool isInMonth,
);
```

### EventTileBuilder

Value:

```dart
Widget Function(
    DateTime date,
    List<CalendarEventData> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
);
```

### WeekDayBuilder

Value:

```dart
Widget Function(
  int day,
);
```

### DateWidgetBuilder

Value:

```dart
Widget Function(
  DateTime date,
);
```

### CalendarPageChangeCallBack

```dart
void Function(
    DateTime date, 
    int page, 
);
```

### PageChangeCallback

Value:

```dart
void Function(
  DateTime date,
  CalendarEventData event,
);
```

### StringProvider

Value:

```dart
String Function(
    DateTime date, 
    {
      DateTime? secondaryDate,
    }
);
```

### WeekPageHeaderBuilder

Value:

```dart
Widget Function(
    DateTime startDate, 
    DateTime endDate,
);
```

### TileTapCallback

Value:

```dart
void Function(
    CalendarEventData<T> event, 
    DateTime date,
);
```

### CellTapCallback

Value:

```dart
void Function(
    List<CalendarEventData> events, 
    DateTime date,
);
```

### EventFilter

Value:

```dart
List<CalendarEventData> Function(
    DateTime date, 
    List<CalendarEventData> events, 
);
```
