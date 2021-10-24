import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/scopes/store.dart';
import 'package:applithium_core/services/analytics/service.dart';
import 'package:applithium_core/services/analytics/session_adapter.dart';
import 'package:applithium_core/services/history/config.dart';
import 'package:applithium_core/services/history/lifecycle_adapter.dart';
import 'package:applithium_core/services/history/usage_listener.dart';
import 'package:applithium_core/services/service_base.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:applithium_core/utils/extentions.dart';

class UsageHistoryService extends AplService {
  String get _sessionCountKey =>
      "$config.UsageHistoryService.sessionCount";

  String get firstSessionDayKey =>
      "$config.UsageHistoryService.firstSessionDay";

  String get firstSessionMonthKey =>
      "$config.UsageHistoryService.firstSessionMonth";

  String get firstSessionYearKey =>
      "$config.UsageHistoryService.firstSessionYear";

  String get lastSessionDayKey =>
      "$config.UsageHistoryService.lastSessionDay";

  String get lastSessionMonthKey =>
      "$config.UsageHistoryService.lastSessionMonth";

  String get lastSessionYearKey =>
      "$config.UsageHistoryService.lastSessionYear";

  late UsageHistoryConfig config;
  late Future<SharedPreferences> preferencesProvider;
  SessionListener? listener;

  @override
  Future<void> init(AplConfig appConfig) async {
    config = appConfig.usageConfig;
  }

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

  @override
  void addToStore(Store store) {
    store.add((provider) {
      this.preferencesProvider = provider.get();
      provider.getOrNull<AnalyticsService>()?.let((analytics) {
        this.listener = AnalyticsSessionAdapter(provider.get(), provider.get());
      });
      return this;
    });
  }
}

extension _RemoteUsageConfig on AplConfig {
  static const _KEY_PREFERENCE = "preference";

  UsageHistoryConfig get usageConfig {
    return UsageHistoryConfig("usage");
  }
}
