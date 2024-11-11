# Migration Guide

## Migrate from `1.x.x` to latest

1. Migrate `HeaderStyle`.
   ```dart
    // Old
    final style = HeaderStyle(
      headerTextStyle : TextStyle(),
      headerMargin : EdgeInsets.zero,
      headerPadding : EdgeInsets.zero,
      titleAlign : TextAlign.center,
      decoration : BoxDecoration(),
      mainAxisAlignment : MainAxisAlignment.spaceBetween,
      leftIcon : Icon(Icons.left),
      rightIcon : Icon(Icons.right),
      leftIconVisible : true,
      rightIconVisible : true,
      leftIconPadding : EdgeInsets.zero,
      rightIconPadding : EdgeInsets.zero,
    );
   ```
   ```dart 
   // After Migration
   
   // NOTE: leftIconVisible and rightIconVisible is removed in
   // latest version. set leftIconConfig and rightIconConfig null to
   // hide the respective icon.
   final style = HeaderStyle(
      headerTextStyle : TextStyle(),
      headerMargin : EdgeInsets.zero,
      headerPadding : EdgeInsets.zero,
      titleAlign : TextAlign.center,
      decoration : BoxDecoration(),
      mainAxisAlignment : MainAxisAlignment.spaceBetween,
      
      // Set this null to hide the left icon.
      leftIconConfig : IconDataConfig(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.left),
      ),
   
      // Set this null to hide the right icon.
      rightIconConfig :  IconDataConfig(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.right),
      ),
    );
   ```
2. Migrate `CalendarPageHeader` | `DayPageHeader` | `MonthPageHeader` | `WeekPageHeader`:
   ```dart
      // Old
      final header = MonthPageBuilder({
        date = DateTime.now(),
        dateStringBuilder = (date, {secondaryDate}) => '$date',
        backgroundColor = Constants.headerBackground,
        iconColor = Constants.black,
      });
   ```
   ```dart
      // After Migration
      final header = MonthPageBuilder({
        date = DateTime.now(),
        dateStringBuilder = (date, {secondaryDate}) => '$date',
        headerStyle = HeaderStyle.withSameIcons(
          decoration: BoxDecoration(
            color: Constants.headerBackground,
          ),       
          iconConfig: IconDataConfig(
            color: Constants.black,
          ),
        ),
      });
   ```