import 'dart:async';

import 'package:applithium_core/events/model.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:flutter/widgets.dart';

import 'ads.dart';

class AdsService {
  static const int RETRY_COUNT = 2;

  final Logger _logger;
  final Ad Function() Function(AdType type, String id) _lazyAdsFactory;

  final _initializedSubject = Completer();

  final Map<EventTriggerModel, _AdFuture> _ads = {};

  bool _isEnabled;

  AdsService(this._logger, this._lazyAdsFactory);

  Map<EventTriggerModel, Future<bool> Function(BuildContext)>
      get triggerHandlers => {
            for (final entry in _ads.entries)
              entry.key: (context) async {
                if (_isEnabled) {
                  return await entry.value.show();
                } else {
                  return Future.value(false);
                }
              }
          };

  void init(AdsConfig config, Future<bool> isEnabledFuture) async {
    _logger.log("init");
    final isEnabled = await isEnabledFuture;
    if (_isEnabled == null && isEnabled) {
      _initImpl(config);
      _initializedSubject.complete(null);
    }

    _isEnabled = isEnabled;

    return _initializedSubject.future;
  }

  void _initImpl(AdsConfig config) {
    _logger.log("initImpl $config");
    config.placements.forEach((placement) => _bindAd(placement.trigger,
        _lazyAdsFactory.call(placement.type, placement.placementId)));

    _loadAll();
  }

  void _bindAd(EventTriggerModel trigger, Ad Function() builder) {
    _logger.log("bindAd trigger: $trigger, builder = $builder");
    final future = _AdFuture(builder);
    _ads[trigger] = future;
  }

  void _loadAll() {
    _logger.log("loadAll");
    _ads.values.forEach((value) => value.load());
  }
}

class _AdFuture {
  final Ad Function() builder;

  Ad instance;
  int retryCount = AdsService.RETRY_COUNT;

  _AdFuture(this.builder);

  void load() async {
    instance = builder();
    instance.listener = (AdEvent event) {
      switch (event) {
        case AdEvent.failedToLoad:
          if (retryCount > 0) {
            instance.load();
            retryCount--;
          }
          break;
        default:
          break;
      }
    };

    instance.load();
  }

  Future<bool> show() async {
    print("call show");
    return _showImpl(true);
  }

  Future<bool> _showImpl(bool waitingToLoad) {
    if (instance != null) {
      return instance.isLoaded().then((isLoaded) {
        if (isLoaded) {
          return instance.show().whenComplete(() {
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

class AdsConfig {
  static const String _adKeyWordsKey = "keywords";
  static const String _adPlacementsKey = "placements";

  final List<AdPlacement> placements;
  final List<String> keyWords;

  AdsConfig(Map<String, dynamic> params)
      : keyWords = (params[_adKeyWordsKey] as List<dynamic>).cast<String>(),
        placements = (params[_adPlacementsKey] as List<dynamic>)
            .map((item) => AdPlacement.fromJson(item));
}

class AdPlacement {
  static const String _adPlacementIdKey = "id";
  static const String _adTypeKey = "type";
  static const String _adTriggerKey = "trigger";

  final String placementId;
  final AdType type;
  final EventTriggerModel trigger;

  factory AdPlacement.fromJson(Map<String, dynamic> json) {
    return AdPlacement(json[_adPlacementIdKey], _parseType(json[_adTypeKey]),
        EventTriggerModel.fromMap(json[_adTriggerKey]));
  }

  AdPlacement(this.placementId, this.type, this.trigger);
}

enum AdType { interstitial, banner }

AdType _parseType(String stringValue) {
  return AdType.values.firstWhere((val) => val.toString() == stringValue,
      orElse: () => AdType.interstitial);
}
