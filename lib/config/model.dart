

import 'package:applithium_core/services/ads/model.dart';
import 'package:applithium_core/services/promo/service.dart';

abstract class Configuration {

  String get preferencesName;

  String getString(dynamic key);

  String getVector(dynamic key);

  PromoConfig get promoConfig;

  AdsConfig get adsConfig;
}