import 'package:flutter/material.dart';
import 'package:flutter_calendar_page/flutter_calendar_page.dart';

/// Paints 24 hour lines.
class HourLinePainter extends CustomPainter {
  final Color lineColor;
  final double lineHeight;
  final double offset;
  final double minuteHeight;
  final bool showVerticalLine;
  final double verticalLineOffset;

  /// Paints 24 hour lines.
  HourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.minuteHeight,
    required this.offset,
    required this.showVerticalLine,
    this.verticalLineOffset = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    for (int i = 1; i < Constants.hoursADay; i++) {
      double dy = i * minuteHeight * 60;
      canvas.drawLine(Offset(offset, dy), Offset(size.width, dy), paint);
    }

    if (showVerticalLine)
      canvas.drawLine(Offset(offset + verticalLineOffset, 0),
          Offset(offset + verticalLineOffset, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is HourLinePainter &&
        (oldDelegate.lineColor != this.lineColor ||
            oldDelegate.offset != this.offset ||
            this.lineHeight != oldDelegate.lineHeight ||
            this.minuteHeight != oldDelegate.minuteHeight ||
            this.showVerticalLine != oldDelegate.showVerticalLine);
  }
}

/// Paints a single horizontal line at [offset].
class CurrentTimeLinePainter extends CustomPainter {
  final Color color;
  final double height;
  final Offset offset;
  final bool showBullet;
  final double bulletRadius;

  /// Paints a single horizontal line at [offset].
  CurrentTimeLinePainter({
    this.showBullet = true,
    required this.color,
    required this.height,
    required this.offset,
    this.bulletRadius = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(offset.dx, offset.dy),
      Offset(size.width, offset.dy),
      Paint()
        ..color = color
        ..strokeWidth = height,
    );

    if (showBullet)
      canvas.drawCircle(
          Offset(offset.dx, offset.dy), bulletRadius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is CurrentTimeLinePainter &&
      (this.color != oldDelegate.color ||
          this.height != oldDelegate.height ||
          this.offset != oldDelegate.offset);
}
