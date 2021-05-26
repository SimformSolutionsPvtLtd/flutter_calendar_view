extension DateTimeExtensions on DateTime {
  bool compareWithoutTime(DateTime date) {
    if (date == null) throw "Null value provided.";

    return this.day == date.day &&
        this.month == date.month &&
        this.year == date.year;
  }
}
