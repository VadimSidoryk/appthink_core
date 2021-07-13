import 'package:applithium_core/usecases/base.dart';

class ListLoadItemsUseCase<T> extends UseCase<List<T>> {

  final UseCase<List<T>> loadingSource;
  final bool addToEnd;

  ListLoadItemsUseCase(this.loadingSource, this.addToEnd);

  @override
  Stream<List<T>> invokeImpl(List<T>? state, Map<String, dynamic> params) async* {
    final list = state ?? [];
    final newItems = await loadingSource.withEventParams(params).invoke(state).first;
    if(newItems.isEmpty) {
      throw "End has been reached";
    }

    if(addToEnd) {
      yield list..addAll(newItems);
    } else {
      yield newItems..addAll(list);
    }
  }
}