import 'package:applithium_core/services/resources/model.dart';

class ApplicationConfig {

  factory ApplicationConfig.getDefault() => ApplicationConfig(messagingApiKey: "", resources: ResourceConfig({}));

  final String messagingApiKey;

  final ResourceConfig resources;

  ApplicationConfig({
    required this.messagingApiKey,
    required this.resources
  });

}
