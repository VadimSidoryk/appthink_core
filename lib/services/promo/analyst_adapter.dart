import 'package:applithium_core/events/mapper/scheme.dart';
import 'package:applithium_core/events/system_listener.dart';
import 'package:flutter/cupertino.dart';

import 'service.dart';

class PromoEventsAdapter extends SystemListener {
  final PromoService _service;

  PromoEventsAdapter(this._service);

  @override
  List<NavigatorObserver> get navigatorObservers => [];

  @override
  void onEvent(EventData event) async {
    _service.handleEvent(event);
  }
}


