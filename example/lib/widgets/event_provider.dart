import 'package:example/model/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

import '../app_colors.dart';

class DataProvider extends InheritedWidget {
  final CalendarController<Event> controller;

  late final InputDecoration inputDecoration;

  DataProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child) {
    var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(
        width: 2,
        color: AppColors.lightNavyBlue,
      ),
    );

    inputDecoration = InputDecoration(
      border: inputBorder,
      disabledBorder: inputBorder,
      errorBorder: inputBorder.copyWith(
        borderSide: BorderSide(
          width: 2,
          color: AppColors.red,
        ),
      ),
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
      focusedErrorBorder: inputBorder,
      hintText: "Event Title",
      hintStyle: TextStyle(
        color: AppColors.black,
        fontSize: 17,
      ),
      labelStyle: TextStyle(
        color: AppColors.black,
        fontSize: 17,
      ),
      helperStyle: TextStyle(
        color: AppColors.black,
        fontSize: 17,
      ),
      errorStyle: TextStyle(
        color: AppColors.red,
        fontSize: 12,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
    );
  }

  static DataProvider of(BuildContext context) {
    final DataProvider? result =
        context.dependOnInheritedWidgetOfExactType<DataProvider>();
    assert(result != null, 'No DataProvider<T> found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DataProvider old) => false;
}
