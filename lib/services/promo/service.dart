import 'dart:io';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/services/events/model.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rate_my_app/rate_my_app.dart';

class PromoService {

  final Configuration _config;
  final Future<RateMyApp> _rateMyApp;

  PromoService(this._config, this._rateMyApp);

  Map<EventTriggerModel,
      Future<bool> Function(BuildContext)> get triggerHandlers =>
      {
        for (final placement in _config.promoConfig.placements)
          placement.trigger: _createHandler(placement.type, placement.details)
      };

  Future<bool> Function(BuildContext) _createHandler(PromoType type, PromoDetails details) {
    switch (type) {
      case PromoType.rateUs:
        return (context) => _showRateUs(context, details as RateUsDetails);
      default:
        throw "Illegal promo type";
    }
  }

  Future<bool> _showRateUs(BuildContext context, RateUsDetails details) async {
    log("call _showRateUs");

    final service = await _rateMyApp;
    await service.showStarRateDialog(
      context,
      title: details.title,
      message: details.message,
      actionsBuilder: (context, stars) =>
          _ratingChangedContent(context, service, details, stars),
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 10),
      ),
      starRatingOptions: StarRatingOptions(),
    );
    return true;
  }

  List<Widget> _ratingChangedContent(BuildContext context, RateMyApp service,
      RateUsDetails details, double stars) {
    return [FlatButton(
      child: Text(details.buttonTitle),
      onPressed: () {
        log('Thanks for the ' +
            (stars == null ? '0' : stars.round().toString()) +
            ' star(s) !');
        if (stars == 5) {
          LaunchReview.launch(androidAppId: details.link);
        }
        service.save().then((v) => Navigator.pop(context));
      },
    )
    ];
  }
}

class PromoConfig {
  static const String _PROMO_TYPE_KEY = "type";
  static const String _PROMO_TRIGGER_KEY = "trigger";
  static const String _DETAILS_KEY = "details";

  final List<PromoPlacement> placements = [];

  PromoConfig(List<dynamic> placementsJson) {
    for (Map<String, dynamic> item in placementsJson) {
      Map<String, dynamic> triggerJson = item[_PROMO_TRIGGER_KEY];
      final trigger = EventTriggerModel.fromMap(triggerJson);
      PromoDetails details;
      final type = _parseType(item[_PROMO_TYPE_KEY]);
      switch (type) {
        case PromoType.rateUs:
          details = RateUsDetails.fromJson(item[_DETAILS_KEY]);
      }
      placements.add(PromoPlacement(type, details, trigger));
    }
  }
}

abstract class PromoDetails {}

class PromoPlacement {
  final PromoType type;
  final PromoDetails details;
  final EventTriggerModel trigger;

  PromoPlacement(this.type, this.details, this.trigger);
}

enum PromoType { rateUs }

PromoType _parseType(String stringValue) {
  return PromoType.values.firstWhere((val) => val.toString() == stringValue,
      orElse: () => PromoType.rateUs);
}

class RateUsDetails extends PromoDetails {
  
  static const _TITLE_KEY = "title";
  static const _MESSAGE_KEY = "message";
  static const _BUTTON_TITLE_KEY = "button_title";
  static const _LINK_KEY = "link";
  
  final String title;
  final String message;
  final String buttonTitle;
  final String link;
  
  factory RateUsDetails.fromJson(Map<String, dynamic> config) {
    return RateUsDetails(
      config[_TITLE_KEY],
      config[_MESSAGE_KEY],
      config[_BUTTON_TITLE_KEY],
      config[_LINK_KEY]
    );
  }

  RateUsDetails(this.title, this.message, this.buttonTitle, this.link);
}
