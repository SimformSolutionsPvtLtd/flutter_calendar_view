// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class FullDayHeaderTextConfig {
  /// Set full day events header text config
  const FullDayHeaderTextConfig({
    this.textAlign = TextAlign.center,
    this.maxLines = 2,
    this.textOverflow = TextOverflow.ellipsis,
  });

  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow textOverflow;
}
