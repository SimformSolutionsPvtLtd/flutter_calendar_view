import 'package:flutter/cupertino.dart';

import '../components/days_row/measure_size.dart';

/// Controller to notify the height of cell gotten from [MeasureSize]
class CellHeightController extends ChangeNotifier {
  double? cellHeight;
  void onChanged(Size size) {
    if (cellHeight == null) {
      cellHeight = size.height;
      notifyListeners();
    }
  }
}
