import 'dart:ui';

/// Raw color tokens used to seed the default `…ViewThemeData.light()` /
/// `.dark()` constructors.
///
/// This is the package's single design-token palette. Mode-dependent tokens
/// live on the [light] and [dark] sub-palettes; tokens that are identical in
/// both modes are exposed once as `static const` fields on the class itself.
///
/// Internal to the package — consumers theme the views through the exported
/// `…ViewThemeData` extensions, not these raw values.
class CalendarViewColors {
  const CalendarViewColors._({
    required this.primary,
    required this.onPrimary,
    required this.outline,
    required this.outlineVariant,
    required this.onSurface,
    required this.surfaceContainerHigh,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainerHighest,
    required this.emptyContent,
  });

  final Color primary;
  final Color onPrimary;
  final Color outline;
  final Color outlineVariant;
  final Color onSurface;
  final Color surfaceContainerHigh;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainerHighest;
  final Color emptyContent;

  /// Mode-dependent tokens for a light theme.
  static const CalendarViewColors light = CalendarViewColors._(
    primary: Color(0xffEF5366),
    onPrimary: Color(0xffffffff),
    outline: Color(0xff857373),
    outlineVariant: Color(0xffd7c1c2),
    onSurface: Color(0xff22191a),
    surfaceContainerHigh: Color(0xfff6e4e4),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfffff0f0),
    surfaceContainerHighest: Color(0xfff0dede),
    emptyContent: Color(0xFFAFAFAF),
  );

  /// Mode-dependent tokens for a dark theme.
  static const CalendarViewColors dark = CalendarViewColors._(
    primary: Color(0xffffb3b6),
    onPrimary: Color(0xff561d23),
    outline: Color(0xff9f8c8c),
    outlineVariant: Color(0xff524343),
    onSurface: Color(0xfff0dede),
    surfaceContainerHigh: Color(0xff322828),
    surfaceContainerLowest: Color(0xff140c0c),
    surfaceContainerLow: Color(0xff22191a),
    surfaceContainerHighest: Color(0xff3d3232),
    emptyContent: Color(0xFF8C8C8C),
  );

  // Mode-independent tokens — identical in light and dark, so defined once.

  /// Fully transparent color.
  static const Color transparent = Color(0x00000000);

  /// Text/icon color for the month-header image overlay (always over a dark
  /// gradient, so white in both modes).
  static const Color monthHeaderText = Color(0xFFFFFFFF);

  /// Semi-opaque dark end color of the month-header gradient overlay.
  static const Color monthHeaderGradientEnd = Color(0x8A000000);

  /// Text-shadow color for the month-header title.
  static const Color monthHeaderTextShadow = Color(0x73000000);
}
