import 'package:applithium_core/presentation/bloc.dart';

import 'events.dart';
import 'state.dart';

class AnimatedPageBloc extends AplBloc<AnimatedPageState> {
  final int _countOfSteps;
  final Function()? onFinish;

  AnimatedPageBloc(this._countOfSteps, {this.onFinish})
      : super(AnimatedPageState(stepsCount: _countOfSteps)) {
    doOn<NextPage>((event, emit) {
      final index = event.currentIndex;
      if (index + 1 >= _countOfSteps) {
        onFinish?.call();
      } else {
        emit(state.copyWith(index: index + 1));
      }
    });
  }
}
