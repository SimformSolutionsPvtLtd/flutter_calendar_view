import 'package:flutter/material.dart';

import '../../extension.dart';
import '../../localization/locale_controller.dart';
import '../../theme/theme_controller.dart';
import '../day_view_page.dart';
import '../month_view_page.dart';
import '../multi_day_view_page.dart';
import '../schedule_view_page.dart';
import '../week_view_page.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  /// Shows a dialog to select the current locale.
  void _showLocaleDialog(BuildContext context) {
    final localeController = LocaleController.of(context);
    _showSelectionDialog<String>(
      context: context,
      title: context.translate.selectLanguage,
      currentValue: localeController.currentLocale,
      options: const [
        (value: 'en', label: 'English'),
        (value: 'es', label: 'Spanish'),
        (value: 'ar', label: 'Arabic'),
      ],
      onSelected: localeController.setLocale,
    );
  }

  /// Shows a dialog to select the current theme.
  void _showThemeDialog(BuildContext context) {
    final themeController = ThemeController.of(context);
    final translate = context.translate;
    _showSelectionDialog<ThemeMode>(
      context: context,
      title: translate.theme,
      currentValue: themeController.themeMode,
      options: [
        (value: ThemeMode.system, label: translate.themeSystem),
        (value: ThemeMode.light, label: translate.themeLight),
        (value: ThemeMode.dark, label: translate.themeDark),
      ],
      onSelected: themeController.setThemeMode,
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pushRoute(ScheduleViewPageDemo()),
              child: Text(translate.scheduleView),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.brightness_6, color: context.appColors.onPrimary),
            onPressed: () => _showThemeDialog(context),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.language, color: context.appColors.onPrimary),
            onPressed: () => _showLocaleDialog(context),
          ),
        ],
      ),
    );
  }

  /// Shows a themed single-choice selection dialog. The active option is
  /// highlighted with a tinted background and a primary-coloured check icon,
  /// and every colour flows through `context.appColors` so the selection stays
  /// legible in both light and dark themes.
  Future<void> _showSelectionDialog<T>({
    required BuildContext context,
    required String title,
    required T currentValue,
    required List<({T value, String label})> options,
    required ValueChanged<T> onSelected,
  }) {
    final colors = context.appColors;
    final translate = context.translate;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: TextStyle(color: colors.onSurface)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = option.value == currentValue;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Material(
                  color: isSelected
                      ? colors.primary.withValues(alpha: 0.12)
                      : colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      onSelected(option.value);
                      Navigator.of(dialogContext).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? colors.primary
                                    : colors.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check, color: colors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              translate.cancel,
              style: TextStyle(color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
