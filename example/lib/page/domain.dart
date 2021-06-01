import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/repositories/content_repository.dart';

abstract class MyUseCase {
  Future<int> loadInitialValue();

  Future<int> increment(int currentValue);
}

class MyRepository extends ContentRepository<int> {

  final MyUseCase useCase;

  MyRepository({required this.useCase});

  @override
  Future<int> loadData() {
    return useCase.loadInitialValue();
  }

  void notifyIncrement() {
    updateLocalData((it) => useCase.increment(it));
  }
}

class MyEvents extends BaseEvents {
  MyEvents(String analyticTag) : super(analyticTag);

  factory MyEvents.incrementClicked() => _IncrementClicked();

}


class _IncrementClicked extends MyEvents {
  _IncrementClicked() : super("increment_clicked");
}

class MyBloc extends ContentBloc<int> {

  final MyRepository repository;

  MyBloc(this.repository) : super(repository);

  @override
  Stream<ContentState<int>> mapEventToStateImpl(BaseEvents event) async* {
    yield* super.mapEventToStateImpl(event);

    if(event is _IncrementClicked) {
      repository.notifyIncrement();
    }
  }
}