import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';

/// Immutable bag of the [ScheduleView] knobs the demo lets the user flip at
/// runtime. Held in a [ValueNotifier] so a change rebuilds only the schedule —
/// the AppBar and FABs around it stay put.
///
/// Defaults mirror the values [ScheduleViewWidget] previously hard-coded, so
/// the first frame looks identical to before the settings menu existed.
@immutable
class ScheduleViewConfig {
  final bool showDaysWithoutEvents;
  final bool showEmptyMonths;
  final ScheduleDateLayout dateLayout;

  const ScheduleViewConfig({
    this.showDaysWithoutEvents = false,
    this.showEmptyMonths = true,
    this.dateLayout = ScheduleDateLayout.left,
  });

  ScheduleViewConfig copyWith({
    bool? showDaysWithoutEvents,
    bool? showEmptyMonths,
    ScheduleDateLayout? dateLayout,
  }) {
    return ScheduleViewConfig(
      showDaysWithoutEvents:
          showDaysWithoutEvents ?? this.showDaysWithoutEvents,
      showEmptyMonths: showEmptyMonths ?? this.showEmptyMonths,
      dateLayout: dateLayout ?? this.dateLayout,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ScheduleViewConfig &&
      other.showDaysWithoutEvents == showDaysWithoutEvents &&
      other.showEmptyMonths == showEmptyMonths &&
      other.dateLayout == dateLayout;

  @override
  int get hashCode =>
      Object.hash(showDaysWithoutEvents, showEmptyMonths, dateLayout);
}

/// AppBar action that opens a stay-open popup panel for editing [config].
///
/// Edits are staged in a local draft while the menu is open; the shared
/// [config] notifier — and therefore the schedule — is updated only once, when
/// the menu closes. Both close paths (the Done button and a tap outside) pop
/// the menu with a `null` result, which routes through
/// [PopupMenuButton.onCanceled], the single commit point.
class ScheduleSettingsButton extends StatefulWidget {
  final ValueNotifier<ScheduleViewConfig> config;

  const ScheduleSettingsButton({super.key, required this.config});

  @override
  State<ScheduleSettingsButton> createState() => _ScheduleSettingsButtonState();
}

class _ScheduleSettingsButtonState extends State<ScheduleSettingsButton> {
  // Pending edits, kept out of the shared notifier so toggling a switch does
  // not rebuild the schedule. Re-synced from the committed config on each open.
  late ScheduleViewConfig _draft = widget.config.value;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      tooltip: context.translate.scheduleSettings,
      icon: const Icon(Icons.tune),
      // Start each session from the currently committed config. Runs after
      // itemBuilder but before the menu route builds, so the panel reads it.
      onOpened: () => _draft = widget.config.value,
      // Fires on every dismissal — Done button or tap outside — and is the only
      // place the staged draft is published, so the schedule rebuilds once.
      onCanceled: () => widget.config.value = _draft,
      // A single `enabled: false` item gives its InkWell a null onTap, so it
      // never joins the gesture arena — a stray row tap can't dismiss the menu
      // — while the controls inside still win their own taps and work normally.
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          enabled: false,
          padding: EdgeInsets.zero,
          // The open menu lives in its own route and won't rebuild when this
          // button does, so a StatefulBuilder gives the panel a local setState
          // to reflect draft edits while staying open.
          child: StatefulBuilder(
            builder: (context, setMenuState) => _SettingsPanel(
              value: _draft,
              onChanged: (next) => setMenuState(() => _draft = next),
              onDone: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  final ScheduleViewConfig value;
  final ValueChanged<ScheduleViewConfig> onChanged;
  final VoidCallback onDone;

  const _SettingsPanel({
    required this.value,
    required this.onChanged,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final translate = context.translate;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              translate.scheduleShowDaysWithoutEvents,
              style: TextStyle(color: appColors.onSurfaceVariant),
            ),
            value: value.showDaysWithoutEvents,
            onChanged: (v) =>
                onChanged(value.copyWith(showDaysWithoutEvents: v)),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              translate.scheduleShowEmptyMonths,
              style: TextStyle(color: appColors.onSurfaceVariant),
            ),
            value: value.showEmptyMonths,
            onChanged: (v) => onChanged(value.copyWith(showEmptyMonths: v)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Text(
              translate.scheduleDateLayout,
              style: TextStyle(color: appColors.onSurfaceVariant),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<ScheduleDateLayout>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ScheduleDateLayout.left,
                  icon: const Icon(Icons.view_sidebar_outlined),
                  label: Text(translate.scheduleDateLayoutLeft),
                ),
                ButtonSegment(
                  value: ScheduleDateLayout.top,
                  icon: const Icon(Icons.view_agenda_outlined),
                  label: Text(translate.scheduleDateLayoutTop),
                ),
              ],
              selected: {value.dateLayout},
              onSelectionChanged: (s) =>
                  onChanged(value.copyWith(dateLayout: s.first)),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TextButton(onPressed: onDone, child: Text(translate.done)),
            ),
          ),
        ],
      ),
    );
  }
}
