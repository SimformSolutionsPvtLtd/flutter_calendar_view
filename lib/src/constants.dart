import 'dart:math';
import 'dart:ui';

class Constants {
  Constants._();

  static final Random _random = Random();
  static final int _maxColor = 256;

  static const int hoursADay = 24;

  static final List<String> weekTitles = ["M", "T", "W", "T", "F", "S", "S"];

  static const Color defaultLiveTimeIndicatorColor = const Color(0xff444444);
  static const Color defaultBorderColor = const Color(0xffdddddd);
  static const Color black = const Color(0xff000000);
  static const Color white = const Color(0xffffffff);
  static const Color offWhite = const Color(0xfff0f0f0);
  static const Color headerBackground = const Color(0xFFDCF0FF);
  static Color get randomColor {
    return Color.fromRGBO(_random.nextInt(_maxColor),
        _random.nextInt(_maxColor), _random.nextInt(_maxColor), 1);
  }
}
