

import 'package:applithium_core/services/ads/model.dart';
import 'package:applithium_core/services/promo/service.dart';

abstract class Configuration {
  String preferencesName;

  PromoConfig promoConfig;
  AdsConfig adsConfig;

}