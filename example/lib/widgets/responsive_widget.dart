import 'package:flutter/material.dart';

import '../constants.dart';

class ResponsiveWidget extends StatelessWidget {
  final double? width;
  final double breakPoint;
  final Widget webWidget;
  final Widget mobileWidget;

  const ResponsiveWidget({
    Key? key,
    this.width,
    this.breakPoint = BreakPoints.web,
    required this.webWidget,
    required this.mobileWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = this.width ?? MediaQuery.of(context).size.width;

    if (width < breakPoint) {
      return mobileWidget;
    } else {
      return webWidget;
    }
  }
}
