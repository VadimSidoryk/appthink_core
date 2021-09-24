abstract class BaseState<M> {
  final String tag;

  BaseState(this.tag);

  BaseState<M> withError(dynamic error);

  BaseState<M> withData(M data);
}