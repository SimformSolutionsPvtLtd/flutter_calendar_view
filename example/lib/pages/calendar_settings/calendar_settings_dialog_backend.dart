part of 'calendar_settings_dialog.dart';

mixin CalendarSettingsDialogBackend on State<CalendarSettingsDialog> {
  final _form = GlobalKey<FormState>();

  late CalendarSettingsProvider _settings;

  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _initialDateController;

  late DateTime _minDate;
  late DateTime _maxDate;
  late DateTime _initialDate;
  late CurveTypes _animationCurve;

  @override
  void initState() {
    super.initState();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _initialDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _settings = CalendarSettingsProvider.of(context);

    _minDate = _settings.minDate;
    _maxDate = _settings.maxDate;
    _initialDate = _settings.initialDate;
    _animationCurve = _settings.animationCurve;
  }

  void _saveSettings() {
    _form.currentState!.save();

    app.currentState!.updateSettings(
      initialDate: _initialDate,
      maxDate: _maxDate,
      minDate: _minDate,
      animationCurve: _animationCurve,
    );
    context.pop();
  }
}
