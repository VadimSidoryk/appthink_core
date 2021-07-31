import 'package:applithium_core/usecases/base.dart';

UseCase<List<T>?, List<T>> listLoadMoreItems<T>(
    UseCase<List<T>, List<T>> loader,
    {bool addToEnd = false}) {
  return (originalList) async {
    final list = originalList ?? [];
    final newItems = await loader.call(list);
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
