import 'package:flutter/material.dart';

import '../widgets/responsive_widget.dart';
import 'mobile/mobile_home_page.dart';
import 'web/web_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    this.onChangeTheme,
    super.key,
  });

  /// Return true for dark mode
  /// false for light mode
  final void Function(bool)? onChangeTheme;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileWidget: MobileHomePage(onChangeTheme: onChangeTheme),
      webWidget: WebHomePage(onThemeChange: onChangeTheme),
    );
  }
}
