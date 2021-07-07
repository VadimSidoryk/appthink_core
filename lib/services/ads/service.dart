import 'dart:async';

import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/events/event_trigger.dart';
import 'package:flutter/widgets.dart';

import 'ads.dart';
import 'model.dart';

class AdsService {
  static const int RETRY_COUNT = 2;

  final Ad Function() Function(AdType type, String id) _lazyAdsFactory;

  final _initializedSubject = Completer();

  final Map<AplEventTrigger, _AdFuture> _ads = {};

  bool? _isEnabled;

  AdsService(this._lazyAdsFactory);

  Map<AplEventTrigger, Future<bool> Function(BuildContext)>
      get triggerHandlers => {
            for (final entry in _ads.entries)
              entry.key: (context) async {
                if (_isEnabled == true) {
                  return await entry.value.show();
                } else {
                  return Future.value(false);
                }
              }
          };

  void init(AdsConfig config, Future<bool> isEnabledFuture) async {
    log("init");
    final isEnabled = await isEnabledFuture;
    if (_isEnabled == null && isEnabled) {
      _initImpl(config);
      _initializedSubject.complete(null);
    }

    _isEnabled = isEnabled;

    return _initializedSubject.future;
  }

  void _initImpl(AdsConfig config) {
    log("initImpl $config");
    config.placements.forEach((placement) => _bindAd(placement.trigger,
        _lazyAdsFactory.call(placement.type, placement.placementId)));

    _loadAll();
  }

  void _bindAd(AplEventTrigger trigger, Ad Function() builder) {
    log("bindAd trigger: $trigger, builder = $builder");
    final future = _AdFuture(builder);
    _ads[trigger] = future;
  }

  void _loadAll() {
    log("loadAll");
    _ads.values.forEach((value) => value.load());
  }
}

class _AdFuture {
  final Ad Function() builder;

  Ad? instance;
  int retryCount = AdsService.RETRY_COUNT;

  _AdFuture(this.builder);

  void load() async {
    instance = builder();
    (instance as Ad).listener = (AdEvent event) {
      switch (event) {
        case AdEvent.failedToLoad:
          if (retryCount > 0) {
            instance?.load();
            retryCount--;
          }
          break;
        default:
          break;
      }
    };

    instance?.load();
  }

  Future<bool> show() async {
    print("call show");
    return _showImpl(true);
  }

  Future<bool> _showImpl(bool waitingToLoad) {
    if (instance != null) {
      return (instance as Ad).isLoaded().then((isLoaded) {
        if (isLoaded) {
          return (instance as Ad).show().whenComplete(() {
            load();
          });
        } else {
          if (waitingToLoad) {
            return Future.delayed(Duration(seconds: 3)).then((value) {
              return _showImpl(false);
            });
          } else {
            return Future.value(false);
          }
        }
      });
    } else {
      return Future.error("Instance is null");
    }
  }
}
