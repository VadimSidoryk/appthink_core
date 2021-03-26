abstract class AplRoute {
  final String name;
  final Object arguments;

  AplRoute(this.name, {this.arguments});
}

class Back extends AplRoute {
  Back() : super("");
}

class DialogResult<O> extends AplRoute {
  final bool result;
  final O output;

  DialogResult(this.result, this.output) : super('');
}