import 'dart:async';

import 'package:applithium_core/events/model.dart';
import 'package:flutter/widgets.dart';

import 'ads.dart';

class AdsService {
  static const int RETRY_COUNT = 2;

  static final AdsService instance = AdsService._();

  final _initializedSubject = Completer();

  final Map<EventTriggerModel, _AdFuture> _ads = {};

  bool _isEnabled;

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

  AdsService._();

  void init(AdConfig config, Observable<bool> isEnabledObs) async {
    isEnabledObs.listen((isEnabled) {
      if(_isEnabled == null && isEnabled) {
        _initImpl(config);
        _initializedSubject.complete(null);
      }

      _isEnabled = isEnabled;
    });

    return _initializedSubject.future;
  }

  void _initImpl(AdConfig config) {
    FirebaseAdMob.instance.initialize(appId: LocalConfiguration.adMobAppId);

    _targetingInfo = MobileAdTargetingInfo(
      keywords: config.keyWords,
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );

    config.placements.forEach((placement) => _bindAd(placement.trigger,
        _getBuilder(_targetingInfo, placement.type, placement.placementId)));

    _loadAll();
  }

  Ads Function() _getBuilder(
      MobileAdTargetingInfo info, AdType type, String id) {
    switch (type) {
      case AdType.interstitial:
        return () => InterstitialAd(adUnitId: id, targetingInfo: info);
      case AdType.banner:
        return () => BannerAd(adUnitId: id, targetingInfo: info);
    }
  }

  void _bindAd(EventTriggerModel trigger, Ads Function() builder) {
    final future = _AdFuture(builder);
    _ads[trigger] = future;
  }

  void _loadAll() {
    _ads.values.forEach((value) => value.load());
  }
}

class _AdFuture {
  final Ads Function() builder;

  Ads instance;
  int retryCount = AdsService.RETRY_COUNT;

  _AdFuture(this.builder);

  void load() async {
    instance = builder();
    instance.listener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.failedToLoad:
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

class AdConfig {
  static const String _adKeyWords = "keywords";

  static const String _adPlacementsKey = "placements";

  static const String _adPlacementIdKey = "placement";
  static const String _adTypeKey = "type";
  static const String _adTriggerKey = "trigger";

  static AdType _parseType(String stringValue) {
    return AdType.values.firstWhere((val) => val.toString() == stringValue,
        orElse: () => AdType.interstitial);
  }

  static Map<String, dynamic> defaultParams() => {
    _adKeyWords: ["instagram", "beautiful apps"],
    _adPlacementsKey: [
      {
        _adPlacementIdKey: LocalConfiguration.downloadedInterstitialAdId,
        _adTypeKey: AdType.interstitial.toString(),
        _adTriggerKey:
        EventTriggerModel(DOWNLOAD_STARTED_TAG, Operator.mod, 2).toMap()
      }
    ]
  };

  List<AdPlacement> get placements {
    final List<AdPlacement> result = [];
    List<dynamic> placements = _params[_adPlacementsKey];
    for (Map<String, dynamic> item in placements) {
      Map<String, dynamic> triggerJson = item[_adTriggerKey];
      final trigger = EventTriggerModel.fromMap(triggerJson);
      final placement = AdPlacement(
          item[_adPlacementIdKey], _parseType(item[_adTypeKey]), trigger);
      result.add(placement);
    }

    return result;
  }

  List<String> get keyWords =>
      (_params[_adKeyWords] as List<dynamic>).cast<String>();

  final Map<String, dynamic> _params;

  AdConfig(this._params);
}

class AdPlacement {
  final String placementId;
  final AdType type;
  final EventTriggerModel trigger;

  AdPlacement(this.placementId, this.type, this.trigger);
}

enum AdType { interstitial, banner }