import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:equatable/equatable.dart';

class BattleListRepository extends ListRepository<BattleLiteModel> {
  final BattlesSource _source;

  BattleListRepository(this._source) : super(20);

  @override
  Future<List<BattleLiteModel>> loadItems(
      int startIndex, BattleLiteModel lastValue, int itemsToLoad) {
    return _source.getTopBattles(startIndex ~/ itemsToLoad + 1, itemsToLoad);
  }

  void notifyBattleAdded(BattleDetailsModel model) {
    addItems([model]);
  }
}

class TopBattlesBloc extends ListBloc<BattleLiteModel, TopBattlesEvent> {
  TopBattlesBloc(BattleListRepository repository) : super(repository);
}

class TopBattlesEvent extends BaseListEvent {
  TopBattlesEvent(String analyticTag) : super(analyticTag);
}

class ParticipantModel extends UserLiteModel {
  final String fullSizeImage;
  final double ranking;

  ParticipantModel(String id, String displayName, String thumbnailUrl,
      this.fullSizeImage, this.ranking)
      : super(id, displayName, thumbnailUrl, true);

  @override
  List<Object> get props => [id];
}

class BattleLiteModel extends Equatable {
  final int id;
  final String title;
  final ParticipantModel participant1;
  final ParticipantModel participant2;
  final int startTime;

  BattleLiteModel(this.id, this.participant1, this.participant2, this.startTime,
      this.title);

  @override
  List<Object> get props => [id];
}

abstract class BattlesSource {
  Future<List<BattleLiteModel>> getTopBattles(int page, int itemsPerPage);
}
