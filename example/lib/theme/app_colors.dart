import 'dart:ui';

/// App-chrome color palette for the example app.
///
/// Mode-dependent colors live on the [light] and [dark] sub-palettes; colors
/// that are the same in both modes (the demo accent literals) are exposed once
/// as `static const` fields.
///
/// This is the example's single source of truth for brand colors — the
/// package's calendar view themes are wired from it in `theme/app_theme.dart`,
/// so changing [AppColors.light]/`dark` `primary` updates both the app chrome
/// and the calendars together.
class AppColors {
  const AppColors._({
    required this.primary,
    required this.onPrimary,
    required this.outline,
    required this.outlineVariant,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
  });

  final Color primary;
  final Color onPrimary;
  final Color outline;
  final Color outlineVariant;
  final Color background;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;

  /// Mode-dependent colors for a light theme.
  static const AppColors light = AppColors._(
    primary: Color(0xffEF5366),
    onPrimary: Color(0xfff0f0f0),
    outline: Color(0xff857373),
    outlineVariant: Color(0xffd7c1c2),
    background: Color(0xffffffff),
    surface: Color(0xffffffff),
    onSurface: Color(0xff22191a),
    onSurfaceVariant: Color(0xff857373),
  );

  /// Mode-dependent colors for a dark theme.
  static const AppColors dark = AppColors._(
    primary: Color(0xffffb3b6),
    onPrimary: Color(0xff561d23),
    outline: Color(0xff9f8c8c),
    outlineVariant: Color(0xff524343),
    background: Color(0xff140c0c),
    surface: Color(0xff140c0c),
    onSurface: Color(0xfff0dede),
    onSurfaceVariant: Color(0xff9f8c8c),
  );

  // Mode-independent demo accent colors — same in both themes.
  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xff626262);
  static const Color white = Color(0xfff0f0f0);
  static const Color red = Color(0xfff96c6c);
  static const Color grey = Color(0xffe0e0e0);
  static const Color bluishGrey = Color(0xffdddee9);
}
