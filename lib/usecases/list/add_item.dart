import 'package:applithium_core/usecases/base.dart';

typedef ItemBuilder<T> = T Function(Map<String, dynamic>);

class ListAddItemUseCase<T> extends UseCase<List<T>> {

  final ItemBuilder<T> builder;
  final bool addToEnd;

  ListAddItemUseCase({required this.builder, required this.addToEnd});

  @override
  Stream<List<T>> invokeImpl(List<T>? state, Map<String, dynamic> params) async* {
    final list = state ?? <T>[];
    final itemToAdd = builder(params);
    if(addToEnd) {
      yield list..add(itemToAdd);
    } else {
      yield [itemToAdd] + list;
    }
  }
}