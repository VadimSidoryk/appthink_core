import 'package:applithium_core/usecases/base.dart';

UseCaseWithParams<List<T>?, List<T>, P> listLoadMoreItems<T, P>(UseCaseWithParams<List<T>, List<T>, P> loader,
    {bool addToEnd = false}) {
  return (originalList, params) async {
    final list = originalList ?? [];
    final newItems = await loader.call(list, params);
    if (newItems.isEmpty) {
      throw "End has been reached";
    }

    if (addToEnd) {
      return list..addAll(newItems);
    } else {
      return newItems..addAll(list);
    }
  };
}
