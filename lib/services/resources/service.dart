import 'package:applithium_core/services/resources/model.dart';
import 'package:flutter/cupertino.dart';

class ResourceService {

  static getResourcesForLocale(BuildContext context, ResourceConfig config) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if(config.hasStringsForLanguage(languageCode)) {
      return config.getStringsForLanguage(languageCode);
    } else {
      return config.getDefaultStrings();
    }
  }

  final Map<String, String> _stringResources;

  ResourceService(BuildContext context, ResourceConfig config): _stringResources = getResourcesForLocale(context, config);

  String getString(String key) {
    return _stringResources[key];
  }
}