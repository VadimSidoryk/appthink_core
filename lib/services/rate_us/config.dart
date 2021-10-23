class RateUsConfig {
  final String title;
  final String text;
  final String googlePlayId;
  final String appStoreId;
  final int minDays;
  final int minLaunches;
  final int remindDays;
  final int remindLaunches;

  RateUsConfig(
      {required this.title,
        required this.text,
        required this.googlePlayId,
        required this.appStoreId,
        required this.minDays,
        required this.minLaunches,
        required this.remindDays,
        required this.remindLaunches});
}