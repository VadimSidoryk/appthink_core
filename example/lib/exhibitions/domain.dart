import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/data/api.dart';
import 'package:applithium_core_example/data/dtos.dart';
import 'package:equatable/equatable.dart';

class ExhibitionModel extends Equatable {
  final String id;
  final String name;
  final String description;

  ExhibitionModel(this.id, this.name, this.description);

  @override
  List<Object> get props => [id];

  factory ExhibitionModel.fromDTO(ExhibitionItemDTO dto) {
    return ExhibitionModel(dto.id, dto.title, dto.text);
  }
}

class ExhibitionsRepository extends ListRepository<ExhibitionModel> {
  final CooperHewittApi _api;

  ExhibitionsRepository(this._api) : super(50);

  @override
  Future<List<ExhibitionModel>> loadItems(int startIndex, ExhibitionModel lastValue, int itemsToLoad) {
    return _api.getExhibitions(startIndex ~/ itemsToLoad, itemsToLoad)
        .then((dtoList) => dtoList.map((dto) => ExhibitionModel.fromDTO(dto)).toList());
  }
}