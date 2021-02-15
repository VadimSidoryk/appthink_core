abstract class BaseRepository<T> {
  Stream<T> updatesStream;

  Future<bool> updateData(bool isForced);

  void close();
}