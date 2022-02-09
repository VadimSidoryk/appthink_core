abstract class BaseState<M> {
  final String tag;
  get error;

  const BaseState(this.tag);

  BaseState<M> withError(dynamic error);

}