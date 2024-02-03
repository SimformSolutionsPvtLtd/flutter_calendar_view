import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeExtensions', () {
    test('datesOfWeek_simple', () {
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 02, 25));
    });
    test('datesOfWeek_DaylightSavingTime-2023-03-26', () {
      // Just to be sure, testing for dates adjecent to daylinght saving time
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 03, 25));
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 03, 26));
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 03, 27));
    });
    test('datesOfWeek_DaylightSavingTime-2023-10-29', () {
      // Just to be sure, testing for dates adjecent to daylinght saving time
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 10, 28));
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 10, 29));
      testDatesOfWeekForAllWeekDayStarts(DateTime(2023, 10, 30));
    });
    test('firstDayOfWeek_simple', () {
      testAllFirstDayOfTheWeek(DateTime(2023, 02, 25));
    });
    test('firstDayOfWeek_DaylightSavingTime-2023-03-26', () {
      // Just to be sure, testing for dates adjecent to daylinght saving time
      testAllFirstDayOfTheWeek(DateTime(2023, 03, 25));
      testAllFirstDayOfTheWeek(DateTime(2023, 03, 26));
      testAllFirstDayOfTheWeek(DateTime(2023, 03, 27));
    });
    test('firstDayOfWeek_DaylightSavingTime-2023-10-29', () {
      // Just to be sure, testing for dates adjecent to daylinght saving time
      testAllFirstDayOfTheWeek(DateTime(2023, 10, 28));
      testAllFirstDayOfTheWeek(DateTime(2023, 10, 29));
      testAllFirstDayOfTheWeek(DateTime(2023, 10, 30));
    });
    test('lastDayOfWeek_simple', () {
      testAllLastDayOfTheWeek(DateTime(2023, 02, 25));
    });
    test('lastDayOfWeek_DaylightSavingTime-2023-03-26', () {
      // Just to be sure, testing for dates adjecent to daylinght saving time
      testAllLastDayOfTheWeek(DateTime(2023, 03, 25));
      testAllLastDayOfTheWeek(DateTime(2023, 03, 26));
      testAllLastDayOfTheWeek(DateTime(2023, 03, 27));
    });
    test('lastDayOfWeek_DaylightSavingTime-2023-10-29', () {
      // Just to be sure, testing for dates adjecent to daylinght saving time
      testAllLastDayOfTheWeek(DateTime(2023, 10, 28));
      testAllLastDayOfTheWeek(DateTime(2023, 10, 29));
      testAllLastDayOfTheWeek(DateTime(2023, 10, 30));
    });
  });
}

/// Does datesOfWeek tests for this date with all 7 [WeekDays] as starts.
void testDatesOfWeekForAllWeekDayStarts(DateTime date) {
  for (final start in WeekDays.values) {
    testDatesOfWeek(
      getWeekStartDay(date, start),
      date.datesOfWeek(start: start),
    );
  }
}

void testDatesOfWeek(DateTime firstDay, List<DateTime> result) {
  expect(result.length, 7, reason: "There must be 7 dates in a week!");

  expect(result[0], DateTime(firstDay.year, firstDay.month, firstDay.day));
  expect(result[1], DateTime(firstDay.year, firstDay.month, firstDay.day + 1));
  expect(result[2], DateTime(firstDay.year, firstDay.month, firstDay.day + 2));
  expect(result[3], DateTime(firstDay.year, firstDay.month, firstDay.day + 3));
  expect(result[4], DateTime(firstDay.year, firstDay.month, firstDay.day + 4));
  expect(result[5], DateTime(firstDay.year, firstDay.month, firstDay.day + 5));
  expect(result[6], DateTime(firstDay.year, firstDay.month, firstDay.day + 6));
}

/// Does exactly 7x7 = 49 tests, testing this date and 6 next consecutive dates
/// as referent first days of the week, and for each referent first day of the
/// week does tests that this date and its 7 consecutive days are pointing it as
/// a first day of the week.
void testAllFirstDayOfTheWeek(DateTime date) {
  for (var i = 0; i < 7; i++) {
    final testDate = DateTime(
      date.year,
      date.month,
      date.day + i,
    );

    testFirstDayOfTheWeekForAllWeekDays(testDate);
  }
}

void testFirstDayOfTheWeekForAllWeekDays(DateTime firstDayOfTheWeek) {
  final weekDays = getWeekDays(firstDayOfTheWeek);
  for (var i = 0; i < 7; i++) {
    final date = DateTime(
      firstDayOfTheWeek.year,
      firstDayOfTheWeek.month,
      firstDayOfTheWeek.day + i,
    );

    expect(firstDayOfTheWeek, date.firstDayOfWeek(start: weekDays));
  }
}

/// Does exactly 7x7 = 49 tests, testing this date and 6 consecutive dates as
/// referent last days of the week, and for each referent last day of the week
/// does tests that this date and its previous days are pointing it as a last
/// day of the week.
void testAllLastDayOfTheWeek(DateTime date) {
  for (var i = 0; i < 7; i++) {
    final testDate = DateTime(
      date.year,
      date.month,
      date.day + i,
    );

    testLastDayOfTheWeekForAllWeekDays(testDate);
  }
}

void testLastDayOfTheWeekForAllWeekDays(DateTime lastDayOfTheWeek) {
  final weekDays = nextWeekDays(getWeekDays(lastDayOfTheWeek));
  for (var i = 0; i < 7; i++) {
    final date = DateTime(
      lastDayOfTheWeek.year,
      lastDayOfTheWeek.month,
      lastDayOfTheWeek.day - i,
    );

    expect(lastDayOfTheWeek, date.lastDayOfWeek(start: weekDays));
  }
}

DateTime getWeekStartDay(DateTime date, WeekDays start) {
  final weekStartDay = DateTime(
      date.year, date.month, date.day - (date.weekday - start.index - 1) % 7);
  return DateTime(weekStartDay.year, weekStartDay.month, weekStartDay.day);
}

WeekDays getWeekDays(DateTime date) {
  switch (date.weekday) {
    case 1:
      return WeekDays.monday;
    case 2:
      return WeekDays.tuesday;
    case 3:
      return WeekDays.wednesday;
    case 4:
      return WeekDays.thursday;
    case 5:
      return WeekDays.friday;
    case 6:
      return WeekDays.saturday;
    case 7:
      return WeekDays.sunday;
    default:
      throw Exception("""
        Date $date has unrecognisable weekday expencted [1-7], 
        but ${date.weekday} was provided.
          """);
  }
}

WeekDays nextWeekDays(WeekDays current) {
  switch (current) {
    case WeekDays.monday:
      return WeekDays.tuesday;
    case WeekDays.tuesday:
      return WeekDays.wednesday;
    case WeekDays.wednesday:
      return WeekDays.thursday;
    case WeekDays.thursday:
      return WeekDays.friday;
    case WeekDays.friday:
      return WeekDays.saturday;
    case WeekDays.saturday:
      return WeekDays.sunday;
    case WeekDays.sunday:
      return WeekDays.monday;
  }
}
