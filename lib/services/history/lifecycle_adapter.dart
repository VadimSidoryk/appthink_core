import 'package:flutter/widgets.dart';

import 'service.dart';

class UsageWidgetStateAdapter extends WidgetsBindingObserver {

  final UsageHistoryService usageService;

  UsageWidgetStateAdapter(this.usageService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        usageService.resumeSession();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        usageService.pauseSession();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}