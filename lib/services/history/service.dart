import 'package:applithium_core/services/history/lifecycle_adapter.dart';
import 'package:applithium_core/services/history/usage_listener.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageHistoryService {
  String get _sessionCountKey =>
      "$preferencesName.UsageHistoryService.sessionCount";

  String get firstSessionDayKey =>
      "$preferencesName.UsageHistoryService.firstSessionDay";

  String get firstSessionMonthKey =>
      "$preferencesName.UsageHistoryService.firstSessionMonth";

  String get firstSessionYearKey =>
      "$preferencesName.UsageHistoryService.firstSessionYear";

  String get lastSessionDayKey =>
      "$preferencesName.UsageHistoryService.lastSessionDay";

  String get lastSessionMonthKey =>
      "$preferencesName.UsageHistoryService.lastSessionMonth";

  String get lastSessionYearKey =>
      "$preferencesName.UsageHistoryService.lastSessionYear";

  UsageHistoryService(
      {this.preferencesName, required this.preferencesProvider, this.listener});

  final String? preferencesName;
  final Future<SharedPreferences> preferencesProvider;
  final SessionListener? listener;

  WidgetsBindingObserver asWidgetObserver() {
    return UsageWidgetStateAdapter(this);
  }

  void openSession() async {
    final count = await _getSessionCount();
    final daysFromFirst = await _daysFromFirstSession();
    final daysFromLast = await _daysFromLastSession();
    listener?.onSessionStarted(count, daysFromFirst, daysFromLast);
  }

  void pauseSession() {
    listener?.onSessionPaused();
  }

  void resumeSession() {
    listener?.onSessionResumed();
  }

  Future<int> _getSessionCount() async {
    final prefs = await preferencesProvider;
    final count = prefs.getInt(_sessionCountKey) ?? 0;
    prefs.setInt(_sessionCountKey, count + 1);
    _saveFirstSessionDayTime();
    _saveLastSessionDayTime();
    return count + 1;
  }

  Future<int> _daysFromFirstSession() async {
    final now = DateTime.now();
    final prefs = await preferencesProvider;
    final year = prefs.getInt(firstSessionYearKey) ?? now.year;
    final month = prefs.getInt(firstSessionMonthKey) ?? now.month;
    final day = prefs.getInt(firstSessionDayKey) ?? now.day;

    return now.difference(new DateTime(year, month, day)).inDays;
  }

  Future<int> _daysFromLastSession() async {
    final now = DateTime.now();

    final prefs = await preferencesProvider;
    final year = prefs.getInt(lastSessionYearKey) ?? now.year;
    final month = prefs.getInt(lastSessionMonthKey) ?? now.month;
    final day = prefs.getInt(lastSessionDayKey) ?? now.day;

    _saveLastSessionDayTime();

    return now.difference(new DateTime(year, month, day)).inDays;
  }

  Future<void> _saveFirstSessionDayTime() async {
    final prefs = await preferencesProvider;
    final now = DateTime.now();
    prefs.setInt(firstSessionYearKey, now.year);
    prefs.setInt(firstSessionMonthKey, now.month);
    prefs.setInt(firstSessionDayKey, now.day);
  }

  Future<void> _saveLastSessionDayTime() async {
    final prefs = await preferencesProvider;
    final now = DateTime.now();
    prefs.setInt(lastSessionYearKey, now.year);
    prefs.setInt(lastSessionMonthKey, now.month);
    prefs.setInt(lastSessionDayKey, now.day);
  }
}
