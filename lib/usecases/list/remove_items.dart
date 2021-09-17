
import '../base.dart';


UseCase<List<IM>, List<IM>> listRemoveItems<IM>(bool Function(IM) finder) {
  return (state) async {
    final result = List.of(state);
    result.removeWhere(finder);
    return result;
  };
}