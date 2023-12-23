// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'constants.dart';
import 'enumerations.dart';

/// Paints 24 hour lines.
class HourLinePainter extends CustomPainter {
  /// Color of hour line
  final Color lineColor;

  /// Height of hour line
  final double lineHeight;

  /// Offset of hour line from left.
  final double offset;

  /// Height occupied by one minute of time stamp.
  final double minuteHeight;

  /// Flag to display vertical line at left or not.
  final bool showVerticalLine;

  /// left offset of vertical line.
  final double verticalLineOffset;

  /// Style of the hour and vertical line
  final LineStyle lineStyle;

  /// Line dash width when using the [LineStyle.dashed] style
  final double dashWidth;

  /// Line dash space width when using the [LineStyle.dashed] style
  final double dashSpaceWidth;

  /// Emulates offset of vertical line from hour line starts.
  final double emulateVerticalOffsetBy;

  /// Indicates if the layout direction is right-to-left (RTL).
  ///
  /// This value is crucial for correctly drawing the table, especially
  /// elements like the vertical line which change position based on
  /// the layout direction. Pass this from parent contexts to ensure
  /// accurate representation in RTL layouts.
  final bool isRtl;

  /// Paints 24 hour lines.
  HourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.minuteHeight,
    required this.offset,
    required this.showVerticalLine,
    required this.emulateVerticalOffsetBy,
    this.verticalLineOffset = 10,
    this.lineStyle = LineStyle.solid,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dx = offset + emulateVerticalOffsetBy;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = 1; i < Constants.hoursADay; i++) {
      final dy = i * minuteHeight * 60;
      if (lineStyle == LineStyle.dashed) {
        var startX = dx;
        while (startX < size.width) {
          canvas.drawLine(
              Offset(startX, dy), Offset(startX + dashWidth, dy), paint);
          startX += dashWidth + dashSpaceWidth;
          if (isRtl && startX > size.width) break; // Stop drawing extra dashes
        }
      } else {
        canvas.drawLine(Offset(isRtl ? size.width - offset : offset, dy),
            Offset(isRtl ? 0 : size.width, dy), paint);
      }
    }

    if (showVerticalLine) {
      final verticalOffset = isRtl ? size.width - offset : offset;
      if (lineStyle == LineStyle.dashed) {
        var startY = 0.0;
        while (startY < size.height) {
          canvas.drawLine(
              Offset(verticalOffset + verticalLineOffset, startY),
              Offset(verticalOffset + verticalLineOffset, startY + dashWidth),
              paint);
          startY += dashWidth + dashSpaceWidth;
        }
      } else {
        canvas.drawLine(Offset(verticalOffset, 0),
            Offset(verticalOffset, size.height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is HourLinePainter &&
        (oldDelegate.lineColor != lineColor ||
            oldDelegate.offset != offset ||
            lineHeight != oldDelegate.lineHeight ||
            minuteHeight != oldDelegate.minuteHeight ||
            showVerticalLine != oldDelegate.showVerticalLine);
  }
}

class HalfHourLinePainter extends CustomPainter {
  /// Color of half hour line
  final Color lineColor;

  /// Height of half hour line
  final double lineHeight;

  /// Offset of half hour line from left.
  final double offset;

  /// Height occupied by one minute of time stamp.
  final double minuteHeight;

  /// Style of the half hour line
  final LineStyle lineStyle;

  /// Line dash width when using the [LineStyle.dashed] style
  final double dashWidth;

  /// Line dash space width when using the [LineStyle.dashed] style
  final double dashSpaceWidth;

  /// Paint half hour lines
  HalfHourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.offset,
    required this.minuteHeight,
    required this.lineStyle,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = 0; i < Constants.hoursADay; i++) {
      final dy = i * minuteHeight * 60 + (minuteHeight * 30);
      if (lineStyle == LineStyle.dashed) {
        var startX = offset;
        while (startX < size.width) {
          canvas.drawLine(
              Offset(startX, dy), Offset(startX + dashWidth, dy), paint);
          startX += dashWidth + dashSpaceWidth;
        }
      } else {
        canvas.drawLine(Offset(offset, dy), Offset(size.width, dy), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is HourLinePainter &&
        (oldDelegate.lineColor != lineColor ||
            oldDelegate.offset != offset ||
            lineHeight != oldDelegate.lineHeight ||
            minuteHeight != oldDelegate.minuteHeight);
  }
}

//using HalfHourIndicatorSettings for this too
class QuarterHourLinePainter extends CustomPainter {
  /// Color of quarter hour line
  final Color lineColor;

  /// Height of quarter hour line
  final double lineHeight;

  /// Offset of quarter hour line from left.
  final double offset;

  /// Height occupied by one minute of time stamp.
  final double minuteHeight;

  /// Style of the quarter hour line
  final LineStyle lineStyle;

  /// Line dash width when using the [LineStyle.dashed] style
  final double dashWidth;

  /// Line dash space width when using the [LineStyle.dashed] style
  final double dashSpaceWidth;

  /// Paint quarter hour lines
  QuarterHourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.offset,
    required this.minuteHeight,
    required this.lineStyle,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = 0; i < Constants.hoursADay; i++) {
      final dy1 = i * minuteHeight * 60 + (minuteHeight * 15);
      final dy2 = i * minuteHeight * 60 + (minuteHeight * 45);

      if (lineStyle == LineStyle.dashed) {
        var startX = offset;
        while (startX < size.width) {
          canvas.drawLine(
              Offset(startX, dy1), Offset(startX + dashWidth, dy1), paint);
          startX += dashWidth + dashSpaceWidth;

          canvas.drawLine(
              Offset(startX, dy2), Offset(startX + dashWidth, dy2), paint);
          startX += dashWidth + dashSpaceWidth;
        }
      } else {
        canvas.drawLine(Offset(offset, dy1), Offset(size.width, dy1), paint);
        canvas.drawLine(Offset(offset, dy2), Offset(size.width, dy2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is HourLinePainter &&
        (oldDelegate.lineColor != lineColor ||
            oldDelegate.offset != offset ||
            lineHeight != oldDelegate.lineHeight ||
            minuteHeight != oldDelegate.minuteHeight);
  }
}

/// Paints a single horizontal line at [offset].
class CurrentTimeLinePainter extends CustomPainter {
  /// Color of time indicator.
  final Color color;

  /// Height of time indicator.
  final double height;

  /// offset of time indicator.
  final Offset offset;

  /// Flag to show bullet at left side or not.
  final bool showBullet;

  /// Radius of bullet.
  final double bulletRadius;

  final bool isRtl;

  /// Paints a single horizontal line at [offset].
  CurrentTimeLinePainter(
      {this.showBullet = true,
      required this.color,
      required this.height,
      required this.offset,
      this.bulletRadius = 5,
      required this.isRtl});

  @override
  void paint(Canvas canvas, Size size) {
    double startX = isRtl ? 0 : size.width;
    double endX = isRtl ? size.width - offset.dx : offset.dx;
    canvas.drawLine(
      Offset(startX, offset.dy),
      Offset(endX, offset.dy),
      Paint()
        ..color = color
        ..strokeWidth = height,
    );

    if (showBullet) {
      canvas.drawCircle(
          Offset(endX, offset.dy), bulletRadius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is CurrentTimeLinePainter &&
      (color != oldDelegate.color ||
          height != oldDelegate.height ||
          offset != oldDelegate.offset);
}
