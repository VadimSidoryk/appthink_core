abstract class UseCase<I, O> {
  Future<O> loadData(I input);
}