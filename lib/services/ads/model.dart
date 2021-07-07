import 'package:applithium_core/events/event_trigger.dart';

class AdsConfig {
  static const String _adKeyWordsKey = "keywords";
  static const String _adPlacementsKey = "placements";

  final List<AdPlacement> placements;
  final List<String> keyWords;

  AdsConfig(Map<String, dynamic> params)
      : keyWords = (params[_adKeyWordsKey] as List<dynamic>).cast<String>(),
        placements = (params[_adPlacementsKey] as List<dynamic>)
            .map((item) => AdPlacement.fromJson(item))
            .toList();
}

class AdPlacement {
  static const String _adPlacementIdKey = "id";
  static const String _adTypeKey = "type";
  static const String _adTriggerKey = "trigger";

  final String placementId;
  final AdType type;
  final AplEventTrigger trigger;

  factory AdPlacement.fromJson(Map<String, dynamic> json) {
    return AdPlacement(json[_adPlacementIdKey], _parseType(json[_adTypeKey]),
        AplEventTrigger.fromMap(json[_adTriggerKey]));
  }

  AdPlacement(this.placementId, this.type, this.trigger);
}

enum AdType { interstitial, banner }

AdType _parseType(String stringValue) {
  return AdType.values.firstWhere((val) => val.toString() == stringValue,
      orElse: () => AdType.interstitial);
}
