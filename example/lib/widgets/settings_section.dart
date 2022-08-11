import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'custom_divider.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingTitle(title: title),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          ...children,
        ],
      ),
    );
  }
}

class SettingTitle extends StatelessWidget {
  const SettingTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 22,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
        ),
        Expanded(child: const CustomDivider()),
      ],
    );
  }
}
