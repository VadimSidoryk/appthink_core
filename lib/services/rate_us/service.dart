import 'dart:convert';
import 'dart:io';

import 'package:applithium_core/config/model.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rate_my_app/rate_my_app.dart';


import 'config.dart';
import 'config_remote.dart';

class RateUsService  {
  late RateMyApp _impl;
  late RateUsConfig _config;

  RateUsService(AplConfig config) {
    _init(config);
  }

  Future<void> _init(AplConfig config) async {
    _config = config.rateUs;
    _impl = RateMyApp(
      googlePlayIdentifier: _config.googlePlayId,
      appStoreIdentifier: _config.appStoreId,
    );
    await _impl.init();
  }

  bool get shouldOpenDialog => _impl.shouldOpenDialog;

  void showRateUsDialog(BuildContext context) {
    _impl.showRateDialog(
      context,
      title: _config.title,
      // The dialog title.
      message: _config.text,
      // The dialog message.
      rateButton: 'RATE',
      // The dialog "rate" button text.
      noButton: 'NO THANKS',
      // The dialog "no" button text.
      laterButton: 'MAYBE LATER',
      // The dialog "later" button text.
      ignoreNativeDialog: Platform.isAndroid,
      // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      dialogStyle: const DialogStyle(),
      // Custom dialog styles.
      onDismissed: () => _impl.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    );
  }

  void showStarsDialog(BuildContext context) {
    _impl.showStarRateDialog(
      context,
      title: _config.title,
      // The dialog title.
      message: _config.text,
      // The dialog message.
      actionsBuilder: (context, stars) {
        // Triggered when the user updates the star rating.
        return [
          // Return a list of actions (that will be shown at the bottom of the dialog).
          FlatButton(
            child: Text('OK'),
            onPressed: () async {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');
              // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
              // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
              await _impl.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(
                  context, RateMyAppDialogButton.rate);
            },
          ),
        ];
      },
      ignoreNativeDialog: Platform.isAndroid,
      // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      dialogStyle: DialogStyle(
        // Custom dialog styles.
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: const StarRatingOptions(),
      // Custom star bar rating options.
      onDismissed: () => _impl.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    );
  }
}

extension RemoteSaveOnConfig on AplConfig {
  static const _KEY_RATE_US = "rate_us";

  RateUsConfig get rateUs {
    final result = this.getString(_KEY_RATE_US);
    final json = jsonDecode(result);
    return RemoteRateUsConfigSerializer.fromMap(json);
  }
}