abstract class AplRoute {
  final String name;
  final Object arguments;

  AplRoute(this.name, {this.arguments});
}

class Back extends AplRoute {
  Back() : super("");
}