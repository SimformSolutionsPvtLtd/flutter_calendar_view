import 'package:flutter/material.dart';

import '../../extension.dart';
import '../../localization/locale_controller.dart';
import '../day_view_page.dart';
import '../month_view_page.dart';
import '../multi_day_view_page.dart';
import '../week_view_page.dart';

class MobileHomePage extends StatefulWidget {
  MobileHomePage({this.onChangeTheme, super.key});

  final void Function(bool)? onChangeTheme;

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  bool isDarkMode = false;

  void _showLocaleDialog(BuildContext context) {
    final localeController = LocaleController.of(context);
    final currentLocale = localeController.currentLocale;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, 'en', 'English', currentLocale),
              Divider(),
              _buildLanguageOption(context, 'es', 'Spanish', currentLocale),
              Divider(),
              _buildLanguageOption(context, 'ar', 'Arabic', currentLocale),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String locale, String name, String currentLocale) {
    final isSelected = locale == currentLocale;

    return InkWell(
      onTap: () {
        LocaleController.of(context).setLocale(locale);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate.flutterCalendarPage),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => context.pushRoute(MonthViewPageDemo()),
              child: Text(translate.monthView),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pushRoute(DayViewPageDemo()),
              child: Text(translate.dayView),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pushRoute(WeekViewDemo()),
              child: Text(translate.weekView),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pushRoute(MultiDayViewDemo()),
              child: Text(translate.multidayView),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: Icon(
              Icons.dark_mode,
              color: context.appColors.onPrimary,
            ),
            onPressed: () {
              isDarkMode = !isDarkMode;
              if (widget.onChangeTheme != null) {
                widget.onChangeTheme!(isDarkMode);
              }
              setState(() {});
            },
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            heroTag: null,
            child: Icon(
              Icons.language,
              color: context.appColors.onPrimary,
            ),
            onPressed: () => _showLocaleDialog(context),
          ),
        ],
      ),
    );
  }
}
