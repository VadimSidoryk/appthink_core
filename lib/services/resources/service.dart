import 'package:applithium_core/services/base.dart';
import 'package:applithium_core/services/resources/model.dart';
import 'package:flutter/cupertino.dart';

class ResourceService extends AplService<ResourceConfig> {

  static getResourcesForLocale(BuildContext context, ResourceConfig config) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if(config.hasStringsForLanguage(languageCode)) {
      return config.getStringsForLanguage(languageCode);
    } else {
      return config.getDefaultStrings();
    }
  }

  late Map<String, String> _stringResources;

  String getString(String key) {
    return _stringResources[key] as String;
  }

  @override
  void init(BuildContext context, ResourceConfig config) {
    _stringResources = getResourcesForLocale(context, config);
  }
}