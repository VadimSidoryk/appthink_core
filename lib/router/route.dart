abstract class AplRoute {
  final String url;

  AplRoute(this.url);
}

class OpenDialog<M> extends AplRoute {
  final M model; 
  final Function(Object?) _resultListener;
  OpenDialog(this.model, this._resultListener) : super("dialog/$model");
  
  void notifyDialogClosed(dynamic result) {
    _resultListener.call(result);
  }
}

class Back extends AplRoute {
  final dynamic result;
  Back({this.result}) : super("<-");
}
