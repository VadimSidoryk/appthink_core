import 'package:shared_preferences/shared_preferences.dart';

class UsageHistoryService {

  String get _isFirstSessionKey =>
      "$_preferencesName.UsageHistoryService.isFirstSession";

  String get firstSessionDayKey =>
      "$_preferencesName.UsageHistoryService.firstSessionDay";

  String get firstSessionYearKey =>
      "$_preferencesName.UsageHistoryService.firstSessionYear";

  String get firstSessionMonthKey =>
      "$_preferencesName.UsageHistoryService.firstSessionMonth";

  String get lastSessionDayKey =>
      "$_preferencesName.UsageHistoryService.lastSessionDay";

  String get lastSessionYearKey =>
      "$_preferencesName.UsageHistoryService.lastSessionYear";

  String get lastSessionMonthKey =>
      "$_preferencesName.UsageHistoryService.lastSessionMonth";

  UsageHistoryService(this._preferencesName, this._preferencesFuture);

  final String _preferencesName;
  final Future<SharedPreferences> _preferencesFuture;

  Future<bool> isFirstSession() async {
    final prefs = await _preferencesFuture;
    if (prefs.containsKey(_isFirstSessionKey)) {
      return false;
    } else {
      prefs.setBool(_isFirstSessionKey, false);
      _saveFirstSessionDayTime();
      _saveLastSessionDayTime();
      return true;
    }
  }

  Future<int> daysFromFirstSession() async {
    final prefs = await _preferencesFuture;
    final year = prefs.getInt(firstSessionYearKey);
    final month = prefs.getInt(firstSessionMonthKey);
    final day =  prefs.getInt(firstSessionDayKey);

    final now = DateTime.now();

    return now.difference(new DateTime(year, month, day)).inDays;
  }

  Future<int> daysFromLastSession() async {
    final prefs = await _preferencesFuture;
    final year = prefs.getInt(lastSessionYearKey);
    final month = prefs.getInt(lastSessionMonthKey);
    final day = prefs.getInt(lastSessionDayKey);

    _saveLastSessionDayTime();

    final now = DateTime.now();
    return now.difference(new DateTime(year, month, day)).inDays;
  }

  Future<void> _saveFirstSessionDayTime() async {
    final prefs = await _preferencesFuture;
    final now = DateTime.now();
    prefs.setInt(firstSessionYearKey, now.year);
    prefs.setInt(firstSessionMonthKey, now.month);
    prefs.setInt(firstSessionDayKey, now.day);
  }

  Future<void> _saveLastSessionDayTime() async {
    final prefs = await _preferencesFuture;
    final now = DateTime.now();
    prefs.setInt(lastSessionYearKey, now.year);
    prefs.setInt(lastSessionMonthKey, now.month);
    prefs.setInt(lastSessionDayKey, now.day);
  }
}
