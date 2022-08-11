part of 'my_app.dart';

mixin MyAppBackend on State<MyApp> {
  late final controller = EventController<String>()..addAll(events);

  DateTime _minDate = DateTime(2000);
  DateTime _maxDate = DateTime(2025);
  DateTime _initialDate = DateTime.now();
  CurveTypes _animationCurve = CurveTypes.ease;

  void updateSettings({
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? initialDate,
    CurveTypes? animationCurve,
  }) {
    _minDate = minDate ?? _minDate;
    _maxDate = maxDate ?? _maxDate;
    _initialDate = initialDate ?? _initialDate;
    _animationCurve = animationCurve ?? _animationCurve;

    if (mounted) {
      setState(() {});
    }
  }
}
