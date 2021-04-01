abstract class AplRoute {
  final String name;

  AplRoute(this.name);
}

abstract class PushScreen extends AplRoute {
  final dynamic arguments;
   PushScreen(name, {this.arguments}): super(name);
}

class OpenDialog<M> extends AplRoute {
  final M model; 
  final Function(dynamic) _resultListener;
  OpenDialog(this.model, this._resultListener) : super("dialog/$model");
  
  void notifyDialogClosed(dynamic result) {
    _resultListener.call(result);
  }
}

class Back extends AplRoute {
  final dynamic result;
  Back({this.result}) : super("<-");
}
