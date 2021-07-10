import 'package:applithium_core/usecases/base.dart';

class ListLoadMoreUseCase extends UseCase<List<Map<String, dynamic>>> {

  int _currentPage = 0;
  int _itemLoaded = 0;

  @override
  Stream<List<Map<String, dynamic>>> invokeImpl({required List<Map<String, dynamic>> state}) {

  }

}