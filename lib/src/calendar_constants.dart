// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

class CalendarConstants {
  CalendarConstants._();

  /// minimum and maximum dates are approx. 100,000,000 days
  /// before and after epochDate
  static final DateTime epochDate = DateTime(1970);
  static final DateTime maxDate = DateTime(275759);
  static final DateTime minDate = DateTime(-271819);
}
