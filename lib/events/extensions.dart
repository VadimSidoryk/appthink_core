import 'events_listener.dart';

extension SendUtils0<E> on E Function() {
  Function() to(EventsListener<E> listener) => () {
    final event = this.call();
    listener.onEvent(event);
  };
}

extension SendUtils1<E, T> on E Function(T) {
  Function(T) to(EventsListener<E> listener) => (it) {
    final event = this.call(it);
    listener.onEvent(event);
  };
}

extension SendUtils2<E, T1, T2> on E Function(T1, T2) {
  Function(T1, T2) to(EventsListener<E> listener) => (it1, it2) {
    final event = this.call(it1, it2);
    listener.onEvent(event);
  };
}

extension SendUtils3<E, T1, T2, T3> on E Function(T1, T2, T3) {
  Function(T1, T2, T3) to(EventsListener<E> listener) => (it1, it2, it3) {
    final event = this.call(it1, it2, it3);
    listener.onEvent(event);
  };
}

extension SendUtils4<E, T1, T2, T3, T4> on E Function(T1, T2, T3, T4) {
  Function(T1, T2, T3, T4) to(EventsListener<E> listener) => (it1, it2, it3, it4) {
    final event = this.call(it1, it2, it3, it4);
    listener.onEvent(event);
  };
}