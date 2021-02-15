abstract class BaseRepository<T> {
  Stream<T> dataStream;

  Future<bool> updateData(bool isForced);

  void close();
}