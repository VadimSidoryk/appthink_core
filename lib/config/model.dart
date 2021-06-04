abstract class AplConfig {
  Map<String, Map<String, String>> get resources;
}

class EmptyConfig extends AplConfig {
  @override
  Map<String, Map<String, String>> get resources => {
    "": {}
  };
}