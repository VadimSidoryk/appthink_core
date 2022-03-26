abstract class EventsListener<E> {
  void onEvent(E event);
}

extension SendUtils<E> on EventsListener<E> {
  Function() send0(E Function() eventFactory) => () {
    final event = eventFactory.call();
    onEvent(event);
  };

  Function(T) send1<T>(E Function(T) eventFactory) => (arg) {
    final event = eventFactory.call(arg);
    onEvent(event);
  };

  Function(T1, T2) send2<T1, T2>(E Function(T1, T2) eventFactory) =>
          (arg1, arg2) {
        final event = eventFactory.call(arg1, arg2);
        onEvent(event);
      };

  Function(T1, T2, T3) send3<T1, T2, T3>(E Function(T1, T2, T3) eventFactory) =>
          (arg1, arg2, arg3) {
        final event = eventFactory.call(arg1, arg2, arg3);
        onEvent(event);
      };
}


