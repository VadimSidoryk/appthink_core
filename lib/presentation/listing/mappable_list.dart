import 'package:applithium_core/json/mappable.dart';
import 'package:quiver/collection.dart';

class MappableList<M extends Mappable> extends DelegatingList<M> implements Mappable {

  final List<M> _original;

  MappableList(this._original);

  List<M> get delegate => _original;

  @override
  Map<String, dynamic> asArgs() {
    throw UnimplementedError();
  }


}