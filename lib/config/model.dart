import 'package:applithium_core/services/resources/model.dart';

class AplConfig {

  factory AplConfig.getDefault() => AplConfig(messagingApiKey: "", resources: ResourceConfig({"": {}}));

  final String messagingApiKey;

  final ResourceConfig resources;

  AplConfig({
    required this.messagingApiKey,
    required this.resources
  });

}
