
import '../base.dart';


UseCase<List<IM>, List<IM>> removeItems<IM>(bool Function(IM) finder) {
  return (state) async {
    final result = List.of(state);
    result.removeWhere(finder);
    return result;
  };
}