import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';
import 'package:flutter_calendar_page/src/extensions.dart';

class MonthView<T> extends StatefulWidget {
  /// A function that returns a [Widget] that determines appearance of each cell in month calendar.
  final CellBuilder<T>? cellBuilder;

  /// Builds month page title.
  ///
  /// Used default title builder if null.
  final DateWidgetBuilder? headerBuilder;

  final CalendarPageChangeCallBack? onPageChange;

  /// Builds the name of the weeks.
  ///
  /// Used default week builder if null.
  ///
  /// Here day will range from 0 to 6 starting from Monday to Sunday.
  final WeekDayBuilder? weekDayBuilder;

  /// Determines the lower boundary user can scroll.
  ///
  /// If not provided [Constants.epochDate] is default.
  final DateTime? minMonth;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided [Constants.maxDate] is default.
  final DateTime? maxMonth;

  /// Defines initial display month.
  ///
  /// If not provided current date is default date.
  final DateTime? initialMonth;

  /// Defines whether to show default borders or not.
  ///
  /// Default value is true
  ///
  /// Use [borderSize] to define width of the border and
  /// [borderColor] to define color of the border.
  final bool showBorder;

  /// Defines width of default border
  ///
  /// Default value is [Colors.blue]
  ///
  /// It will take affect only if [showBorder] is set.
  final Color borderColor;

  /// Page transition duration used when user try to change page using [MonthView.nextPage] or [MonthView.previousPage]
  ///
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using [MonthView.nextPage] or [MonthView.previousPage]
  ///
  final Curve pageTransitionCurve;

  /// A required parameters that controls events for month view.
  ///
  /// This will auto update month view when user adds events in controller.
  /// This controller will store all the events. And returns events for particular day.
  ///
  final CalendarController<T> controller;

  /// Defines width of default border
  ///
  /// Default value is 1
  ///
  /// It will take affect only if [showBorder] is set.
  final double borderSize;

  /// Defines aspect ratio of day cells in month calendar page.
  final double cellAspectRatio;

  /// Defines aspect ratio of week cells in month calendar page.
  /// This ratio is for week titles.
  final double weekCellAspectRatio;

  final double? width;

  /// Here T determines Type of your event class. You can specify Type of class in which you are storing your event data.
  const MonthView({
    Key? key,
    this.weekCellAspectRatio = 1.5,
    this.showBorder = true,
    this.borderColor = Colors.blue,
    this.cellBuilder,
    this.minMonth,
    this.maxMonth,
    required this.controller,
    this.initialMonth,
    this.borderSize = 1,
    this.cellAspectRatio = 0.55,
    this.headerBuilder,
    this.weekDayBuilder,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.width,
    this.onPageChange,
  }) : super(key: key);

  @override
  MonthViewState<T> createState() => MonthViewState<T>();
}

class MonthViewState<T> extends State<MonthView<T>> {
  late DateTime _minDate;
  late DateTime _maxDate;
  late DateTime _currentDate;
  late int _currentIndex;

  int _totalMonths = 0;

  late PageController _pageController;

  late double _width;
  late double _cellWidth;
  late double _cellHeight;
  late double _height;

  late CellBuilder<T> _cellBuilder;
  late WeekDayBuilder _weekBuilder;

  late DateWidgetBuilder _headerBuilder;

  @override
  void initState() {
    super.initState();

    _minDate = widget.minMonth ?? Constants.epochDate;
    _maxDate = widget.maxMonth ?? Constants.maxDate;

    _currentDate = widget.initialMonth ?? DateTime.now();

    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    _totalMonths = _maxDate.getMonthDifference(_minDate);

    widget.controller.addListener(_reload);

    _currentIndex = _minDate.getMonthDifference(_currentDate) - 1;

    _pageController = PageController(initialPage: _currentIndex);

    _cellBuilder = widget.cellBuilder ?? _defaultCellBuilder;
    _weekBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;
    _headerBuilder = widget.headerBuilder ?? _defaultHeaderBuilder;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _width = widget.width ?? MediaQuery.of(context).size.width;
    _cellWidth = _width / 7;
    _cellHeight = _cellWidth / widget.cellAspectRatio;
    _height = _cellHeight * 6 + (_cellWidth / widget.weekCellAspectRatio);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _width,
            child: _headerBuilder(_currentDate),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: _width,
                height: _height,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChange,
                  itemBuilder: (_, index) {
                    DateTime date =
                        DateTime(_minDate.year, _minDate.month + index, 1);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: _width,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: widget.weekCellAspectRatio,
                            ),
                            shrinkWrap: true,
                            itemCount: 7,
                            itemBuilder: (_, index) {
                              return _weekBuilder(index);
                            },
                          ),
                        ),
                        Expanded(
                          child: _MonthPageBuilder<T>(
                            key: ValueKey(date.toIso8601String()),
                            width: _width,
                            height: _height,
                            controller: widget.controller,
                            borderColor: widget.borderColor,
                            borderSize: widget.borderSize,
                            cellBuilder: _cellBuilder,
                            cellRatio: widget.cellAspectRatio,
                            date: date,
                            showBorder: widget.showBorder,
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: _totalMonths,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Calls when user changes page using gesture or inbuilt methods.
  void _onPageChange(int value) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + (value - _currentIndex),
          _currentDate.day,
        );
        _currentIndex = value;
      });
    }
    widget.onPageChange?.call(_currentDate, _currentIndex);
  }

  /// Default month view header builder
  Widget _defaultHeaderBuilder(DateTime date) {
    return MonthPageHeader(
      onTitleTapped: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: Constants.minDate,
          lastDate: Constants.maxDate,
        );

        if (selectedDate == null) return;
        this.jumpToDate(selectedDate);
      },
      onPreviousMonth: previousPage,
      date: date,
      onNextMonth: nextPage,
    );
  }

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(int index) {
    return Container(
      alignment: Alignment.center,
      child: Text(Constants.weekTitles[index]),
    );
  }

  /// Default cell builder. Used when [widget.cellBuilder] is null
  ///
  Widget _defaultCellBuilder<T>(
      date, List<CalendarEventData<T>> events, isToday, isInMonth) {
    return FilledCell(
      date: date,
      shouldHighlight: isToday,
      backgroundColor: isInMonth ? Color(0xffffffff) : Color(0xffdedede),
      events: events,
    );
  }

  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve] respectively.
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve] respectively.
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Jumps to page number [page]
  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve] respectively.
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve);
  }

  /// Returns current page number.
  int get currentPage => _currentIndex;

  /// Jumps to page which gives month calendar for [date]
  void jumpToDate(DateTime date) {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getMonthDifference(date) - 1);
  }

  /// Animate to page which gives month calendar for [date].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MonthView.pageTransitionDuration] and [MonthView.pageTransitionCurve] respectively.
  Future<void> animateToDate(DateTime date,
      {Duration? duration, Curve? curve}) async {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getMonthDifference(date) - 1,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible date in month view.
  DateTime get currentDate =>
      DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
}

/// A single month page.
class _MonthPageBuilder<T> extends StatelessWidget {
  final double cellRatio;
  final bool showBorder;
  final double borderSize;
  final Color borderColor;
  final CellBuilder<T> cellBuilder;
  final DateTime date;
  final CalendarController<T> controller;
  final double width;
  final double height;

  const _MonthPageBuilder({
    Key? key,
    required this.cellRatio,
    required this.showBorder,
    required this.borderSize,
    required this.borderColor,
    required this.cellBuilder,
    required this.date,
    required this.controller,
    this.width = 0,
    this.height = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DateTime> monthDays = date.datesOfMonths;
    return Container(
      width: width,
      height: height,
      child: GridView.builder(
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: cellRatio,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: 42,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: showBorder
                  ? Border.all(
                      color: borderColor,
                      width: borderSize,
                    )
                  : null,
            ),
            child: cellBuilder(
              monthDays[index],
              controller.getEventsOnDay(monthDays[index]),
              monthDays[index].compareWithoutTime(DateTime.now()),
              monthDays[index].month == date.month,
            ),
          );
        },
      ),
    );
  }
}
