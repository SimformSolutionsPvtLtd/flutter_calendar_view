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

  /// Defines the width of timeline
  final double? timelineWidth;

  /// Defines directionality
  final TextDirection textDirection;

  /// Paints 24 hour lines.
  HourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.minuteHeight,
    required this.offset,
    required this.showVerticalLine,
    required this.startHour,
    required this.emulateVerticalOffsetBy,
    this.timelineWidth,
    this.endHour = Constants.hoursADay,
    this.verticalLineOffset = 10,
    this.lineStyle = LineStyle.solid,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
    this.textDirection = TextDirection.ltr,
  });

  bool get isLtr => textDirection == TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
    final dx = offset + emulateVerticalOffsetBy;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    // X point of Point P2
    final endXPoint = size.width - (isLtr ? 0 : timelineWidth ?? 0);

    for (var i = startHour + 1; i < endHour; i++) {
      final dy = (i - startHour) * minuteHeight * 60;
      if (lineStyle == LineStyle.dashed) {
        var startX = dx;
        final width = isLtr ? size.width : size.width - (timelineWidth ?? 0);

        while (startX < width) {
          canvas.drawLine(
            Offset(startX, dy),
            Offset(startX + dashWidth, dy),
            paint,
          );
          startX += dashWidth + dashSpaceWidth;
        }
      } else {
        final startX = isLtr ? dx : dx - (timelineWidth ?? 0);
        canvas.drawLine(Offset(startX, dy), Offset(endXPoint, dy), paint);
      }
    }

    if (showVerticalLine) {
      final ltrOffset = offset + verticalLineOffset;
      final rtlOffset = size.width - verticalLineOffset - (timelineWidth ?? 0);
      if (lineStyle == LineStyle.dashed) {
        final xPoint = isLtr ? ltrOffset : rtlOffset;
        var startY = 0.0;
        while (startY < size.height) {
          canvas.drawLine(
            Offset(xPoint, startY),
            Offset(xPoint, startY + dashWidth),
            paint,
          );
          startY += dashWidth + dashSpaceWidth;
        }
      } else {
        canvas.drawLine(
          Offset(isLtr ? ltrOffset : rtlOffset, 0),
          Offset(isLtr ? ltrOffset : rtlOffset, size.height),
          paint,
        );
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

  /// Defines directionality
  final TextDirection textDirection;

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
    this.textDirection = TextDirection.ltr,
  });

  bool get isLtr => textDirection == TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = startHour; i < endHour; i++) {
      final dy = (i - startHour) * minuteHeight * 60 + (minuteHeight * 30);
      final width = isLtr ? size.width : size.width - offset;
      if (lineStyle == LineStyle.dashed) {
        var startX = isLtr ? offset : 5.0;
        while (startX < width) {
          canvas.drawLine(
            Offset(startX, dy),
            Offset(startX + dashWidth, dy),
            paint,
          );
          startX += dashWidth + dashSpaceWidth;
        }
      } else {
        final startX = isLtr ? offset : 0.0;
        final endX = isLtr ? width : size.width - offset;
        canvas.drawLine(Offset(startX, dy), Offset(endX, dy), paint);
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

  /// Defines the width of timeline
  final double? timelineWidth;

  /// Defines directionality
  final TextDirection textDirection;

  /// Paint quarter hour lines
  QuarterHourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.offset,
    required this.minuteHeight,
    required this.lineStyle,
    this.timelineWidth,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
    this.textDirection = TextDirection.ltr,
  });

  bool get isLtr => textDirection == TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (var i = 0; i < Constants.hoursADay; i++) {
      final dy1 = i * minuteHeight * 60 + (minuteHeight * 15);
      final dy2 = i * minuteHeight * 60 + (minuteHeight * 45);
      final endX = isLtr ? size.width : size.width - offset;

      if (lineStyle == LineStyle.dashed) {
        var startX = offset;
        while (startX < endX) {
          canvas.drawLine(
            Offset(startX, dy1),
            Offset(startX + dashWidth, dy1),
            paint,
          );
          startX += dashWidth + dashSpaceWidth;

          canvas.drawLine(
            Offset(startX, dy2),
            Offset(startX + dashWidth, dy2),
            paint,
          );
          startX += dashWidth + dashSpaceWidth;
        }
      } else {
        final startXPoint = isLtr ? offset : 0.0;
        canvas
          ..drawLine(
            Offset(startXPoint, dy1),
            Offset(endX, dy1),
            paint,
          )
          ..drawLine(
            Offset(startXPoint, dy2),
            Offset(endX, dy2),
            paint,
          );
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

  /// Defines directionality
  final TextDirection textDirection;

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
    this.textDirection = TextDirection.ltr,
  });
  bool get isLtr => textDirection == TextDirection.ltr;
  @override
  void paint(Canvas canvas, Size size) {
    final startXPoint = isLtr
        ? offset.dx - (showBullet ? 0 : 8)
        : offset.dx - (showBullet ? 8 : 0);
    final endXPoint = size.width - (isLtr ? 0 : timeBackgroundViewWidth);
    canvas.drawLine(
      Offset(startXPoint, offset.dy),
      Offset(endXPoint, offset.dy),
      Paint()
        ..color = color
        ..strokeWidth = height,
    );

    if (showBullet) {
      final xPoint = isLtr ? offset.dx : offset.dx + size.width;
      canvas.drawCircle(
        Offset(xPoint, offset.dy),
        bulletRadius,
        Paint()..color = color,
      );
    }

    if (showTimeBackgroundView) {
      final dx = isLtr
          ? offset.dx - timeBackgroundViewWidth - 4
          : offset.dx + size.width;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            max(3, dx),
            offset.dy - 11,
            timeBackgroundViewWidth,
            24,
          ),
          const Radius.circular(12),
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
            fontSize: 12,
            color: showTimeBackgroundView ? Colors.white : color,
          ),
        ),
      )
        ..layout()
        ..paint(
          canvas,
          Offset(
            isLtr ? 15 : offset.dx + size.width + 15,
            isLtr ? offset.dy - 6.0 : offset.dy - 12.0,
          ),
        );
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
