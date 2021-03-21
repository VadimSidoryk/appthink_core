import 'package:applithium_core/ads/service.dart';
import 'package:applithium_core/promo/service.dart';

abstract class Configuration {
  String preferencesName;

  PromoConfig promoConfig;
  AdsConfig adsConfig;

}