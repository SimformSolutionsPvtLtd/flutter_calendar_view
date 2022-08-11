# [1.0.0 - 12 Aug 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.0.0)

- **Breaking Changes**
    - Improved logic to compare `CalendarEventData`.

      Note: This changes the behaviour of comparing two events using `==` operator. Please test your
      app properly after updating to this version.

- Add 15,30 and 60 minutes slots for `onDateLongPress` callback in Week and Day view.
- Add method to update filter in `EventController`.
- Restructured the logic to store single time events.
- Add method to scroll to an event.
  Issue [#30 - Scroll to an event in day view](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/30)
- Added
  feature [#36 - Feature/custom strings](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/36)
- Use normalized dates in difference calculations.

# [0.0.5 - 2 Jun 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.5)

- Fixed
  issue [#48 - WeekView header date is different from the calendar view](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/48)
- Added
  feature [#46 - Change beginning of week in MonthView](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/46)
- Fixed
  issue [#42 - WeekDayTile causes RenderFlex-Overflow](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/42)
- Fixed
  issue [#65 - Adding onCellTap callback breaks whole calendar](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/65)
- Fixed
  issue [#62 - Missing redraw events](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/62)
- Fixed
  issue [#16 - Scroll to index/liveTime](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/16)
- Show live time indicator line above event tiles.
  PR [#67](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/67)

# [0.0.4 - 2 Mar 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.4)

- Fixed
  issue [#39 - Detect a long press on the calendar](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/39)
- Fixed
  issue [#38 - Modifying CalendarEventData](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/38)
- Fixed
  issue [#27 - EventController remove event don't work](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/27)
- Fixed
  issue [#13 - Give the option to show weekdays in a WeekView.](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/13)

# [0.0.3 - 12 Oct 2021](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.3)

- Added support for multiple day events

# [0.0.2 - 3 Sep 2021](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.2)

- Update `README.md` file.
- Add license information in package files.
- Update project description in `pubspec.yaml`
- Update documentation.
- Add `CalendarControllerProvider`.
- Add `onEventTap` callback in `WeekView` and `DayView`.
- Add `onCellTap` callback in `MonthView`.
- Make `controller` optional parameter in all views where `CalendarControllerProvider` is provided.

# [0.0.1 - 26 Aug 2021](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.1)

- Initial release