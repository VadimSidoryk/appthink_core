abstract class Trackable  {
  bool get shouldBeTracked;
  String get name;
  Map<String, Object>? get params;

  const Trackable();
}