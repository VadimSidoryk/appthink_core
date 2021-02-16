import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core_example/data/api.dart';
import 'package:applithium_core_example/exhibition/domain.dart';

class DetailsBloc extends ContentBloc<ObjectModel, DetailsEvent> {

  DetailsBloc(ObjectRepository repository) : super(repository);

}

class ObjectRepository extends ContentRepository {

  final CooperHewittApi _api;
  final String _objectId;

  ObjectRepository(this._api, this._objectId);

  @override
  Future<ObjectModel> loadData() {
    _api.getObjectInfo(_objectId)
        .then((dto) => ObjectModel.fromDTO(dto));
  }

}

class DetailsEvent extends BaseContentEvent {

  DetailsEvent(String analyticTag) : super(analyticTag);

}