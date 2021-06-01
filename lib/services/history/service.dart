import 'package:applithium_core/services/history/usage_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageHistoryService {

  String get _isFirstSessionKey =>
      "$preferencesName.UsageHistoryService.isFirstSession";

  String get firstSessionDayKey =>
      "$preferencesName.UsageHistoryService.firstSessionDay";

  String get firstSessionYearKey =>
      "$preferencesName.UsageHistoryService.firstSessionYear";

  String get firstSessionMonthKey =>
      "$preferencesName.UsageHistoryService.firstSessionMonth";

  String get lastSessionDayKey =>
      "$preferencesName.UsageHistoryService.lastSessionDay";

  String get lastSessionYearKey =>
      "$preferencesName.UsageHistoryService.lastSessionYear";

  String get lastSessionMonthKey =>
      "$preferencesName.UsageHistoryService.lastSessionMonth";

  UsageHistoryService({required this.preferencesName, required this.preferencesFuture, this.listener});

  final String preferencesName;
  final Future<SharedPreferences> preferencesFuture;
  final UsageListener? listener;

  void onNewSession() {
    listener?.onSessionStarted();
  }


  Future<bool> _isFirstSession() async {
    final prefs = await preferencesFuture;
    if (prefs.containsKey(_isFirstSessionKey)) {
      return false;
    } else {
      prefs.setBool(_isFirstSessionKey, false);
      _saveFirstSessionDayTime();
      _saveLastSessionDayTime();
      return true;
    }
  }

  Future<int> _daysFromFirstSession() async {
    final now = DateTime.now();
    final prefs = await preferencesFuture;
    final year = prefs.getInt(firstSessionYearKey) ?? now.year;
    final month = prefs.getInt(firstSessionMonthKey) ?? now.month;
    final day =  prefs.getInt(firstSessionDayKey) ?? now.day;

    return now.difference(new DateTime(year, month, day)).inDays;
  }

  Future<int> _daysFromLastSession() async {
    final now = DateTime.now();


    final prefs = await preferencesFuture;
    final year = prefs.getInt(lastSessionYearKey) ?? now.year;
    final month = prefs.getInt(lastSessionMonthKey) ?? now.month;
    final day = prefs.getInt(lastSessionDayKey) ?? now.day;

    _saveLastSessionDayTime();

    return now.difference(new DateTime(year, month, day)).inDays;
  }

  Future<void> _saveFirstSessionDayTime() async {
    final prefs = await preferencesFuture;
    final now = DateTime.now();
    prefs.setInt(firstSessionYearKey, now.year);
    prefs.setInt(firstSessionMonthKey, now.month);
    prefs.setInt(firstSessionDayKey, now.day);
  }

  Future<void> _saveLastSessionDayTime() async {
    final prefs = await preferencesFuture;
    final now = DateTime.now();
    prefs.setInt(lastSessionYearKey, now.year);
    prefs.setInt(lastSessionMonthKey, now.month);
    prefs.setInt(lastSessionDayKey, now.day);
  }
}

