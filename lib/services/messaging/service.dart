abstract class MessagingService {

  Stream<String> get tokenStream;

  void startListening();

  void stopListening();
}