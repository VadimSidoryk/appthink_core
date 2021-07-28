import 'package:applithium_core/usecases/base.dart';

typedef ItemBuilder<I, O> = O Function(I);

UseCaseWithParams<List<T>, List<T>, P> listAddItem<P, T>(ItemBuilder<P, T> builder,
    {bool addToEnd = true}) {
  return (originalList, params) async {
    final list = originalList ?? <T>[];
    final itemToAdd = builder(params);
    if (addToEnd) {
      return list..add(itemToAdd);
    } else {
      return [itemToAdd] + list;
    }
  };
}

