// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'dart:math';

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

  /// First hour displayed in the layout
  final int startHour;

  /// Emulates offset of vertical line from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for day and week view
  final int endHour;

  /// Paints 24 hour lines.
  HourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.minuteHeight,
    required this.offset,
    required this.showVerticalLine,
    required this.startHour,
    required this.emulateVerticalOffsetBy,
    this.endHour = Constants.hoursADay,
    this.verticalLineOffset = 10,
    this.lineStyle = LineStyle.solid,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dx = offset + emulateVerticalOffsetBy;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = startHour + 1; i < endHour; i++) {
      final dy = (i - startHour) * minuteHeight * 60;
      if (lineStyle == LineStyle.dashed) {
        var startX = dx;
        while (startX < size.width) {
          canvas.drawLine(
              Offset(startX, dy), Offset(startX + dashWidth, dy), paint);
          startX += dashWidth + dashSpaceWidth;
        }
      } else {
        canvas.drawLine(Offset(dx, dy), Offset(size.width, dy), paint);
      }
    }

    if (showVerticalLine) {
      if (lineStyle == LineStyle.dashed) {
        var startY = 0.0;
        while (startY < size.height) {
          canvas.drawLine(Offset(offset + verticalLineOffset, startY),
              Offset(offset + verticalLineOffset, startY + dashWidth), paint);
          startY += dashWidth + dashSpaceWidth;
        }
      } else {
        canvas.drawLine(Offset(offset + verticalLineOffset, 0),
            Offset(offset + verticalLineOffset, size.height), paint);
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

  /// First hour displayed in the layout
  final int startHour;

  /// This field will be used to set end hour for day and week view
  final int endHour;

  /// Paint half hour lines
  HalfHourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.offset,
    required this.minuteHeight,
    required this.lineStyle,
    required this.startHour,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
    this.endHour = Constants.hoursADay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = startHour; i < endHour; i++) {
      final dy = (i - startHour) * minuteHeight * 60 + (minuteHeight * 30);
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

  /// Time string
  final String timeString;

  /// Flag to show time at left side or not.
  final bool showTime;

  /// Flag to show time backgroud view.
  final bool showTimeBackgroundView;

  /// Width of time backgroud view.
  final double timeBackgroundViewWidth;

  /// Paints a single horizontal line at [offset].
  CurrentTimeLinePainter({
    required this.showBullet,
    required this.color,
    required this.height,
    required this.offset,
    required this.bulletRadius,
    required this.timeString,
    required this.showTime,
    required this.showTimeBackgroundView,
    required this.timeBackgroundViewWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(offset.dx - (showBullet ? 0 : 8), offset.dy),
      Offset(size.width, offset.dy),
      Paint()
        ..color = color
        ..strokeWidth = height,
    );

    if (showBullet) {
      canvas.drawCircle(
          Offset(offset.dx, offset.dy), bulletRadius, Paint()..color = color);
    }

    if (showTimeBackgroundView) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            max(3, offset.dx - 68),
            offset.dy - 11,
            timeBackgroundViewWidth,
            24,
          ),
          Radius.circular(12),
        ),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..strokeWidth = bulletRadius,
      );
    }

    if (showTime) {
      TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: timeString,
          style: TextStyle(
            fontSize: 12.0,
            color: showTimeBackgroundView ? Colors.white : color,
          ),
        ),
      )
        ..layout()
        ..paint(canvas, Offset(offset.dx - 62, offset.dy - 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is CurrentTimeLinePainter &&
      (color != oldDelegate.color ||
          height != oldDelegate.height ||
          offset != oldDelegate.offset ||
          bulletRadius != oldDelegate.bulletRadius ||
          timeString != oldDelegate.timeString ||
          timeBackgroundViewWidth != oldDelegate.timeBackgroundViewWidth ||
          showBullet != oldDelegate.showBullet ||
          showTime != oldDelegate.showTime ||
          showTimeBackgroundView != oldDelegate.showTimeBackgroundView);
}
