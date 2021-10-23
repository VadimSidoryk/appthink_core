const VAL_DEFAULT_INTENT = "";

class ShareConfig {
  final Map<String, dynamic> intentToSubject;
  final Map<String, dynamic> intentToText;

  ShareConfig({required this.intentToSubject, required this.intentToText})
      : assert(intentToSubject.containsKey(VAL_DEFAULT_INTENT) && intentToText.containsKey(VAL_DEFAULT_INTENT));
}