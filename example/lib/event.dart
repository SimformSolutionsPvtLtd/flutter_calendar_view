class Event {
  final String title;

  Event({this.title = "Title"});

  @override
  bool operator ==(Object other) => other is Event && this.title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => this.title;
}
