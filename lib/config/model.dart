class AplConfig {
  final Map<String, Map<String, String>>  resources;
  final Map<String, Map<String, dynamic>> eventHandlers;
  final Map<String, Map<String, dynamic>> uiComponents;

  AplConfig({required this.resources, required this.eventHandlers, required this.uiComponents});

}
