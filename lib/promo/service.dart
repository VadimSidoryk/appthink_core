import 'dart:io';

import 'package:applithium_core/events/model.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class PromoService {

  final Logger _logger;
  final PromoConfig _config;
  final Future<RateMyApp> _rateMyApp;

  PromoService(this._logger, this._config, this._rateMyApp);

  Map<EventTriggerModel, Future<bool> Function(BuildContext)> get triggerHandlers =>
      {
        for (final placement in _config.placements)
          placement.trigger: _createHandler(placement.type)
      };

  Future<bool> Function(BuildContext) _createHandler(PromoType type) {
    switch (type) {
      case PromoType.rateUs:
        return (context) => _showRateUs(context);
      default:
        throw "Illegal promo type";
    }
  }

  Future<bool> _showRateUs(BuildContext context) async {
    print("call _showRateUs");

    String title;
    if(Platform.isIOS) {
      title = 'Like using Peeq app?';
    } else {
      title = 'Like using Zeelq app?';
    }

    final service = await _rateMyApp;

    await service.showStarRateDialog(
      context,
      title: title,
      message:
      'Then take a little bit of your time to leave a rating. Thanks!',
      onRatingChanged: (stars) =>
      [_ratingChangedContent(context, service, stars)],
      ignoreIOS: false,
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 10),
      ),
      starRatingOptions: StarRatingOptions(),
    );
    return true;
  }

  Widget _ratingChangedContent(
      BuildContext context, RateMyApp service, double stars) {
    return FlatButton(
      child: Text('RATE'),
      onPressed: () {
        log('Thanks for the ' +
            (stars == null ? '0' : stars.round().toString()) +
            ' star(s) !');
        if (stars == 5) {
          LaunchReview.launch(androidAppId: LocalConfiguration.rateUsLink);
        }
        service.doNotOpenAgain = true;
        service.save().then((v) => Navigator.pop(context));
      },
    );
  }
}

class PromoConfig {
  static const String _promoPlacementsKey = "placements";
  static const String _promoTypeKey = "type";
  static const String _promoTriggerKey = "trigger";

  static Map<String, dynamic> defaultParams() => {
    _promoPlacementsKey: [
      {
        _promoTypeKey: PromoType.rateUs.toString(),
        _promoTriggerKey:
        EventTriggerModel(DOWNLOAD_STARTED_TAG, Operator.equals, 3).toMap()
      }
    ]
  };



  List<PromoPlacement> get placements {
    List<PromoPlacement> result = [];
    List<dynamic> jsonItems = _params[_promoPlacementsKey];
    for (Map<String, dynamic> item in jsonItems) {
      Map<String, dynamic> triggerJson = item[_promoTriggerKey];
      final trigger = EventTriggerModel.fromMap(triggerJson);
      result.add(PromoPlacement(_parseType(item[_promoTypeKey]), trigger));
    }

    return result;
  }

  final Map<String, dynamic> _params;

  PromoConfig(this._params);
}

class PromoPlacement {
  final PromoType type;
  final EventTriggerModel trigger;

  PromoPlacement(this.type, this.trigger);
}

enum PromoType { rateUs }