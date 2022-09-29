class Lazy<T> {

  T? _instance;

  final T Function() provider;

  Lazy(this.provider);

  T get() => _instance ??= provider();
}