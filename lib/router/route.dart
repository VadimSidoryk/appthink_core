abstract class AplRoute {
  final String name;

  AplRoute(this.name);
}

abstract class Push extends AplRoute {
  final dynamic arguments;
   Push(name, {this.arguments}): super(name);
}

class Back extends AplRoute {
  final dynamic result;
  Back({this.result}) : super("<-");
}
