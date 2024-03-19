- # [1.1.1] (UnReleased)
- Fixed issue related to onDateTap no triggered in WeekView and dayView. [#332](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/332)
# [1.1.0 - 28 Feb 2024](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.1.0) 
- Fixed issue related to Hiding Header [#299](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/299)
- Fixed issue related to auto scroll to initial duration for day
  view. [#269](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/269)
- Added
  feature added a callback for the default header title. [#241](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/241)
- Added
  feature added the quarterHourIndicator for the DayView & halfHourIndicator and
  quarterHourIndicator for WeekView. [#270](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/270)
- Added
  feature added Support for changing the week day position(top/bottom) in weekView. [#283](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/283)
- Adds new flag `includeEdges` in `EventArrangers`. [#290](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/294)
- Fixed null check exception while adding events. [#282](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/282)
- Added new method `update` to update the events in `EventController`. [#125](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/125)
- Added new parameter `includeFullDayEvents` in `getEventsOnDay` to decide whether to include full-day events in the returned list or not.
- Added getters `isRangingEvent` and `isFullDayEvent` in `CalendarEventData` to check if the event is a ranging event or a full-day event.
- Added new method `occursOnDate` in `CalendarEventData` to check if the event occurs on the given date or not.
- Made `description` in `CalendarEventData` nullable.
- Fixed issue in `MonthView` event's titleStyle to set the style from specific event.[#325](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/325)
### Deprecations
  - Deprecated `events` getter in `EventController` and adds `allEvents` to replace it.

# [1.0.4 - 9 Aug 2023](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.0.4)

- Fixed
  Issue [#219 - There is an issue with the daily view layout display](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/219)
- Fixed
  Issue [#205 - SafeArea can't be deactivated on MonthView](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/205)
- Fixed
  Issue [#237 - DayView & MonthView layout issue in landscape mode](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/237)
- Added Feature
  [#57 - Change default start hour in DayView](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/57)
- Fixed
  Issue [#225 - Unwanted space at top in DayView while using sliver](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/225)

# [1.0.3 - 3 Apr 2023](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.0.3)

- Added
  Feature [#172 - Press Detector builder for day view and week view](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/172)
- Added
  Feature [#147 - Added text style and description style in CalendarEventData](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/147)
- Added
  Feature [#174 - Animate to specific scroll controller offset](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/174)
- Fixed
  Issue [#161 - Unable to add 11.30 PM to 12.00PM](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/161)
- Fixed
  Issue [#179 - Removing Full Day Event does not work](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/179)
- Fixed
  Issue [#184 - Use available vertical space month view](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/184)
- Fixed
  Issue [#191 - DisplayBorder in WeekDayTile in month_view_components does not work correctly](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/191)
- Fixed
  Issue [#197 - Some DateTimeExtensions methods are not working properly for Daylight Saving Time](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/197)
- Fixed
  Issue [#199 - HeaderStyle decoration no have effect on MonthView](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/199)

# [1.0.2 - 10 Jan 2023](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.0.2)

- Added
  Feature [#144 - WeekView not support show current week number](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/144)
- Added
  Feature [#149 - Full day events support](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/149)
- Fixed
  Issue [#142 - week day not align center](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/142)
- Fixed
  Issue [#146 - WeekView wrapped by SafeArea](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/146)

# [1.0.1 - 25 Nov 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.0.1)

- Added
  Feature [#26 - Support for locale](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/26)
- Added removeWhere method in `EventController` to conditionally remove multiple
  events. (Fixes
  Issue [#31](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/31))
- Added customization in calendar views and
  closes [#34](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/34).
    - Added Customizations in `DayView`.
      Adds `dateStringBuilder`, `timeStringBuilder`, `headerStyle`
      parameters in `Dayview`,
    - Added Customizations in `MonthView`.
      Adds `headerStringBuilder`, `dateStringBuilder`
      , `weekDayStringBuilder`, `headerStyle` parameters in `WeekView`.
    - Added Customizations in `WeekView`.
      Adds `headerStyle`,  `headerStringBuilder`
      , `timeLineStringBuilder`, `weekDayStringBuilder`, `weekDayDateStringBuilder`
      parameters
      in `WeekView`,
- Added onTap lister in day and week views. issue #50.
- Updated calculation of day difference. issue #80, #97.
- Fixed
  Issue [#93 - Showing only 1 day in DayView](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/93)
- Fixed
  Issue [#130 - Week view incorrectly displays events when a day contains overlapping events](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/130)

# [1.0.0 - 12 Aug 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/1.0.0)

- **Breaking Changes**
    - Improved logic to compare `CalendarEventData`.

      Note: This changes the behaviour of comparing two events using `==`
      operator. Please test your
      app properly after updating to this version.

- Added 15,30 and 60 minutes slots for `onDateLongPress` callback in Week and
  Day view.
- Added method to update filter in `EventController`.
- Restructured the logic to store single time events.
- Added method to scroll to an event.
  Issue [#30 - Scroll to an event in day view](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/30)
- Added
  Feature [#36 - Feature/custom strings](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/36)
- Use normalized dates in difference calculations.

# [0.0.5 - 2 Jun 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.5)

- Fixed
  Issue [#48 - WeekView header date is different from the calendar view](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/48)
- Added
  Feature [#46 - Change beginning of week in MonthView](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/46)
- Fixed
  Issue [#42 - WeekDayTile causes RenderFlex-Overflow](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/42)
- Fixed
  Issue [#65 - Adding onCellTap callback breaks whole calendar](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/65)
- Fixed
  Issue [#62 - Missing redraw events](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/62)
- Fixed
  Issue [#16 - Scroll to index/liveTime](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/16)
- Show live time indicator line above event tiles.
  PR [#67](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/pull/67)

# [0.0.4 - 2 Mar 2022](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.4)

- Fixed
  Issue [#39 - Detect a long press on the calendar](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/39)
- Fixed
  Issue [#38 - Modifying CalendarEventData](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/38)
- Fixed
  Issue [#27 - EventController remove event don't work](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/27)
- Fixed
  Issue [#13 - Give the option to show weekdays in a WeekView.](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/issues/13)

# [0.0.3 - 12 Oct 2021](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.3)

- Added support for multiple day events

# [0.0.2 - 3 Sep 2021](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.2)

- Updated `README.md` file.
- Added license information in package files.
- Updated project description in `pubspec.yaml`
- Updated documentation.
- Added `CalendarControllerProvider`.
- Added `onEventTap` callback in `WeekView` and `DayView`.
- Added `onCellTap` callback in `MonthView`.
- Make `controller` optional parameter in all views
  where `CalendarControllerProvider` is provided.

# [0.0.1 - 26 Aug 2021](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/tree/0.0.1)

- Initial release