import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/events.dart';

abstract class BlocCallbacks {
    List<Function(AplBloc)> get binders;

    void bindTo(AplBloc bloc) {
      binders.forEach((element) => element.call(bloc));
    }
}

extension Event0<E extends WidgetEvents> on E Function() {
  Function(AplBloc) bind(Function() callback) => (bloc) {
    bloc.doOn<E>((event, emit) {
      callback.call();
    });
  };
}

extension Event1<E extends WidgetEvents, T1> on E Function(T1) {
  Function(AplBloc) bind(Function(E) callback) => (bloc) {
    bloc.doOn<E>((event, emit) {
      callback.call(event);
    });
  };
}

extension Event2<E extends WidgetEvents, T1, T2> on E Function(T1, T2) {
  Function(AplBloc) bind(Function(E) callback) => (bloc) {
    bloc.doOn<E>((event, emit) {
      callback.call(event);
    });
  };
}

extension Event3<E extends WidgetEvents, T1, T2, T3> on E Function(T1, T2, T3) {
  Function(AplBloc) bind(Function(E) callback) => (bloc) {
    bloc.doOn<E>((event, emit) {
      callback.call(event);
    });
  };
}

extension Event4<E extends WidgetEvents, T1, T2, T3, T4> on E Function(T1, T2, T3, T4) {
  Function(AplBloc) bind(Function(E) callback) => (bloc) {
    bloc.doOn<E>((event, emit) {
      callback.call(event);
    });
  };
}
