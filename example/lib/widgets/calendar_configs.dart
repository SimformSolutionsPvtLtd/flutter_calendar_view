import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../localization/locale_controller.dart';
import '../theme/app_theme_extension.dart';
import '../theme/theme_controller.dart';
import 'add_event_form.dart';

class CalendarConfig extends StatefulWidget {
  final void Function(CalendarView view) onViewChange;
  final CalendarView currentView;

  const CalendarConfig({
    super.key,
    required this.onViewChange,
    this.currentView = CalendarView.month,
  });

  @override
  State<CalendarConfig> createState() => _CalendarConfigState();
}

class _CalendarConfigState extends State<CalendarConfig> {
  // Map of supported locales with their display names
  final Map<String, String> supportedLocales = {
    'en': 'English',
    'es': 'Spanish',
    'ar': 'Arabic',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final translate = context.translate;
    final localeController = LocaleController.of(context);
    final themeController = ThemeController.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            translate.flutterCalendarPage,
            style: TextStyle(color: colors.onSurface, fontSize: 30),
          ),
        ),
        Divider(color: colors.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Language selector dropdown
                    Expanded(
                      child: _buildThemedDropdown<String>(
                        colors: colors,
                        value: localeController.currentLocale,
                        icon: Icons.language,
                        options: supportedLocales.entries
                            .map(
                              (entry) => (value: entry.key, label: entry.value),
                            )
                            .toList(),
                        onChanged: localeController.setLocale,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Theme mode selector dropdown
                    Expanded(
                      child: _buildThemedDropdown<ThemeMode>(
                        colors: colors,
                        value: themeController.themeMode,
                        icon: Icons.brightness_6,
                        options: [
                          (
                            value: ThemeMode.system,
                            label: translate.themeSystem,
                          ),
                          (value: ThemeMode.light, label: translate.themeLight),
                          (value: ThemeMode.dark, label: translate.themeDark),
                        ],
                        onChanged: themeController.setThemeMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  translate.activeView,
                  style: TextStyle(fontSize: 20.0, color: colors.onSurface),
                ),
                Wrap(
                  children: List.generate(CalendarView.values.length, (index) {
                    final view = CalendarView.values[index];
                    final isSelected = view == widget.currentView;
                    // Get translated name based on the view
                    String viewName = '';
                    switch (view) {
                      case CalendarView.month:
                        viewName = translate.monthView;
                      case CalendarView.day:
                        viewName = translate.dayView;
                      case CalendarView.week:
                        viewName = translate.weekView;
                      case CalendarView.multiday:
                        viewName = translate.multidayView;
                      case CalendarView.schedule:
                        viewName = translate.scheduleView;
                    }
                    return GestureDetector(
                      onTap: () => widget.onViewChange(view),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 40,
                        ),
                        margin: const EdgeInsets.only(right: 20, top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: isSelected ? colors.primary : colors.surface,
                          border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.outlineVariant,
                          ),
                        ),
                        child: Text(
                          viewName,
                          style: TextStyle(
                            color: isSelected
                                ? colors.onPrimary
                                : colors.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Text(
                  "${translate.addEvent}: ",
                  style: TextStyle(fontSize: 20.0, color: colors.onSurface),
                ),
                const SizedBox(height: 20),
                AddOrEditEventForm(
                  onEventAdd: (event) {
                    CalendarControllerProvider.of(
                      context,
                    ).controller.add(event);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a bordered, theme-aware dropdown whose currently selected menu
  /// entry is marked with a clearly visible check icon. Colours flow through
  /// `context.appColors` so the selection stays legible in both light and dark
  /// themes. The collapsed button shows only the label via
  /// [DropdownButton.selectedItemBuilder], keeping the check confined to the
  /// open menu.
  Widget _buildThemedDropdown<T>({
    required AppThemeExtension colors,
    required T value,
    required IconData icon,
    required List<({T value, String label})> options,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(icon, color: colors.onSurfaceVariant),
          dropdownColor: colors.surface,
          borderRadius: BorderRadius.circular(12),
          style: TextStyle(color: colors.onSurface, fontSize: 18),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
          selectedItemBuilder: (context) => options
              .map(
                (option) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    option.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.onSurface, fontSize: 18),
                  ),
                ),
              )
              .toList(),
          items: options.map((option) {
            final isSelected = option.value == value;
            return DropdownMenuItem<T>(
              value: option.value,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        color: isSelected ? colors.primary : colors.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check, size: 20, color: colors.primary),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
