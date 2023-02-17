import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LifecycleListeners extends WidgetsBindingObserver {
  final AsyncCallback? onResume;
  final AsyncCallback? onPause;
  final AsyncCallback? onInactive;
  final AsyncCallback? onDetached;

  LifecycleListeners({
    this.onResume,
    this.onPause,
    this.onInactive,
    this.onDetached
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume?.call();
        break;
      case AppLifecycleState.paused:
        onPause?.call();
        break;
      case AppLifecycleState.inactive:
        onInactive?.call();
        break;
      case AppLifecycleState.detached:
        onDetached?.call();
        break;
    }
  }
}
