import 'package:applithium_core/services/resources/model.dart';

class ApplicationConfig {

  factory ApplicationConfig.getDefault() => ApplicationConfig(resources: ResourceConfig({}));

  final ResourceConfig resources;

  ApplicationConfig({
    required this.resources
  });
}
