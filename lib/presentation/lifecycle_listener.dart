import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LifecycleListeners extends WidgetsBindingObserver {
  final AsyncCallback resumeListener;
  final AsyncCallback suspendingListener;

  LifecycleListeners({
    required this.resumeListener,
    required this.suspendingListener,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeListener();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingListener();
        break;
    }
  }
}
