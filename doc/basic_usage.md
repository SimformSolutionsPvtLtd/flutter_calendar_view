1. Wrap `MaterialApp` with `CalendarControllerProvider` and
   assign `EventController` to it.

    ```dart
    CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
            // Your initialization for material app.
        ),
    )
    ```

2. Add calendar views.

   For Month View

    ```dart
    Scaffold(
        body: MonthView(),
    );
    ```

   For Day View

    ```dart
    Scaffold(
        body: DayView(),
    );
    ```

   For Week view

    ```dart
    Scaffold(
        body: WeekView(),
    );
    ```

   For more info on properties
   visit [documentation](https://pub.dev/documentation/calendar_view/latest/calendar_view/calendar_view-library.html)
   .

3. Use `controller` to add or remove events.

   To Add event:

    ```dart
    final event = CalendarEventData(
        date: DateTime(2021, 8, 10),
        event: "Event 1",
    );

    CalendarControllerProvider.of(context).controller.add(event);
    ```

   To Add events in range of dates:

   ```dart
   final event = CalendarEventData(
           date: DateTime(2021, 8, 10),
           endDate: DateTime(2021,8,15),
           event: "Event 1",
       );

       CalendarControllerProvider.of(context).controller.add(event);
   ```

   To Remove event:

    ```dart
    CalendarControllerProvider.of(context).controller.remove(event);
    ```

   As soon as you add or remove events from the controller, it will
   automatically update the
   calendar view assigned to that controller.
   See, [Use of EventController](#use-of-eventcontroller)
   for more info

4. Use `GlobalKey` to change the page or jump to a specific page or date.
   See, [Use of GlobalKey](#use-of-globalkey) for more info.