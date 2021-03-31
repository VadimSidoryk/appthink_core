import 'package:applithium_core/blocs/base_bloc.dart';

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
  final BaseBloc _bloc;
  OpenDialog(this.model, this._bloc) : super("dialog/$model");
  
  void notifyDialogClosed(dynamic result) {
    _bloc.add(BaseEvents.dialogClosed(model, result));
  }
}

class Back extends AplRoute {
  final dynamic result;
  Back({this.result}) : super("<-");
}
