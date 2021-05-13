typedef void AdListener(AdEvent event);

abstract class Ad {
  Future<bool> isLoaded();
  Future<bool> show();
  void load();
  AdListener? listener;
}

enum AdEvent {
  loaded,
  failedToLoad,
  clicked,
  impression,
  opened,
  leftApplication,
  closed,
}