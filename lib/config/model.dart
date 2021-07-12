import 'package:applithium_core/presentation/config.dart';
import 'package:applithium_core/services/resources/model.dart';

class ApplicationConfig {
  final ResourceConfig resources;
  final Map<String, Map<String, dynamic>> eventHandlers;
  final Map<String, PresentationConfig> presentations;

  ApplicationConfig({
    required this.resources,
    required this.eventHandlers,
    required this.presentations
  });

  PresentationConfig getFor(String path) {
    return presentations[path]!;
  }

}
